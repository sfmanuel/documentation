# Settings View

The Settings resource is a key-value store with several uses.
Keys have to be strings and values are interpreted as a YAML document. Settings can be manipulated via the user interface, via the REST API, and via flow scripts. Please see the [Manipulating resources](Manipulating resources) documentation on details how to use those methods. The examples in this document are limited to one method per use-case. The method described are interchangeable by any of the other methods.

To manipulate Settings using the REST API you need an authorization token. Please see the [Authentication](Authentication#restapi) documentation on how to obtain a authorization token.

## Examples

Here are some common examples how the Settings resource can be used.

### Storing configuration parameters

Let's assume you use a system user to authenticate to your servers. You can store the name of the system user in a setting record:

```bash
curl -s 'https://starflows.com/api/1/setting' -d '{"name":"system_user","value":"user123"}' -H "Authorization: $TOKEN"
```

Your flow scripts can then read the setting value whenever they want to authenticate:

```python
user = c.setting('system_user')
c.task(
    'SSH',
    hostname='test.example.com',
    login=user,
    script='systemctl restart httpd'
)
```

If you choose to change the user-name you only need to update it in one place: the setting value:

```bash
curl -s -X PATCH 'https://starflows.com/api/1/setting/system_user' -d '{value":"user789"}' -H "Authorization: $TOKEN"
```

and with the next execution your flow scripts will read and use the new value.

### Storing output

Your flow scripts can write the value of a setting to represent the current status of the execution:

```python
c.setting('occurrences_found', 42)
```

Other flow scripts can read the value and adapt their behaviour accordingly:

```python
count = c.setting('occurrences_found')
if count > 32:
    c.task(
        'SMTP',
        smtp_host='mail.example.com',
        from='no-reply@example.com',
        to='kevin@example.com',
        subject='counter alert',
        body=f'found {count} occurrences'
    ).run()
```

The value can also retrieved using the REST API:

```bash
curl -s 'https://starflows.com/api/1/setting/occurrences_found' -H "Authorization: $TOKEN" | jq .
```

```json
{
  "updated": {
    "name": "occurrences_found",
    "value": "42",
    "id": "1"
  }
}
```

### Client configuration

The Settings resource is also used to store client configuration settings. All settings are optional and use a system provided default value if unset. Here is a list of possible client configuration settings, with a description and the default value:

Setting name | Default value | Description
--- | --- | ---
client.execution.retention_time.minutes | 1440 | How long an ended execution is kept before being deleted. 1440 minutes = 1 day. This can be overridden when starting an execution in a flow script.
client.input.timeout.minutes | 10 | How long to wait for user input. This can be overridden when requesting user input in a flow script.
client.flow.library.fallback | True | If a flow is not found in the client, look for it in the [public Cloudomation flow script library](https://github.com/starflows/library). Valid options are 'True' and 'False'. Disabling this option will reduce the functionality of the user interface if certain flow scripts are not available in the client. See [User Interface](User Interface#flowscripts) for a list of flow scripts which are used by the user interface.

### User configuration

Any setting of the [Client configuration](#clientconfiguration) section can be overridden by a user setting. User settings are specified by replacing `client` with `user.<username>` in the setting name. If, for example, the user kevin wants to have more time to answer input requests he could override the client-wide or system-wide setting by creating a user setting:

```bash
curl -s 'https://starflows.com/api/1/setting' -d '{"name":"user.kevin.input.timeout.minutes","value":60}' -H "Authorization: $TOKEN"
```
