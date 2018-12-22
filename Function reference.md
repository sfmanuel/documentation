# Function reference

<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Cloudomation class](#cloudomation-class)
	- [c.task](#ctask)
	- [c.flow](#cflow)
	- [c.script](#cscript)
	- [c.wait_for](#cwait_for)
	- [c.wait_for_all](#cwait_for_all)
	- [c.sleep](#csleep)
	- [c.sleep_until](#csleepuntil)
	- [c.logIn](#clogin)
	- [c.log](#clog)
	- [c.end](#cend)
	- [c.get_inputs](#cget_inputs)
	- [c.getVaultToken](#cgetvaulttoken)
	- [c.set_output](#cset_output)
	- [c.set_output](#cset_output)
	- [c.set_outputs](#cset_outputs)
	- [c.setting](#csetting)
	- [c.watch](#cwatch)
	- [c.get_parent](#cget_parent)
	- [c.get_env_name](#cget_env_name)
- [Execution class](#execution-class)
	- [clone](#clone)
	- [set_input](#set_input)
	- [set_inputs](#set_inputs)
	- [run_async](#run_async)
	- [run](#run)
	- [wait](#wait)
	- [get_status](#get_status)
	- [get_outputs](#get_outputs)

<!-- /TOC -->

## Cloudomation class
This class of functions allows you to interact with Cloudomation. You can read settings, create child executions, write to the log, set outputs for your flow script etc.

### c.task  
Executes a task. Through tasks, you can interact with the outside world. The following tasks are available in Cloudomation:
- REST  
- SSH  
- SMTP  
- INPUT  
- AWS  
- REDIS  

See [tasks](Tasks) for details on the individual tasks.

```text
 Parameters:  
    - task             the name of the task - see [tasks](Tasks)  
    - inputs           a dictionary containing the input parameters for
                       the task  
    - name             the name of the execution  
    - location         the actor location where to execute the task. can be
                       a public or private actor location  
    - protect_inputs   a list of input keys which should be redacted. to be
                       used on fields containing sensitive information  
    - protect_outputs  a list of output keys which should be redacted.  
    - retention_time   how many seconds the execution record should be
                       retained after ending. when the time passed the
                       record will be deleted  
    - **kwargs         all additional kwargs will be added to the inputs  
```

Example:  
```python
def handler(c):
  # create a REST task and run it
  task = c.task('REST', url='https://api.icndb.com/jokes/random').run()
  # access a field of the JSON response
  joke = task.get_outputs()['json']['value']['joke']
  # end with a joke
c.end('success', message=joke)
```  

Returns:  
The execution object with the execution ID. This means that you can chain any function from the [Execution class](#executionclass) directly after the execution of a task.

Find more examples in the [public flow script library](https://github.com/starflows/library){ext}:
- [Example AWS task](https://github.com/starflows/library/blob/master/Example%20Task%20AWS.py){ext}
- [Example INPUT task](https://github.com/starflows/library/blob/master/Example%20Task%20INPUT.py){ext}

### c.flow
Executes a flow script. You can reference any flow script within your Cloudomation accout by ID or name, or reference a flow script in a public github repository. See [using flow scripts from git](Using flow scripts from git) for information on how to dynamically execute flow scripts from a public github repository.

```text
 Parameters:  
    - flow             the name or ID of the flow script
    - inputs           a dictionary containing the input parameters for
                       the flow
    - name             the name of the execution
    - pass_token       if a vault_token should be passed to the child
                       execution
    - protect_inputs   a list of input keys which should be redacted. to be
                       used on fields containing sensitive information
    - protect_outputs  a list of output keys which should be redacted.
    - retention_time   how many seconds the execution record should be
                       retained after ending. when the time passed the
                       record will be deleted
    - **kwargs         all additional kwargs will be added to the inputs
```

Example:  
```python
def handler(c):
    # Query user details
    questions = {
        'name': {
            'label': 'New user name',
        },
        'email': {
            'label': 'New user email address',
        },
        'password': {
            'label': 'New user password',
            'type': 'password',
        },
    }
    execution = c.flow(
        'Input Form',
        questions=questions,
        protect_outputs=['responses']  # protect responses,
                                       # they contain a password
    ).run()
    outputs = execution.get_outputs()
    user = outputs['responses']  # the responses dict is the user
```  

This example is part of the [create user](https://github.com/starflows/library/blob/master/Create%20User.py){ext} flow script available in the [public flow script library](https://github.com/starflows/library){ext}. If the referenced flow `Input Form` if not found in the current client it will be fetched from the public flow script library.

### c.script
Executes a script.

```text
 Parameters:  
    - script           the script to be executed
    - inputs           a dictionary containing the input parameters for the
                       script
    - name             the name of the execution
    - pass_token       if a vault_token should be passed to the child
                       execution
    - protect_inputs   a list of input keys which should be redacted. to be
                       used on fields containing sensitive information
    - protect_outputs  a list of output keys which should be redacted.
    - retention_time   how many seconds the execution record should be
                       retained after ending. when the time passed the
                       record will be deleted
 - **kwargs            all additional kwargs will be added to the inputs
```

Example:  
```python
coming soon
```  

### c.wait_for
Wait for the first of the given executions to finish. This is an OR relation. If you need an AND relation use chained calls to wait_for or [cloudomation.wait_for_all()](#cwait_for_all).

```text
 Parameters:  
    - *args            execution objects or execution IDs to wait for
    - expected         a list of status codes which are expected
    - unexpected       what to do if the ending execution does not have an
                       expected status. Possible values are:
                           - error: end this execution with error
                           - raise: raise an UnexpectedStatusError
                           - ignore: continue normally
```

Example:
```python
cloudomation.wait_for(A).wait_for(B) # waits until A and B are both ended
cloudomation.wait_for(A, B) # waits for either A or B, whichever ends first
```  

Returns:  
    the id of the execution which finished first
    or None if the list of executions to wait for is empty

### c.wait_for_all
Wait for all of the given executions to finish.

```text
 Parameters:  
    - *args            execution objects or execution IDs to wait for
    - expected         a list of status codes which are expected
    - unexpected       what to do if the ending execution does not have an
                       expected status. Possible values are:
                           - error: end this execution with error
                           - raise: raise an UnexpectedStatusError
                           - ignore: continue normally
```

Example:
```python
cloudomation.wait_for_all(A, B) # waits until A and B are both ended
cloudomation.wait_for_all(A, B).flow('myflow') # waits until A and B ended and then executes myflow
```  

Returns:  
The Cloudomation object. This means that you can chain any function from the Cloudomation class directly after the c.wait_for_all function.

### c.sleep
### c.sleep_until
### c.logIn
### c.log
### c.end
### c.get_inputs
### c.getVaultToken
### c.set_output
### c.set_output
### c.set_outputs
### c.setting
### c.watch
### c.get_parent
### c.get_env_name

## Execution class
Functions from the execution class can be applied on execution objects.

### clone
### set_input
### set_inputs
### run_async
### run
### wait
### get_status
### get_outputs
