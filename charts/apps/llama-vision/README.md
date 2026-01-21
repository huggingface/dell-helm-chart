# Llama 3.2 11B Vision Helm Chart

A Helm chart for deploying Llama 3.2 11B Vision multimodal chat application with a Gradio frontend and Text Generation Inference (TGI) backend.

## Overview

This chart deploys a complete multimodal AI application consisting of:
- **Frontend**: Gradio web interface for interacting with the model
- **Backend**: Text Generation Inference (TGI) server hosting the Llama 3.2 11B Vision model

## Prerequisites

- Kubernetes cluster with GPU support
- NVIDIA GPU operator installed
- Helm 3.x
- Valid Hugging Face token with access to Llama 3.2 models
- Docker image for Gradio frontend (see Building the Frontend section)

## Building the Frontend

Before installing the chart, build and push the Gradio frontend image:

```bash
cd charts/apps/llama-vision/app
docker build -t <your-registry>/llama-vision-frontend:latest .
docker push <your-registry>/llama-vision-frontend:latest
```

Update the `values.yaml` file with your image repository:
```yaml
frontend:
  image:
    repository: <your-registry>/llama-vision-frontend
    tag: latest
```

## Installation

### 1. Create a values file

Create a `my-values.yaml` file with your configuration:

```yaml
frontend:
  image:
    repository: your-registry/llama-vision-frontend
    tag: latest

backend:
  config:
    numShard: 1  # Adjust based on GPU availability
    gpuCount: 1  # Number of GPUs
    gpuProduct: "NVIDIA-L40S"  # Optional: specific GPU type

  secrets:
    hfToken: "hf_your_token_here"  # Your Hugging Face token

  resources:
    limits:
      nvidia.com/gpu: 1  # Must match gpuCount

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: llama-vision.example.com
      paths:
        - path: /
          pathType: Prefix
```

### 2. Install the chart

```bash
helm install llama-vision ./charts/apps/llama-vision -f my-values.yaml
```

### 3. Wait for deployment

The backend may take 5-10 minutes to start as it loads the 11B model:

```bash
# Watch backend pod
kubectl get pods -l app.kubernetes.io/component=backend -w

# Check backend logs
kubectl logs -l app.kubernetes.io/component=backend -f

# Watch frontend pod
kubectl get pods -l app.kubernetes.io/component=frontend -w
```

### 4. Access the application

If ingress is enabled:
```bash
# Access via configured hostname
open http://llama-vision.example.com
```

If using port-forward:
```bash
kubectl port-forward svc/llama-vision-frontend 7860:7860
open http://localhost:7860
```

## Configuration

### Frontend Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `frontend.enabled` | Enable frontend deployment | `true` |
| `frontend.image.repository` | Frontend image repository | `""` (must be set) |
| `frontend.image.tag` | Frontend image tag | `latest` |
| `frontend.config.tgiUrl` | TGI backend URL (auto-configured if empty) | `""` |
| `frontend.service.type` | Kubernetes service type | `ClusterIP` |
| `frontend.service.port` | Service port | `7860` |
| `frontend.resources.requests.cpu` | CPU request | `500m` |
| `frontend.resources.requests.memory` | Memory request | `512Mi` |
| `frontend.resources.limits.cpu` | CPU limit | `1000m` |
| `frontend.resources.limits.memory` | Memory limit | `1Gi` |

### Backend Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `backend.enabled` | Enable backend deployment | `true` |
| `backend.image.repository` | TGI image repository | `registry.dell.huggingface.co/...` |
| `backend.image.tag` | TGI image tag | `tgi-3.1.0` |
| `backend.config.modelId` | Model ID | `meta-llama/Meta-Llama-3.2-11B-Vision-Instruct` |
| `backend.config.numShard` | Number of model shards | `1` |
| `backend.config.maxBatchPrefillTokens` | Max batch prefill tokens | `81256` |
| `backend.config.maxTotalTokens` | Max total tokens | `81256` |
| `backend.config.maxInputTokens` | Max input tokens | `81128` |
| `backend.config.gpuCount` | Number of GPUs | `1` |
| `backend.config.gpuProduct` | GPU product selector (optional) | `""` |
| `backend.secrets.hfToken` | Hugging Face token | `""` (required) |
| `backend.service.type` | Kubernetes service type | `ClusterIP` |
| `backend.service.port` | Service port | `80` |
| `backend.resources.limits.nvidia.com/gpu` | GPU limit | `1` |
| `backend.shm.enabled` | Enable shared memory | `true` |
| `backend.shm.size` | Shared memory size | `1Gi` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `nginx` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hosts configuration | See values.yaml |
| `ingress.tls` | TLS configuration | `[]` |

