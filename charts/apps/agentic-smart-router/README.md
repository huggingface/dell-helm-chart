# Agentic Smart Router

This NVIDIA Agentic Toolkit (NAT) application introduces the first integration of the NVIDIA LLM Router within a
multi-framework, agent-oriented architecture. The supervisory agent and routing control plane are implemented
using LangChain, while the retrieval-augmented generation (RAG) subsystem is built on LlamaIndex. Together, these
components form an end-to-end intelligent agent workflow that accepts a user prompt and, by leveraging
integrated retrieval and routing capabilities, dynamically determines and invokes the most appropriate model to
service the request.

## TL;DR

```bash
# From the Helm Repository
helm repo add deh https://huggingface.github.io/dell-helm-chart
helm repo update
helm install agentic-smart-router deh/agentic-smart-router

# OR from local source
helm install agentic-smart-router ./charts/apps/agentic-smart-router
```

## Introduction

This chart bootstraps a NVIDIA Agentic Smart Router deployment on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (for persistence)

## Installing the Chart

### From the Helm Repository

```bash
# Add the repository
helm repo add deh https://huggingface.github.io/dell-helm-chart
helm repo update

# Install the chart
helm install my-agentic-smart-router deh/agentic-smart-router
```

### From Local Source

```bash
# Clone the repository
git clone https://github.com/huggingface/dell-helm-chart.git
cd dell-helm-chart

# Install the chart
helm install my-agentic-smart-router ./charts/apps/agentic-smart-router
```

The command deploys NVIDIA Agentic Smart Router on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-agentic-smart-router` deployment:

```bash
helm delete my-agentic-smart-router
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                | Description                                  | Value     |
|---------------------|----------------------------------------------|-----------|
| `nameOverride`      | String to partially override the chart name  | `""`      |
| `fullnameOverride`  | String to fully override the chart name      | `""`      |

### Main Agentic Smart Router parameters

| Name                           | Description                                                                  | Value                   |
|--------------------------------|------------------------------------------------------------------------------|-------------------------|
| `ngcApiKey`                    | NVIDIA GPU Cloud API Key                                                     | ``                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-agentic-smart-router deh/agentic-smart-router \
  --set ngcApiKey=<your-ngc-api-key>
```

The above command sets the NVIDIA NGC API key.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-agentic-smart-router deh/agentic-smart-router -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
