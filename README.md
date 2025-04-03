# Helm Chart for the Dell Enterprise Hub

> Hugging Face's Helm Chart for deploying open-source AI applications on Dell Platforms

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square)
![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)
![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

> [!WARNING]
> This Helm Chart is intended to be used within the Dell Enterprise Hub on Dell instances,
> and is subject to changes before the 0.1.0 release!

## Installing the Chart

To add the chart from the current repository you need to run:

```console
$ helm repo add dell https://raw.githubusercontent.com/huggingface/dell-helm-chart/main/charts/dell
$ helm repo update dell
```

Then to install the chart on a Kubernetes cluster you can run the following:

```console
$ helm install dell-tgi dell/dell \
    --set appName="tgi" \
    --set numReplicas=1 \
    --set instanceName="xe9680-nvidia-h100" \
    --set modelId="meta-llama/meta-llama-3-70b-instruct" \
    --set env.PORT=80 \
    --set env.NUM_SHARD=8
```

Or run it with the default values that will deploy [`meta-llama/meta-llama-3-70b-instruct`](https://huggingface.co/meta-llama/meta-llama-3-70b-instruct)
on the instance `xe9680-nvidia-h100` with 8 x NVIDIA H100:

```console
$ helm install dell-tgi dell/dell
```

## Testing the Chart

To test that the template is generated as expected in advance, you can run the
following command and play around with the different alternatives:

```console
$ helm template charts/dell
```
