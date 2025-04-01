{{- define "validateInputs" -}}

{{- $instanceName := .Values.instanceName -}}
{{- $numGpus := .Values.env.NUM_SHARD | int -}}

{{- $instances := include "instances" . | fromYaml -}}

{{/* Check if instance exists */}}
{{- if not (hasKey $instances $instanceName) -}}
  {{- fail (printf "Invalid instanceName '%s'. Valid options: %s" $instanceName (keys $instances | sortAlpha | join ", ")) -}}
{{- end -}}

{{- $config := get $instances $instanceName -}}

{{/* Check instance supports the GPU count */}}
{{- if not (has (float64 $numGpus) $config.gpus) -}}
  {{- fail (printf "Invalid numGpus '%d' for %s. Valid options: %s" $numGpus $instanceName ($config.gpus | sortAlpha | join ", ")) -}}
{{- end -}}

{{- end -}}
