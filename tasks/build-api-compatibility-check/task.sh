#!/bin/bash

export ROOT_FOLDER=$( pwd )
export REPO_RESOURCE=repo
export TOOLS_RESOURCE=tools
export VERSION_RESOURCE=version
export OUTPUT_RESOURCE=out

echo "Root folder is [${ROOT_FOLDER}]"
echo "Repo resource folder is [${REPO_RESOURCE}]"
echo "Tools resource folder is [${TOOLS_RESOURCE}]"
echo "Version resource folder is [${VERSION_RESOURCE}]"

cd ${ROOT_FOLDER}/${REPO_RESOURCE}

# CURRENTLY WE ONLY SUPPORT JVM BASED PROJECTS OUT OF THE BOX
[[ -f "${ROOT_FOLDER}/${TOOLS_RESOURCE}/tasks/build-api-compatibility-check/projectType/pipeline-jvm.sh" ]] && source "${ROOT_FOLDER}/${TOOLS_RESOURCE}/tasks/build-api-compatibility-check/projectType/pipeline-jvm.sh" || \
    echo "No ${ROOT_FOLDER}/${TOOLS_RESOURCE}/tasks/build-api-compatibility-check/projectType/pipeline-jvm.sh found"
#
# export OUTPUT_FOLDER=$( outputFolder )
# export TEST_REPORTS_FOLDER=$( testResultsAntPattern )
#
# echo "Output folder [${OUTPUT_FOLDER}]"
#
# echo "Generating settings.xml / gradle properties for Maven in local m2"
# source ${ROOT_FOLDER}/${TOOLS_RESOURCE}/tasks/generate-settings.sh

source ${ROOT_FOLDER}/${TOOLS_RESOURCE}/tasks/common.sh

export TERM=dumb

echo "Deploying the built application on test environment"
cd ${ROOT_FOLDER}/${REPO_RESOURCE}

apiCompatibilityCheck
