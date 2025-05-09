{{/*
Expand the name of the chart.
*/}}
{{- define "models.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "models.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "models.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "models.labels" -}}
helm.sh/chart: {{ include "models.chart" . }}
{{ include "models.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "models.selectorLabels" -}}
app.kubernetes.io/name: {{ include "models.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* 
Original validation helpers for NUM_SHARD 
*/}}
{{- define "validateNumShard" -}}
{{- $validShardValues := list 1 2 4 8 -}}
{{- if not (has (int .Values.env.NUM_SHARD) $validShardValues) -}}
  {{- fail "Invalid NUM_SHARD value. Must be one of: 1, 2, 4, 8" -}}
{{- end -}}
{{- end -}}

{{/* 
Original validation helpers for instanceName 
*/}}
{{- define "validateInstanceName" -}}
{{- $instanceNames := list "xe9680-nvidia-h100" "xe9680-amd-mi300x" "xe9680-intel-gaudi3" "xe8640-nvidia-h100" "r760xa-nvidia-h100" "r760xa-nvidia-l40s" -}}
{{- if not (has .Values.instanceName $instanceNames) -}}
  {{- fail "Invalid instance name. Must be one of: xe9680-nvidia-h100, xe9680-amd-mi300x, xe9680-intel-gaudi3, xe8640-nvidia-h100, r760xa-nvidia-h100, r760xa-nvidia-l40s" -}}
{{- end -}}
{{- end -}}

{{/* 
Original function to get node selector based on instance name 
*/}}
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