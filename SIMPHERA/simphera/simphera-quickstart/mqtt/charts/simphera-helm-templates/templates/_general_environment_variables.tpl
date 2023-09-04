{{- define "simphera.generalEnvironmentVariables" -}}
- name: WTC_LOG_LEVEL
  value: {{ .Values.global.simphera.log.level | quote }}
- name: WTC_LOG_FORMAT
  value: CONSOLE_JSON
- name: WTC_MQTT_TOPIC_PREFIX
  value: {{ .Values.global.simphera.mqtt.topicPrefix | quote }}
- name: WTC_MQTT_HOST
  value: {{ printf "%s:9001" .Values.global.simphera.mqtt.host | quote }}
- name: WTC_MQTT_USER
  valueFrom:
    secretKeyRef:
      name: {{ include "simphera.mqtt.secret" . }}
      key: username
- name: WTC_MQTT_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "simphera.mqtt.secret" . }}
      key: password
- name: OIDC_ISSUER_URL
  value: {{ .Values.global.simphera.openIdProvider.issuerUrl | quote }}
- name: OIDC_CLIENT_ID
  value: {{ .Values.global.simphera.openIdProvider.clientId | quote }}
- name: OIDC_SCOPE
  value: {{ .Values.global.simphera.openIdProvider.scope | quote }}
{{- end -}}
