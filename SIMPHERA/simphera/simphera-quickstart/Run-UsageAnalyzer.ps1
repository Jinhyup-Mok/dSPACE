<# dSPACE PowerShell-File
#
# Name = Run-UsageAnalyzer.ps1
# Purpose = Script for analyzing the license usage records of the SIMPHERA billing service.
#
# Copyright 2021, dSPACE GmbH. All rights reserved.
#>

<#
.SYNOPSIS
    Executes the license usage analyzer and outputs the result on the console.
.DESCRIPTION
    This script starts the usageanalyzer which analyzes the license usage records of the SIMPHERA billing service and
    lists the results in a variety of reports. The time period evaluated and displayed in the report can be configured as well as the output type.
    The correct kubernetes cluster context has to be set, e.g. by setting the KUBECONFIG environment variable.
.PARAMETER Namespace
    The kubernetes namespace the helm chart has been deployed to.
.PARAMETER HelmRelease
    The name of the SIMPHERA helm release.
.PARAMETER arg1
    An optional first argument to the usage analyzer. It must be enclosed in quotation marks.
.PARAMETER arg2
    An optional 2nd argument to the usage analyzer. It must be enclosed in quotation marks.
.PARAMETER arg3
    An optional 3rd argument to the usage analyzer. It must be enclosed in quotation marks.
.PARAMETER arg4
    An optional 4th argument to the usage analyzer. It must be enclosed in quotation marks.
.PARAMETER arg5
    An optional 5th argument to the usage analyzer. It must be enclosed in quotation marks.
.PARAMETER arg6
    An optional 6th argument to the usage analyzer. It must be enclosed in quotation marks.
.PARAMETER arg7
    An optional 7th argument to the usage analyzer. It must be enclosed in quotation marks.
.PARAMETER Kubeconfig
    Optional path to 'kubeconfig' file. If omitted, the file specified in environment variable 'KUBECONFIG' is used.
.EXAMPLE
    ./<chart-name>/Run-UsageAnalyzer.ps1 -Namespace mysimphera -HelmRelease mysimphera "-r:Detailed" "-j"
#>

param(
    [parameter(Mandatory=$true)][string] $Namespace,
    [parameter(Mandatory=$true)][string] $HelmRelease,
    [parameter(Mandatory=$false)][string] $arg1,
    [parameter(Mandatory=$false)][string] $arg2,
    [parameter(Mandatory=$false)][string] $arg3,
    [parameter(Mandatory=$false)][string] $arg4,
    [parameter(Mandatory=$false)][string] $arg5,
    [parameter(Mandatory=$false)][string] $arg6,
    [parameter(Mandatory=$false)][string] $arg7,
    [parameter(Mandatory=$false)][string] $Kubeconfig = $null -ne $env:KUBECONFIG ? "$env:KUBECONFIG" : "$env:HOME/.kube/config"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

# Get the current helm configuration
$helmValues=`helm get values -n $Namespace $HelmRelease -a -o json --kubeconfig $Kubeconfig | ConvertFrom-Json

# Extract Image tag and repository from helm configuration
$imageTag = $helmValues.global.simphera.image.tag
$imageRegistry = $helmValues.global.simphera.image.registry

# Check whether image pull secrets are specified in helm configuration
$pullSecretJsonString = ""
if (($helmValues.global.simphera.image | Get-Member pullSecrets) -and $helmValues.global.simphera.image.pullSecrets.Count -gt 0)
{
    $pullSecret = $helmValues.global.simphera.image.pullSecrets[0]
    $pullSecretJsonString = '"imagePullSecrets": [{"name": "' + $pullSecret + '"}], '
}

# Extract PostgreSQL configuration from helm configuration
$postgresqlHostname = $helmValues.global.simphera.databases.simphera.pgHost
$postgresqlDbName = $helmValues.global.simphera.databases.simphera.pgDatabase
$postgresqlDbPort = $helmValues.global.simphera.databases.simphera.pgPort

if (($helmValues.global.simphera.databases.simphera | Get-Member secret) -and ($null -ne $helmValues.global.simphera.databases.simphera.secret))
{
  $postgresqlSecretName = $helmValues.global.simphera.databases.simphera.secret
}
else
{
  $postgresqlSecretName = "database-simphera-secret"
}

# Mount custom root certificates
$volumes = ""
$volumeMounts = ""

if($helmValues.global.simphera.customRootCertificates | Get-Member existingSecret){

    $certificatesSecret = $helmValues.global.simphera.customRootCertificates.existingSecret
    $secretKey = $helmValues.global.simphera.customRootCertificates.key
    $volumeMounts = @"
        "volumeMounts": [
          {
            "name": "custom-root-certificates",
            "readOnly": true,
            "mountPath": "/etc/ssl/certs/customRootCertificates.pem",
            "subPath": "$secretKey"
          }
        ],
"@
    $volumes = @"
    "volumes": [
        {
            "name": "custom-root-certificates",
            "secret": {
                "secretName": "$certificatesSecret"
            }
        }
    ],
"@
}

# Calculate repository of initialization container image
$analyzerImage = $imageRegistry + "/dspace/simphera/billing/usageanalyzer:" + $imageTag

# Create the json needed to configure the pod
$json_raw = @"
{
    "spec": {
         $pullSecretJsonString
         $volumes
         "containers": [{
            $volumeMounts
            "name": "usageanalyzer",
            "image": "$analyzerImage",
            "args": [
                    "$arg1",
                    "$arg2",
                    "$arg3",
                    "$arg4",
                    "$arg5",
                    "$arg6",
                    "$arg7"
            ],
            "env": [{
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
                    {
                        "name": "DB_PORT",
                        "value": "$postgresqlDbPort"
                    },
                    {
                        "name": "DB_NAME",
                        "value": "$postgresqlDbName"
                    }
            ]
        }]
    }
}
"@

$json = $json_raw -replace '\s','' |  ConvertTo-Json -Compress

# Start a new pod in the cluster that performs the initialization.
kubectl run usageanalyzer -n $Namespace -i --image=$analyzerImage --overrides=$json --restart=Never --leave-stdin-open --rm=true --quiet --pod-running-timeout=5m --kubeconfig=$Kubeconfig
