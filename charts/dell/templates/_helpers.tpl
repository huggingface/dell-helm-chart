{{- define "validateNumShard" -}}
{{- $validShardValues := list 1 2 4 8 -}}
{{- if has (int .Values.env.NUM_SHARD) $validShardValues -}}
  {{- true -}}
{{- else -}}
  {{- fail "Invalid NUM_SHARD value. Must be one of: 1, 2, 4, 8" -}}
{{- end -}}
{{- end -}}

{{- define "validateInstanceName" -}}
{{- $instanceNames := list "xe9680-nvidia-h100" "xe9680-amd-mi300x" "xe9680-intel-gaudi3" "xe8640-nvidia-h100" "r760xa-nvidia-h100" "r760xa-nvidia-l40s" -}}
{{- if has .Values.instanceName $instanceNames -}}
  {{- true -}}
{{- else -}}
  {{- fail "Invalid instance name. Must be one of: xe9680-nvidia-h100, xe9680-amd-mi300x, xe9680-intel-gaudi3, xe8640-nvidia-h100, r760xa-nvidia-h100, r760xa-nvidia-l40s" -}}
{{- end -}}
{{- end -}}

{{- define "getNodeSelector" -}}
{{- if eq .Values.instanceName "xe9680-nvidia-h100" -}}
  {{- "NVIDIA-H100-80GB-HBM3" -}}
{{- else if eq .Values.instanceName "xe8640-nvidia-h100" -}}
  {{- "NVIDIA-H100-80GB-HBM3" -}}
{{- else if eq .Values.instanceName "r760xa-nvidia-h100" -}}
  {{- "NVIDIA-H100-PCIe" -}}
{{- else if eq .Values.instanceName "r760xa-nvidia-l40s" -}}
  {{- "NVIDIA-L40S" -}}
{{- else -}}
  {{- "" -}}
{{- end -}}
{{- end -}}
