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
charts/
├── models/          # Charts for deploying LLM models
│   └── templates/   # Templates for model deployments
├── apps/            # Charts for deploying applications
│   ├── anythingllm/ # AnythingLLM application chart
│   └── openwebui/   # OpenWebUI application chart
```

## Available Charts

### Models

The models chart allows for deploying large language models (LLMs) from the Hugging Face Hub on Dell hardware:

- **models** - Deploy models like Llama, Mistral, and others on optimized Dell hardware

### Applications

Application charts for deploying AI-powered applications:

| Chart | Description | Version |
|-------|-------------|---------|
| **openwebui** | Modern, feature-rich web UI for Ollama and LLMs | 0.1.0 |
| **anythingllm** | Open-source AI assistant with document management, memory, and chat capabilities | 0.1.0 |

## Installing Charts from the Repository

### Adding the Repository

To add the chart repository:

```console
$ helm repo add deh https://raw.githubusercontent.com/huggingface/dell-helm-chart/main/
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
$ helm install my-app deh/apps/anythingllm \
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
