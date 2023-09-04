# SIMPHERA Quickstart Helm chart

This Helm chart can be used to install SIMPHERA including some addtional services (Keycloak, MinIO, Mosquitto, etc.) needed to operate it. It is called _Quickstart_ because it does not only contain the core SIMPHERA services but also the aforementioned services. From a technical point of view this Helm chart is an _umbrella_ chart, i.e. it is made of various individual Helm charts. There is also a pure _SIMPHERA Helm chart_ that is only made of the core SIMPHERA services. Please do only use the _Quickstart_ chart.

The general installation procedure for SIMPHERA is explained in the [SIMPHERA Administration Manual ](https://www.dspace.com/go/SIMPHERA-Admin). If you did not yet read the Administration Manual, please read it now.

This Helm Chart contains a `values.yaml` file with the documentation of each individual configuration property that is available to configure the deployment of SIMPHERA. Therefore, please create an empty `values.yaml` file for your deployment first. Then open the `values.yaml` file from the Helm Charts folder in a text editor. Read through all the configuration properties and add those properties to your `values.yaml` file that needs to be changed.

## Configuration Changelog

This section documents all configuration changes between the various SIMPHERA versions.

### 23.2 to 23.3

* You no longer need to specify the `name` property for each individual storage (under `global.simphera.storages`) because the name is now extracted from the YAML path.
* There is a new mandatory storage you have to configure under `global.simphera.storages.measurementStorage`. This storage is used by the _Experiment App_ to store temporary data during the _analyze use-case_. The type of this storage must be `PersistentVolume`. You can either specify an existing `StorageClass` or an existing `PersistentVolumeClaim` for this storage. The corresponding persistent volume have to support the access mode `ReadWriteMany`.

### 23.1 to 23.2

* Storages of type `PersistentVolume` now support the specification of a `subpath`. Using this feature you can use a single persistent volume for multiple SIMPHERA storages.

### 22.9 to 23.1

* Removed `appshell.hooks.validation.analyze`, `appshell.hooks.validation.report` and `appshell.hooks.validation.testcaseresult`. These hooks must now be specified using the `additionalLinks` value in `values.yaml`.
* Role-based access control (RBAC) can be enabled and configured under `global.simphera.authorization`. Please see `values.yaml` file for details.

### 22.8 to 22.9

* Changed `global.simphera.datareplay.cacheStorageName` from `datareplayCacheStorage` to `datareplayProcessingObjectCacheStorage`
* Replaced `global.simphera.ivs` with `global.simphera.rdm`
* Added `global.simphera.rdm.type` to determine what type of recording data manager is used.

### 22.7 to 22.8

* The credentials for the MQTT broker can be specified using an existing secret. The name of the secret has to be specified in `global.simphera.mqtt.secret`.
* To install SIMPHERA demo data please use the new Powershell script `Install-Demodata.ps1` that is provided as part of the helm chart. See the [SIMPHERA Administration Manual ](https://www.dspace.com/go/SIMPHERA-Admin) for further details. 

### 22.6 to 22.7

* Per default base URLs of the various apps (SIMPHERA, Keycloak, MinIO) are assumed to be reachable from the outside under `https://hostname/` where `hostname` is configured under `global.simphera.hostnames`. If they are reachable under a different port or via HTTP instead of HTTPS then you must configure these URLs under `global.simphera.baseUrls`.
* The configuration of custom root certificates has been refactored. If you use custom root TLS certificate authorities for the SIMPHERA TLS certificates or for external systems such as PostgreSQL then you have to provide a single Kubernetes secret with the concatenation of all your custom root certificates in PEM format. You have to configure the name of the secret under `global.simphera.customRootCertificates.existingSecret` and the key of the file inside the secret under `global.simphera.customRootCertificates.key`.
* The name of agent image can be configured under `global.simphera.agent.image.name`. See the `values.yaml` file of the Quickstart chart for a default image name.` Currently the following docker images are supported
  * `dspace/simphera/execution/execution_node/linux/2021a`
* From now on you must specify a _username_ and a _password_ for the MQTT broker that is used by SIMPHERA. The values are `global.simphera.mqtt.username` and `global.simphera.mqtt.password`.

### 22.4 to 22.5

* The repositories of all 3rd party container images can be configured under `global.simphera.image.thirdparty`. See the `values.yaml` file of the Quickstart chart for a complete list.
* If you want to use existing Kubernetes service accounts you can configure them under 'global.simphera.serviceAccounts'.
  * The value `global.simphera.minio.serviceAccount` is deprecated. Please use `global.simphera.serviceAccounts.minio` instead.
* The pre-existing secret given to `global.simphera.minio.adminSecret` now requires the keys `user` instead of `access-key` and `password` instead of `secret-key`. This now matches the keys defined in the secret that is created by this chart if `global.simphera.minio.adminSecret` is not set.
* Variable `global.simphera.agent.rtmaps.licenseFileConfigMap` has been removed. Licensing for RTMaps is now done via CodeMeter. 

### 1.x to 22.4

The configuration of the SIMPHERA Quickstart Helm Chart has been refactored to make the configuration easier. From now on, all configuration properties are under the YAML node `global.simphera`. All configuration variables are documented in the `values.yaml` file of the Quickstart Helm chart.

Overview of the most important changes:
* All the properties that used to be under `global` are now under `global.simphera`.
* The DNS names for SIMPHERA, MinIO and Keycloak have to be configured under `global.simphera.hostnames`.
* The secret names for the TLS certificates for SIMPHERA, MinIO and Keycloak have to be configured under `global.simphera.tlsCertificates`.
* The configuration of MinIO, Keycloak and MQTT is now located under `global.simphera.minio`, `global.simphera.keycloak` and `global.simphera.mqtt`. The properties themselves did also change. Please see the `values.yaml` file for details.
* Additional ingress annotations can be specified under `global.simphera.ingress.additionalAnnotations`.
* The CodeMeter license server has to be specified under `global.simphera.codemeter.server`.
* The usage of a web proxy can be configured under `global.simphera.proxy.hostname`.
* The log level for the SIMPHERA backend can be configured under `global.simphera.log.level`.
* PostgreSQL and PGAdmin4 are no longer part of the SIMPHERA Quickstart Chart.

Due to these structural changes of the Helm chart the `helm upgrade` command may fail. In that case you first have to delete the Helm release using `helm delete` and afterwards you can run `helm install`.

# SIMPHERA Legal Notices

SIMPHERA uses third-party software components including open-source software. The legal information about these third-party components is collected in the `SIMPHERA_LegalNotices.zip` file next to this _Readme_. It contains the dSPACE EULA, the Microsoft .NET Library License and individual files for the different software artifacts of SIMPHERA. The files with filenames containing _OSSAcknowledgements_ contain the legal notices (open-source licenses and copyright information) of the software that is installed inside the corresponding components.

# Appendix: Troubleshooting

## Migration Job Exists with Error

When SIMPHERA is deployed to the cluster migration jobs are started in order to check whether data within the databases needs to be migrated to a new version. Such a migration step may fail, e.g. because the database is not (yet) available. In general there is a retry mechanism implemented but this does not always solve the problem. So after some time a migration job may exit with an error code. In that case you have to have a look at the log messages of the corresponding pod to find the reason of the problem. If the problem is solved you have to delete the corresponsing Kubernetes _Job_. Afterwards you can execute the `helm install` or `helm upgrade` command again in order to re-create the migration job.
