#!/bin/bash
set -e

# Finds the latest prod tag from git
function findLatestProdTag() {
    local LAST_PROD_TAG=$(git for-each-ref --sort=taggerdate --format '%(refname)' refs/tags/prod | head -n 1)
    LAST_PROD_TAG=${LAST_PROD_TAG#refs/tags/}
    echo "${LAST_PROD_TAG}"
}