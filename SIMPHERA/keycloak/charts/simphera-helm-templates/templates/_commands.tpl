{{/* Execute command or wrap command with linkerd-await */}}
{{- define "simphera.job.command" -}}
{{- $ := index . 0 -}}
{{- $cmd := index . 1 -}}
{{- $args := ternary (slice . 1) (slice . 2) $.Values.global.simphera.linkerd.enabled -}}
{{- if $.Values.global.simphera.linkerd.enabled }}
command: ["/usr/local/bin/linkerd-await"]
{{- else }}
command: [{{ $cmd | quote}}]
{{- end }}
args:
{{- if $.Values.global.simphera.linkerd.enabled }}
  - "--shutdown"
  - "--"
{{- end }}
{{- range $args }}
  - {{ . | quote }}
{{- end }}  
{{- end -}}