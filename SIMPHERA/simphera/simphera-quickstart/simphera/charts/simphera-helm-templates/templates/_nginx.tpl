{{- define "simphera.nginx.volumeMounts" -}}
- name: nginx-cache
  mountPath: /var/cache/nginx
- name: nginx-var
  mountPath: /var/nginx
{{- end -}}

{{- define "simphera.nginx.volumes" -}}
- name: nginx-cache
  emptyDir: {}
- name: nginx-var
  emptyDir: {}
{{- end -}}

{{/* health checks of a SIMPHERA frontend container, refer to https://developers.redhat.com/blog/2020/11/10/you-probably-need-liveness-and-readiness-probes#example_4__putting_it_all_together */}}
{{- define "simphera.frontendContainerHealthChecks" -}}
readinessProbe:
  httpGet:
    path: /index.html
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 15
  failureThreshold: 5
livenessProbe:
  exec:
    command:
    - /bin/sh
    - -c
    - "pgrep nginx"
  initialDelaySeconds: 10
  periodSeconds: 15
  failureThreshold: 5
{{- end -}}
