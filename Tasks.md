# Tasks

Tasks are the Cloudomation functions that allow your flow scripts to interact with the outside world - anything and everything outside of the Cloudomation platform. Whenever you want to issue a command to a program, run a script on a remote system, or get query a database - all that is performed through tasks.

Tasks are called through the cloudomation function c.task(). Each task creates a separate execution, with its own inputs and outputs.

For example, you could call a REST API using the Cloudomation REST task:
```python
def handler(c):
    inputs = {
        'url': 'https://httpbin.org/post',
        'method': 'post',
        'data': 'payload',
    }
    task = c.task('REST', inputs)
    task.runAsync()
    # do other stuff
    task.wait()
    outputs = task.getOutputs()
    c.log(outputs)
```

Or you can request input from a user of the Cloudomation platform by using the INPUT task:
```python
def handler(c):
    response = c.task('INPUT', request='enter a number').run().getOutputs()['response']
    try:
        number = int(response)
    except:
        c.end('error', 'you did not enter a number')
    c.log(f'your number was {number}')
    c.end('success', message='all done')
```

The inputs required and outputs supplied by a task depend on the task type. Below your find documentation on each of the currently available task types.

## Task types

currently the following task types are supported:
1. [AWS](#awstask)
2. [INPUT](#inputtask)
3. [REDIS](#redistask)
4. [REST](#resttask)
5. [SMTP](#smtptask)
6. [SSH](#sshtask)

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
def handler(c):
    # get AWS credentials from setting
    creds = c.setting('aws creds')
    # create a child execution task which talks with AWS
    task = c.task(
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
        **credentials
    ).run()  # run the task
    # provide the response back to the caller
    c.setOutput('task out', task.getOutputs())
    c.end('success', message='all done')
```

### INPUT task

Interactively query an input from a cloudomation user. Requests will show up in the input section of the cloudomation user interface and any user of the client can submit responses.

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
def handler(c):
    # create a task to request input from a user and run it
    task = c.task('INPUT', request='please enter a number').run()
    # access the response
    response = task.getOutputs()['response']
    try:
        # try to convert the string response to a float
        number = float(response)
    except ValueError:
        # if the conversion failed, the response was not a number
        return c.end('error', f'you did not enter a number, but "{response}"')
    # if the conversion succeeded, end with success
    return c.end('success', message=f'thank you! your number was "{number}"')
```

### REDIS task

Interact with a REDIS ke value store. Consult the redis commands documentation at [https://redis.io/commands](https://redis.io/commands){ext} for details on commands, arguments and result schemas.

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
def handler(c):
    # create a REST task and run it
    task = c.task('REST', url='https://api.icndb.com/jokes/random').run()
    # access a field of the JSON response
    joke = task.getOutputs()['json']['value']['joke']
    # end with a joke
    c.end('success', message=joke)
```

### SMTP task

Send an email using an SMTP server.

**Inputs:**
* `from` - string
* `to` - string
* `subject` - string
* `body` - string
* `login` - string
* `password` - protected string
* `smtp_host` - string
* `smtp_port` - number, default: 25
* `use_tls` - boolean


**Outputs:**
* {} The SMPT task does not return any outputs.

**Example:**
```python
# coming soon
```

### SSH task

Connect to a remote host using SSH and execute a script.

**Inputs:**
* `hostname` - string
* `hostkey` - string
* `port` - number, default: 22
* `username` - string
* `password` - string, default: None
* `key` - string, default: None
* `script` - string
* `connect-timeout` - number, default: 10
* `script-timeout` - integer, default: 60
* `remove-cr` - boolean, default: True
* `remove-ansi-escapes` - boolean, default: True

**Outputs:**
* `retcode` - integer  
  The return code
* `report` - string  
  The outputs your scripts produce on the remote systems

**Example:**
```python
import re


def handler(c):
    # Authenticate using private key
    info_task = c.task(
        'SSH',
        # public accessible name or IP
        hostname='my-ssh-server',
        # key to check host identiy.
        # can be read with "$ ssh-keyscan -t rsa <my-ssh-server>"
        hostkey='ssh-rsa AAAAB3NzaC1yc2E...',
        username='kevin',
        key='-----BEGIN RSA PRIVATE KEY-----\nMII...',
        script='''
               echo "hostname" "'$(hostname)'"
               echo "username" "'$(id -un)'"
               echo "cpu" "'$(uname -p)'"
               '''
    ).run()

    report = info_task.getOutputs()['report']
    hostname = re.search("hostname '([^']*)'", report).group(1)
    username = re.search("username '([^']*)'", report).group(1)
    cpu = re.search("cpu '([^']*)'", report).group(1)

    c.logln(f'info_task was running on {hostname} using {cpu} as {username}')

    # Authenticate using password
    uptime_task = c.task(
        'SSH',
        hostname='my-ssh-server',
        hostkey='ssh-rsa AAAAB3NzaC1yc2E...',
        username='kevin',
        password='***',
        script='''
               echo "up since" "'$(uptime -s)'"
               '''
    ).run()

    report = uptime_task.getOutputs()['report']
    up_since = re.search("up since '([^']*)'", report).group(1)

    c.logln(f'{hostname} is up since {up_since}')
```
