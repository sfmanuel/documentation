# Settings View

The Settings resource is a key-value store with several use cases.

Keys have to be strings and values are interpreted as a YAML document. Settings can be manipulated via the user interface, via the REST API, and via flow scripts. Please see the [Manipulating resources](Manipulating+resources) documentation on details how to use those methods. The examples in this document are limited to one method per use-case. The method described is interchangeable by any of the other methods.

To manipulate Settings using the command line you need an authorization token. Please see the [Authentication](Authentication#viathecommandline) documentation on how to obtain a authorization token.

## Examples

Here are some common examples how the Settings resource can be used.

### Storing configuration parameters

Let's assume you use a system user to authenticate to your servers. You can store the name of the system user in a setting record:

```bash
$ curl -s 'https://starflows.com/api/1/setting' -d '{"name":"system_user","value":"user123"}' -H "Authorization: $TOKEN"
```

Your flow scripts can then read the setting value whenever they want to authenticate:

```python
def handler(system, this):
    user = system.setting('system_user').get('value')
    this.task(
        'SSH',
        hostname='test.example.com',
        login=user,
        script='systemctl restart httpd'
    ).run()
```

If you choose to change the user-name you only need to update it in one place: the setting value:

```bash
$ curl -s -X PATCH 'https://starflows.com/api/1/setting/system_user' -d '{"value":"user789"}' -H "Authorization: $TOKEN"
```

and with the next execution your flow scripts will read and use the new value.

### Storing output

Your flow scripts can write the value of a setting to represent the current status of the execution:

```python
def handler(system, this):
    system.setting('occurrences_found', value=42)
```

Other flow scripts can read the value and adapt their behaviour accordingly:

```python
def handler(system, this):
    count = system.setting('occurrences_found').get('value')
    if count > 32:
        this.task(
            'SMTP',
            smtp_host='mail.example.com',
            from='no-reply@example.com',
            to='kevin@example.com',
            subject='counter alert',
            text=f'found {count} occurrences'
        ).run()
```

The value can also retrieved using the REST API:

```bash
$ curl -s 'https://starflows.com/api/1/setting/occurrences_found' -H "Authorization: $TOKEN" | jq .
{
  "updated": {
    "name": "occurrences_found",
    "value": "42",
    "id": "1"
  }
}
```

### Client configuration

#### Settings to tune functionality

The Settings resource is also used to store client configuration settings. All settings are optional and use a system provided default value if unset. Here is a list of possible client configuration settings, with a description and the default value:

Setting name | Default value | Description
--- | --- | ---
`client.execution.retention_time.minutes` | 10080 | How long an ended execution is kept before being deleted. 10080 minutes = 1 week. A flow script can override this setting when starting child executions.
`client.message.success.retention_time.minutes` | 720 | How long a success message is kept before being deleted. 720 minutes = 12 hours. The maximum value is 10080 = 1 week.
`client.message.info.retention_time.minutes` | 720 | How long a info message is kept before being deleted. 720 minutes = 12 hours. The maximum value is 10080 = 1 week.
`client.message.warning.retention_time.minutes` | 1440 | How long a warning message is kept before being deleted. 1440 minutes = 24 hours. The maximum value is 10080 = 1 week.
`client.message.error.retention_time.minutes` | 10800 | How long an error message is kept before being deleted. 10080 minutes = 1 week. The maximum value is 10080 = 1 week.
`client.input.timeout.minutes` | 10 | How long to wait for user input. A flow script can override this setting when requesting user input.
`client.flow.library.fallback` | True | If a flow is not found in the client, look for it in the public Cloudomation [flow script library](https://github.com/starflows/library){ext}. Valid options are `True` and `False`. Disabling this option will reduce the functionality of the user interface if certain flow scripts are not available in the client. See [User Interface](User+Interface) for a list of flow scripts which are used by the user interface.
`client.locations` | [] | A list of actor locations which are private to the client.

#### Settings to add functionality

##### Webhooks
Setting name:  
`client.webhook.<webhook name>`

Setting content:  
```yaml
flow_name: my-flow-name
user_name: my-user-name
key: my-secret-api-key
```
This setting configures a webhook at the endpoint `https://cloudomation.io/api/webhook/<client name>/<webhook name>`. A `GET` or `POST` request to that URL will execute a flow script. The webhook will return the flow with all inputs and outputs as a json response. If no response is required, adding 'async' as a parameter to the call will only trigger the flow and return as response only the execution id.  
See the [webhooks](/Webhooks.md) documentation for more detail.

###### Example calls
```bash
curl -d '{"key": "my-secret-api-key"}' https://cloudomation.io/api/webhook/test-client/my-webhook
```
```bash
curl -d '{"key": "my-secret-api-key"}' https://cloudomation.io/api/webhook/test-client/my-webhook?async
```

##### File uploads

When a file is [uploaded](/upload) to Cloudomation a specific webhook `client.webhook.file.added` is being called.
The flow script will receive three parameters:
- user_name: the name of the user who uploaded the file
- file_path: the path of the file in the files resource
- size: the size of the uploaded file, in bytes.

The flow script has the possibility to further process the uploaded file. Possibilities include:
- creating a flow script
- creating/updating a setting
- sending an email with the file as attachment

The following flow script is an example implementation:

```python
def handler(system, this):
    inputs = this.get('input_value').get('data_json')
    if not inputs:
        return this.success('no inputs: nothing to do')
    file_path = inputs.get('file_path')
    if not file_path:
        return this.success('no file_path: nothing to do')
    file = system.file(file_path)
    if file_path.endswith('.py'):
        file_content = file.load('content')
        system.flow(
            name=file_path[:-len('.py')],
            script=file_content,
        )
        file.delete()
    elif file_path.endswith('.yaml'):
        file_content = file.load('content')
        system.setting(
            name=file_path[:-len('.yaml')],
            value=file_content,
        )
        file.delete()
    return this.success('all done')
```


### User configuration

Any setting of the [Client configuration](#clientconfiguration) section can be overridden by a user setting. User settings are specified by replacing `client` with `user.<username>` in the setting name. If - for example - the user kevin wants to have more time to answer input requests he could override the client-wide or system-wide setting by creating a user setting:

```bash
$ curl -s 'https://starflows.com/api/1/setting' -d '{"name":"user.kevin.input.timeout.minutes","value":60}' -H "Authorization: $TOKEN"
```
