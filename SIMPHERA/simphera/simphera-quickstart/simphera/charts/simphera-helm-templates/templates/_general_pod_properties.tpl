{{- define "simphera.generalPodProperties" -}}
{{- with .Values.global.simphera.linuxNodes.nodeSelector -}}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.global.simphera.linuxNodes.tolerations -}}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
imagePullSecrets:
{{- range .Values.global.simphera.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}

{{- define "simphera.aurelionPodProperties" -}}
{{- with .Values.global.simphera.linuxAurelionNodes.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: simphera.dspace.com/aurelion
              operator: In
              values:
              - "true"
        topologyKey: "kubernetes.io/hostname"
{{- with .Values.global.simphera.linuxAurelionNodes.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
imagePullSecrets:
{{- range .Values.global.simphera.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
