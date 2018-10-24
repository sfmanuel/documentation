# Running flow scripts remotely

You can run a flow script from your local machine by using a helper script:

**flow-runner.bash:**

```bash
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

curl -H "Authorization: $TOKEN" -d "${EXECUTION}" https://cloudomation.io/api/1/execution
echo ""
```

You can download the script here: [flow-runner.bash](https://github.com/starflows/documentation/blob/master/utilities/flow-runner.bash)

**flow-runner.ps1:**
```powershell
param (
    [Parameter(Mandatory=$true)][string]$FLOW
)

Write-Host "Runinng flow..."
$DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition
$TOKEN_FILE = "${DIR}/token"
if (-Not (Test-Path "${TOKEN_FILE}"))
{
    Invoke-Expression -Command "${DIR}/auth.ps1"
}
$TOKEN = Get-Content -Path "${TOKEN_FILE}"

if (-Not (Test-Path "${FLOW}"))
{
    Write-Error "flow ${FLOW} does not exist"
    Exit 1
}
Write-Host "Flow: ${FLOW}"

$NAME = Split-Path "${FLOW}" -Leaf
$SCRIPT_PLAIN = Get-Content "${FLOW}"
$BYTES = [System.Text.Encoding]::Ascii.GetBytes($SCRIPT_PLAIN)
$SCRIPT = [Convert]::ToBase64String($BYTES)

$EXECUTION = @{
    script = "${SCRIPT}"
    name = "${NAME}"
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "https://cloudomation.io/api/1/execution" `
    -Method Post `
    -Body "${EXECUTION}" `
    -Headers @{Authorization = "${TOKEN}"}
```

You can download the script here: [flow-runner.ps1](https://github.com/starflows/documentation/blob/master/utilities/flow-runner.ps1)

This helper script requires `auth.bash` or `auth.ps1` to be in the same directory. Please
find more information at [Authentication](Authentication#viatherestapi).

You can download `auth.bash` here: [auth.bash](https://github.com/starflows/documentation/blob/master/utilities/auth.bash)

You can download `auth.ps1` here: [auth.ps1](https://github.com/starflows/documentation/blob/master/utilities/auth.ps1)

You can execute the helper script and pass the path to a local flow script as first parameter:

**bash:**
```bash
$ ./flow-runner.bash hello.py
Running flow...
Flow: hello.py
{"id": 1234}
```

**PowerShell:**
```powershell
PS /> ./flow-runner.ps1 ./hello.py

Runinng flow...
Flow: ./hello.py

  id
  --
1234
```

or you can use the helper script as [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) in your script and directly execute it.

**hello.py:**
```python
#!/path/to/your/flow-runner.bash


def handler(c):
    c.success('hello world')
```

**bash:**
```bash
$ chmod +x hello.py
$ ./hello.py
Running flow...
Flow: ./hello.py
{"id": 1235}
```
