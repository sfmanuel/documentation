# Flows

The Flows section shows all flow scripts that you currently have available on the Cloudomation platform. Here, you can manually [create new flow scripts](#createflowscripts), [run flow scripts](#runflowscripts), [edit existing flow scripts](#editflowscripts) and [delete flow scripts](#deleteflowscripts). This page also gives a general overview on [how to start a task](#interactwithotherservices) or [on calling other flow scripts](#runflowscripts) on cloudomation.

## Create flow scripts

Once you press the "new" button on the top left of the Flows section view, a flow script editor will be opened. The editor will already contain a few sample code lines. Replace the "# TODO: write your automation" line with your automation. Clicking the run button on top of the flow view will execute the flow and automatically redirect you to the [Executions](/executions) view.

A newly created flow will automatically be assigned an ID and a name. The ID is a random number that uniquely identifies the flow which can not be edited. The name is "new flow" plus a time stamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format. You can edit the name of a flow either in the flow details view or in the flows overview.

The flow script editor provided in the Cloudomation user interface is mainly intended for writing small flow scripts, or doing small edits on existing flow scripts. For larger projects, it is recommended to use an editor of your choice and synchronise your flow scripts to the Cloudomation platform via git (or any other remotely accessible store which you can access via a flow script), or to use the [helper script](Running+flow+scripts+remotely) to run your local flow scripts remotely.

## Edit flow scripts
You can directly edit a flow in cloudomation by navigating to it and changing the Script value. The Flow is saved by clicking one of the "Save", "Try" or "Run" buttons. Old versions of the script will not be saved by Cloudomation, so be sure to have a backup of the flows if you make significant changes. Or even better: Use a version control system.

## Run flow scripts
Flows can be run by either clicking the "Run" or "Try" button on the flow itself, or by calling it from another flow:

```python
def handler(system, this):
    my_flow = this.flow('my_other_flow_name')
    return this.success('all done')
```

When a flow fails and was called by another flow, the called flow will raise an Exception and the calling flow will fail too. To handle a failed flow differently, simply catch the Exception:

```python
def handler(system, this):
    try:
        my_flow = this.flow('my_other_flow_name')
    except Exception:
        this.log('my flow failed')
    else:
        this.log('my flow succeeded')
    return this.success('all done')
```

## Delete flow scripts

## Interact with other services

All of this did not yet explain how to actually automate things. [Tasks](/documentation/Tasks) are here to communicate with other services, they are provided by Cloudomation and called from within a flow script. There are many different Tasks already provided, including a git and a rest task.

A task is created much like the execution of a flow script:

```python
def handler(system, this):
    my_task = this.task(
        'GIT',
        command='get',
        url='https://github.com/starflows/library.git'
    )
    return this.success('all done')
```

Access the "output_value" field of a task to get the outputs of the task: `output_dict = my_task.get('output_value')`

To see a list of available tasks go to [Tasks documentation](/documentation/Tasks).

Webhooks are used to trigger the execution of a flow script, to see how to set one up go to [Webhooks documentation](/documentation/Webhooks).