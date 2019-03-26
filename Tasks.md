# Tasks

Tasks are the Cloudomation functions that allow your flow scripts to interact with the outside world - anything and everything outside of the Cloudomation platform. Whenever you want to issue a command to a program, run a script on a remote system, or get query a database - all that is performed through tasks.

Tasks are called through the Cloudomation function c.task(). Each task creates a separate execution, with its own inputs and outputs.

For example, you could call a REST API using the Cloudomation REST task:
```python
def handler(system, this):
    inputs = {
        'url': 'https://httpbin.org/post',
        'method': 'post',
        'data': 'payload',
    }
    task = this.task('REST', inputs)
    task.run_async()
    # do other stuff
    task.wait()
    outputs = task.get('output_value')
    this.log(outputs)
    return this.success('all done')
```

Or you can request input from a user of the Cloudomation platform by using the INPUT task:
```python
def handler(system, this):
    response = this.task('INPUT', request='enter a number').run().get('output_value')['response']
    try:
        number = int(response)
    except:
        this.error('you did not enter a number')
    this.log(f'your number was {number}')
    return this.success('all done')
```

The inputs required and outputs supplied by a task depend on the task type. Below your find documentation on each of the currently available task types.

## Task types

currently the following task types are supported:
1. [AWS](#awstask)
2. [GIT](#gittask)
3. [INPUT](#inputtask)
4. [REDIS](#redistask)
5. [REST](#resttask)
6. [SMTP](#smtptask)
7. [SSH](#sshtask)

### AWS task

Call the AWS API using the Boto3 low-level clients. Consult the Boto3 documentation at [https://boto3.amazonaws.com/v1/documentation/api/latest/index.html](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html){ext} for details on clients/services/waiters and results.

**Inputs:**
* `aws_access_key_id` - string
* `aws_secret_access_key` - protected string
* `region` - string, default: None
* `client` - string
* `service` - string, default: None
* `waiter` - string, default: None
* `parameters` - dictionary, default: None

**Outputs:**
* `result` - dictionary

**Example:**
```python
def handler(system, this):
    # get AWS credentials from setting
    credentials = system.setting('aws credentials').get('value')
    # create a child execution task which talks with AWS
    run_instance = this.task(
        'AWS',
        region='eu-central-1',
        client='ec2',
        service='run_instances',
        parameters={
            'ImageId': 'ami-0f5dbc86dd9cbf7a8',
            'InstanceType': 't2.micro',
            'MaxCount': 1,
            'MinCount': 1,
        },
        init={
            'protect_inputs': [
                'aws_access_key_id',
                'aws_secret_access_key',
            ],
        },
        **credentials
    ).run()  # run the task
    # provide the response back to the caller
    run_instance_outputs = run_instance.get('output_value')
    this.log(run_instance_outputs=run_instance_outputs)
    # wait until the instance is running
    instance_id = run_instance_outputs['result']['Instances'][0]['InstanceId']
    wait_available = this.task(
        'AWS',
        region='eu-central-1',
        client='ec2',
        waiter='instance_running',
        parameters={
            'InstanceIds': [
                instance_id,
            ]
        },
        **credentials
    ).run()
    # provide the response back to the caller
    wait_available_outputs = wait_available.get('output_value')
    this.log(wait_available_outputs=wait_available_outputs)
    return this.success('all done')
```

**Example 2:**

An extended example can be found in the library: [Example Task AWS](https://github.com/starflows/library/blob/master/Example%20Task%20AWS.py){ext}

### GIT task

Run git commands on a repository.  
Note that the git task allows you to interact with your git repository, but does not automatically synchronise the flow scripts in your git repository with your Cloudomation account. To synchronise flow scripts and settings from git into your Cloudomation account, use this [git sync flow script](https://github.com/starflows/library/blob/master/sync%20flow%20scripts.py) available in the public flow script library. Feel free to make a copy and adapt it to your specific use case.

**Inputs:**
* `command` - string  
  The git command you want to execute. **Currently only supports get.**  
* `repository_url` - string, default: None  
  The url of the remote git repository
* `repository_path` - string, default: None  
  This is your git path on the Cloudomation system. In the case of a get command, the contents of the remote repository will be stored here.  
* `ref` - string, default: master  
  A commit reference, e.g. the commit you want to get. Can be a branch, tag, or git commit Sha.
* `httpCookie` - string, default: None  
  Authentication for some private git repositories is possible via http Cookie

**Outputs:**
* `execution_id` - integer
* `status_code` - integer
* `output` - string  
  The output contains the stdout from the git command, i.e. everything that is printed on the command line after the git command was executed
* `error` - string  
  The error contains the stderr from the command line.
* `message` - string  
  The ended message for the task. If the task ended with an error, the message will contain information about what went wrong
* `status` - string  
  The ended status for the task. Either "success" or "error".

**Example:**
```python
def handler(system, this):
    # get the contents of a public github repository
    this.task(
        'GIT',
        command='get',
        # Specify the url of the repository - note that all files from that  
        # repository will be copied
        repository_url='https://github.com/starflows/library/',
        # the repository path is where the files from git are stored in  
        # Cloudomation
        repository_path='flows_from_git',
        # I want to get the master branch - I could also specify a tag or  
        # commit sha
        ref='master',
    ).run()
    # Listing the files I got from git in the repository I specified on the  
    # Cloudomation platform
    files = system.files('flows_from_git')
    # I set the output to the list of files
    this.log(files)
    return this.success(message='all done')
```

### INPUT task

Interactively query an input from a Cloudomation user. Requests will show up in the input section of the Cloudomation user interface and any user of the client can submit responses.

**Inputs:**
* `request` - string
* `reference` - string, default: ''  
  The reference can be any string. Its function is to allow you to assign outputs correctly. For example, if you request several values from a user, you can use the reference to know which input they gave to which request.
* `timeout` - float, default: 0  
  Timeouts of <=0 mean that there is no timeout: the input query will remain open until a user gives an input. Setting a timeout value means that the input request will disappear from the user interface after the timeout has passed if no user provides input - in that case, the INPUT task will change status to error with the message "input request expired". Timeout values are given in minutes, and it accepts floats (e.g. 1.5).

**Outputs:**
* `response` - string  
  The user's response.
* `reference` - string  
  The reference you defined (if any) in the task definition.

**Example:**
```python
def handler(system, this):
    # create a task to request input from a user and run it
    task = this.task('INPUT', request='please enter a number').run()
    # access the response
    response = task.get('output_value')['response']
    try:
        # try to convert the string response to a float
        number = float(response)
    except ValueError:
        # if the conversion failed, the response was not a number
        return this.end('error', f'you did not enter a number, but "{response}"')
    # if the conversion succeeded, end with success
    return this.end('success', message=f'thank you! your number was "{number}"')
```

### REDIS task

Interact with a REDIS key value store. Consult the redis commands documentation at [https://redis.io/commands](https://redis.io/commands){ext} for details on commands, arguments and result schemas.

**Inputs:**
* `host` - string
* `port` - integer, default: 6379
* `command` - string
* `args` - list, default: []

**Outputs:**
* `result` - object

**Example:**
```python
# coming soon
```


### REST task

Call a REST service.

**Inputs:**
* `url` - string
* `method` - string, default: get
* `data` - dictionary, default: None
* `headers` - dictionary, default: None
* `cookies` - dictionary, default: None
* `cacert` - string, default: None  
  To attach self-signed certificates (ca = certificate authority, cert = certificate)
  To access https:// urls, you need to sign your request. Certificates trusted by default by debian jessie will work.
* `expected_status_code` - list, default: [200, 201, 202, 204]
* `pass_user_token` - boolean, default: False  
  Only for accessing the Cloudomation API. If set to True, a short-lived token is generated for the user who started the execution. This token is passed in the header to the Cloudomation API.

**Outputs:**
* `status_code` - integer
* `headers` - dictionary
* `cookies` - dictionary
* `encoding` - string
* `text` - string  
  The text output will contain the response body if it could not successfully be parsed as json.
* `json` - dictionary  
  The json output will contain the response body if it can be successfully parsed as json. Otherwise, the response body will be delivered in the text output.

**Example:**
```python
def handler(system, this):
    # create a REST task and run it
    task = this.task('REST', url='https://api.icndb.com/jokes/random').run()
    # access a field of the JSON response
    joke = task.get('output_value')['json']['value']['joke']
    # end with a joke
    return this.end('success', message=joke)
```

### SMTP task

Send an email using an SMTP server.

**Inputs:**
* `from` - string
* `to` - string
* `subject` - string
* `text` - string
  The text will be the body of the email. You can supply it as text or html or
  both. If you supply both, the recipient can choose to see the email in either
  html or plain text.
* `html` - string
  Html formatted body of the email.
* `login` - string
* `password` - protected string
* `smtp_host` - string
* `smtp_port` - number, default: 25
* `use_tls` - boolean
  Whether or not to use a Transport Security Layer (TLS) encrypted connection

**Outputs:**
* {} The SMPT task does not return any outputs.

**Example:**
```python
def handler(system, this):
    # create an SMPT task and run it
    this.task(
        'SMTP',
        inputs={
                'from': 'cloudomation@cloudomation.io',
                'to': 'info@cloudomation.io',
                'subject': 'Cloudomation email',
                # the text will be the email body. Alternatively you could add
                # a html formatted body with the key 'html'.
                'text': 'This email was sent with Cloudomation',
                'login': 'cloudomation@cloudomation.io',
                'password': '****',
                'smtp_host': 'SMTP.example.com',
                'smtp_port': 587,
                'use_tls': True
        }
    ).run()
    # there are no outputs for the SMTP task
    return this.success(message='all done')
```

### SSH task

Connect to a remote host using SSH and execute a script.

You can register shell variables as "output variables" using
`#OUTPUT_VAR(variable_name)`:

```bash
VARIABLE="some content"
#OUTPUT_VAR(VARIABLE)
```

The value of registered variables is available to the calling flow script
in the `var` dictionary of the task outputs:

```python
outputs = task(...).get('output_value')
variable = outputs['var']['VARIABLE']
# `variable` contains "some content"
```

**Inputs:**
* `hostname` - string
* `hostkey` - string
* `port` - number, default: 22
* `username` - string
* `password` - string, default: None
* `key` - string, default: None
* `script` - string
* `connect_timeout` - number, default: 10
* `script_timeout` - integer, default: 60
* `remove_cr` - boolean, default: True
* `remove_ansi_escapes` - boolean, default: True

**Outputs:**
* `retcode` - integer
  The return code
* `report` - string
  The outputs your scripts produce on the remote systems
* `var` - dictionary
  The content of all variables which were registered using `#OUTPUT_VAR(variable)`

**Example:**
```python
def handler(system, this):
    # Authenticate using private key
    info_task = this.task(
        'SSH',
        # public accessible name or IP
        hostname='my-ssh-server',
        # key to check host identity.
        # can be read with "$ ssh-keyscan -t rsa <my-ssh-server>"
        hostkey='ssh-rsa AAAAB3NzaC1yc2E...',
        username='kevin',
        key='-----BEGIN RSA PRIVATE KEY-----\nMII...',
        script=(
            '''
            HOSTNAME=$(hostname)
            USERNAME=$(id -un)
            CPU=$(uname -p)
            #OUTPUT_VAR(HOSTNAME)
            #OUTPUT_VAR(USERNAME)
            #OUTPUT_VAR(CPU)
            '''
        ),
    ).run()

    outputs = info_task.get('output_value')
    hostname = outputs['var']['HOSTNAME']
    username = outputs['var']['USERNAME']
    cpu = outputs['var']['CPU']

    this.log(f'info_task was running on {hostname} using {cpu} as {username}')

    # Authenticate using password
    uptime_task = this.task(
        'SSH',
        hostname='my-ssh-server',
        hostkey='ssh-rsa AAAAB3NzaC1yc2E...',
        username='kevin',
        password='***',
        script=(
            '''
            UPTIME=$(uptime -s)
            #OUTPUT_VAR(UPTIME)
            '''
        ),
    ).run()

    outputs = uptime_task.get('output_value')
    uptime = outputs['var']['UPTIME']

    this.log(f'{hostname} is up since {uptime}')

    return this.success('all done')
```
