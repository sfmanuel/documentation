#!/usr/bin/env bash

read -e -p "Client Name: " -i "CorpInc AG" CLIENT_NAME
read -e -p "User Name: " -i "kevin" USER_NAME
stty -echo
read -p "Password: " PASSWORD
stty echo
echo ""
AUTH="{\"client_name\":\"${CLIENT_NAME}\",\"user_name\":\"${USER_NAME}\",\"password\":\"${PASSWORD}\"}"

echo "Sending auth..."
REPLY=$(curl -m 2 -s -d "${AUTH}" https://starflows.com/api/1/auth)
if [ "$?" -ne "0" ]; then
  echo "Failed to send auth!" 1>&2
  return 1
fi

if [ "${REPLY}" == "401: Unauthorized" ]; then
  echo "Authentication failed: ${REPLY}" 1>&2
  return 1
fi

echo "Extracting token..."
TOKEN=$(echo ${REPLY} | jq -r ".token")
if [ "$?" -ne "0" ]; then
  echo "Failed to extract token!" 1>&2
  return 1
fi
export TOKEN

echo "Token was exported. All done!"
