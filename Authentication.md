
# Authentication

To use Cloudomation you need an account. Please see [signing up](Signing+up) on how to sign up for an account. When you sign up you create a client with one user. You can later add more users to your client. All users of your client will share the same resources in Cloudomation.

Below are the descriptions on how to authenticate with Cloudomation using different methods.

## Via the user interface

To authenticate via the user interface you need to visit the [login page](/login). You need to enter your client name, user name, and your password. Optionally, you can also enter a vault token which can be used to retrieve secrets from a [Hashicorp Vault <i class="fa fa-external-link"></i>](https://www.vaultproject.io/).

Additionally there is the option to choose if your login should be remembered between browser sessions.

Once all the required fields are filled out you can click on "Login". If the authentication is successful your browser receives a cookie. The cookie contains a JWT token which is used to authenticate by subsequent requests. The validity of the token depends on the "Remember me" setting. If "Remember me" was chosen, the cookie is valid for 90 days. Otherwise, it is valid for the browser session only. The browser session usually ends when the browser window is closed.

## Via the REST API

To authenticate using the REST API you need to POST a JSON string containing your credentials to `https://starflows.com/api/1/auth`. An example JSON might look like:
```json
{
    "client_name": "CorpInc AG",
    "user_name": "kevin",
    "password": "secret"
}
```
If successful, the reply might look like:
```json
{
    "client_name": "CorpInc AG",
    "user_name": "kevin",
    "user_id": "1",
    "is_client_admin": true,
    "is_system_admin": false,
    "token": "eyJ...",
    "exp": 1538822075.055123
}
```
If unsuccessful, the API returns with `HTTP 401: Unauthorized`

## Via the command line

Authentication using the command line uses a command line tool like curl to authenticate against the REST API. The schema of the request is described in [Via the REST API](#viatherestapi). You can use a script to handle the authentication and extracting the token for further use:
```bash
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

```
You can download the script here: [auth.bash](https://github.com/starflows/documentation/blob/master/utilities/auth.bash)

The script exports an environment variable TOKEN containing your token. To use the environment variable in your current shell you need to source the script:
```bash
$ source auth.bash
Client Name: CorpInc AG
User Name: kevin
Password:
Sending auth...
Extracting token...
Token was exported. All done!
$ echo $TOKEN
eyJ...
```
You can then use the token to authenticate further requests:
```bash
$ curl -s 'https://starflows.com/api/1/user/kevin' -H "Authorization: $TOKEN" | jq .
{
  "updated": {
    "last_activity": "1531049907.7785194",
    "status": "active",
    "password": "",
    "name": "kevin",
    "id": "1",
    "email": "kevin@example.com"
  }
}
```
