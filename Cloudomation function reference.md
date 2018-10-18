# Cloudomation function reference

## Cloudomation class
This class of functions allows you to interact with Cloudomation. You can read settings, create child executions, write to the log, set outputs for your flow script etc.

### c.task  
creates a pending task execution  
> Parameters:
        - task           the name of the task - see [tasks](Tasks)
        - inputs         a dictionary containing the input parameters for
                         the task
        - name           the name of the execution
        - location       the actor location where to execute the task. can be
                         a public or private actor location
        - protect_inputs a list of input keys which should be redacted. to be
                         used on fields containing sensitive information
        - protect_outputs a list of output keys which should be redacted.
        - retention_time how many seconds the execution record should be
                         retained after ending. when the time passed the
                         record will be deleted
        - **kwargs       all additional kwargs will be added to the inputs

> Example:
        ```python
        def handler(c):
            # create a REST task and run it
            task = c.task('REST', url='https://api.icndb.com/jokes/random').run()
            # access a field of the JSON response
            joke = task.getOutputs()['json']['value']['joke']
            # end with a joke
            c.end('success', message=joke)
        ```
Find more examples in the [public flow script library](https://github.com/starflows/library):
- [Example AWS task](https://github.com/starflows/library/blob/master/Example%20Task%20AWS.py)
- [Exammple INPUT task](https://github.com/starflows/library/blob/master/Example%20Task%20INPUT.py)

### c.flow
### c.script
### c.waitFor
### c.waitForAll
### c.sleep
### c.sleep_until
### c.logIn
### c.log
### c.end
### c.getInputs
### c.getVaultToken
### c.setOutput
### c.setOutput
### c.setOutputs
### c.setting
### c.watch
### c.getParent
### c.getInstance

## Execution class
### *c.clone*
coming soon
### c.setInput
### c.setInputs
### c.runAsync
### c.run
### c.wait
### c.getStatus
### c.getOutputs