## Examples

### Minimal Configuration (Port-Forward Access)

```yaml
frontend:
  image:
    repository: your-registry/llama-vision-frontend
    tag: latest

backend:
  secrets:
    hfToken: "hf_your_token_here"
```

### Multi-GPU Configuration

```yaml
frontend:
  image:
    repository: your-registry/llama-vision-frontend
    tag: latest

backend:
  config:
    numShard: 4
    gpuCount: 4
    gpuProduct: "NVIDIA-L40S"
    maxBatchPrefillTokens: 32768
    maxTotalTokens: 16256
    maxInputTokens: 16128

  secrets:
    hfToken: "hf_your_token_here"

  resources:
    limits:
      nvidia.com/gpu: 4
```

### With Ingress and TLS

```yaml
frontend:
  image:
    repository: your-registry/llama-vision-frontend
    tag: latest

backend:
  secrets:
    hfToken: "hf_your_token_here"

ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - host: llama-vision.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: llama-vision-tls
      hosts:
        - llama-vision.example.com
```

## Troubleshooting

### Backend not starting

Check the TGI logs:
```bash
kubectl logs -l app.kubernetes.io/component=backend -f
```

Common issues:
- Invalid Hugging Face token
- Insufficient GPU memory
- Model not accessible (requires approval)

### Frontend can't connect to backend

Check that the backend service is ready:
```bash
kubectl get svc -l app.kubernetes.io/component=backend
kubectl get pods -l app.kubernetes.io/component=backend
```

Test backend health:
```bash
kubectl port-forward svc/llama-vision-backend 8080:80
curl http://localhost:8080/health
```

### Out of memory errors

Reduce token limits or increase GPU resources:
```yaml
backend:
  config:
    maxBatchPrefillTokens: 32768
    maxTotalTokens: 16256
    maxInputTokens: 16128
```

## Upgrading

```bash
helm upgrade llama-vision ./charts/apps/llama-vision -f my-values.yaml
```

## Uninstalling

```bash
helm uninstall llama-vision
```

## Architecture

```
┌─────────────────────────────────────────┐
│          Ingress (Optional)             │
└───────────────┬─────────────────────────┘
                │
                v
┌─────────────────────────────────────────┐
│      Frontend Service (ClusterIP)       │
│           Port: 7860                    │
└───────────────┬─────────────────────────┘
                │
                v
┌─────────────────────────────────────────┐
│       Frontend Deployment               │
│    (Gradio App Container)               │
│    - Multimodal chat interface          │
│    - Image upload support               │
│    - Streaming responses                │
└───────────────┬─────────────────────────┘
                │ HTTP/REST
                v
┌─────────────────────────────────────────┐
│      Backend Service (ClusterIP)        │
│           Port: 80                      │
└───────────────┬─────────────────────────┘
                │
                v
┌─────────────────────────────────────────┐
│       Backend Deployment                │
│    (TGI Container)                      │
│    - Llama 3.2 11B Vision model         │
│    - OpenAI-compatible API              │
│    - GPU acceleration                   │
│    - Shared memory volume               │
└─────────────────────────────────────────┘
```

## Resources

- [Llama 3.2 Vision Model](https://huggingface.co/meta-llama/Llama-3.2-11B-Vision-Instruct)
- [Original HuggingFace Space](https://huggingface.co/spaces/huggingface-projects/llama-3.2-vision-11B)
- [Text Generation Inference](https://github.com/huggingface/text-generation-inference)
- [Gradio Documentation](https://www.gradio.app/docs)

## License

Apache 2.0
