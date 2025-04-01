{{- define "instance" -}}

{{/* Validate inputs */}}
{{- include "validateInputs" . -}}

{{/* Get instances and extract GPU IDs */}}
{{- $instances := include "instances" . | fromYaml -}}
{{- $instanceMap := dict -}}
{{- range $name, $config := $instances -}}
  {{- $_ := set $instanceMap $name $config.gpuId -}}
{{- end -}}


{{/* Get the provider from the instances configuration */}}
{{- $provider := (get $instances .Values.instanceName).provider -}}

{{/* Get the GPU type from the instances configuration */}}
{{- $gpuType := (get $instances .Values.instanceName).gpuId -}}

{{/* Get the GPU resource from the provider */}}
{{- $gpuResource := "nvidia.com/gpu" -}}
{{- if eq $provider "amd" -}}
  {{- $gpuResource = "amd.com/gpu" -}}
{{- end -}}


{{- $output := dict
  "provider" $provider
  "limits" (dict $gpuResource .Values.numGpus)
-}}

{{/* Add nodeSelector with GPU type for NVIDIA instances */}}
{{- if eq $provider "nvidia" -}}
  {{- $output = set $output "nodeSelector" (dict "nvidia.com/gpu.product" $gpuType) -}}
{{- end -}}

{{- toYaml $output -}}

{{- end -}}
