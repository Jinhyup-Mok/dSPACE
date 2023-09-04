<# dSPACE PowerShell-File
#
# Name = Install-Demodata.ps1
# Purpose = Script for the installation of SIMPHERA demo projects.
#
# Copyright 2022, dSPACE GmbH. All rights reserved.
#>

<#
.SYNOPSIS
    Installs SIMPHERA demo projects.
.DESCRIPTION
    This script adds some demo projects to a SIMPHERA installation.
    The correct kubernetes cluster context has to be set, e.g. by setting the KUBECONFIG environment variable.
.PARAMETER Namespace
    The kubernetes namespace the helm chart has been deployed to.
.PARAMETER HelmRelease
    The name of the SIMPHERA helm release.
.PARAMETER AccessToken
    The token to be used for authentication on uploading demo data via SIMPHERA REST API.
.PARAMETER DemoSet
    Optional name of the demo set to be installed. Available sets are 'default', 'aurelion', '2021a', '2021a_aurelion', '2022a' and '2022a_aurelion'. If omitted, demo sets 'default', 'aurelion', '2021a' and '2021a_aurelion' are installed.
.PARAMETER Kubeconfig
    Optional path to 'kubeconfig' file. If omitted, the file specified in environment variable 'KUBECONFIG' is used.
.EXAMPLE
    ./<chart-name>/Install-Demodata.ps1 -Namespace mysimphera -HelmRelease mysimphera -DemoSet default -AccessToken wef73Ih...qX38oMcg
#>

param(
    [parameter(Mandatory=$true)][string] $Namespace,
    [parameter(Mandatory=$true)][string] $HelmRelease,
    [parameter(Mandatory=$false)][string] $AccessToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJRMGhmSE5oZS1qSGNjOFBXZVZKMjFkZTJFMEJLU3dKYktnVFpvNjg4QWgwIn0.eyJleHAiOjE2OTIxNzM3ODUsImlhdCI6MTY5MjE3MTk4NSwiYXV0aF90aW1lIjoxNjkyMTcxOTg1LCJqdGkiOiI1MDRkNmNkMi1hODY4LTRiMjEtYjgwZC1iY2E1MTYxMjg4MTciLCJpc3MiOiJodHRwczovL215c2ltcGhlcmEtbG9naW4uZHNwYWNlLmNsb3VkL2F1dGgvcmVhbG1zL3NpbXBoZXJhIiwiYXVkIjpbInNpbXBoZXJhLWNsaWVudCIsImFjY291bnQiXSwic3ViIjoiNzRkNTM3NjAtMDVmMS00NGVhLTllNGItMWQwZGY3ZGM4MGNmIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoic2ltcGhlcmEtY2xpZW50Iiwic2Vzc2lvbl9zdGF0ZSI6IjVmZjFiNjhjLTRiMTQtNGE4ZC1iYjQyLWZiNWQyOTkxYmVlMyIsImFsbG93ZWQtb3JpZ2lucyI6WyIqIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvZmZsaW5lX2FjY2VzcyIsImRlZmF1bHQtcm9sZXMtc2ltcGhlcmEiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwiLCJzaWQiOiI1ZmYxYjY4Yy00YjE0LTRhOGQtYmI0Mi1mYjVkMjk5MWJlZTMiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsIm5hbWUiOiJkU1BBQ0UgS29yZWEiLCJncm91cHMiOltdLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJzaW1waGVyYSIsImdpdmVuX25hbWUiOiJkU1BBQ0UiLCJmYW1pbHlfbmFtZSI6IktvcmVhIn0.ZVIMlsXjayp0zLx6ttpOrmJWM0MSJF1oYRhd3LfF_8pODiXW-p730Yg4D5kDPMX26tYbqsjvtQLsazKbCo7v1Vf5SzX-hbQwoe169QRVZH0NQmA102miTQvrxLBjUv3AMjddQdzVZOCJLmXbNtW2EXHsBSMSPLj5121DkavzpA1zAHxa2sjAdBhG2bFPD2jl04oOrysIe4wsZjk9xa6u_GmsTefH9es8dz4I7J8zIyu1paJ5mK7HA_6el30mIAvqF93d1rl4qx7_UQK71sCYCoZfYI58JnPWE4wiNg-iz9TFBm2OtzI5QVtNRDXvO6JKohdJ76oq3ofgxTA1K0Yoww",
    [parameter(Mandatory=$false)][string[]] [ValidateSet("default", "aurelion" ,"2021a", "2021a_aurelion", "2022a", "2022a_aurelion")] $DemoSet = @("default", "aurelion", "2021a", "2021a_aurelion"),
    [parameter(Mandatory=$false)][string] $Kubeconfig = $null -ne $env:KUBECONFIG ? "$env:KUBECONFIG" : "$env:HOME/.kube/config"
)

$ErrorActionPreference = "Stop"

