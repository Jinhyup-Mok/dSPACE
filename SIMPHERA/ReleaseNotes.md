# SIMPHERA Release Notes

## SIMPHERA 23.3

### New / Changed

* Test Environments and SUTs: Changes in REST APIs. The methods for Test Environments and SUTs in SIMPHERA API v1 are deprecated but still supported for at least the six upcoming SIMPHERA releases. We recommend to change to SUT API version 1.0 or Test Environment API version 1.0.
* Projects: The methods for projects in the previous SIMPHERA REST API v1 have been removed. You have to use Project API version 1.0 instead.
* AURELION:
    * Enable simulation with multiple AURELION instances for local execution
    * New demo test environments `ASM Traffic Windows AURELION Multi-Instance (2021-A)` and `ASM Traffic Windows AURELION Multi-Instance (2022-A)`
    * Support for custom AURELION container images for custom 3D-content extensions.
* Experiments: New functionality for analyzing scenario-based testing results. 
* Demands and Capabilities: Further development of the functionality `Demands and Capabilities` for SUTs and Test Environments which allows to specify compatible items.
** Extended REST APIs for SUTs and Test Environments for `Demands and Capabilities` specification.
** Display potential compatibility issues for Scenario-based testing Suites.
** Display potential compatibility issues in selection dialogs for SUTs and Test Environments in Scenario-based testing Suites.

### Fixed

* Sporadic error during blocking simulation with AURELION in SIMPHERA

## SIMPHERA 23.2

### New / Changed

* AURELION:
** Update to AURELION 23.1.
** Support for dSPACE Release 2022-A.
** AURELION plug-in is now provided as a built-in plug-in for AURELION use cases. A reference in the test environment is no longer required. You can remove existing references manually.
** New weather parameters (`Fog`, `RainIntensity`, `TimeOfDay`) for AURELION scenarios were added.
** Support for custom 3D-content extensions (PAK files).
* Scenarios: Added new REST API. The previous API functions are deprecated, but are still supported for the near future. We recommend that you update to the new API functions.
* Data replay testing:  `rtmaps_dSPACE_v2.pck` package is pre-installed in the execution image and no longer needs to be added manually to every processing object.
* Data replay testing: You can customize subjob container resources with Helm variables.
* Additional links: Changed default behavior. Links are now opened in the same Browser tab. This can be influenced manually via Browser functions.
* Test Environments and SUTs: Enhanced functionalities.
** `CreatedBy` and `ModifiedBy` information is provided.
** Pages are shown in read-only mode, if user has no permissions to edit.
* Projects: **Announcement!** The methods for projects in the previous SIMPHERA REST API v1, which were already declared `deprecated`, will be removed in the next SIMPHERA release.

## SIMPHERA 23.1

### New / Changed

* Experiments: Added support for dSPACE Release 2022-A
* Scenario-based testing: Added support for dSPACE Release 2022-A
* Scenario-based testing: Added support for additional links.
* Data replay testing: Usage of SIMPHERA Recording Data Manager (RDM) interface to support other RDMs besides IVS.
** Names and messages in UI and REST API are adapted and provide a generic terminology.
* Prepare: `CreatedBy` and `ModifiedBy` information for the following items is provided: sensors, vehicles, scenarios
* Test Environments and SUTs: Enhanced functionalities in the UI.
** Details pages with support for custom attributes and tags.
** Improved overview pages with pagination, search functionality, tag support, resizable columns, and column chooser.
** Improved selection dialogs with search functionality and tag support for test environments and SUTs at all points of use.
* Experiments: `CreatedBy` and `ModifiedBy` information for experiments.
* Experiments: Improved handling when placing widget on overlap and option to select default sizes for the configuration widgets.
* Experiments: New `Frame` widget for displaying images.
* Scenario-based testing: Variable values can be written triggered by observers.
* Scenario-based testing: Create self-contained runs to be independent from changes in prepare.

## SIMPHERA 22.9

### New / Changed

