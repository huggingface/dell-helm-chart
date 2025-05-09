# Models Helm Chart

This Helm chart is used for deploying large language models (LLMs) on Dell hardware platforms.

## Overview

The Models chart provides a standardized way to deploy Hugging Face's Text Generation Inference (TGI) service with various models from the Hugging Face Hub, optimized for Dell's hardware offerings.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Access to Dell hardware platforms
- Access to the Hugging Face model registry

## Installing the Chart

```bash
helm install my-model-deployment ./charts-new/models --set modelId=meta-llama/llama-2-70b-chat
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nameOverride` | Override the name of the chart | `""` |
| `fullnameOverride` | Override the full name of the chart | `""` |
| `appName` | Name of the application to be deployed | `"tgi"` |
| `instanceName` | Dell instance type to run on | `"xe9680-nvidia-h100"` |
| `numReplicas` | Number of replicas to deploy | `1` |
| `modelId` | Hugging Face model ID | `"meta-llama/meta-llama-3-70b-instruct"` |
| `env.PORT` | Port for the TGI service | `80` |
| `env.NUM_SHARD` | Number of GPUs to use | `8` |

### Supported Instance Types

- `xe9680-nvidia-h100`: Dell PowerEdge XE9680 with NVIDIA H100 GPUs
- `xe9680-amd-mi300x`: Dell PowerEdge XE9680 with AMD MI300X GPUs
- `xe9680-intel-gaudi3`: Dell PowerEdge XE9680 with Intel Gaudi3 accelerators
- `xe8640-nvidia-h100`: Dell PowerEdge XE8640 with NVIDIA H100 GPUs
- `r760xa-nvidia-h100`: Dell PowerEdge R760xa with NVIDIA H100 PCIe GPUs
- `r760xa-nvidia-l40s`: Dell PowerEdge R760xa with NVIDIA L40S GPUs

## Usage Examples

### Deploying a basic model

```bash
helm install llama3 ./charts-new/models \
  --set modelId=meta-llama/meta-llama-3-70b-instruct \
  --set instanceName=xe9680-nvidia-h100 \
  --set env.NUM_SHARD=8 \
  --set appName=llama3
```

### Deploying with different hardware

```bash
helm install mistral ./charts-new/models \
  --set modelId=mistralai/Mistral-7B-Instruct-v0.2 \
  --set instanceName=r760xa-nvidia-l40s \
  --set env.NUM_SHARD=2 \
  --set appName=mistral
```

## Notes

- The chart automatically validates that the `instanceName` is a supported Dell hardware type.
- The `NUM_SHARD` value is validated to be one of: 1, 2, 4, or 8.
- Different hardware platforms have different optimal configurations; consult Dell documentation for details.

## Additional Resources

- [Text Generation Inference Documentation](https://huggingface.co/docs/text-generation-inference)
- [Dell Hardware Documentation](https://www.dell.com/support/) 