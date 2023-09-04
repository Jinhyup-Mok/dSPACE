{{- define "simphera.legalChecks" -}}

{{- if ne .Values.global.simphera.dspaceEulaAccepted true }}
{{ fail "You need to accept the dSPACE EULA in order to install SIMPHERA by setting 'global.simphera.dspaceEulaAccepted' to 'true'." }}
{{- end }}
{{- if ne .Values.global.simphera.microsoftDotnetLibraryLicenseAccepted true }}
{{ fail "You need to accept the Microsoft .NET Library License in order to install SIMPHERA by setting 'global.simphera.microsoftDotnetLibraryLicenseAccepted' to 'true'." }}
{{- end }}

{{- end -}}
