# Webhooks

The webhooks setting allows you to configure a webhook with Cloudomation that triggers a specific flow script. Creating this setting configures an endpoint at `https://cloudomation.io/api/webhook/<client name>/<webhook name>`. A `GET` or `POST` request to that URL will execute a flow script. Optionally, the webhook will return a response.

To register a webhook, you need to create a setting that follows a specific pattern:

setting name:  
`client.webhook.<webhook name>`  

setting content:  
```yaml
flow_name: my-flow-name
user_name: my-user-name
key: my-secret-api-key
```

The flow will receive a dictionary containing the request headers and payload.
The `key` field is optional. If specified, the request must contain the key in
the query string or JSON payload.

The standard behavior of the webhook is to execute the flow script, wait for the flow script to finish, and then return the flow with all its inputs and outputs as a json response to the call. If no response is required, it is possible to add a parameter `async` to the webhook call, which will trigger the flow script without sending a response.

**Example setting**   
setting name:  
`client.webhook.signup`

setting content:  
```yaml
flow_name: signup
user_name: kevin
key: my-secret-api-key
```

Creating this setting configures an endpoint at `https://cloudomation.io/api/webhook/myclient/signup`. A `GET` or `POST` request to that URL will execute the flow named `signup` with the permissions of user `kevin`.

**Example calls**   
```bash
curl -d '{"key": "my-secret-api-key"}' https://cloudomation.io/api/webhook/test-client/my-webhook
```
The above call will trigger the flow script, wait for it to finish and return the flow script itself as well as its inputs and outputs as a json response.
```bash
curl -d '{"key": "my-secret-api-key"}' https://cloudomation.io/api/webhook/test-client/my-webhook?async
```
The above call will trigger the flow script and return immediately without waiting for the flow to finish. The json response will contain the execution id.
