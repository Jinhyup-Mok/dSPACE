{{- define "simphera.customRootCertificates.environmentVariables" -}}
{{- if .Values.global.simphera.customRootCertificates.existingSecret }}
- name: SSL_CERT_DIR
  value: "/etc/ssl/certs"
- name: SSL_CERT_FILE
  value: "/etc/ssl/certs/customRootCertificates.pem"
- name: NODE_EXTRA_CA_CERTS
  value: "/etc/ssl/certs/customRootCertificates.pem"
{{- end }}
{{- end -}}

{{- define "simphera.customRootCertificates.volumeMounts" -}}
{{- if .Values.global.simphera.customRootCertificates.existingSecret }}
- name: custom-root-certificates
  mountPath: "/etc/ssl/certs/customRootCertificates.pem"
  subPath: {{ .Values.global.simphera.customRootCertificates.key | required ("Required value not set: global.simphera.customRootCertificates.key") }}
  readOnly: true
{{- end }}
{{- end -}}

{{- define "simphera.customRootCertificates.volumes" -}}
{{- if .Values.global.simphera.customRootCertificates.existingSecret }}
- name: custom-root-certificates
  secret:
    secretName: {{ .Values.global.simphera.customRootCertificates.existingSecret }}
{{- end }}
{{- end -}}
