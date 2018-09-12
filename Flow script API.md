# Flow script API

the API is exposed to flow scripts by passing the Cloudomation object to the
handler function.
```python
def handler(c):
    # use the cloudomation object "c"
    c.log('Hello World!')
```

Here are the sources of the Cloudomation classes for reference:
```python
import time
import yaml
import traceback


# TODO: getOutputs and getStatus per default with wait


STATUS_LIST = [
    'pending',
    'queued',
    'running',
    'scheduled',
    'waiting',
    'paused',
    'success',
    'error',
    'fault',
]
ENDED_STATUS_LIST = [
    'success',
    'error',
    'fault',
]
UNEXPECTED_OPTIONS = [
    'error',
    'raise',
    'ignore',
]


class UnexpectedStatusError(Exception):
    def __init__(self, execution_id, expected_status, actual_status):
        self.execution_id = execution_id
        self.expected_status = expected_status
        self.actual_status = actual_status

    def __str__(self):
        return (
            f'execution ID {self.execution_id}:'
            f' expected "{self.expected_status}",'
            f' actual "{self.actual_status}"')


class Cloudomation(object):
    def __init__(self, channel, execution_id):
        self._channel = channel
        self.execution_id = execution_id

    def _get_loc(self):
        stack = traceback.extract_stack()
        last_lineno = None
        loc_lineno = None
        loc_cmd = None
        for s in stack:
            if s.filename.endswith('cloudomation.py'):
                loc_lineno = last_lineno
                loc_cmd = s.name
                break
            last_lineno = s.lineno
        return f'line {loc_lineno}: {loc_cmd}'

    def _send(self, obj):
        obj['loc'] = self._get_loc()
        self._channel.send(obj)

    def task(
            self,
            task,
            inputs={},
            name=None,
            location=None,
            protect_inputs=None,
            protect_outputs=None,
            retention_time=None,
            **kwargs):
        """
        create a pending task execution
        params:
        - task           the name of the task
        - inputs         a dictionary containing the input parameters for
                         the task
        """
        if not inputs:
            inputs = {}
        inputs.update(kwargs)
        self._send({
            'cmd': 'create_execution_task',
            'task': task,
            'inputs': inputs,
            'name': name,
            'location': location,
            'protect_inputs': protect_inputs,
            'protect_outputs': protect_outputs,
            'retention_time': retention_time,
        })
        execution_id = self._channel.receive()
        return Execution(self, execution_id)

    def flow(
            self,
            flow,
            inputs={},
            name=None,
            pass_token=False,
            protect_inputs=None,
            protect_outputs=None,
            retention_time=None,
            **kwargs):
        """
        create a pending flow execution
        params:
        - flow           the name, optionally with path, of the flow script
        - inputs         a dictionary containing the input parameters for
                         the flow
        - pass_token     if a vault_token should be passed to the child
                         execution
        """
        if not inputs:
            inputs = {}
        inputs.update(kwargs)
        self._send({
            'cmd': 'create_execution_flow',
            'flow': flow,
            'inputs': inputs,
            'name': name,
            'pass_token': pass_token,
            'protect_inputs': protect_inputs,
            'protect_outputs': protect_outputs,
            'retention_time': retention_time,
        })
        execution_id = self._channel.receive()
        return Execution(self, execution_id)

    def script(
            self,
            script,
            inputs={},
            name=None,
            pass_token=False,
            protect_inputs=None,
            protect_outputs=None,
            retention_time=None,
            **kwargs):
        """
        create a pending script execution
        params:
        - script         the script to be executed
        - inputs         a dictionary containing the input parameters for the
                         script
        """
        if not inputs:
            inputs = {}
        inputs.update(kwargs)
        self._send({
            'cmd': 'create_execution_script',
            'script': script,
            'inputs': inputs,
            'name': name,
            'pass_token': pass_token,
            'protect_inputs': protect_inputs,
            'protect_outputs': protect_outputs,
            'retention_time': retention_time,
        })
        execution_id = self._channel.receive()
        return Execution(self, execution_id)

    def waitFor(self, *args, expected=['success'], unexpected='error'):
        """
        wait for the first of the given executions to finish. This is an
        OR relation. If you need an AND relation use chained calls to
        waitFor or cloudomation.waitForAll()
        Parameters:
            *args - Execution objects or execution IDs to wait for
            expected - a list of status codes which are expected
            unexpected - what to do if the ending execution does not have an
                         expected status
                possible values are:
                - error: end this execution with error
                - raise: raise an UnexpectedStatusError
                - ignore: continue normally
        Example:
            cloudomation.waitFor(A).waitFor(B) waits until A and B are both
                                               ended
            cloudomation.waitFor(A, B) waits for either A or B, whichever ends
                                       first
        Returns:
            the id of the execution which finished first
            or None if the list of executions to wait for is empty
        """
        if not args:
            return None
        if not all([s in ENDED_STATUS_LIST for s in expected]):
            invalid = [s for s in expected if s not in ENDED_STATUS_LIST]
            return self.end('fault', (
                f'invalid value{"s" if len(invalid) > 1 else ""}'
                f' "{invalid}" for parameter "expected"'))
        if unexpected not in UNEXPECTED_OPTIONS:
            return self.end('fault', (
                f'invalid value "{unexpected}" for parameter "unexpected"'))
        execution_ids = [
            (arg.execution_id if isinstance(arg, Execution) else arg)
            for arg in args]
        self._send({
            'cmd': 'wait_for',
            'execution_ids': execution_ids
        })
        resumed_by_id = self._channel.receive()
        resumed_by = Execution(self, resumed_by_id)
        if unexpected != 'ignore':
            status, status_message = resumed_by.getStatus()
            if status not in expected:
                outputs = resumed_by.getOutputs()
                message = (
                    f'child execution ID "{resumed_by.execution_id}"'
                    f' did not end with any expected status in {expected},'
                    f' but with status "{status}": "{status_message}".'
                    f' All outputs:\n{outputs}')
                if unexpected == 'error':
                    return self.end('error', message)
                elif unexpected == 'raise':
                    raise UnexpectedStatusError(
                        resumed_by.execution_id,
                        expected,
                        status)
        return resumed_by

    def waitForAll(self, *args, expected=['success'], unexpected='error'):
        """
        wait for all of the given executions to finish
        Parameters:
            *args - Execution objects or execution IDs to wait for
            the expected and unexpected parameters are the same as for waitFor
        Returns:
            the cloudomation object
        """
        for ex in args:
            self.waitFor(ex, expected=expected, unexpected=unexpected)
        return self

    def sleep(self, delay_sec: float):
        """
        sleep for a given amount of time
        the execution will resume not before the time passed,
        but might resume slightly later depending on system load
        same as sleep_until(time.time() + delay_sec)
        """
        return self.sleep_until(time.time() + delay_sec)

    def sleep_until(self, sleep_until: float):
        """
        sleep until a given time
        the execution will resume not before the time passed,
        but might resume slightly later depending on system load
        """
        self._send({
            'cmd': 'sleep_until',
            'sleep_until': sleep_until,
        })
        return self

    def logln(self, out, *args, **kwargs):
        return self.log(out, *args, _nl='\n', **kwargs)

    def log(self, out, *args, _nl=None, **kwargs):
        if type(out) == dict:
            out = yaml.safe_dump(
                out,
                default_flow_style=False,
                allow_unicode=True,
                indent=4).rstrip()
        else:
            out = str(out)
        message = out
        if args:
            message += ' ' + ', '.join([str(arg) for arg in args])
        if kwargs:
            kvs = ['{}={}'.format(k, v) for k, v in kwargs.items()]
            message += ' ' + ' '.join(kvs)
        if _nl:
            message += _nl
        self._send({
            'cmd': 'set_output',
            'key': 'logging',
            'value': message,
            'append': True
        })
        return self

    def end(self, status='success', message='end status set by script'):
        self._send({
            'cmd': 'end',
            'status': status,
            'message': message,
        })
        # receive, so this tasklet is blocked
        # self._channel.receive()

    def getInputs(self, execution_id=None):
        if execution_id is None:
            execution_id = self.execution_id
        self._send({
            'cmd': 'get_inputs',
            'execution_id': execution_id,
        })
        return self._channel.receive()

    def getVaultToken(self):
        self._send({
            'cmd': 'get_vault_token'
        })
        return self._channel.receive()

    def setOutput(self, key, value, append=False):
        self._send({
            'cmd': 'set_output',
            'key': key,
            'value': value,
            'append': append
        })
        return self

    def setOutputs(self, outputs={}, merge=True, **kwargs):
        assert type(outputs) == dict
        outputs.update(kwargs)
        self._send({
            'cmd': 'set_outputs',
            'outputs': outputs,
            'merge': merge
        })
        return self

    def setting(self, setting_name, value=None):
        """
        if value is given, it sets the setting to it and returns it
        else it reads the value and returns it.
        """
        if value is None:
            self._send({
                'cmd': 'get_setting',
                'setting': setting_name,
            })
        else:
            self._send({
                'cmd': 'set_setting',
                'setting': setting_name,
                'value': value,
            })
        return self._channel.receive()

    def watch(self, resource_name, record_id):
        self._send({
            'cmd': 'watch',
            'resource_name': resource_name,
            'record_id': record_id,
        })
        while True:
            self._send({
                'cmd': 'watch_consume',
            })
            yield self._channel.receive()

    def getParent(self):
        self._send({
            'cmd': 'get_parent'
        })
        parent_id = self._channel.receive()
        return Execution(self, parent_id)

    # TODO: add more getters (type, flow name, start time, etc)

    # TODO: generic short hands - also for vault, etc...
    # def recurring(self, flow_name, delay_sec):
    #    return self.flow(
    #        'recurring.py',
    #        {
    #            'flow_name': flow_name,
    #            'delay_sec': delay_sec
    #        },
    #        name='recurring {} every {} seconds'.format(flow_name, delay_sec)
    #    )


class Execution(object):
    def __init__(self, cloudomation, execution_id):
        self.cloudomation = cloudomation
        self._channel = cloudomation._channel  # for convenience
        self.execution_id = execution_id

    def _send(self, obj):
        self.cloudomation._send(obj)

    def __str__(self):
        return str(self.__dict__)

    def __eq__(self, value):
        if isinstance(value, Execution):
            return self.execution_id == value.execution_id
        return self.execution_id == value

    def __hash__(self):
        return hash(self.execution_id)

    def clone(self, inputs=None, location=None, name=None, **kwargs):
        if inputs is None:
            inputs = {}
        assert type(inputs) == dict
        inputs.update(kwargs)
        self._send({
            'cmd': 'execution_clone',
            'execution_id': self.execution_id,
            'inputs': inputs,
            'name': name,
            'location': location,
        })
        cloned_execution_id = self._channel.receive()
        return Execution(self.cloudomation, cloned_execution_id)

    def setInputs(self, inputs=None, **kwargs):
        if inputs is None:
            inputs = {}
        assert type(inputs) == dict
        inputs.update(kwargs)
        if not inputs:
            return self
        self._send({
            'cmd': 'execution_set_inputs',
            'execution_id': self.execution_id,
            'inputs': inputs,
        })
        return self

    def setInput(self, key, val):
        return self.setInputs({key: val})

    def getInputs(self):
        return self.cloudomation.getInputs(self.execution_id)

    def runAsync(self, inputs=None, location=None, **kwargs):
        """
        starts the execution asynchrounously
        does not block
        Parameters:
        - inputs: if given, the execution is cloned, the inputs are
                  applied to the clone, and then the execution is started.
                  same as Execution.clone(inputs).runAsync()
        """
        if inputs or location or kwargs:
            return self.clone(inputs, location, **kwargs).runAsync()
        self._send({
            'cmd': 'execution_run_async',
            'execution_id': self.execution_id,
        })
        return self

    def run(
            self,
            inputs=None,
            expected=['success'],
            unexpected='error',
            location=None,
            **kwargs):
        """
        starts the execution synchrounously
        blocks until the execution reaches an ended status
        same as execution.runAsync().wait()
        """
        return self.runAsync(inputs, location, **kwargs).wait(
            expected=expected,
            unexpected=unexpected)

    def wait(self, expected=['success'], unexpected='error'):
        """
        blocks until the execution reaches an ended status
        if the execution already ended this function returns immedeately
        execution.wait() has the same effect as
        cloudomation.waitFor(execution), except this function returns the
        execution object and cloudomation.waitFor returns the execution id of
        the execution which ended first
        Parameters:
            the expected and unexpected parameters are the same as for
            cloudomation.waitFor
        """
        self.cloudomation.waitFor(
            self,
            expected=expected,
            unexpected=unexpected)
        return self

    def getStatus(self):
        self._send({
            'cmd': 'execution_get_status',
            'execution_id': self.execution_id,
        })
        return self._channel.receive()

    def getOutputs(self):
        self._send({
            'cmd': 'execution_get_outputs',
            'execution_id': self.execution_id,
        })
        return self._channel.receive()
```
