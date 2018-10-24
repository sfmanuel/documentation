#!/usr/bin/env bash

echo "Authenticating..."
read -e -p "Client Name: " -i "CorpInc AG" CLIENT_NAME
read -e -p "User Name: " -i "kevin" USER_NAME
stty -echo
read -p "Password: " PASSWORD
stty echo
echo ""
AUTH="{\"client_name\":\"${CLIENT_NAME}\",\"user_name\":\"${USER_NAME}\",\"password\":\"${PASSWORD}\"}"

echo "Sending auth..."
REPLY=$(curl -m 2 -s -d "${AUTH}" https://cloudomation.io/api/1/auth)
if [ "$?" -ne "0" ]; then
  echo "Failed to send auth!" 1>&2
  return 1
fi

if [ "${REPLY}" == "401: Unauthorized" ]; then
  echo "Authentication failed: ${REPLY}" 1>&2
  exit 1
fi

echo "Extracting token..."
TOKEN=$(echo ${REPLY} | jq -r ".token")
if [ "$?" -ne "0" ]; then
  echo "Failed to extract token!" 1>&2
  exit 1
fi

DIR=$(dirname $0)
TOKEN_FILE="${DIR}/token"
touch "${TOKEN_FILE}"
chmod 600 "${TOKEN_FILE}" || exit 1
echo "${TOKEN}" > "${TOKEN_FILE}"
chmod 400 "${TOKEN_FILE}"

echo "Token was stored in ${TOKEN_FILE}. All done!"
