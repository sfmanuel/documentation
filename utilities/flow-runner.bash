#!/usr/bin/env bash

echo "Running flow..."
DIR=$(dirname $0)
TOKEN_FILE="${DIR}/token"
TOKEN=$(cat "${TOKEN_FILE}")

if [ -z "${TOKEN}" ]; then
    ${DIR}/auth.bash
fi

FLOW=$1
if [ -z "${FLOW}" ]; then
    echo "missing parameter <flow script>" 1>&2
    exit 1
fi
if [ ! -f "${FLOW}" ]; then
    echo "flow ${FLOW} does not exist" 1>&2
    exit 1
fi
echo "Flow: ${FLOW}"

NAME=$(basename "${FLOW}")
SCRIPT=$(cat "${FLOW}" | base64 -w0)

EXECUTION="{\"script\":\"${SCRIPT}\",\"name\":\"${NAME}\"}"

curl -H "Authorization: $TOKEN" -d "${EXECUTION}" https://cloudomation.com/api/1/execution
echo ""