# Get the current helm configuration
$helmValues=`helm get values -n $Namespace $HelmRelease -a -o json --kubeconfig $Kubeconfig | ConvertFrom-Json

# Extract Image tag and repository from helm configuration
$imageTag = $helmValues.global.simphera.image.tag
$containerRegistry = $helmValues.global.simphera.image.registry

# Check whether image pull secrets are specified in helm configuration
$pullSecretJsonString = ""
if ($helmValues.global.simphera.image.pullSecrets.Count -gt 0)
{
    $pullSecret = $helmValues.global.simphera.image.pullSecrets[0]
    $pullSecretJsonString = '"imagePullSecrets": [{"name": "' + $pullSecret + '"}], '
}

# Extract PostgreSQL configuration from helm configuration
$postgresqlHostname = $helmValues.global.simphera.databases.simphera.pgHost

$postgresqlDbName = $helmValues.global.simphera.databases.simphera.pgDatabase
$postgresqlDbPort = $helmValues.global.simphera.databases.simphera.pgPort

if ($null -ne $helmValues.global.simphera.databases.simphera.secret)
{
  $postgresqlSecretName = $helmValues.global.simphera.databases.simphera.secret
}
else
{
  $postgresqlSecretName = "database-simphera-secret"
}

# Extract MinIO configuration from helm configuration
if ($null -ne $helmValues.global.simphera.minio.adminSecret)
{
  $minioCredentialsSecretName = $helmValues.global.simphera.minio.adminSecret
}
else
{
  $minioCredentialsSecretName = "minio-admin-secret"
}

# Calculate repository of initialization container image
$initializeImage = $containerRegistry + "/dspace/simphera/core/initialize:" + $imageTag

# Mount custom root certificates
$volumes = @(@"
      {
        "name": "app-config",
        "configMap": {
            "name": "appshell-config"
        }
      }
"@)

$volumeMounts = @(@"
          {
            "name": "app-config",
            "readOnly": true,
            "mountPath": "/demos/app-config.js",
            "subPath": "app-config.js"
          }
"@)

if($null -ne $helmValues.global.simphera.customRootCertificates.existingSecret){

    $certificatesSecret = $helmValues.global.simphera.customRootCertificates.existingSecret
    $secretKey = $helmValues.global.simphera.customRootCertificates.key
    $volumeMounts += @"
          {
            "name": "custom-root-certificates",
            "readOnly": true,
            "mountPath": "/etc/ssl/certs/customRootCertificates.pem",
            "subPath": "$secretKey"
          }
"@
    $volumes += @"
      {
        "name": "custom-root-certificates",
        "secret": {
            "secretName": "$certificatesSecret"
        }
      }
"@
}

# Arguments for the init container
$containerArgs = @()
$containerArgs += "-action"
$containerArgs += "importDemos"
$containerArgs += "-bearerToken"
$containerArgs += $AccessToken
$containerArgs += "-containerRegistry"
$containerArgs += $containerRegistry
$containerArgs += "-demoSets"
$containerArgs += $DemoSet -join ','

# Convert argument array to string
$containerArgsString = '"' + ($containerArgs -join '", "') + '"'

# Create the json needed to configure the pod
$json_raw = @"
{
  "spec": {
    $pullSecretJsonString
    "volumes": [
$($volumes -join ",`n")
    ],
    "nodeSelector": {
        "kubernetes.io/os": "linux"
    },
    "containers": [
      {
        "volumeMounts": [
$($volumeMounts -join ",`n")
        ],
        "name": "demoimport",
        "image": "$initializeImage",
        "args": [ $containerArgsString ],
        "env": [
          {
            "name": "RFS_MINIO_DEFAULT_ACCESS_KEY",
            "valueFrom": {
              "secretKeyRef": {
                "name": "$minioCredentialsSecretName",
                "key": "user"
              }
            }
          },
          {
            "name": "RFS_MINIO_DEFAULT_SECRET_KEY",
            "valueFrom": {
              "secretKeyRef": {
                "name": "$minioCredentialsSecretName",
                "key": "password"
              }
            }
          },
          {
            "name": "DB_USER",
            "valueFrom": {
              "secretKeyRef": {
                "name": "$postgresqlSecretName",
                "key": "username"
              }
            }
          },
          {
            "name": "DB_PASSWORD",
            "valueFrom": {
              "secretKeyRef": {
                "name": "$postgresqlSecretName",
                "key": "password"
              }
            }
          },
          {
            "name": "DB_HOST",
            "value": "$postgresqlHostname"
          },
          { "name": "DB_PORT", "value": "$postgresqlDbPort" },
          { "name": "DB_NAME", "value": "$postgresqlDbName" }
        ]
      }
    ]
  }
}
"@

$json = $json_raw -replace '\s','' #|  ConvertTo-Json -Compress
echo $json >  tempjson.txt
# Start a new pod in the cluster that performs the initialization.
kubectl run databaseinitialization -n $Namespace --overrides=$json --restart=Never --leave-stdin-open --quiet --pod-running-timeout=10m --image=$initializeImage --kubeconfig=$Kubeconfig
