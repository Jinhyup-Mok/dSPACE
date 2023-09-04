{{/* Annotations for SIMPHERA REST API ingresses */}}
{{- define "simphera.restApiIngressAnnotations" -}}
kubernetes.io/ingress.class: nginx
{{- if .Values.global.simphera.ingress.sslRedirect }}
ingress.kubernetes.io/ssl-redirect: "true"
{{- end }}
nginx.ingress.kubernetes.io/enable-cors: 'true'
nginx.ingress.kubernetes.io/auth-url: "http://authmanagerservice.{{ .Release.Namespace }}.svc.{{ .Values.global.simphera.clusterDomain }}:8000/validate"
nginx.ingress.kubernetes.io/auth-response-headers: Authorization
nginx.ingress.kubernetes.io/proxy-body-size: 200m
nginx.ingress.kubernetes.io/server-snippet: |
  location @custom_401 {
    default_type application/json;
    return 401 '
    {
      "code": 401,
      "message": "Invalid Authentication Token",
      "target": "",
      "details": [
        {
          "code": 401,
          "message": "Provide a valid authentication token.",
          "target": "",
          "details": [],
          "innerError": null
        }
      ],
      "innerError": null
    }';
  }
  error_page 401 @custom_401;
{{- range $k, $v := .Values.global.simphera.ingress.additionalAnnotations }}
{{ $k }}: "{{ $v }}"
{{- end }}
{{- end -}}

{{/* Annotations for frontend ingresses */}}
{{- define "simphera.frontendIngressAnnotations" -}}
kubernetes.io/ingress.class: nginx
nginx.ingress.kubernetes.io/proxy-body-size: 200m
ignore-check.kube-linter.io/required-annotation-ingress-auth-url: "Frontends must not require authentication since the application itself must be loadable without any authentication."
{{- if .Values.global.simphera.ingress.sslRedirect }}
ingress.kubernetes.io/ssl-redirect: "true"
{{- end }}
{{- range $k, $v := .Values.global.simphera.ingress.additionalAnnotations }}
{{ $k }}: "{{ $v }}"
{{- end }}
{{- end -}}


{{/* Annotations for API gateway ingresses */}}
{{- define "simphera.apiGatewayIngressAnnotations" -}}
kubernetes.io/ingress.class: nginx
{{- if .Values.global.simphera.ingress.sslRedirect }}
ingress.kubernetes.io/ssl-redirect: "true"
{{- end }}
nginx.ingress.kubernetes.io/auth-url: "http://authmanagerservice.{{ .Release.Namespace }}.svc.{{ .Values.global.simphera.clusterDomain }}:8000/validate"
nginx.ingress.kubernetes.io/auth-response-headers: Authorization
nginx.ingress.kubernetes.io/proxy-body-size: 200m
{{- if .Values.global.simphera.enableCORS }}
nginx.ingress.kubernetes.io/enable-cors: "true"
nginx.ingress.kubernetes.io/cors-allow-headers: "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization,x-request-id"
{{- end }}
{{- range $k, $v := .Values.global.simphera.ingress.additionalAnnotations }}
{{ $k }}: "{{ $v }}"
{{- end }}
{{- end -}}

{{/* Annotations for Swagger ingresses */}}
{{- define "simphera.swaggerIngressAnnotations" -}}
kubernetes.io/ingress.class: nginx
ignore-check.kube-linter.io/required-annotation-ingress-auth-url: "Swagger frontends must not require authentication since the swagger frontend itself must be loadable without any authentication."
{{- if .Values.global.simphera.ingress.sslRedirect }}
ingress.kubernetes.io/ssl-redirect: "true"
{{- end }}
{{- range $k, $v := .Values.global.simphera.ingress.additionalAnnotations }}
{{ $k }}: "{{ $v }}"
{{- end }}
{{- end -}}

{{/* TLS specification for all ingresses */}}
{{- define "simphera.ingressTls" -}}
{{- if .Values.global.simphera.tlsCertificates.simphera }}
tls:
- hosts:
  - {{ .Values.global.simphera.hostnames.simphera }}
  secretName: {{ .Values.global.simphera.tlsCertificates.simphera }}
{{- end }}
{{- end -}}
