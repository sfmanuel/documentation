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
|record_flow|Your flow scripts, i.e. all flow scripts that you have stored in the [Flows](/flows) section of your account.|0.01|Every flow script in the [Flows](/flows) list costs 0.01 Token for as long as it exists. You can delete flow scripts to free up Token.|Forever / until you actively delete them. Flow scripts do not have an expiration date. This means that they stay in your account (and block Token) from the time you create them until the time you actively delete them.|
|record_setting|your settings, i.e. everything you see in the [Settings](/settings) view.|0.01|Every entry in the [Settings](/settings) view costs 0.01 Token.|Forever / until you actively delete them. Settings do not have an expiration date. This means that they stay in your account (and block Token) from the time you create them until the time you actively delete them.|
|execution_flow|Execution of the flow method in a running flow script. The flow function allows you to define and start child flow scripts from within a flow script.|1|When you use the flow method in a flow script, and then run this flow script, 1 Token will be blocked when the flow method is called for as long as it takes the method call to complete.|Short lived / only during runnin execution. This will typically block 1 Token for no more than a few milliseconds. Depending on the parameters with which you use the flow method, it can also be longer - e.g. when you wait for the child flow script to finish before returning to the parent flow script, the flow method in the parent flow script can be active for longer, blocking 1 Token until it finishes.|
|execution_script||1|||
|execution_task_aws||2|||
|execution_task_input||1|||
|execution_task_redis||2|||
|execution_task_rest||1|||
|execution_task_smtp||2|||
|execution_task_ssh||2|||
|execution_task_git||3|||
|execution_task_scp||2|||
|execution_task_k8s||3|||
|files_gb||1|||
|socket||0.1|||

## Quick tips to reduce your Token usage

## Buying and cancelling Token

## How many Token do I need for my use case?

## What happens if I run out of Token?

You don't need to worry about having too few Token either: Token are blocked only for as long as they are used. If there are not enough Token for your automation to run, it will pause and tell you that it is waiting for Token.
