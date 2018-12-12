# Using flow scripts from git

## Flow scripts from your git repository
With the [GIT taskt type](/Tasks#gittask) you can copy flow scripts and settings from your public or private git repository into your Cloudomation account. There is a [git sync flow script](https://github.com/starflows/library/blob/master/sync%20flow%20scripts.py) available in the public flow script library that allows you to easily set up synchronisation between your git repository and Cloudomation.

## Flow scripts from the Cloudomation library
Cloudomation will search the [public flow script library](https://github.com/starflows/library){ext} for any flow script that is executed which doesn't exist in the client account from which it is executed. For example, if you call c.flow('Create User') from a flow script and you do not have a Create User flow script in your account, Cloudomation will automatically fetch the Create User flow script from the public flow script library and execute it. The flow script will only be fetched and executed dynamically, and will not be stored in your client account.  
