{{/* Annotations for SIMPHERA migration jobs */}}
{{- define "simphera.migrationAnnotations" -}}
ignore-check.kube-linter.io/no-liveness-probe: "Migration jobs only run once and for a short time, thus, they don't require liveness probes."
ignore-check.kube-linter.io/no-readiness-probe: "Migration jobs don't need a readiness probe since they don't get called from outside."
{{- end -}}
