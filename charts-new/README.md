# Dell Helm Charts

This repository contains Helm charts for deploying applications on Dell platforms.

## Repository Structure

```
charts-new/
├── models/           # Charts for deploying LLM models
├── apps/             # Charts for deploying applications
│   ├── openwebui/    # OpenWebUI chart
│   ├── anythingllm/  # AnythingLLM chart
│   └── ...           # Other application charts
```

## Available Charts

### Models

Model deployment charts for large language models (LLMs) and other AI workloads.

### Applications

| Chart | Description | Version |
|-------|-------------|---------|
| [openwebui](./apps/openwebui) | OpenWebUI - A modern, feature-rich web UI for Ollama and LLMs | 0.1.0 |
| [anythingllm](./apps/anythingllm) | AnythingLLM - Open-source, modular AI assistant with document management, memory, and chat capabilities | 0.1.0 |

## Usage

Each chart includes its own README with specific installation and configuration instructions.

### General Installation Example

```bash
helm install my-release ./charts-new/apps/openwebui
```

## Requirements

- Kubernetes 1.19+
- Helm 3.2.0+

## Contributing

If you'd like to contribute to these charts, please refer to the contributing guidelines (TODO). 