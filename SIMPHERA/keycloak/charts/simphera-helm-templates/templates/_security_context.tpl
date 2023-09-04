{{/* securityContext of a regular SIMPHERA backend pod */}}
{{- define "simphera.backendPodSecurityContextAndServiceAccount" -}}
{{- $randomId := randNumeric 4 | int | add 10000 -}}
securityContext:
  runAsUser: {{ $randomId }}
  runAsGroup: {{ $randomId }}
{{- if .Values.global.simphera.serviceAccounts.simphera }}
serviceAccountName: {{ .Values.global.simphera.serviceAccounts.simphera | quote }}
{{- else }}
serviceAccountName: simphera
{{- end }}
{{- end -}}

{{/* securityContext of a SIMPHERA frontend (nginx) pod */}}
{{/* The user ID 33 is specified here because that is the user ID */}}
{{/* of user 'www-data' of the NGINX base image. */}}
{{- define "simphera.frontendPodSecurityContextAndServiceAccount" -}}
securityContext:
  runAsUser: 33
{{- if .Values.global.simphera.serviceAccounts.simphera }}
serviceAccountName: {{ .Values.global.simphera.serviceAccounts.simphera | quote }}
{{- else }}
serviceAccountName: simphera
{{- end }}
{{- end -}}

{{/* securityContext of a regular SIMPHERA container */}}
{{- define "simphera.frontendContainerSecurityContext" -}}
securityContext:
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
{{- end -}}


{{/* securityContext of a regular SIMPHERA container */}}
{{- define "simphera.containerSecurityContext" -}}
securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
{{- if .Values.enableSysPtrace }}
    add:
      - SYS_PTRACE
{{- end }}
{{- end -}}

{{/* Name of the service account for the executor agent */}}
{{- define "simphera.executorAgentServiceAccountName" -}}
{{- if .Values.global.simphera.serviceAccounts.executorAgentLinux -}}
{{ .Values.global.simphera.serviceAccounts.executorAgentLinux | quote -}}
{{- else -}}
executoragentlinux
{{- end -}}
{{- end -}}

{{/* securityContext of a regular SIMPHERA executoragents cronjobs */}}
{{- define "simphera.CronJobPodSecurityContext" -}}
{{- $randomId := randNumeric 4 | int | add 10000 -}}
securityContext:
  runAsUser: {{ $randomId }}
  runAsGroup: {{ $randomId }}
{{- end -}}
