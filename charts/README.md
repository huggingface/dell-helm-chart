# Dell Helm Charts

This repository contains Helm charts for deploying applications and models on Dell platforms.

## Repository Structure

```
charts/
├── models/           # Charts for deploying LLM models
│   └── templates/    # Templates for model deployments
├── apps/             # Charts for deploying applications
│   ├── openwebui/    # OpenWebUI chart
│   ├── anythingllm/  # AnythingLLM chart
│   └── ...           # Other application charts
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

## Installation

For detailed installation instructions for each chart, please refer to their respective README files:

- [Models Chart Documentation](./models/README.md)
- [AnythingLLM Chart Documentation](./apps/anythingllm/README.md)
- [OpenWebUI Chart Documentation](./apps/openwebui/README.md)

## Requirements

- Kubernetes 1.19+
- Helm 3.2.0+
- Access to Dell hardware platforms for model deployments 