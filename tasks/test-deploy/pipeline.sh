#!/bin/bash
set -e

function testDeploy() {
    # TODO: Consider making it less JVM specific
    projectGroupId=$( retrieveGroupId )
    appName=$( retrieveAppName )
    # Log in to PaaS to start deployment
    logInToPaas

    # First delete the app instance to remove all bindings
    deleteAppInstance "${appName}"

    deployServices

    # deploy app
    downloadAppBinary ${REPO_WITH_BINARIES} ${projectGroupId} ${appName} ${PIPELINE_VERSION}
    deployAndRestartAppWithNameForSmokeTests ${appName} "${appName}-${PIPELINE_VERSION}" "${UNIQUE_RABBIT_NAME}" "${UNIQUE_EUREKA_NAME}" "${UNIQUE_MYSQL_NAME}"
    propagatePropertiesForTests ${appName}
}
