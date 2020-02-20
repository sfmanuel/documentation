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

curl -H "Authorization: $TOKEN" -d "${EXECUTION}" https://cloudomation.com/api/1/execution
echo ""
```

You can download the script here: [flow-runner.bash](https://github.com/starflows/documentation/blob/master/utilities/flow-runner.bash){ext}

This helper script requires `auth.bash` to be in the same directory. Please
find more information at [Authentication](Authentication#viatherestapi).

You can download `auth.bash` here: [auth.bash](https://github.com/starflows/documentation/blob/master/utilities/auth.bash){ext}

You can execute the helper script and pass the path to a local flow script as first parameter:

**bash:**
```bash
$ ./flow-runner.bash hello.py
Running flow...
Flow: hello.py
{"id": 1234}
```

or you can use the helper script as [shebang](https://en.wikipedia.org/wiki/Shebang_%28Unix%29){ext} in your script and directly execute it.

**hello.py:**
```python
#!/path/to/your/flow-runner.bash


def handler(system, this):
    this.success('hello world')
```

**bash:**
```bash
$ chmod +x hello.py
$ ./hello.py
Running flow...
Flow: ./hello.py
{"id": 1235}
```
