# Example interaction with Github: GIT task, webhook configuration, INPUT and REST task
If you are not looking for code, but for example use cases, please take a look at these [example use cases](https://cloudomation.com/examples/){ext}.

This example consists of three flow scripts. You can find all of them in the [public flow script library](https://github.com/starflows/library){ext} as well:
- [Configure Github and Cloudomation webhooks](https://github.com/starflows/library/blob/live/configure_webhooks_github_cloudomation.py){ext}
- [Request Github information](https://github.com/starflows/library/blob/live/request_github_info.py){ext}
- [Synchronise flow script and settings from Github](https://github.com/starflows/library/blob/live/sync_from_github.py){ext}

To run the full process, make sure that you have all three flow scripts in your Cloudomation account, and that the flow scripts are named the same as they are in Github (without the .py extension). Start with the "Configure Github and Cloudomation" flow script and see what happens. Enjoy!

## Table of Content
- [Description](#description)
- [Flow script 1: Configure Github and Cloudomation webhooks](#flow-script-1-configure-github-and-cloudomation-webhooks)
- [Flow script 2: Request Github information](#flow-script-2-request-github-information)
- [Flow script 3: Synchronise flow script and settings from Github](#flow-script-3-synchronise-flow-script-and-settings-from-github)

## Description
This example shows how webhooks can be configured automatically using flow scripts - both on Cloudomation, as well as on other systems, here demonstrated with Github. The first flow script configures two webhooks: one on Cloudomation, and one on Github.

The webhook on Github pushes a notification to the webhook on Cloudomation every time there is a push to the Github repository for which the webhook is set up. The Cloudomation webhook receives the notification from Github and triggers a flow script: one that synchronises flow scripts and settings from the Github repository into Cloudomation.

The Cloudomation webhook can be configured to trigger any flow script, and the webhook on Github can be configured to push different notifications: e.g. when there is a pull request on the repository. The synchronisation of flow scripts into Cloudomation is only one of many possible examples of how such a setup could be used. Other uses could be to trigger a build for a software whenever there is a push to a repository (the build can be triggered on a build server, or be implemented within Cloudomation). Or you could simply set up a notification system: notify certain people whenever there is a pull request on your git repository.

The example here is set up for github, but the principle is the same for any git repository.

The third flow script - request github information - is a helper script that requests information about your github repository from the user via the INPUT task. It also includes the setup and first configuration of a github repository if you want to create a new one.

## Flow script 1: Configure Github and Cloudomation webhooks

```python
# This flow script does two things:
# 1. it sets up a webhook on Cloudomation which is then used to subscribe to a
# github webhook
# 2. it sets up a github webhook which pushes events from a github repo to the
# Cloudomation webhook

# The Cloudomation webhook is set to trigger a flow script that synchronises
# flow scripts and settings from a github repo to Cloudomation whenever there
# is a push to the github repository.

# If you have a setting called "github_info", this flow script will assume that
# it contains three values: your github username, the name of the github repo
# you want to synchronise with Cloudomation, and a github access token which
# enables the flow script to configure a webhook for your github repo. If the
# setting doesn't exist, it will start a secod flow script called
# "request_github_info" which is alo available in the public flow script
# library. This second flow script will ask you about your github info and if
# you want, it will create a github repository for you.

# The actual synchronisation of flow scripts and settings from github to your
# Cloudomation client account is done by a third flow script called
# "sync_from_github". Guess what: it's also available in the public flow script
# library.

# For this process to work, you need the following three flow scripts:
# 1. configure_webhoooks_github_cloudomation (this one)
# 2. request_github_info
# 3. sync_from_github

# Enjoy :)


def handler(system, this):
    # (1) Set up a Cloudomation webhook
    # which triggers a flow script which synchronises settings and flow scripts
    # from a github repo

    # check if the webhook exists
    if not system.setting('client.webhook.github_sync').exists():
        # if it doesn't exist, we create it
        c_webhook_key_request = this.task(
            'INPUT',
            request=(
                'Please specify an authorization key for the Cloudomation '
                'webhook. Can be any alphanumeric string.'
            )
        )
        c_webhook_key = c_webhook_key_request.get('output_value')['response']

        cloudomation_username = this.get('user_name')
        system.setting(
            name='client.webhook.github_sync',
            value={
                "flow_name": "sync_from_github",
                "user_name": cloudomation_username,
                "key": c_webhook_key
            }
        )
    else:
        c_webhook_key = (
            system.setting('client.webhook.github_sync').load('value')['key']
        )

    # (2) Set up a github webhook
    # which pushes events from a repository to the Cloudomation webhook

    # check if github info setting exists
    # if it doesn't, start the flow script to request the info from the user
    if not system.setting('github_info').exists():
        this.flow('request_github_info')

    github_info = system.setting('github_info').load('value')
    github_username = github_info['github_username']
    github_repo_name = github_info['github_repo_name']
    github_token = github_info['github_token']

    # Check if the webhook already exists. To do that, we call the
    # github REST API to list all existing webhooks for your repository.
    github_webhook_endpoint = (
        f'https://api.github.com/repos/'
        f'{github_username}/'
        f'{github_repo_name}/'
        f'hooks'
    )

    list_github_webhooks = this.task(
        'REST',
        url=github_webhook_endpoint,
        headers={
            'Authorization': f'token {github_token}'
        },
    )

    # we get the response
    github_list_webhook = list_github_webhooks.get('output_value')['json']

    # and we check if our webhook already exists
    cloudomation_client_name = this.get('client_name')
    c_webhook_url = (
        f'https://cloudomation.com/api/1/webhook/'
        f'{cloudomation_client_name}/'
        f'github_sync?'
        f'key={c_webhook_key}'
    )

    webhook_exists = False

    for webhook in github_list_webhook:
        if webhook['config']['url'] == c_webhook_url:
            webhook_exists = True
            break

    this.set_output('webhook_exists', webhook_exists)

    # if the webhook doesn't already exist, we create it
    if not webhook_exists:
        this.task(
            'REST',
            url=github_webhook_endpoint,
            method='POST',
            data={
              'events': [
                'push'
              ],
              'config': {
                'url': c_webhook_url,
                'content_type': 'json'
              }
            },
            headers={
                'Authorization': f'token {github_token}'
            },
        )
        this.set_output('webhook_created', 'true')

    return this.success('All done - Cloudomation and github webhooks set up.')
```

## Flow script 2: Request Github information

```python
# This flow script requests information about your github repository and
# guides you through the process of setting up a repository, if you want. It
# will store all information about your github repository in a setting called
# "github_info". This setting can then be used by other flow scripts that
# interact with your github repository.

# You can run it manually to create a github repo, or use it together with
# another flow script called configure_webhooks_github_cloudomation to set
# up a webhook on Cloudomation and github which will synchronise your flow
# scripts and settings automatically from your github repository with
# Cloudomation whenever there is a push to the repository.

# For the actual synchronisation of flow scripts, once your webhook is set
# up, you need a third flow script: sync_from_github. All are available in
# the public flow script library.

# For this process to work, you need the following three flow scripts:
# 1. configure_webhoooks_github_cloudomation
# 2. request_github_info (this one)
# 3. sync_from_github

def handler(system, this):

    github_account_exists = this.task(
        'INPUT',
        request=(
            'Do you have a github account? Please answer y for yes or n for no'
        )
    )

    if github_account_exists.get('output_value')['response'] == 'n':
        this.task(
            'INPUT',
            request=(
                'Please go to https://github.com/join and create an account.'
            )
        )

    elif github_account_exists.get('output_value')['response'] == 'y':
        github_un_request = this.task(
            'INPUT',
            request=('What is your github username?')
        )
        github_username = github_un_request.get('output_value')['response']

        github_token_request = this.task(
            'INPUT',
            request=(
                'To interact with your github account via the github REST API,'
                ' we need a github token for your account. Please go to '
                'https://github.com/settings/tokens and generate a personal '
                'access token. Check the following options: repo and '
                'admin:repo_hook. Paste the token here after you have created '
                'it.'
            )
        )
        github_token = github_token_request.get('output_value')['response']

        github_repo_exists = this.task(
            'INPUT',
            request=(
                'Do you have a github repository you would like to use for '
                'your flow scripts? Please answer y for yes or n for no. If '
                'you answer n, we will set up a new repository for you.'
            )
        )
        this.log(github_repo_exists.get('output_value')['response'])

        if github_repo_exists.get('output_value')['response'] == 'y':
            github_repo_name_request = this.task(
                'INPUT',
                request=('What is the name of your github repository?')
            )
            github_repo_name = (
                github_repo_name_request.get('output_value')['response']
            )

        elif github_repo_exists.get('output_value')['response'] == 'n':
            github_repo_name_request = this.task(
                'INPUT',
                request=(
                    'We will now set up a github repository for you. '
                    'What should be the name of the repository?'
                )
            )
            github_repo_name = (
                github_repo_name_request.get('output_value')['response']
            )

            github_desc_request = this.task(
                'INPUT',
                request=(
                    'Please describe your repository briefly. '
                    'This description will be published on your '
                    'github repository page, where you can change '
                    'it later.'
                )
            )
            github_repo_description = (
                github_desc_request.get('output_value')['response']
            )

            private_repo_request = this.task(
                'INPUT',
                request=(
                    'Do you want to create a private repository? Please '
                    'respond true to create a private repository or false to '
                    'create a public repository. After you respond, your '
                    'repository will be created. Please check the outputs of '
                    'this execution to see if the repository was created '
                    'successfully.'
                )
            )
            private_repo = private_repo_request.get('output_value')['response']

            homepage = (
                f'https://github.com/{github_username}/{github_repo_name}'
            )

            this.task(
                'REST',
                url='https://api.github.com/user/repos',
                method='POST',
                data={
                    'name': github_repo_name,
                    'description': github_repo_description,
                    'homepage': homepage,
                    'private': private_repo,
                    'has_issues': 'true',
                    'has_projects': 'true',
                    'has_wiki': 'true',
                    'auto_init': 'true'
                },
                headers={
                    'Authorization': f'token {github_token}'
                },
            )
            this.log(
                f'Github repository created successfully. '
                f'Check it out here: {homepage}'
            )

        else:
            this.task(
                'INPUT',
                request=(
                    'We did not recognise your response. '
                    'Please restart the flow script and try again.'
                ),
                timeout=0.2
            )

        github_info = {
            'github_username': github_username,
            'github_repo_name': github_repo_name,
            'github_token': github_token
        }

        system.setting(name='github_info', value=github_info)
        this.set_output('github_info', github_info)

    else:
        this.task(
            'INPUT',
            request=(
                'We did not recognise your response. '
                'Please restart the flow script and try again.'
            ),
            timeout=0.2
        )

    return this.success('All done.')
```

## Flow script 3: Synchronise flow script and settings from Github

```python
# This flow is registered as webhook, triggered by a commit to the
# repository. When started manually, it will sync from master.

# The flow script will sync all files from the github repository specified
# in the "github_info" setting. It will create flow script from all files
# ending with .py and create settings from all files ending with .yaml.

# You can set up the webhooks on github to trigger this flow script using the
# configure_webhooks_github_cloudomation flow script, which is available in the
# public flow script library. You can use another flow script to guide you
# through the process of setting up a github repository. It's called
# request_github_info and is also available in the public flow script library.

# For the full process, you need the following three flow scripts:
# 1. configure_webhoooks_github_cloudomation
# 2. request_github_info
# 3. sync_from_github (this one)

# This flow script is the only one you need continously to syncronise flow
# scripts from your github repository. The other two you need once to set it
# all up.

# Note that once you have this set up, this flow script will ALWAYS check out
# your github repository WHENEVER THERE IS A PUSH. Make sure that you set this
# up to synchronise only a repository that you want to regularly synchronise
# with Cloudomation.

# If you want to stop synchronising files from your github repository with
# Cloudomation, the easiest way is to disable the webhook on github. You can
# also remove or rename the webhook on Cloudomation, but that will lead to
# errors on the side of your github webhook, which will still try to send
# notifications to the Cloudomation webhook.

import yaml
import os


def handler(system, this):
    inputs = this.get('input_value')
    try:
        commit_sha = inputs['data_json']['commit_sha']
    except KeyError:
        commit_sha = 'master'

    # read the connection information of the private repository
    repo_info = system.setting('github_info').get('value')
    github_username = repo_info['github_username']
    github_repo_name = repo_info['github_repo_name']
    github_token = repo_info['github_token']

    repo_url = (
        f'https://{github_username}:{github_token}@github.com/'
        f'{github_username}/{github_repo_name}.git'
    )

    this.task(
        'GIT',
        command='get',
        repository_url=repo_url,
        files_path='synced_from_git',
        ref=commit_sha,
    )
    # the git 'get' command ensures the content of the repository in a local
    # folder. it will clone or fetch and merge.

    # list all flows from the repository
    # this call will return a list of File objects
    files = system.files(filter={'field': 'name', 'op': 'like', 'value': 'synced_from_git/%'})
    for file_ in files:
        # split the path and filename
        path, filename = os.path.split(file_.get('name'))
        # split the filename and file extension
        name, ext = os.path.splitext(filename)
        if path == 'flows' and ext == '.py':
            # create or update Flow object
            system.flow(name).save(script=file_.get('content'))
        elif path == 'settings' and ext == '.yaml':
            # load the yaml string in the file content
            value = yaml.safe_load(file_.get('content'))
            # create or update Setting object
            system.setting(name).save(value=value)

    return this.success('Github sync complete')
```
