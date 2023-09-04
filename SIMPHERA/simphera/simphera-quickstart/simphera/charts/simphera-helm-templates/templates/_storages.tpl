{{/*
Create a environment variables for defined storages.
*/}}
{{- define "simphera.storages" -}}
{{- if .Values.global.simphera.storages }}
{{- range $name, $value := $.Values.global.simphera.storages }}
{{- $type := $value.type | required (printf "Required value not set: global.simphera.storages.%s.type" $name) }}
{{/* If the type on the Helm level is 'PersistentVolume' then the code running inside the container
         can use regular file I/O to access the files. So from the container's point of view the
         type is 'File_System' */}}
{{- $typeOnContainer := eq $type "PersistentVolume" | ternary "File_System" $type }}
{{- $prefix := printf "RFS_%s_%s" $typeOnContainer $name | upper -}}
{{/* make it as global as possible to allow proxies for basically every storage type  */}}
{{- if $value.enabledProxy }}
- name: {{ $prefix }}_PROXY_HOSTNAME
  value: {{ $.Values.global.simphera.proxy.hostname | quote }}
{{- end }}

{{- if eq $type "Minio" }}
{{- if not $value.path }}
{{ printf "You must configure the base URL to your MinIO/S3 storage for storage '%s' under 'global.simphera.storages.%s.path'. Please refer to the SIMPHERA Administration Manual for more details." $name $name | fail }}
{{- else if not (kindIs "string" $value.path) }}
{{ printf "The base URL to your MinIO/S3 storage for storage '%s' under 'global.simphera.storages.%s.path' must be a string. Please refer to the SIMPHERA Administration Manual for more details." $name $name | fail }}
{{- else if not ($value.path | lower | hasPrefix "http") }}
{{ printf "The base URL to your MinIO/S3 storage for storage '%s' under 'global.simphera.storages.%s.path' must start with 'http'. Current value is '%s'. Please refer to the SIMPHERA Administration Manual for more details." $name $name $value.path | fail }}
{{- else }}
{{- if $value.secretName }}
- name: {{ $prefix }}_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretName | quote }}
      key: user
- name: {{ $prefix }}_SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretName | quote }}
      key: password
{{- else }}
- name: {{ $prefix }}_ACCESS_KEY
  value: {{ $value.accessKey | quote }}
- name: {{ $prefix }}_SECRET_KEY
  value: {{ $value.secretKey | quote }}
{{- end }}
{{- end }}
{{- end }}

{{- if eq $type "MinioToken" }}
{{- if $value.secretName }}
- name: {{ $prefix }}_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretName | quote }}
      key: token
{{- else }}
- name: {{ $prefix }}_TOKEN
  value: {{ $value.token | quote }}
{{- end }}
{{- end }}
{{- if eq $type "Azure" }}
{{- if $value.secretName }}
- name: {{ $prefix }}_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretName | quote }}
      key: accessKey
- name: {{ $prefix }}_SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretName | quote }}
      key: secretKey
- name: {{ $prefix }}_STORAGE_ACCOUNT_NAME
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretName | quote }}
      key: storageAccountName
- name: {{ $prefix }}_STORAGE_ACCOUNT_KEY
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretName | quote }}
      key: storageAccountKey
{{- else }}
- name: {{ $prefix }}_ACCESS_KEY
  value: {{ $value.accessKey | quote }}
- name: {{ $prefix }}_SECRET_KEY
  value: {{ $value.secretKey | quote }}
- name: {{ $prefix }}_STORAGE_ACCOUNT_NAME
  value: {{ $value.storageAccountName | quote }}
- name: {{ $prefix }}_STORAGE_ACCOUNT_KEY
  value: {{ $value.storageAccountKey | quote }}
{{- end }}
{{- end }}

{{- if eq $type "HTTPBearer" }}
{{- if $value.secretName }}
- name: {{ $prefix }}_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretName | quote }}
      key: token
{{- else }}
- name: {{ $prefix }}_TOKEN
  value: {{ $value.token | quote }}
{{- end }}
{{- end }}
- name: {{ $prefix }}_PATH
{{- if eq $type "PersistentVolume" }}
  value: {{ printf "/storages/%s" $name | quote }}
{{- else }}
  value: {{ $value.path | quote }}
{{- end }}
- name: {{ $prefix }}_ENABLED_IRSA
  value: {{ or $value.enabledIrsa "false" | quote }}
{{- end }}
{{- end }}
{{- end -}}


