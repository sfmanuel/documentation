# Executions

## Creating executions

Executions can be created in several ways:

* [Using the Cloudomation user-interface](#creatingexecutionsintheui)
* [Using the Cloudomation REST API](#creatingexecutionsusingtherestapi)
* [Using web-hooks](#creatingexecutionsusingwebhooks)

### Creating executions in the UI

To create a new execution in the Cloudomation user-interface first select one
or more flow records from the [flows list view](/flows). Then click the
<span class="text-success"><i class="fa fa-play"></i><span class="ml-1">Play</span></span>
button in the action-bar. This will run the flow script immediately and once.

> <i class="fa fa-info-circle fa-2x text-info"></i> You can run a flow script [at a specific time in the future](#delayedexecutions).

> <i class="fa fa-info-circle fa-2x text-info"></i> You can run a flow script [repeatedly in a set interval](#recurringexecutions).

> <i class="fa fa-info-circle fa-2x text-info"></i> You can run a flow script [regularly at the same time](#scheduledexecutions).

### Creating executions using the REST API

To create a new execution using the Cloudomation REST API send a HTTP POST
request to `https://cloudomation.com/api/1/execution`. The request and response
schemas are documented in the [API explorer](/explorer).

> <i class="fa fa-info-circle fa-2x text-info"></i> To create an execution using the REST API
the request must be authenticated as a Cloudomation user. See
[Authentication](Authentication) on how to authenticate
REST API requests.

> <i class="fa fa-info-circle fa-2x text-info"></i> If you want to create executions without
authentication see [Webhooks](Webhooks)

### Creating executions using web-hooks

Executions can be created using web-hooks. See [Webhooks](Webhooks) for more
information.

## Delayed executions

Executions can be configured to start at a specific moment in the future, or
after a specific timeout. To delay an execution run click the dropdown arrow
next to the
<span class="text-success"><i class="fa fa-play"></i><span class="ml-1">Play</span><i class="ml-1 fa fa-caret-down"></i></span>
button and select
<span class="text-success"><i class="fa fa-clock-o"></i><span class="ml-1">Run delayed</span></span>.

You will be redirected to the input request list to configure the delayed execution run.

> <i class="fa fa-info-circle fa-2x text-info"></i> The "Run delayed" functionality is
implemented in [Delayed.py](https://github.com/starflows/library/blob/master/Delayed.py){ext}
from the [public flow library](https://github.com/starflows/library){ext}.
The implementation is meant to be a boilerplate and you are encouraged to
customise it to your needs.

## Recurring executions

Executions can be started recurring in defined intervals. To create a recurring execution click the dropdown arrow next to the
<span class="text-success"><i class="fa fa-play"></i><span class="ml-1">Play</span><i class="ml-1 fa fa-caret-down"></i></span>
button and select
<span class="text-success"><i class="fa fa-repeat"></i><span class="ml-1">Run recurring</span></span>.

You will be redirected to the input request list to configure the recurring execution run.

> <i class="fa fa-info-circle fa-2x text-info"></i> The "Run recurring" functionality is
implemented in [Recurring.py](https://github.com/starflows/library/blob/master/Recurring.py){ext}
from the [public flow library](https://github.com/starflows/library){ext}.
The implementation is meant to be a boilerplate and you are encouraged to
customise it to your needs.

## Scheduled executions

Executions can be scheduled to run at a defined time every day. To create a scheduled execution click the dropdown arrow next to the
<span class="text-success"><i class="fa fa-play"></i><span class="ml-1">Play</span><i class="ml-1 fa fa-caret-down"></i></span>
button and select
<span class="text-success"><i class="fa fa-calendar"></i><span class="ml-1">Run scheduled</span></span>.

You will be redirected to the input request list to configure the scheduled execution run.

> <i class="fa fa-info-circle fa-2x text-info"></i> The "Run scheduled" functionality is
implemented in [Scheduled.py](https://github.com/starflows/library/blob/master/Scheduled.py){ext}
from the [public flow library](https://github.com/starflows/library){ext}.
The implementation is meant to be a boilerplate and you are encouraged to
customise it to your needs.
