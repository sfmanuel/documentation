# API migration

This document describes steps that need to be performed to migrate existing
Flow scripts to the a newer version of the
[Flow script function reference](Flow+script+function+reference).

## Version 0

### Flow script created before 2019-01-01

On 2019-01-01 some incompatible changes to the Flow script function reference
were published. Please read the section below for an overview of the necessary
steps to migrate your existing flow scripts to the new version.

#### Handler function changes

The handler function now receives two parameters: the `system` object and
`this` - the execution object of the own execution.

**system**

The `system` object is used to access functionality which is not related to a
running execution. This includes:

- reading system state. Example:
    `env_name = system.get_env_name()`
- opening resources for read. Example:
    `user_name = system.flow('my flow').get('modified_by')`
- opening resources for write. Example:
    `system.setting('my setting').save(value={'key': my value'})`
- iterating over collections of resources. Example:

    ```python
    for file in system.files(dir='logs'):
        content = file.get('content')
        if 'ERROR:' in content:
            this.log(content)
    ```

**this**

The `this` object represents the currently running execution. It can be used
to access functionality related to the execution. This includes:

- reading execution state. Example: `inputs = this.get('input_value')`
- writing execution state. Example: `this.save(message='my message')`
- creating child executions. Example:

    ```python
    # create a child flow execution
    child_flow = this.flow('my flow', run=False)
    # run the child flow execution in the background
    flow.run_async()

    # create a child task execution and run it
    child_task = this.task('REST')

    # create and run a child script in one call
    script = '''
        def handler(system, this):
            this.log('Hello World!')
            this.success('all done')
        '''
    child_script = this.script(script)
    ```

The object returned by `this.flow`, `this.task`, or `this.script` is also
an execution object and provides the same functionality as the `this` object.
This includes:
- reading execution state. Example: `state = child_flow.load('state')`
- writing execution state. Example: `child_task.save(name='renamed')`
- handling execution lifecycle. Example:
    ```python
    # control a child
    child_script.pause()
    child_script.run_async()  # resume in the background
    child_script.cancel()

    # wait for a child to end
    child_task.wait()
    # which is the same as
    this.wait_for(child_task)
    ```

#### Steps to perform to migrate

Perform the following steps to migrate your existing flow script to the new
API syntax:

- Change the parameters of the handler function:

    ```python
    # old signature
    def handler(c):

    # new signature
    def handler(system, this):
    ```

- If your flow script used any of the following methods, replace the method
    call with the new version:

    Old method call | New method call | Notes
    --- | --- | ---
    `c.getEnvName()` | `system.get_env_name()`
    `c.getInputs()` | `this.get('input_value')`
    `execution.getOutputs()` | `execution.get('output_value')`
    `c.setOutputs(o)` | `this.save(output_value=o)`
    `c.setOutput(k, v)` | `this.set_output(k, v)`
    `c.log(m)` | `this.log(m)`
    `c.logln(m)` | `this.log(m)` | The log is stored as structured data, no need to add newlines to separate the "next" log line.
    `c.flow(f)` | `this.flow(f)`
    `c.task(t)` | `this.task(t)`
    `c.script(s)` | `this.script(s)`
    `c.end(s, m)` | `this.end(s, m)`
    `c.success(m)` | `this.success(m)`
    `c.error(m)` | `this.error(m)`
    `c.setting(s)` | `system.setting(s).get('value')` | "value" is just one of several fields you can "get" from a setting.
    `c.setting(s, v)` | `system.setting(s).save(value=v)`
    `c.waitFor(e)` | `this.wait_for(e)` | return\_when defaults to ALL\_SUCCEEDED
    `c.waitFor(e1, e2)` | `this.wait_for(e1, e2, return_when=system.return_when.FIRST_ENDED)`
    `c.waitForAll(e1, e2)` | `this.wait_for(e1, e2, return_when=system.return_when.ALL_SUCCEEDED)`
