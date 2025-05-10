# AnythingLLM

[AnythingLLM](https://github.com/Mintplex-Labs/anything-llm) is an open-source, modular AI assistant with document management, memory, and chat capabilities.

## TL;DR

```bash
# From the Helm Repository
helm repo add deh https://raw.githubusercontent.com/huggingface/dell-helm-chart/main/repo
helm repo update
helm install my-anythingllm deh/anythingllm

# OR from local source
helm install my-anythingllm ./charts/apps/anythingllm
```

## Introduction

This chart bootstraps an AnythingLLM deployment on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (for persistence)

## Installing the Chart

### From the Helm Repository

```bash
# Add the repository
helm repo add deh https://raw.githubusercontent.com/huggingface/dell-helm-chart/main/repo
helm repo update

# Install the chart
helm install my-anythingllm deh/anythingllm
```

### From Local Source

```bash
# Clone the repository
git clone https://github.com/huggingface/dell-helm-chart.git
cd dell-helm-chart

# Install the chart
helm install my-anythingllm ./charts/apps/anythingllm
```

The command deploys AnythingLLM on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-anythingllm` deployment:

```bash
helm delete my-anythingllm
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                | Description                                  | Value     |
|---------------------|----------------------------------------------|-----------|
| `nameOverride`      | String to partially override the chart name  | `""`      |
| `fullnameOverride`  | String to fully override the chart name      | `""`      |

### Main AnythingLLM parameters

| Name                           | Description                                                                  | Value                   |
|--------------------------------|------------------------------------------------------------------------------|-------------------------|
| `main.enabled`                 | Enable AnythingLLM deployment                                                | `true`                  |
| `main.image.repository`        | AnythingLLM image repository                                                | `mintplexlabs/anythingllm` |
| `main.image.tag`               | AnythingLLM image tag                                                       | `latest`                |
| `main.image.pullPolicy`        | AnythingLLM image pull policy                                               | `IfNotPresent`          |
| `main.config.storageClassName` | Storage class for the PVC                                                    | `gp2`                   |
| `main.config.storageSize`      | Size of the storage                                                          | `10Gi`                  |
| `main.config.serverPort`       | Application server port                                                      | `3001`                  |
| `main.config.nodeEnv`          | Node environment                                                             | `production`            |
| `main.config.storageDir`       | Storage directory                                                            | `/app/server/storage`   |
| `main.config.llmProvider`      | LLM provider                                                                 | `generic-openai`        |
| `main.config.genericOpenAiBasePath` | Generic OpenAI base path                                                | `""`                    |
| `main.config.genericOpenAiModelPref` | Generic OpenAI model preference                                        | `""`                    |
| `main.config.genericOpenAiModelTokenLimit` | Generic OpenAI model token limit                                 | `4096`                  |
| `main.config.vectorDb`         | Vector database                                                              | `lancedb`               |
| `main.config.mcpServersConfig` | MCP servers configuration                                                    | See `values.yaml`       |
| `main.secrets.genericOpenAiApiKey` | API key for LLM                                                         | `""`                    |
| `main.securityContext.enabled` | Enable security context                                                      | `true`                  |
| `main.securityContext.fsGroup` | File system group ID                                                         | `1000`                  |
| `main.securityContext.runAsUser` | User ID to run as                                                          | `1000`                  |
| `main.securityContext.runAsGroup` | Group ID to run as                                                        | `1000`                  |
| `main.securityContext.runAsNonRoot` | Run as non-root user                                                    | `true`                  |
| `main.securityContext.allowPrivilegeEscalation` | Allow privilege escalation                                  | `true`                  |
| `main.securityContext.capabilities.add` | Capabilities to add                                                 | `["SYS_ADMIN"]`         |
| `main.initContainer.enabled`   | Enable init container                                                        | `true`                  |
| `main.initContainer.image.repository` | Init container image repository                                      | `busybox`               |
| `main.initContainer.image.tag` | Init container image tag                                                    | `latest`                |
| `main.initContainer.image.pullPolicy` | Init container image pull policy                                     | `IfNotPresent`          |
| `main.service.type`            | Service type                                                                 | `ClusterIP`             |
| `main.service.port`            | Service port                                                                 | `80`                    |
| `main.service.targetPort`      | Target port                                                                  | `3001`                  |
| `main.probes.readiness.enabled` | Enable readiness probe                                                      | `true`                  |
| `main.probes.readiness.path`   | Readiness probe path                                                         | `/api/ping`             |
| `main.probes.readiness.initialDelaySeconds` | Initial delay seconds                                           | `30`                    |
| `main.probes.readiness.periodSeconds` | Period seconds                                                        | `10`                    |
| `main.probes.readiness.timeoutSeconds` | Timeout seconds                                                      | `5`                     |
| `main.probes.liveness.enabled` | Enable liveness probe                                                        | `true`                  |
| `main.probes.liveness.path`    | Liveness probe path                                                          | `/api/ping`             |
| `main.probes.liveness.initialDelaySeconds` | Initial delay seconds                                            | `60`                    |
| `main.probes.liveness.periodSeconds` | Period seconds                                                         | `20`                    |
| `main.probes.liveness.timeoutSeconds` | Timeout seconds                                                       | `5`                     |
| `main.resources.requests.cpu`  | CPU request                                                                  | `250m`                  |
| `main.resources.requests.memory` | Memory request                                                             | `512Mi`                 |
| `main.resources.limits.cpu`    | CPU limit                                                                    | `500m`                  |
| `main.resources.limits.memory` | Memory limit                                                                 | `1Gi`                   |
| `main.persistence.enabled`     | Enable persistence                                                           | `true`                  |
| `main.persistence.size`        | Storage size                                                                 | `10Gi`                  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-anythingllm deh/anythingllm \
  --set main.service.type=LoadBalancer
```

The above command sets the service type to LoadBalancer.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-anythingllm deh/anythingllm -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The AnythingLLM image stores data at the `/app/server/storage` path of the container. A Persistent Volume Claim is used to keep the data across deployments. 

## Configuration

### LLM Provider

AnythingLLM supports several LLM providers. The default provider is `generic-openai`. You can configure the provider with:

```yaml
main:
  config:
    llmProvider: "generic-openai"
    genericOpenAiBasePath: "https://your-openai-compatible-api.com/v1" 
    genericOpenAiModelPref: "your-model-name"
  secrets:
    genericOpenAiApiKey: "your-api-key"
```

### MCP Servers Configuration

AnythingLLM supports Model Control Protocol (MCP) servers for various plugins and extensions. The `mcpServersConfig` parameter is of type object and needs to be properly formatted as JSON. For complex JSON objects, use the `--set-json` parameter when installing the chart:

```bash
# Using --set-json for MCP servers configuration
helm install my-anythingllm deh/anythingllm \
  --set-json 'main.config.mcpServersConfig={"mcpServers":{"fetch":{"command":"uvx","args":["mcp-server-fetch"],"anythingllm":{"autoStart":true}},"mcp-youtube":{"command":"uvx","args":["mcp-youtube"]}}}'
```

When using values.yaml, you can define it as an object:

```yaml
main:
  config:
    mcpServersConfig:
      mcpServers:
        fetch:
          command: "uvx"
          args:
            - "mcp-server-fetch"
          anythingllm:
            autoStart: true
        mcp-youtube:
          command: "uvx"
          args:
            - "mcp-youtube"
```

### Security Context

By default, AnythingLLM requires the `SYS_ADMIN` capability for web page scraping. If you don't need this functionality, you can disable it:

```yaml
main:
  securityContext:
    capabilities:
      add: []
``` 