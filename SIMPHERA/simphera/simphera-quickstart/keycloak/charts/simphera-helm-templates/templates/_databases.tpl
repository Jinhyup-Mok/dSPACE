{{- define "simphera.databases.simphera.environmentVariables" -}}
{{- $pgDatabase := .Values.global.simphera.pgbouncer.enabled | ternary "simphera" .Values.global.simphera.databases.simphera.pgDatabase -}}
{{- $pgHost := .Values.global.simphera.pgbouncer.enabled | ternary "pgbouncer" .Values.global.simphera.databases.simphera.pgHost -}}
{{- $pgPort := .Values.global.simphera.pgbouncer.enabled | ternary "6432" .Values.global.simphera.databases.simphera.pgPort -}}
{{- $pgSecret := default "database-simphera-secret" .Values.global.simphera.databases.simphera.secret -}}
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: {{ $pgSecret }}
      key: username
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ $pgSecret }}
      key: password
- name: DB_HOST
  value: {{ $pgHost | quote }}
- name: DB_PORT
  value: {{ $pgPort | quote }}
- name: DB_NAME
  value: {{ $pgDatabase | quote }}
{{- end -}}

{{- define "simphera.databases.simpheraScbtResults.environmentVariables" -}}
{{- if .Values.global.simphera.databases.simpheraScbtResults.enabled -}}
{{- $pgDatabase := .Values.global.simphera.pgbouncer.enabled | ternary "simphera_scbt_results" .Values.global.simphera.databases.simpheraScbtResults.pgDatabase -}}
{{- $pgHost := .Values.global.simphera.pgbouncer.enabled | ternary "pgbouncer" .Values.global.simphera.databases.simpheraScbtResults.pgHost -}}
{{- $pgPort := .Values.global.simphera.pgbouncer.enabled | ternary "6432" .Values.global.simphera.databases.simpheraScbtResults.pgPort -}}
{{- $pgSecret := default "database-simphera-scbt-results-secret" .Values.global.simphera.databases.simpheraScbtResults.secret -}}
- name: DB_RESULT_USER
  valueFrom:
    secretKeyRef:
      name: {{ $pgSecret }}
      key: username
- name: DB_RESULT_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ $pgSecret }}
      key: password
- name: DB_RESULT_HOST
  value: {{ $pgHost | quote }}
- name: DB_RESULT_PORT
  value: {{ $pgPort | quote }}
- name: DB_RESULT_NAME
  value: {{ $pgDatabase | quote }}
{{- else -}}
{{- $pgDatabase := .Values.global.simphera.pgbouncer.enabled | ternary "simphera" .Values.global.simphera.databases.simphera.pgDatabase -}}
{{- $pgHost := .Values.global.simphera.pgbouncer.enabled | ternary "pgbouncer" .Values.global.simphera.databases.simphera.pgHost -}}
{{- $pgPort := .Values.global.simphera.pgbouncer.enabled | ternary "6432" .Values.global.simphera.databases.simphera.pgPort -}}
{{- $pgSecret := default "database-simphera-secret" .Values.global.simphera.databases.simphera.secret -}}
- name: DB_RESULT_USER
  valueFrom:
    secretKeyRef:
      name: {{ $pgSecret }}
      key: username
- name: DB_RESULT_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ $pgSecret }}
      key: password
- name: DB_RESULT_HOST
  value: {{ $pgHost | quote }}
- name: DB_RESULT_PORT
  value: {{ $pgPort | quote }}
- name: DB_RESULT_NAME
  value: {{ $pgDatabase | quote }}
{{- end -}}
{{- end -}}
