{{- define "simphera.frontendContainerResources" -}}
resources:
  requests:
    cpu: 1m
    memory: 16Mi
  limits:
    cpu: 1000m
    memory: 256Mi
{{- end -}}

{{- define "simphera.autoscalerContainerResources" -}}
resources:
  requests:
    cpu: 1m
    memory: 16Mi
  limits:
    cpu: 1000m
    memory: 256Mi
{{- end -}}

{{- define "simphera.nodeGatewayContainerResources" -}}
resources:
  requests:
    cpu: 10m
    memory: 128Mi
  limits:
    cpu: 4000m
    memory: 1Gi
{{- end -}}

{{- define "simphera.dotnetBusinesslogicContainerResources" -}}
resources:
  requests:
    cpu: 10m
    memory: 128Mi
  limits:
    cpu: 4000m
    memory: 1Gi
{{- end -}}

{{- define "simphera.nodeBusinesslogicContainerResources" -}}
resources:
  requests:
    cpu: 10m
    memory: 96Mi
  limits:
    cpu: 4000m
    memory: 1Gi
{{- end -}}

{{- define "simphera.migrationContainerResources" -}}
resources:
  requests:
    cpu: 10m
    memory: 64Mi
  limits:
    cpu: 1000m
    memory: 1Gi
{{- end -}}

{{- define "simphera.restApiContainerResources" -}}
resources:
  requests:
    cpu: 10m
    memory: 64Mi
  limits:
    cpu: 4000m
    memory: 1Gi
{{- end -}}

{{- define "simphera.aurelionPodContainerResources" -}}
resources:
  requests:
    cpu: 2000m
    memory: 4Gi
  limits:
    cpu: 8000m
    memory: 16Gi
{{- end -}}

{{- define "simphera.aurelionGenericContainerResources" -}}
resources:
  requests:
    cpu: 10m
    memory: 64Mi
  limits:
    cpu: 2000m
    memory: 1Gi
{{- end -}}

{{- define "simphera.simmanagerContainerResources" -}}
resources:
  requests:
    cpu: 10m
    memory: 64Mi
  limits:
    cpu: 2000m
    memory: 1Gi
{{- end -}}

{{- define "simphera.initContainerResources" -}}
resources:
  requests:
    cpu: 10m
    memory: 32Mi
  limits:
    cpu: 1
    memory: 1Gi
{{- end -}}
