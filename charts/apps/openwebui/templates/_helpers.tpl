{{/*
Expand the name of the chart.
*/}}
{{- define "openwebui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openwebui.fullname" -}}
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
{{- define "openwebui.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "openwebui.labels" -}}
helm.sh/chart: {{ include "openwebui.chart" . }}
{{ include "openwebui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "openwebui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openwebui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create main component name
*/}}
{{- define "openwebui.main.name" -}}
{{- printf "%s-main" (include "openwebui.fullname" .) }}
{{- end }}

{{/*
Main component selector labels
*/}}
{{- define "openwebui.main.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openwebui.name" . }}-main
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: main
{{- end }}

{{/*
Create MCPO component name
*/}}
{{- define "openwebui.mcpo.name" -}}
{{- printf "%s-mcpo" (include "openwebui.fullname" .) }}
{{- end }}

{{/*
MCPO component selector labels
*/}}
{{- define "openwebui.mcpo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openwebui.name" . }}-mcpo
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: mcpo
{{- end }} 