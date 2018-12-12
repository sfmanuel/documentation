# User roles  

There are three user roles available on the Cloudomation platform: users, client administrators, and system administrators.  
It is important to note that all users in one Cloudomation client, not matter their roles, share resources. This means that all users can see, edit, and delete content created by other users such as flow scripts, settings and executions.  
Assigning user roles is currently not flexible: the user who creates a Cloudomation client via the sign up form automatically is assigned the role of client admin. This user cannot be deleted. All additional users are assigned the user role.  

## Users
Users have the lowest level of rights on the system: they can create, execute, edit and generally work with flow scripts, but they have restricted rights with regard to some higher level administrative functions.

Users can *not*:
* create users
* delete users
* deactivate or reactivate users
* generate token usage reports
* delete all executions via the Cloudomation REST API - a user can still bulk delete manually via the Cloudomation user interface
* delete all or individual sockets
* add or modify the token allowance for a client
* list or delete all or individual Cloudomation background processes
* list all clients on a Cloudomation instance
* delete a Cloudomation client

## Client administrators  
System administrators are the user role with the most privileges within a Cloudomation client. In addition to all functionality that is available to users, client admins can administrate users: create, delete, deactivate and reactivate users. They can also create token usage reports, delete socket connections, and delete all executions from a client via the Cloudomation REST API.

Client administrators can *not*:
* add or modify the token allowance for a client
* list or delete all or individual Cloudomation background processes
* list all clients on a Cloudomation instance
* delete a Cloudomation client

## System administrators
System administrators are the user role with the most privileges. They can administrate entire Cloudomation instances with several client accounts. This role is only available to customers with a dedicated Cloudomation instance or a self-hosted or on-premise installation. System admininstrators can modify token allowances, administrate Cloudomation background processes, see information about all clients on an instance, and delete Cloudomation clients.
