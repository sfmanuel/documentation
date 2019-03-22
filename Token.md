# Token

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Token](#token)
	- [What are Token?](#what-are-token)
	- [Why Token?](#why-token)
	- [Token price list](#token-price-list)
	- [Quick tips to reduce your Token usage](#quick-tips-to-reduce-your-token-usage)
	- [Buying and cancelling Token](#buying-and-cancelling-token)
	- [How many Token do I need for my use case?](#how-many-token-do-i-need-for-my-use-case)
	- [What happens if I run out of Token?](#what-happens-if-i-run-out-of-token)

<!-- /TOC -->

## What are Token?
Token are an artificial unit of measurement for computing resources on the Cloudomation platform. We designed the Token measure as a basis for our pricing.  

Most things you do on the Cloudomation platform use some underlying resources, which is measured and displayed to you in Token units. For example, running an automation on the Cloudomation platform uses a specific amount of Token. How many Token one automation uses depends on how complex it is, which functionality is used, and if you are doing many things in parallel in that automation.  

With your Cloudomation account, you buy a certain amount of Token. The amount of Token you have available in your Cloudomation acocunt determines which Cloudomation functionality you can use *at the same time*.  

Token are not used up, they are valid for a specific time, usually one month. They define the maximum amount of resources you can use on the Cloudomation platform at any given time.  

You think of Token similar to the coin you use in a shopping cart: as long as you are using the shopping cart, the coin is in the cart and you can't use it for something else. As soon as you return the cart, you get the coin back and can use it for other things. Token are similar: they are blocked, for example, by runninng an automation for as long as the automation runs. Once the automation has run through, your Token is freed up an can be used for something else.  

This means that the amount of Token in your account essentially determines how many things you can execute in parallel. But running automations is not the only thing that influences your Token usage.  

Most things you do on the Cloudomation platform influence your Token usage in some way. For example, every user you have in your account costs a fraction of a Token. Similarly, while you are logged in, every live view of a page you have open costs a fraction of a Token. You can recognise live views by the green lights next to them in the left hand menu pane - for example, when you have your Executions list open, this list is a live view. It updates live as your executions are running. If you switch to a different view, the Executions list will stay live.

Check the chapter [quick tips to reduce your Token usage](#quick-tips-to-reduce-your-token-usage) to learn how you can avoid unnecessary Token usage. In the chapter [Token price list](#token-price-list) you find a list of everything that requires Token.

You can see how many Token you are currently using by looking at the "Token usage counter" at the top left of the Cloudomation user interface while you are logged in. If you hover over the counter, you will see the percentage of Token currently in use.

You can check your current Token usage in the [Reports](/reports) section while you are logged in. There, you can see how many Token are used for what. Token usage reports are generated regularly. You can always generate your own record by clicking "Generate new report" at the top, which will list the current Token usage of your account.

You can check how many Token you have in your account in the [Tokens](/tokens) section while you are logged in. There, you see how many Token you have and how long they are valid for. Token are usually valid for one month. If you don't cancel your subscription, you Token will automatically be renewed at the end of each month for another month.

So let's recap:
* Token are an artificial unit of measurement
* You need Token to run automations on the Cloudomation platform
* The more Token you have, the more automations you can run at the same time  
* Token are valid for a specific time, usually one month - they are not used up but valid for that entire time, and only ever blocked for the duration of a running execution

## Why Token?

We decided to use Token to simplify the pricing for you. We looked at each functionality, and how much resources it uses, and assigned a fitting Token price for it. For you, this means that everything is priced in Token and you don't need to worry about underlying measures like CPU, RAM, i/o etc. Token allow us to map everything you do on the Cloudomation platform to this one measure.

In addition, Token are not used up. This means that you get to decide how much you want to spend on your Cloudomation account, and that price is fixed. If you buy ten Token, you pay for ten Token, period. You can plan your cost. And you are free to use your Token as much as you like: you don't need to worry about the cost of learning, development, playing around: you pay for your Token once and it costs the same, independent of how much you use it.

## Token price list

The table below lists everything that counts towards your Token usage, how much Token each item requires, and an explanation of what it is. The life time column describes for how long each of the mentioned items usually exists, and therefore for how long they typically block Token for. Remember that Token are not used up but only blocked temporarily, and freed up again once the blocking item expires / has run through / reaches the end of its life time.

|Name in usage report|Explanation|Token price|Token price explanation|Life time|
|---|---|---|
|record_user|The system record of a user. This contains the user name, e-mail-address, password, user role etc. You can see your user records in the [User](/user) section while logged in.|0.01|Every user in your account costs 0.01 Token. When you invite a new user, this will block 0.01 Token in your account for as long a this user exists. When you delete a user, this will free up 0.01 Token in your account. Since you need at least one user for each account, you will always have a minimum Token usage of 0.01 Token in your account.|Forever / long term: user records exist, and block Token, for as long as the user exists.|
|record_execution|The system record of an execution, i.e. a past run of a flow script. This is what you see in the [Executions](/executions) view. An execution record contains all the information of an individual run of a flow script: when it ran, how long it took, which inputs and outputs were used etc.|0.01|Every entry in your [Executions](/executions) list costs 0.01 Token. The execution records are created automatically every time you run a flow script. Running one flow script can generate several execution records: each task within a flow script creates a separate execution record.|7 days: by default, execution records are set to expire after 7 days, meaning that they are automatically deleted and their Token are freed up after 7 days. You can change this default for all execution records using the client.execution.retention_time.minutes setting - refer to the [settings documentation](/documentation/settings) to find out more. You can also change the expiry time for an individual execution manually in the executions view, or in a flow script when starting a child execution.|
|record_flow|Your flow scripts, i.e. all flow scripts that you have stored in the [Flows](/flows) section of your account.|0.01|Every flow script in the [Flows](/flows) list costs 0.01 Token for as long as it exists. You can delete flow scripts to free up Token.|Intermediate to long term: until you actively delete them. Flow scripts do not have an expiration date. This means that they stay in your account (and block Token) from the time you create them until the time you actively delete them.|
|record_setting|your settings, i.e. everything you see in the [Settings](/settings) view.|0.01|Every entry in the [Settings](/settings) view costs 0.01 Token.|Intermediate to long term: until you actively delete them. Settings do not have an expiration date. This means that they stay in your account (and block Token) from the time you create them until the time you actively delete them.|
|execution_flow|Execution of a flow script.|1|Running a flow script (any flow script) blocks 1 Token for the duration of its execution. The Token is freed up again as soon as the flow script finishes successfully, aborts with an error, is waiting for a dependency (a child execution), is waiting for Token, or is paused.|Short term: only during running execution of a flow script. Note that child executions started for tasks are priced separately and do not block the 1 Token which is required for running flow scripts.|
|execution_script|Execution of the script method in a flow script. The script method lets you execute a flow script from within a flow script, creating a child execution (without creating a flow record).|1|When you use the script method in a flow script, and then run this flow script, 1 Token will be blocked when the script method is called for as long as it takes the method call to complete.|Short term: only during running execution. This will typically block 1 Token for no more than a few milliseconds. Depends on the complexity of the script your are executing, and if you run it synchronously (will block the token longer because it will wait until the script finishes and only then return) or asynchronously (returns immediately, frees up your token right away).|
|execution_task_aws|Execution of an AWS task.|2|Calling an AWS task in your flow script will start a child execution for the AWS task. This child execution will block 2 Token for as long as it runs. If the parent execution starts the AWS task synchronously, the parent execution will change into the status "waiting for dependency" until the AWS task completes. While the parent execution is in the "waiting for dependency" status it will not block any Token.|Short term: only while the AWS task is running.|
|execution_task_input|Exeution of an INPUT task.|1|Calling an INPUT task in your flow script will start a child execution for an INPUT task. This child execution will block 1 Token for as long as it runs. It will run until it receives a response, or until it times out. Depending on the responsiveness of the user, and the timeout you define, this can taker more or less time.|Short term: only while the INPUT task is running.|
|execution_task_redis|Execution of a Redis task.|2|Calling a Redis task in your flow script will start a child execution for the Redis task. This child execution will block 2 Token for as long as it runs. If the parent execution starts the Redis task synchronously, the parent execution will change into the status "waiting for dependency" until the Redis task completes. While the parent execution is in the "waiting for dependency" status it will not block any Token.|Short term: only while the Redis task is running.|
|execution_task_rest|Execution of a REST task.|1|Same as the Redis task.|Short term: only while the REST task is running|
|execution_task_smtp|Execution of an smpt task.|2|Same as the Redis task.|Short term: only while the smtp task is running|
|execution_task_ssh|Execution of an ssh task.|2|Same as the Redis task.|Short term: only while the ssh task is running|
|execution_task_git|Execution of a git task.|3|Same as the Redis task.|Short term: only while the git task is running|
|execution_task_scp|Execution of an scp task.|2|Same as the Redis task.|Short term: only while the scp task is running|
|execution_task_k8s|Execution of a kubernetes (k8s) task.|3|Same as the Redis task.|Short term: only while the kubernetes task is running|
|files_gb|Used storage space for files. You can see and organise your files in the [Files](/files) view.|1|File storage is charged by the gigabyte, meaning that from the first file onwards, 1 Token will be blocked for file storage. Up to 1 gigabyte of files can be stored in your Cloudomationa account for 1 Token. As soon as the storage space used for your files increases to more than 1 gigabyte, a second Token will be blocked for storage, and so on.|Intermediate to long term: until you actively delete files. Cloudomation is not intended as a file storage solution. We therefore recommend not keeping files stored on the platform for longer term. The file storage functionality is intended to enable you to use files in your automations - however we recommend removing them when they are no longer immediately used by a flow script.|
|socket|An active web sockets. Web sockets are used to enable live views in the user interface, such as e.g. the Executions view, which is updated live via a web socket to display changes in your executions immediately as they occur.|0.1|Every live view in the user interface opens one active web socket, costing 0.1 token. You can recognise live views by the green circle icon next to them in the left hand menu pane. You can free up Token by closing live views. Please note that being logged in to the Cloudomation user interface in a browser window even when you don't use it means that you block Token by accessing the live views generated for your browser window.|Short to intermediate term: only as long as you have a live view open in your browser window.|

Please note that the Token prices block the mentioned amount of Tokens only **while the respective method is running**. For example, if you use a git task in your flow script, and afterwards you use a REST task, running this flow script will first block 3 Token while the git task is active, free up those 3 Token as soon as the git task is done, and then block 1 Token for the REST task while the REST task is active. It will not block 4 Token right away, or at the same time (unless you specify them to run in parallel). You will need only 3 free Token in total to run such a flow script.

## Quick tips to reduce your Token usage

* Delete old execution records
* Close live views (e.g. open views of past executions)
* Generate a Token usage report: this will trigger a Token check and ensure that you current Token usage calculation is correct. It also gives you an overview of where you are using many Token.
* If you have a high socket count but not many live views open: ask colleagues if they are logged into Cloudomation, possibly in some browser window they don't even actively use - this will still open active connections and block Token
* Pause running executions
* Remove flow scripts
* Delete files - this will only help if you delete all your files, or delete enough to get below 1 GB of storage space

## How many Token do I need for my use case?

A rough estimation of the **minimum amount of Token** you need for a use case can be done in two simple steps:  
(1) Think about the most expensive Cloudomation functionality you want to use  
(2) Check the Token usage in your account while you are not running any executions  
(3) Add one Token for good measure.  
And you're done.

In a small example, it could look like this:  
(1) I want to run a flow script (cost: 1 Token) which does two REST calls (cost: 1 Token each) and one git task (cost: 3 Token). The git task is the most expensive, so for this step I estimate: 3 Token.  
(2) I only have my own user and a few flow scripts, so currently my Token usage while not executing anything is under 1 Token, so for this step I estimate: 1 Token
(3) Add 1 Token    
Total: 5 Token. I can be quite sure that my use case will run through without issue if I have at least 5 Token in my account.  

I can also skip step 2 and only look at the free Token: most expensive feature + 1 Token: that's how many free Token I need before I start my flow script.

Let us look at the logic behind each of these estimation steps:  
(1) Starting any flow script will cost 1 Token. Any other (potentially more expensive) functionality I use in my flow script will start a child execution, which will block its own Token. A flow script only blocks Token while it is running - when it is waiting for a dependency (i.e. a task or child execution), it doesn't block any Token. It is therefore enough to look at the most expensive function to estimate the minimum required Token amount - it will be enough to execute one step after the next, serially.  
(2) It is important to remember that the first Token in your account will never be fully available. Every account comes with a user, which already blocks 0.01 Token. To run a flow script, you will usually have that flow script stored in your Cloudomation account - which again blocks 0.01 Token. So the Token usage in your account will never be 0. This means that you need at least 4 Token in your account to use any functionality that requires 3 Token to run - it will need 3 *available* Token to run.  
(3) Running an execution creates at least 1 execution record, which blocks 0.01 Token. If you use tasks or start child executions, these will create their own execution records. It is therefore necessary to keep in mind that you need at least a little bit more Token than what you would need purely for running a task or flow script. Adding one Token is a very rough approximation - depending on your flow script, it can be that you will need a lot less, or more. But for simple flow scripts it's a sufficient rule of thumb.  

So this is how you can estimate the minimum amount of Token you need. However this estimates only what you need to execute your flow script one step after the next, serially. If you want to parallelize executions - and we recommend that you do - you might need a lot more to reach optimal performance.

To estimate the **optimal amount of Token** you would need to run your flow script at top speed, you would have to think about a few more things:
* How many tasks of which type you run in parallel - your would need to add their cost, e.g. running 3 REST tasks in parallel blocks 3 Token  
* How many child executions you start in total in your flow script - each one will generate an execution record which blocks 0.01 Token, so if you start more than 100 child executions, add a Token to your estimate to allow for this
* Potentially how much data you load into Cloudomation - only relevant if you move around larger amounts of data (i.e. several Gigabytes)

In the future, we will provide a Token calculator feature on the platform which will help you estimate the optimal amount of Token for the execution of any given flow script. In the meantime, we hope that this is enough to help you get a rough idea. In practice, you will quickly start to develop a feeling for how many Token your flow scripts needs while you develop it - just keep an eye on your Token consumption while you run it, and you will quickly see where your optimal token quota lies.

## What happens if I run out of Token?

You don't need to worry about having too few Token either: Token are blocked only for as long as they are used. If there are not enough Token for your automation to run, it will pause and tell you that it is waiting for Token. While that is the case, it doesn't block Token and therefore doesn't interfere with other executions. As soon as enough Token become available, it will start running. This means that the worst thing that can happen is that your automations run a bit more slowly if they have to wait for Token.

## Buying and cancelling Token

We understand that estimating the amount of Token you need for your automations is not an easy task. Therefore, we want to support you as best we can in taking an iterative approach. This means that you can gather experience with your Token usage while you are developing and building out your automations - and we make it easy for you to change your Token subscription on demand.  

You can buy additional Token at any time. They will become available right after you buy them. So if you do realise that you need more: go ahead and buy more Token and start using them right away. If you buy Token during the month, you only pay for them for the remainder of the month, i.e. exactly for the time that you can use them.

Similarly, you can cancel your Token any time. They will stay valid until the end of the current month. Starting the following month, they will be gone and you will not have to pay for them anymore.  s

Note that you can not cancel Token that are part of your basic subscription package (3, 30 or 100, depending on your package). If you have the starter package, you will always have at least 3 Token.  
