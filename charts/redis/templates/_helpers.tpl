{{/*
Expand the name of the chart.
*/}}
{{- define "redis.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "redis.fullname" -}}
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
{{- define "redis.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Namespace override
*/}}
{{- define "redis.namespace" -}}
{{- if .Values.namespaceOverride }}
{{- .Values.namespaceOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Namespace | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "redis.labels" -}}
helm.sh/chart: {{ include "redis.chart" . }}
{{ include "redis.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "redis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redis.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "redis.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "redis.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "redis.masterGroupName" -}}
{{- $masterGroupName := tpl ( .Values.haMode.masterGroupName | default "") . -}}
{{- $validMasterGroupName := regexMatch "^[\\w-\\.]+$" $masterGroupName -}}
{{- if $validMasterGroupName -}}
{{ $masterGroupName }}
{{- else -}}
{{ required "A valid .Values.haMode.masterGroupName is required (matching ^[\\w-\\.]+$)" ""}}
{{- end -}}
{{- end -}}

{{- define "redis.config" -}}
{{- if .Values.redis.config }}
{{- .Values.redis.config }}
{{- end }}
{{- end -}}

{{- define "redis.sentinelConfig" -}}
{{- if .Values.sentinel.config }}
{{- .Values.sentinel.config }}
{{- end }}
{{- end -}}


{{- define "redis.fullDomain" -}}
{{- if .Values.haMode.enabled }}
{{- printf "%s-headless.%s.svc.%s" (include "redis.fullname" .) .Release.Namespace .Values.clusterDomain }}
{{- else }}
{{- printf "%s.%s.svc.%s" (include "redis.fullname" .) .Release.Namespace .Values.clusterDomain }}
{{- end }}
{{- end -}}

{{- define "redis.tls.domains" -}}
{{- range $num := until (.Values.haMode.replicas | int) }}
{{ printf "- %s-%d.%s" (include "redis.fullname" $) $num (include "redis.fullDomain" $) }}
{{- end }}
{{- end -}}