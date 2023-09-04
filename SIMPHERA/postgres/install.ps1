# Install a PostgreSQL database + pgAdmin4 (GUI)
param (
    [Parameter(Position=0,Mandatory=$true)][string]$namespace
)

# Download dependencies from Umbrella chart
# ~/bin/helm.exe dependency build .\postgres-database\

helm install simphera-postgresql ./postgres-database -n $namespace -f ./custom-values.yaml
