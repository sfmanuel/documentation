# Tutorial
Welcome to the Cloudomation tutorial. The tutorial has several chapters. Feel free to jump directly to a chapter that interests you, or start at the top and read through the entire tutorial.  

The tutorial is intended to give you a first idea about the Cloudomation platform, its functionality, some concepts that we use in the documentation, and to get you started with your own explorations of Cloudomation. Not all Cloudomation functionality is covered in this tutorial.  

## Some vocabulary
In Cloudomation, you define automations using flow scripts, or **flows**. Flow scripts are written in Python. You can think of them as the units or pieces of your automation.  

Running a flow script creates an **execution**. An execution contains all the information about a specific run of a flow script - inputs, outputs, runtime, etc.  

An execution can start several **child executions**. A child execution is any execution that is started by another execution, which usually provides the child execution with inputs, with child executions usually also returning something back to the **parent execution** - for example an output, or a status.

So: you write a flow script. When you run it, it creates an execution. Your execution can be the parent execution of child executions.  

There are two different types of functionality that Cloudomation provides. Functionality which happens on the Cloudomation platform - for example one flow script starting a child execution, or logging something - is provided in the form of normal Python functions, which are listed below. To interact with systems outside of the Cloudomation platform, Cloudomation provides functionality in the form of **tasks** - for example REST calls, SSH connections, or sending emails via SMTP (and more). For reasons of security and performance, these tasks are always executed as individual child executions with defined inputs and outputs.

## An introduction to the Cloudomation Flow Script API
The [Cloudomation Flow Script API](Flow+script+API) exploses Cloudomation functionality to the user - you :)  

There are two classes available to you:
- the Cloudomation class, and
- the Execution class

### The Cloudomation class
The Cloudomation class allows you to interact with the Cloudomation platform. You can think of it as the "bottom layer" of Cloudomation functionality. There are a number of functions available in the Cloudomation class. We have grouped them for your convenience to give you an overview what the Cloudomation functions encompass.  

One group of functions in the Cloudomation class create **execution objects**. These are important - all functions of the second class, the execution class, can be applied on execution objects. Cloudomation functions that create execution objects are:
- task
- flow
- script  

Another group of functions allows you to directly interact with other executions:
- watch
- getParent  
- getEnvName  

One group of functions allows you to get information into your flow script - from other executions, or from internal systems:
- getInputs
- getVaultToken
- setting

Then there is a group of functions that allow you to write outputs and logs - which can again be picked up and used by other executions, or be used by you, the user, to log your executions behavior and debug your flow scripts:
- setOutput  
- setOutputs  
- log  
- logln

The next group of function allows you to handle files on the Cloudomation platform. You can read, write, and update files and list files in a directory on the Cloudomation platform:
- file
- list_dir

And the last group of functions allows you to control basic behavior of your execution:
- sleep
- sleep_until
- waitFor
- waitForAll
- end

You can look each function up in the [Cloudomation Flow Script API](Flow+script+API) documentation, which lists parameters, what the function returns, and a small example for each of them.

### The Execution class
Like the name suggests, the execution class allows you to interact with execution objects. We already know that execution objects (or executions) are instances of executed flow scripts.  

Due to the implementation of tasks as individual executions, and our general recommendation to modularise automations into small(ish) individual flow scripts, interaction between executions is a core part of automating processes with Cloudomation.  

Again, we will group the available functions to give you an overview of the available functionality.  

You can provide executions with inputs before executing them:
- setInput
- setInputs

You can control basic execution behavior:
- run
- runAsync
- wait

You can get information from executions:
- getStatus
- getOutputs

And you can clone executions - this is a handy function which allows you to create "execution templates" which you can reuse with modifications:
- clone

## Tasks
We have mentioned that functionality to interact with "the outside world", i.e. anything outside the Cloudomation platform, happens in the form of tasks. You can think of tasks as "mini flow scripts" with fixed, defined inputs,  outputs and functionality.  

The following tasks are currently available on the Cloudomation platform:
- REST - communicate with REST APIs
- SSH - connect to remote systems with ssh (e.g. to execute a script there)
- GIT - check out a git repository (e.g. to get flow scripts and settings from git)
- SMTP - send emails via SMTP
- INPUT - request input from a user in the Cloudomation platform
- AWS - communicate with AWS
- REDIS - access a REDIS database

Cloudomation tasks are documented in more detail in [Tasks](Tasks).

## Writing flow scripts
Now that you have a rough overview of which functionality is available within the Cloudomation platform, let's get started with some small flow scripts.  

Take a look at the [quick start guide](Quick+start) for a first impression. Review the  [Examples](Examples) to get an idea of how more complex flow scripts could look like.    

We also recommend to review the [Tips and tricks for writing flow scripts](Tips+and+tricks+for+writing+flow+scripts) before you get started with your own project.  

It might also be a good idea to take a look at the [public flow script library](https://github.com/starflows/library){ext} to see if there are some snippets or entire flow scripts that you could reuse.
