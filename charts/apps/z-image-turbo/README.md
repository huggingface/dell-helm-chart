# Z-Image-Turbo Helm Chart

This Helm chart deploys Z-Image-Turbo, an ultra-fast AI image generation application powered by the Z-Image-Turbo diffusion model with GPU support.

## Introduction

Z-Image-Turbo provides a Gradio-based web interface for generating high-quality images from text prompts using the Tongyi-MAI/Z-Image-Turbo diffusion model. The application is optimized for GPU acceleration and includes features like configurable generation parameters, persistent model caching, and a modern themed UI.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- GPU nodes with NVIDIA GPU Operator installed
- At least 16GB GPU memory recommended
- PV provisioner support (if persistence is enabled)

## Installing the Chart

### From the Helm Repository

```bash
# Add the repository
helm repo add deh https://huggingface.github.io/dell-helm-chart
helm repo update

# Install the chart
helm install z-image-turbo deh/z-image-turbo \
  --set image.repository=your-registry/z-image-turbo \
  --set image.tag=v1.0.0
```

### From Local Source

```bash
# Clone the repository
git clone https://github.com/huggingface/dell-helm-chart.git
cd dell-helm-chart

# Install the chart
helm install z-image-turbo ./charts/apps/z-image-turbo \
  --set image.repository=your-registry/z-image-turbo \
  --set image.tag=v1.0.0
```

> **Note:** You must build and push your own Docker image containing the application and model before deploying. Update the `image.repository` and `image.tag` values accordingly.

### Building the Docker Image

Before deploying, you need to build the container image:

```bash
# Clone the source repository containing the Dockerfile
git clone https://github.com/yourusername/dell-gradio-app.git
cd dell-gradio-app

# Build the image
docker build -t your-registry/z-image-turbo:v1.0.0 .

# Push to your registry
docker push your-registry/z-image-turbo:v1.0.0
```

## Configuration

The following table lists the configurable parameters for the Z-Image-Turbo chart:

### Application Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `app.name` | Application name | `z-image-turbo` |
| `app.replicaCount` | Number of replicas | `1` |
| `nameOverride` | Override the name of the chart | `""` |
| `fullnameOverride` | Override the fullname of the chart | `""` |

### Image Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Container image repository | `your-registry/z-image-turbo` |
| `image.tag` | Container image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `imagePullSecrets` | Image pull secrets | `[]` |

### Service Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Kubernetes service type | `LoadBalancer` |
| `service.port` | Service port | `7860` |
| `service.targetPort` | Container target port | `7860` |
| `service.annotations` | Service annotations | `{}` |

### Ingress Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `nginx` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hosts configuration | See values.yaml |
| `ingress.tls` | Ingress TLS configuration | `[]` |

### Resource Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources.limits.nvidia.com/gpu` | GPU allocation limit | `1` |
| `resources.limits.memory` | Memory limit | `16Gi` |
| `resources.limits.cpu` | CPU limit | `4` |
| `resources.requests.nvidia.com/gpu` | GPU allocation request | `1` |
| `resources.requests.memory` | Memory request | `8Gi` |
| `resources.requests.cpu` | CPU request | `2` |

### Node Scheduling Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nodeSelector` | Node selector for GPU nodes | `nvidia.com/gpu.present: "true"` |
| `tolerations` | Tolerations for GPU nodes | See values.yaml |
| `affinity` | Affinity rules | `{}` |

### Security Context Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `securityContext.runAsNonRoot` | Run as non-root user | `false` |
| `securityContext.runAsUser` | User ID | `0` |
| `podSecurityContext.fsGroup` | File system group ID | `0` |

### Environment Variables

| Parameter | Description | Default |
|-----------|-------------|---------|
| `env` | Environment variables for the container | See values.yaml |

Default environment variables:
- `GRADIO_SERVER_NAME`: `0.0.0.0`
- `GRADIO_SERVER_PORT`: `7860`
- `PYTHONUNBUFFERED`: `1`
- `CUDA_VISIBLE_DEVICES`: `0`

### Health Checks

| Parameter | Description | Default |
|-----------|-------------|---------|
| `livenessProbe` | Liveness probe configuration | See values.yaml |
| `readinessProbe` | Readiness probe configuration | See values.yaml |

### Persistence Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.enabled` | Enable persistent storage for model cache | `true` |
| `persistence.storageClass` | Storage class name | `""` |
| `persistence.accessMode` | Access mode | `ReadWriteOnce` |
| `persistence.size` | Volume size | `50Gi` |
| `persistence.mountPath` | Mount path for model cache | `/root/.cache/huggingface` |

