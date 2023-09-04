{{- define "simphera.mqtt.secret" -}}
{{- default "mqtt-credentials" (.Values.global.simphera.mqtt.secret | quote) -}}
{{- end -}}
