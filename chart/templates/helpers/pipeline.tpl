{{- define "instance" -}}

{{- include "validateInputs" . -}}

{{- $instances := include "instances" . | fromYaml -}}
{{- $config := get $instances .Values.instanceName -}}
{{- $modelId := .Values.modelId | lower -}}

{{- $gpuResource := "nvidia.com/gpu" -}}
{{- if eq $config.provider "amd" -}}
  {{- $gpuResource = "amd.com/gpu" -}}
{{- end -}}

{{- $output := dict
  "provider" $config.provider
  "requests" (dict $gpuResource .Values.numGpus)
  "limits" (dict $gpuResource .Values.numGpus)
-}}

{{/* Add nodeSelector only for NVIDIA instances */}}
{{- if eq $config.provider "nvidia" -}}
  {{- $output = set $output "nodeSelector" $config.nodeSelector -}}
{{- end -}}

{{- toYaml $output -}}

{{- end -}}
