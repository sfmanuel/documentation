# Task

to interact with the outside world a flow script must create task executions.
Tasks are configured by a input dictionary object and most tasks also provide outputs as a dictionary.

Two examples on how to create and run a task:

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

## Task types

currently the following task types are supported:
1. [AWS](#awstask)
2. [INPUT](#inputtask)
3. [REDIS](#redistask)
4. [REST](#resttask)
5. [SMTP](#smtptask)
6. [SSH](#sshtask)

### AWS task

Call the AWS API using the Boto3 low-level clients. Consult the Boto3 documentation at [https://boto3.amazonaws.com/v1/documentation/api/latest/index.html <i class="fa fa-external-link"></i>](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html) for details on clients/services/waiters and results.

```python
version = 1

input_list = {
    'aws_access_key_id': {
        'type': str,
    },
    'aws_secret_access_key': {
        'type': str,
        'protected': True,
    },
    'region': {
        'type': str,
        'default': None,
    },
    'client': {
        'type': str,
    },
    'service': {
        'type': str,
        'default': None,
    },
    'waiter': {
        'type': str,
        'default': None,
    },
    'parameters': {
        'type': dict,
        'default': None,
    },
}

output_list = {
    'result': {
        'type': dict
    }
}
```

### INPUT task

Interactively query an input from a cloudomation user. Requests will show up in the input section of the cloudomation user interface and any user of the client can submit responses.

```python
version = 1

input_list = {
    'request': {
        'type': str,
    },
    'reference': {
        'type': str,
        'default': '',
    },
    'timeout': {
        'type': int,
        'default': 0,
    },
}

output_list = {
    'response': {
        'type': str,
    },
    'reference': {
        'type': str,
    },
}
```

### REDIS task

interact with a REDIS instance. Consult the redis commands documentation at [https://redis.io/commands <i class="fa fa-external-link"></i>](https://redis.io/commands) for details on commands, arguments and result schemas.

```python
version = 1

input_list = {
    'host': {
        'type': str,
    },
    'port': {
        'type': int,
        'default': 6379,
    },
    'command': {
        'type': str,
    },
    'args': {
        'type': list,
        'default': [],
    },
}

output_list = {
    'result': {
        'type': object,
    },
}
```

### REST task

call a REST service.

#### Parameters
##### `pass_user_token`
generate a short-lived token for the user who started the
execution and pass this token as a header. This works only if the call is
directed to [cloudomation.io](cloudomation.io)

```python
version = 1

input_list = {
    'url': {
        'type': str,
    },
    'method': {
        'type': str,
        'default': 'get',
    },
    'data': {
        'type': dict,
        'default': None,
    },
    'headers': {
        'type': dict,
        'default': None,
    },
    'cookies': {
        'type': dict,
        'default': None,
    },
    'cacert': {
        'type': str,
        'default': None,
    },
    'expected_status_code': {
        'type': list,
        'default': [200, 201, 202, 204],
        # FIXME: provide a better set of "ok" status codes / maybe
        # including 3xx status?
    },
    'pass_user_token': {
        'type': bool,
        'default': False,
    }
}

output_list = {
    'status_code': {
        'type': int,
    },
    'headers': {
        'type': dict,
    },
    'cookies': {
        'type': dict,
    },
    'encoding': {
        'type': str,
    },
    'text': {
        'type': str,
    },
}
```

### SMTP task

send a mail using a SMTP server.

```python
version = 1

input_list = {
    'from': {
        'type': 'String',
    },
    'to': {
        'type': 'String',
    },
    'subject': {
        'type': 'String',
    },
    'body': {
        'type': 'String',
    },
    'login': {
        'type': 'String',
    },
    'password': {
        'type': 'String',
        'protected': True,
    },
    'smtp_host': {
        'type': 'String',
    },
    'smtp_port': {
        'type': 'Number',
        'default': 25,
    },
    'use_tls': {
        'type': 'Boolean',
    },
}

output_list = {}
```

### SSH task

connect to a host using SSH and execute a script.

```python
version = 1

input_list = {
    'hostname': {
        'type': 'String',
    },
    'hostkey': {
        'type': 'String',
    },
    'port': {
        'type': 'Number',
        'default': 22,
    },
    'login': {
        'type': 'String',
    },
    'password': {
        'type': 'String',
        'default': None,
    },
    'key': {
        'type': 'String',
        'default': None,
    },
    'script': {
        'type': 'String',
    },
    'bash-debug-mode': {
        'type': 'Boolean',
        'default': True
    },
}

output_list = {
    'retcode': {
        'type': int,
    },
    'report': {
        'type': str,
    },
}
```
