{{- define "validateInputs" -}}

{{- $modelId := .Values.modelId | lower -}}
{{- $instanceName := .Values.instanceName -}}
{{- $numGpus := .Values.numGpus | int -}}

{{- $instances := include "instances" . | fromYaml -}}

{{- if not (hasKey $instances $instanceName) -}}
  {{- fail (printf "Invalid instanceName '%s'. Valid options: %s" $instanceName (keys $instances | sortAlpha | join ", ")) -}}
{{- end -}}

{{- $config := get $instances $instanceName -}}

{{/* Check instance supports the GPU count */}}
{{- if not (has (float64 $numGpus) $config.gpus) -}}
  {{- fail (printf "Invalid numGpus '%d' for %s. Valid options: %s" $numGpus $instanceName ($config.gpus | sortAlpha | join ", ")) -}}
{{- end -}}

{{/* Check model is supported on instance */}}
{{- if not (hasKey $config.models $modelId) -}}
  {{- $models := keys $config.models | sortAlpha -}}
  {{- fail (printf "Model '%s' not supported on %s. Valid options: %s" $modelId $instanceName ($models | join ", ")) -}}
{{- end -}}

{{/* Check model-specific GPU requirements */}}
{{- $modelConfig := index $config.models $modelId -}}
{{/* Apparently we need to cast to float64, as the configuration from the YAML file is loaded as a list of float values (?) */}}
{{- if not (has (float64 $numGpus) $modelConfig) -}}
  {{- $validGpus := $modelConfig | sortAlpha | join ", " -}}
  {{- fail (printf "Invalid numGpus '%d' for model %s on %s. Valid options: %s" $numGpus $modelId $instanceName $validGpus) -}}
{{- end -}}

{{- end -}}
