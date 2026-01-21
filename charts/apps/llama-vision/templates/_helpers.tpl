{{/*
Expand the name of the chart.
*/}}
{{- define "llama-vision.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "llama-vision.fullname" -}}
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
{{- define "llama-vision.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "llama-vision.labels" -}}
helm.sh/chart: {{ include "llama-vision.chart" . }}
{{ include "llama-vision.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "llama-vision.selectorLabels" -}}
app.kubernetes.io/name: {{ include "llama-vision.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create frontend component name
*/}}
{{- define "llama-vision.frontend.name" -}}
{{- printf "%s-frontend" (include "llama-vision.fullname" .) }}
{{- end }}

{{/*
Frontend component selector labels
*/}}
{{- define "llama-vision.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "llama-vision.name" . }}-frontend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
Create backend component name
*/}}
{{- define "llama-vision.backend.name" -}}
{{- printf "%s-backend" (include "llama-vision.fullname" .) }}
{{- end }}

{{/*
Backend component selector labels
*/}}
{{- define "llama-vision.backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "llama-vision.name" . }}-backend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
Get TGI URL for frontend
*/}}
{{- define "llama-vision.tgiUrl" -}}
{{- if .Values.frontend.config.tgiUrl }}
{{- .Values.frontend.config.tgiUrl }}
{{- else }}
{{- printf "http://%s:%d" (include "llama-vision.backend.name" .) (int .Values.backend.service.port) }}
{{- end }}
{{- end }}
