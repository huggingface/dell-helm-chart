# Helm Chart for the Dell Enterprise Hub

> Helm Charts for deploying open-source AI models and applications from Dell Enterpise Hub (DEH) on Dell platforms

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square)
![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

> [!WARNING]
> These Helm Charts are intended to be used within the Dell Enterprise Hub on Dell instances,
> and are subject to changes!

## Repository Structure

This repository contains Helm charts for deploying both AI models and applications on Dell hardware:

```
charts/               # Source code for the Helm charts
├── models/           # Charts for deploying LLM models
│   └── templates/    # Templates for model deployments
├── apps/             # Charts for deploying applications
│   ├── anythingllm/  # AnythingLLM application chart
│   └── openwebui/    # OpenWebUI application chart
repo/                 # Packaged chart files (.tgz) and index.yaml
```

## Available Charts

### Models

The models chart allows for deploying large language models (LLMs) from the Hugging Face Hub on Dell hardware:

- **models** - Deploy models like Llama, Mistral, and others on optimized Dell hardware

### Applications

Application charts for deploying AI-powered applications:

| Chart | Description | Version |
|-------|-------------|---------|
| **openwebui** | Modern, feature-rich web UI for Ollama and LLMs | 0.0.1 |
| **anythingllm** | Open-source AI assistant with document management, memory, and chat capabilities | 0.0.1 |

## Installing Charts from the Repository

### Adding the Repository

To add the chart repository:

```console
$ helm repo add deh https://raw.githubusercontent.com/huggingface/dell-helm-chart/main/repo
$ helm repo update
```

### Deploying a Model

Deploy a model with specific configuration:

```console
$ helm install llama3 deh/models \
    --set appName="llama3" \
    --set instanceName="xe9680-nvidia-h100" \
    --set modelId="meta-llama/meta-llama-3-70b-instruct" \
    --set env.NUM_SHARD=8
```

Or with default values that will deploy `meta-llama/meta-llama-3-70b-instruct` on `xe9680-nvidia-h100` with 8 GPUs:

```console
$ helm install llama3 deh/models
```

### Deploying an Application

Deploy an application:

```console
$ helm install my-app deh/anythingllm \
    --set main.config.storageClassName="gp2" \
    --set main.config.storageSize="10Gi"
```

## Installing Charts Locally

For development or testing purposes, you can install charts directly from a local clone of this repository:

```console
# Clone the repository
$ git clone https://github.com/huggingface/dell-helm-chart.git
$ cd dell-helm-chart

# Install a model chart
$ helm install llama3 ./charts/models

# Install an application chart
$ helm install openwebui ./charts/apps/openwebui
```

## Testing the Charts

Preview the template generation without installing:

```console
# Test the model chart
$ helm template ./charts/models

# Test an application chart
$ helm template ./charts/apps/anythingllm
```

## Requirements

- Kubernetes 1.19+
- Helm 3.2.0+
- Access to Dell hardware platforms

## Documentation

Each chart includes its own README with specific installation and configuration instructions:

- [Models Chart Documentation](./charts/models/README.md)
- [AnythingLLM Chart Documentation](./charts/apps/anythingllm/README.md)
- [OpenWebUI Chart Documentation](./charts/apps/openwebui/README.md)

## Helm Repository Maintenance

This section provides guidance for maintainers on how to update the Helm chart repository.

### Repository Structure

This repository follows the Helm chart repository best practices:

1. Chart source code is stored in the `charts/` directory
2. Packaged charts and index.yaml are stored in the `repo/` directory

### Chart Versioning

We follow these versioning guidelines for our Helm charts:

1. **Chart Versioning**: Charts follow SemVer (major.minor.patch) starting at v0.0.1 for development
2. **Docker Image Versioning**: Each chart specifies pinned image versions for stability

When updating to new application versions, we create a new chart version to reflect these changes.

### Adding or Updating Charts

When making changes to existing charts or adding new charts, follow these steps:

1. Make changes to the chart source code in the `charts/` directory
2. Update the chart version in the respective `Chart.yaml` file
3. Package the updated chart:

```console
# For updating a single chart (e.g., anythingllm)
$ helm package charts/apps/anythingllm -d repo

# For updating all charts
$ helm package charts/apps/anythingllm -d repo
$ helm package charts/apps/openwebui -d repo
$ helm package charts/models -d repo
```

4. Regenerate the index.yaml file:

```console
$ helm repo index repo --url https://raw.githubusercontent.com/huggingface/dell-helm-chart/main/repo
```

5. Commit and push the changes:

```console
$ git add charts/ repo/
$ git commit -m "Update charts and packages"
$ git push
```

### Testing Before Release

Before pushing changes, always test your charts locally:

```console
# Lint the charts to check for issues
$ helm lint charts/models
$ helm lint charts/apps/anythingllm
$ helm lint charts/apps/openwebui

# Test template rendering
$ helm template charts/models
$ helm template charts/apps/anythingllm
$ helm template charts/apps/openwebui

# Optional: Test installation in a development cluster
$ helm install test-model ./charts/models --dry-run
```