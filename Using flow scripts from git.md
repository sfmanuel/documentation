# Using flow scripts from git

Cloudomation will search the [public flow script library](https://github.com/starflows/library) for any flow script that is executed which doesn't exist in the client account from which it is executed. For example, if you call c.flow('Create User') from a flow script and you do not have a Create User flow script in your account, Cloudomation will automatically fetch the Create User flow script from the public flow script library and execute it. The flow script will only be fetched and executed dynamically, and will not be stored in your client account.  
We encourage Cloudomation users to share their flow scripts in the public flow script library, which enables use of this functionality, and will help other users build their automations more quickly through reuse of existing flow scripts.

Will contain:
- how to loadand execute flow scripts dynamically from public github repositories (other than the public flow script library)
- how to disable dynamic loading of flow scripts from the public flow script library
- how to load flow scripts into the Cloudomation platform from git repositories requiring authentication  