{{/*
Add a environment variables for defined storages.
{{- include "simphera.addStorageByName" (dict "context" .Values "envPrefix" "RESULT_" "storageName" "resultStorage" ) | nindent 8 }}
or with default prefix "STORAGE_NAME", "STORAGE_TYPE", "STORAGE_PATH"
{{- include "simphera.addStorageByName" (dict "context" .Values "storageName" "resultStorage" ) | nindent 8 }}
*/}}
{{- define "simphera.addStorageByName" -}}
{{- $context := .context -}}
{{- $storageName := .storageName -}}
{{- $envPrefix := default "" .envPrefix -}}
{{- if $context.global.simphera.storages }}
{{- range $name, $value := $context.global.simphera.storages }}
{{- if not (empty $storageName) }}
{{- if (eq $name $storageName) }}
- name : {{ $envPrefix }}STORAGE_NAME
  value: {{ $name | quote }}
{{- if eq $value.type "PersistentVolume" }}
  {{/* If the type on the Helm level is 'PersistentVolume' then the code running inside the container
         can use regular file I/O to access the files. So from the container's point of view the
         type is 'File_System' */}}
- name : {{ $envPrefix }}STORAGE_TYPE
  value: "File_System"
- name : {{ $envPrefix }}STORAGE_PATH
  value: {{ printf "/storages/%s" $name | quote }}
{{- else }}
- name : {{ $envPrefix }}STORAGE_TYPE
  value: {{ $value.type | quote }}
- name : {{ $envPrefix }}STORAGE_PATH
  value: {{ $value.path | quote }}
{{- end }}
{{- if eq $value.type "Minio" }}
- name: {{ $envPrefix }}STORAGE_ENABLED_IRSA
  value: {{ or $value.enabledIrsa "false" | quote }}
{{- end}}
{{- if $value.enabledProxy }}
- name: {{ $envPrefix }}PROXY_HOSTNAME
  value: {{ $context.global.simphera.proxy.hostname | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "simphera.storages.volumes" -}}
{{- if .Values.global.simphera.storages }}
{{- $createdVolumeNames := dict -}}
{{- range $name, $value := $.Values.global.simphera.storages }}
{{- $type := $value.type | required (printf "Required value not set: global.simphera.storages.%s.type" $name) }}
{{- if eq $type "PersistentVolume" }}
{{- if $value.existingClaim }}
{{- /*
If the admin uses the same existing claim for multiple storages then we only have to create one volume because
Kubernetes does not allow to create multiple volumes using the same PVC (the pod will never start).
Therefore we put the name of a rendered volume into the dictionary createdVolumeNames and always check before
whether the name already exists in the dictionary. This prevents that it is rendered multiple times.
*/}}
{{- $volumeName := printf "pvc-volume-%s" ($value.existingClaim | lower) | quote }}
{{- if not (hasKey $createdVolumeNames $volumeName) }}
{{- $_ := set $createdVolumeNames $volumeName "true" }}
- name: {{ $volumeName }}
  persistentVolumeClaim:
    claimName: {{ $value.existingClaim | quote }}
{{- end  }}
{{- else }}
- name: {{ printf "storage-%s" ($name | lower) | quote }}
  persistentVolumeClaim:
    claimName: {{ printf "storage-%s-pvc" ($name | lower) | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "simphera.storages.volumemounts" -}}
{{- if .Values.global.simphera.storages }}
{{- range $name, $value := $.Values.global.simphera.storages }}
{{- $type := $value.type | required (printf "Required value not set: global.simphera.storages.%s.type" $name) }}
{{- if eq $type "PersistentVolume" }}
{{- if $value.existingClaim }}
- name: {{ printf "pvc-volume-%s" ($value.existingClaim | lower) | quote }}
{{- else }}
- name: {{ printf "storage-%s" ($name | lower) | quote }}
{{- end }}
  mountPath: {{ printf "/storages/%s" $name | quote }}
{{- if $value.subPath }}
  subPath: {{ $value.subPath | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}
