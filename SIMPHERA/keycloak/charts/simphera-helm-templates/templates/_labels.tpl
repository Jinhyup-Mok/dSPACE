{{/* Mandatory labels for all resources */}}
{{- define "simphera.resourceLabels" -}}
{{- $ := index . 0 -}}
{{- $componentName := index . 1 -}}
app.kubernetes.io/name: simphera
app.kubernetes.io/instance: simphera-{{ $.Release.Name }}
app.kubernetes.io/version: {{ $.Chart.Version | quote }}
app.kubernetes.io/component: {{ $componentName | quote }}
{{- end -}}

{{/* Labels used for selectors to match other resources */}}
{{- define "simphera.selectorLabels" -}}
{{- $ := index . 0 -}}
{{- $componentName := index . 1 -}}
app.kubernetes.io/name: simphera
app.kubernetes.io/instance: simphera-{{ $.Release.Name }}
app.kubernetes.io/component: {{ $componentName | quote }}
{{- end -}}

{{/* Labels used for resources within deployment, replicaset and statefulset templates */}}
{{- define "simphera.templateLabels" -}}
{{- $ := index . 0 -}}
{{- $componentName := index . 1 -}}
app.kubernetes.io/name: simphera
app.kubernetes.io/instance: simphera-{{ $.Release.Name }}
app.kubernetes.io/component: {{ $componentName | quote }}
{{- if $.Values.forcePodRecreation }}
forcePodRecreationIdentifier: {{ $.Release.Revision | quote }}
{{- end -}}
{{- end -}}

{{/* Labels used for resources within job templates */}}
{{- define "simphera.jobTemplateLabels" -}}
{{- $ := index . 0 -}}
{{- $componentName := index . 1 -}}
app.kubernetes.io/name: simphera
app.kubernetes.io/instance: simphera-{{ $.Release.Name }}
app.kubernetes.io/component: {{ $componentName | quote }}
{{- end -}}