* Vehicles: The vehicle type selection when creating a new vehicle has been removed.
* Sensors: New REST API for creating, editing and deleting sensors.
* Data replay testing: `CreatedBy` and `ModifiedBy` information for the following items is provided: suite, test case, run, test case result, result
* Data replay testing: Optional usage of persistent volumes for recordings in the mirror and intermediate recordings in the cache was added.
* Data replay testing: Added download for results in frontend without requiring a login to the file storage.
* Data replay testing: Changed processing object storage file path from `/datareplay/processingObjectStorage/` to `/datareplay/processingobjects/files/`.
* Scenario-based testing: Added download for results and ITC results in frontend without requiring a login to the file storage.
* Simulations: The simulation app is discontinued and deactivated. The Experiment app serves as a replacement.
* Experiments: Experiment app for interactive simulation and analysis is added as a further development of the simulation app.

## SIMPHERA 22.8

### New / Changed

* Data replay testing: Run priority and demands can be set by starting a run via the REST API.
* Scenario-based testing: Provide `CreatedBy` and `ModifiedBy` information for the following items: suite, test case, algorithm, run, test case result, result
* Simulation: Control-Plugin provided as built-in plugin for interactive use cases. Reference in test environment not necessary any more.
* SUTs: New SUT details page and improved SUT overview page.
* Enable usage of AURELION in SIMPHERA:
** New `Sensors` app to define and modify sensors for AURELION.
** Scenarios: Add 3D-environment property.
** Vehicles: Add new AURELION configuration entry.
** New demo project for AURELION.
* Vehicles: New REST API for creating, editing and deleting vehicles.

## SIMPHERA 22.7

### New / Changed

* Scenario-based testing: Interface of custom attributes and tags unified in the ITC executor and the ScbT executor. The previous API functions are deprecated, but are still supported for at least six upcoming SIMPHERA releases. We recommend that you update to the new API functions.
* Scenario-based testing: Custom attributes for algorithm, run, test case result, and result items are available via the REST API and the user interface.
* Scenario-based testing: Completed (passed, failed, error, aborted) runs can be deleted via the user interface.
* Scenario-based testing: Provides IDs of result, run, test case, suite, and project items for ITC algorithms.
* Scenario-based testing: Event `ItemDeletedEvent` is sent when the user deletes the following items: suite, test case, run, algorithm

## SIMPHERA 22.6

### New / Changed

* Scenario-based testing: Completed (passed, failed, error, aborted) runs can be deleted via the REST API.
* Scenario-based testing: Started runs or testcases can be stopped via the REST API.
* Scenario-based testing: Custom attributes for test cases and suites are available via the REST API and the user interface.
* Data replay testing: The REST API version 1.0 is deprecated, but it is still supported for at least the six upcoming SIMPHERA releases. We recommend to update to version 2.0.

## SIMPHERA 22.5

### New / Changed

* Vehicle: The import vehicle functionality has been removed. Instead, you can create an empty vehicle and upload the necessary files on the details page.
* Data replay testing: Data replay testing for open loop testing has been added as a new test method.
* Simulation: A new log widget that shows logs of components related to the currently running simulation was added.
* Scenario-based testing: Run priority and demands can be set by starting a run via the REST API.
* Tagging: A new REST API for managing tags is available. Creating, renaming, deleting, and merging of tags are the main functionalities.

## SIMPHERA 22.4

### New / Changed

* Scenario-based testing: New option to ignore changes in referenced files for runs.
* Scenario-based testing: Custom attributes for test cases are available via the REST API.
* Vehicle: Parameterization of vehicles is no longer supported.
* REST API: New REST API for querying information about storages.

## SIMPHERA 1.5

### New / Changed

* Migration: If you are using a SIMPHERA version older than 1.4, you have to migrate to 1.4 before updating to a newer version. Otherwise, data might be lost, because the CouchDB is no longer deployed with SIMPHERA.
* Scenario-based testing web hooks:
** ValidateResultStateChangedEvent: New source `scenario-based-itc` for ITC results that run on the ITC executor.
* Simulation: Support of multi-core or multi-processor applications.
* Simulation: Scene Viewer uses 3-D road information from a GLB file.
* Scenario: Remove fellow information in frontend.
* Detect changes of referenced files in file storage.

