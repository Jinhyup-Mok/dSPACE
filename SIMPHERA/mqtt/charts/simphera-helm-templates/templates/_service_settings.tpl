{{- define "simphera.serviceSettings.volumeMounts" -}}
{{- $ := index . 0 -}}
{{- $mountPath := index . 1 -}}
- name: servicesettings
  mountPath: {{ $mountPath | quote }}
  subPath: servicesettings.json
{{- end -}}

{{- define "simphera.serviceSettings.volumes" -}}
- name: servicesettings
  configMap:
    name: servicesettings
{{- end -}}
