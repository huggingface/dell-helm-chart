# OpenWebUI Helm Chart

This Helm chart deploys OpenWebUI, a modern, feature-rich web UI for Ollama and LLMs.

## Introduction

OpenWebUI provides a user-friendly interface for interacting with various AI models. It includes a Model Context Protocol (MCP) proxy server for enhanced functionality, allowing for more sophisticated interactions with AI models through context management and specialized tools.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)
- An existing OpenAI-compatible API endpoint (optional)

## Installing the Chart

### From the Helm Repository

```bash
# Add the repository
helm repo add deh https://huggingface.github.io/dell-helm-chart
helm repo update

# Install the chart
helm install my-openwebui deh/openwebui \
  --set main.config.storageClassName=gp2
```

### From Local Source

```bash
# Clone the repository
git clone https://github.com/huggingface/dell-helm-chart.git
cd dell-helm-chart

# Install the chart
helm install my-openwebui ./charts/apps/openwebui \
  --set main.config.storageClassName=gp2
```

> **Required:** The `main.config.storageClassName` parameter must be specified during installation, as it is required for the persistent volume claim.

### Optional MCPO Component

The Model Context Protocol (MCP) component provides tool functionality to enable advanced features like web browsing, time functions, and external API access. **Note that the MCPO component is disabled by default** and must be explicitly enabled with `--set mcpo.enabled=true`.

To enable the MCPO proxy component:

```bash
helm install my-openwebui deh/openwebui \
  --set main.config.storageClassName=gp2 \
  --set mcpo.enabled=true \
  --set-json 'mcpo.config.serverConfig={"mcpServers":{"memory":{"command":"npx","args":["-y","@modelcontextprotocol/server-memory"]}}}'
```

For complex JSON configurations, always use the `--set-json` parameter rather than `--set` to ensure proper JSON formatting:

```bash
# Using --set-json for complex MCPO server configuration with multiple servers
helm install my-openwebui deh/openwebui \
  --set main.config.storageClassName=gp2 \
  --set mcpo.enabled=true \
  --set-json 'mcpo.config.serverConfig={"mcpServers":{"fetch":{"command":"uvx","args":["mcp-server-fetch"]},"airbnb":{"command":"npx","args":["-y","@openbnb/mcp-server-airbnb","--ignore-robots-txt"]},"time":{"command":"uvx","args":["mcp-server-time","--local-timezone=America/New_York"]},"gradio":{"url":"https://abidlabs-mcp-tools.hf.space/gradio_api/mcp/sse"}}}'
```

When using values.yaml, you can specify it as an object:

```yaml
mcpo:
  enabled: true  # Must be set to true to enable MCPO
  config:
    serverConfig:
      mcpServers:
        memory:
          command: "npx"
          args: 
            - "-y"
            - "@modelcontextprotocol/server-memory"
        search:
          command: "npx"
          args:
            - "-y"
            - "@modelcontextprotocol/server-search"
```

## NFS Storage Considerations

When using NFS storage with OpenWebUI's default configuration, you may encounter issues with permissions and SQLite database operations. We recommend using block storage instead of NFS.

If you do choose to use NFS, your NFS StorageClass may need specific configuration to support SQLite-based applications:
- Ensuring proper permissions on directories (777)
- Configuring appropriate NFS mount options

## Configuration

The following table lists the configurable parameters for the OpenWebUI chart:

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nameOverride` | Override the name of the chart | `""` |
| `fullnameOverride` | Override the fullname of the chart | `""` |

### Main Component Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `main.enabled` | Enable the main OpenWebUI component | `true` |
| `main.image.repository` | OpenWebUI image repository | `ghcr.io/open-webui/open-webui` |
| `main.image.tag` | OpenWebUI image tag | `main` |
| `main.image.pullPolicy` | OpenWebUI image pull policy | `IfNotPresent` |
| `main.config.storageClassName` | Storage class for persistent data (required) | `gp2` |
| `main.config.enableOpenAI` | Enable OpenAI-compatible API | `true` |
| `main.config.openaiApiBaseUrls` | OpenAI API base URLs (semicolon-separated) | `""` |
| `main.secrets.openaiApiKeys` | OpenAI API keys (semicolon-separated) | `""` |
| `main.service.type` | Service type for the main component | `ClusterIP` |
| `main.service.port` | Service port for the main component | `8080` |
| `main.resources` | Resource requests and limits for the main component | modest requests/limits |
| `main.persistence.enabled` | Enable persistence for the main component | `true` |
| `main.persistence.size` | Size of the persistent volume claim | `1Gi` |
| `main.securityContext.enabled` | Enable security context settings | `true` |
| `main.securityContext.fsGroup` | The group ID for volume permissions | `0` |
| `main.securityContext.runAsUser` | The user ID to run the container processes | `0` |
| `main.securityContext.runAsGroup` | The group ID to run the container processes | `0` |
| `main.securityContext.runAsNonRoot` | Require the container to run as a non-root user | `false` |

### MCPO Component Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mcpo.enabled` | Enable the MCPO proxy component | `false` |
| `mcpo.image.repository` | MCPO image repository | `ghcr.io/open-webui/mcpo` |
| `mcpo.image.tag` | MCPO image tag | `main` |
| `mcpo.image.pullPolicy` | MCPO image pull policy | `IfNotPresent` |
| `mcpo.config.serverConfig` | JSON configuration for MCP servers | `{}` |
| `mcpo.service.type` | Service type for the MCPO component | `ClusterIP` |
| `mcpo.service.port` | Service port for the MCPO component | `8000` |
| `mcpo.resources` | Resource requests and limits for the MCPO component | modest requests/limits |

## Features

- **Web-based UI**: Modern, responsive interface for interacting with AI models
- **OpenAI-compatible API**: Seamless integration with existing OpenAI-based applications
- **Model Management**: Easy model downloading, updating, and configuration
- **User Authentication**: Secure access control and user management
- **MCP Integration**: Enhanced model interactions through Model Context Protocol
- **Multi-model Support**: Run and switch between different AI models
- **Chat History**: Persistent storage of conversations and model interactions

## Additional Resources

- [OpenWebUI Documentation](https://docs.openwebui.com/)
- [OpenWebUI GitHub Repository](https://github.com/open-webui/open-webui)
- [Model Context Protocol Documentation](https://docs.openwebui.com/openapi-servers/mcp) 