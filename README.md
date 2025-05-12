# Dell Enterprise Hub Helm Charts

This repository hosts Helm charts for deploying AI models and applications from the Dell Enterprise Hub on Dell platforms.

## Usage

[Helm](https://helm.sh) must be installed to use the charts. Please refer to Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```console
$ helm repo add deh https://huggingface.github.io/dell-helm-chart
$ helm repo update
```

You can then run `helm search repo deh` to see the available charts.

## Available Charts

| Chart | Description | 
|-------|-------------|
| **models** | Deploy models like Llama, Mistral, and others on optimized Dell hardware |
| **openwebui** | Modern, feature-rich web UI for Ollama and LLMs |
| **anythingllm** | Open-source AI assistant with document management, memory, and chat capabilities |

## Installing Charts

### Deploying a Model

```console
$ helm install llama3 deh/models \
    --set appName="llama3" \
    --set instanceName="xe9680-nvidia-h100" \
    --set modelId="meta-llama/meta-llama-3-70b-instruct" \
    --set env.NUM_SHARD=8
```

### Deploying an Application

```console
$ helm install my-app deh/anythingllm \
    --set main.config.storageClassName="gp2" \
    --set main.config.storageSize="10Gi"
```

For more detailed information and configuration options, please visit the [main repository](https://github.com/huggingface/dell-helm-chart). 