## SIMPHERA 1.4

### New / Changed

* Scenario: Display fellow information.
* Scenario: Display 3-D road preview.
* Scenario-based Testing: Removed duplicate `KpiPlugin` from demo algorithms to avoid overwrite errors during execution.
* Detect and avoid overwritten files provided by e.g. plug-ins during job execution. Adaption of customer plug-ins might be required!
* Prepare: Store test environments meta data in PostgreSQL.

## SIMPHERA 1.3

### New / Changed

* MinIO version updated to `2021.4.22`
* VEOS version updated to `VEOS 5.2 Patch 1 Linux`
* Scenario-based testing: Store algorithms meta data in PostgreSQL.
* Scenario-based testing: Custom verdict determination is now available for runs.
* Scenario-based testing: Web hooks available for the following events:
** ValidateRunStateChangedEvent - The state of a run has changed.
** ValidateTestCaseResultStateChangedEvent - The state of a test case within a run has changed.
** ValidateResultStateChangedEvent - The state of a result within a run has changed.
* Simulation: Visualization & Control - New graphical library for the Time Plotter widget.
* Scenario: Improved performance for loading the scenario list.
* Scenario: Added pagination to the REST API.

## SIMPHERA 1.2

### New / Changed

* Vehicle: Clone/Duplicate for existing vehicles is now supported.
* Vehicle: Creating vehicles based on a list of base vehicles is now supported.
* Vehicle: Removed `Save & Back`.
* Scenario: Removed `Save & Back`.
* Scenario-based testing: Meta data of suites, runs, and test cases is now stored in PostgreSQL.
* Scenario-based testing: Pagination of suites and test cases is now supported.
* Scenario-based testing: Custom verdict determination available for results and test case results.
* Scenario-based testing: Use multiple test cases when starting a run for a test suite via the REST API.
* Autoscaling of job executor pods.

## SIMPHERA 1.1

### New / Changed

* Scenario-based testing: Result meta data is now stored in the PostgreSQL database.
* Scenario-based Testing: App-specific URLs to project contents are now prefixed by `scenario-based/`, e.g. `%projectid%/suites` becomes `%projectid%/scenario-based/suites`.
* Simulation: Improved display of the statuses in the simulations.
* SUTs: Added `Show description` in `SUTs` view.
* Test Environments: Show description in `Test Environments` view.
* Monitoring: New Jobs dashboard for visualization of SIMPHERA execution jobs running on SIMPHERA execution agents. Also detailed timing information regarding jobs.
* Monitoring: Quick Search dashboard - Added a filter for `Severity`.
* Monitoring: Quick Search dashboard - Pods are now displayed in alphabetical order.
* Monitoring: Infopage Dashboard - Improved the pod list representation.

### Fixed

* Licenses of dSPACE XIL-API and dSPACE VEOS are no longer blocked (for 120 minutes) after job agent has been terminated unexpectedly, e.g. due to installation of a new SIMPHERA release.
* Reduced the log retention to 5 days due to memory aspects.
* Monitoring: Quick Search dashboard - Fixed a bug related to the pod filter.
* Monitoring: Quick Search dashboard - Search fields are now consistently case insensitive.
* Simulation: Visualization & Control - removed the `SimData Debug` widget.

## SIMPHERA 1.0

### New / Changed

* Vehicles: New application available.
* Scenarios: New application available.
* SUTs: New application available.
* Test Environments: New application available.
* Simulations: New application available.
* Scenario-based testing: New application available.

## Contact

[cols="1,3",width=60%,frame=none,grid=none]
|===
|Mail: a|
dSPACE GmbH +
Rathenaustraße 26 +
33102 Paderborn +
Germany
|Tel.: |+49 5251 1638-0
|E-mail: |info@dspace.de
|Web: |<http://www.dspace.com>
|===

© 2021-{year}, dSPACE GmbH. All rights reserved. Brand names or product names are trademarks or registered trademarks of their respective companies or organizations.
