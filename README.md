# Helm Chart for the Dell Enterprise Hub

> Helm Charts for deploying open AI models and applications from Dell Enterpise Hub (DEH) on Dell platforms

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square)
![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

> [!WARNING]
> These Helm Charts are intended to be used with the Dell Enterprise Hub on Dell instances,
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
$ helm repo add deh https://huggingface.github.io/dell-helm-chart
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

For complex MCP configurations, use the `--set-json` parameter:

```console
$ helm install my-app deh/anythingllm \
    --set main.config.storageClassName="gp2" \
    --set-json 'main.config.mcpServersConfig={"mcpServers":{"fetch":{"command":"uvx","args":["mcp-server-fetch"],"anythingllm":{"autoStart":true}}}}'
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

## Advanced Usage

### Complex JSON Configurations

When deploying charts with complex configurations that involve nested JSON objects, use the `--set-json` parameter instead of `--set`. This ensures proper formatting and parsing of JSON data:

```console
# Incorrect - may lead to parsing errors
$ helm install anythingllm ./charts/apps/anythingllm \
    --set main.config.mcpServersConfig={"mcpServers":{"fetch":{"command":"uvx"}}}

# Correct - use --set-json for complex JSON data
$ helm install anythingllm ./charts/apps/anythingllm \
    --set-json 'main.config.mcpServersConfig={"mcpServers":{"fetch":{"command":"uvx","args":["mcp-server-fetch"]}}}'
```

This is particularly important for charts like AnythingLLM and OpenWebUI that use MCP server configurations.

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
2. The GitHub Action ([helm/chart-releaser-action](https://github.com/helm/chart-releaser-action)) automatically:
   - Packages charts when changes are pushed to the main branch
   - Creates GitHub releases for new chart versions
   - Updates the `index.yaml` file in the `gh-pages` branch
   - Publishes charts to GitHub Pages

### Chart Versioning

We follow these versioning guidelines for our Helm charts:

1. **Chart Versioning**: Charts follow SemVer (major.minor.patch) starting at v0.0.1 for development
2. **Docker Image Versioning**: Each chart specifies pinned image versions for stability

When updating to new application versions, create a new chart version to reflect these changes.

### Adding or Updating Charts

When making changes to existing charts or adding new charts, follow these steps:

1. Make changes to the chart source code in the `charts/` directory
2. Update the chart version in the respective `Chart.yaml` file
3. Commit and push the changes to the main branch:

```console
$ git add charts/
$ git commit -m "Update chart [chart-name] to version [x.y.z]"
$ git push origin main
```

The GitHub Action will automatically package the charts, create releases, and update the repository.

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