# Install the SIMPHERA Quickstart Helm chart
param (
    [Parameter(Position=0,Mandatory=$true)][string]$namespace
)

helm install simphera-release ./simphera-quickstart -n $namespace -f ./custom-values.yaml
#change to Upgrade After install