### Service Account Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.annotations` | Service account annotations | `{}` |
| `serviceAccount.name` | Service account name | `""` |

## Advanced Configuration

### Enabling Ingress

To expose the application via Ingress:

```bash
helm install z-image-turbo ./charts/apps/z-image-turbo \
  --set image.repository=your-registry/z-image-turbo \
  --set image.tag=v1.0.0 \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=z-image-turbo.example.com \
  --set ingress.hosts[0].paths[0].path=/ \
  --set ingress.hosts[0].paths[0].pathType=Prefix
```

### Customizing GPU Requirements

To adjust GPU allocation:

```bash
helm install z-image-turbo ./charts/apps/z-image-turbo \
  --set image.repository=your-registry/z-image-turbo \
  --set image.tag=v1.0.0 \
  --set resources.limits.nvidia\.com/gpu=2 \
  --set resources.requests.nvidia\.com/gpu=2
```

### Using Custom Storage Class

To specify a custom storage class for model caching:

```bash
helm install z-image-turbo ./charts/apps/z-image-turbo \
  --set image.repository=your-registry/z-image-turbo \
  --set image.tag=v1.0.0 \
  --set persistence.storageClass=fast-ssd \
  --set persistence.size=100Gi
```

## Features

- **Ultra-fast Image Generation**: Leverages the Z-Image-Turbo diffusion model for rapid image synthesis
- **GPU Acceleration**: Optimized for NVIDIA GPUs with CUDA support
- **Gradio Web UI**: Modern, responsive interface with custom yellow/amber theme
- **Configurable Parameters**: Adjust height, width, inference steps, and seed values
- **Persistent Model Cache**: First launch downloads the model, subsequent launches use cached version
- **Kubernetes-ready**: Fully containerized with production-grade Helm chart
- **Health Checks**: Built-in liveness and readiness probes for reliability

## Model Information

- **Model**: Tongyi-MAI/Z-Image-Turbo
- **Type**: Diffusion model for text-to-image generation
- **Precision**: bfloat16 (GPU) or float32 (CPU)
- **Default Steps**: 8 (configurable 1-20)
- **Guidance Scale**: 0.0 (no classifier-free guidance)
- **Model Size**: ~3-5GB download

## Accessing the Application

After installation, get the application URL:

```bash
# If using LoadBalancer
kubectl get svc z-image-turbo -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

# If using port-forward for testing
kubectl port-forward svc/z-image-turbo 7860:7860
```

Then access the application at `http://<IP>:7860` or `http://localhost:7860`.

## Upgrading the Chart

```bash
helm upgrade z-image-turbo ./charts/apps/z-image-turbo \
  --set image.tag=v2.0.0
```

## Uninstalling the Chart

```bash
# Remove the deployment
helm uninstall z-image-turbo

# Optionally delete the persistent volume claim
kubectl delete pvc z-image-turbo-pvc
```

## Troubleshooting

### Pod Not Starting

Check pod logs:
```bash
kubectl logs -f deployment/z-image-turbo
```

Check pod events:
```bash
kubectl describe pod <pod-name>
```

### GPU Not Detected

Verify GPU operator is installed:
```bash
kubectl get nodes -o json | jq '.items[].status.allocatable'
```

Check for GPU resources:
```bash
kubectl get nodes -o json | jq '.items[].status.allocatable."nvidia.com/gpu"'
```

### Out of Memory Errors

Increase memory limits:
```bash
helm upgrade z-image-turbo ./charts/apps/z-image-turbo \
  --set resources.limits.memory=32Gi \
  --set resources.requests.memory=16Gi
```

### Model Download Issues

The first launch downloads the model (~3-5GB). Check logs for download progress:
```bash
kubectl logs -f deployment/z-image-turbo
```

Ensure persistent volume is properly mounted:
```bash
kubectl describe pvc z-image-turbo-pvc
```

## Performance Tips

1. **Enable Persistence**: Always enable `persistence.enabled: true` to cache the model
2. **GPU Memory**: Use GPUs with at least 16GB memory for optimal performance
3. **Reduce Inference Steps**: Use 4-8 steps for faster generation
4. **Storage Performance**: Use fast SSD-backed storage classes for better model loading times

## Additional Resources

- [Z-Image-Turbo Model Page](https://huggingface.co/Tongyi-MAI/Z-Image-Turbo)
- [Gradio Documentation](https://gradio.app/docs)
- [NVIDIA GPU Operator Documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/getting-started.html)
