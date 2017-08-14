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

echo "Retrieving version"
export PIPELINE_VERSION=$( cat ${ROOT_FOLDER}/${VERSION_RESOURCE}/version )
echo "Retrieved version is [${PIPELINE_VERSION}]"

export CI="CONCOURSE"

cd ${ROOT_FOLDER}/${REPO_RESOURCE}

# CURRENTLY WE ONLY SUPPORT JVM BASED PROJECTS OUT OF THE BOX
[[ -f "${TOOLS_RESOURCE}/tasks/build-and-upload/projectType/pipeline-jvm.sh" ]] && source "${TOOLS_RESOURCE}/tasks/build-and-upload/projectType/pipeline-jvm.sh" || \
    echo "No ${TOOLS_RESOURCE}/tasks/build-and-upload/projectType/pipeline-jvm.sh found"

export -f projectType
export PROJECT_TYPE=$( projectType )
echo "Project type [${PROJECT_TYPE}]"

lowerCaseProjectType=$( echo "${PROJECT_TYPE}" | tr '[:upper:]' '[:lower:]' )
[[ -f "${TOOLS_RESOURCE}/tasks/build-and-upload/projectType/pipeline-${lowerCaseProjectType}.sh" ]] && source "${TOOLS_RESOURCE}/tasks/build-and-upload/projectType/pipeline-${lowerCaseProjectType}.sh" || \
    echo "No ${TOOLS_RESOURCE}/tasks/build-and-upload/projectType/pipeline-${lowerCaseProjectType}.sh found"

export OUTPUT_FOLDER=$( outputFolder )
export TEST_REPORTS_FOLDER=$( testResultsAntPattern )

echo "Output folder [${OUTPUT_FOLDER}]"

echo "Generating settings.xml / gradle properties for Maven in local m2"
source ${ROOT_FOLDER}/${TOOLS_RESOURCE}/tasks/generate-settings.sh

export TERM=dumb

cd ${ROOT_FOLDER}

echo "Building and uploading the projects artifacts"
cd ${ROOT_FOLDER}/${REPO_RESOURCE}

export ENVIRONMENT=BUILD

[[ -f "${__DIR}/pipeline.sh" ]] && source "${__DIR}/pipeline.sh" || \
    echo "No pipeline.sh found"

build

echo "Tagging the project with dev tag"
echo "dev/${PIPELINE_VERSION}" > ${ROOT_FOLDER}/${REPO_RESOURCE}/tag
cp -r ${ROOT_FOLDER}/${REPO_RESOURCE}/. ${ROOT_FOLDER}/${OUTPUT_RESOURCE}/
