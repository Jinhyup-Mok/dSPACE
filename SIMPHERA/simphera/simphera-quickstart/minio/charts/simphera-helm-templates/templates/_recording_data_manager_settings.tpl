{{- define "simphera.recordingDataManagerSettings" -}}
{{- if .Values.global.simphera.rdm.enabled }}
- name: RDM_TYPE
  value: {{ .Values.global.simphera.rdm.type | quote }}
- name: RDM_URL
  value: {{ .Values.global.simphera.rdm.url | quote }}
- name: RDM_API
  value: {{ .Values.global.simphera.rdm.apiUrl | quote }}
- name: RDM_STORAGE_IDS
  value: {{ .Values.global.simphera.rdm.storageIds | quote }}
- name : RDM_PROXY_ENABLED
  value: {{ .Values.global.simphera.rdm.enabledProxy | quote }}
- name : RDM_RETRIES
  value: '2'
- name : RDM_TIMEOUT
  value: '10'
{{- if .Values.global.simphera.rdm.enabledProxy }}
- name : RDM_PROXY_HOSTNAME
  value: {{ .Values.global.simphera.proxy.hostname }}
{{- end }}
{{- if .Values.global.simphera.rdm.secretName }}
- name: RDM_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.global.simphera.rdm.secretName }}
      key: username
- name: RDM_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.global.simphera.rdm.secretName }}
      key: password
{{- else }}
- name: RDM_USER
  value: {{ .Values.global.simphera.rdm.username }}
- name: RDM_PASSWORD
  value: {{ .Values.global.simphera.rdm.password }}
{{- end }}
{{- end }}
{{- end -}}
