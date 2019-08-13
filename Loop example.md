# Example with parent and child flow scripts and a parallel for-loop
This example consists of two flow scripts. You can also find them in the [public flow script library](https://github.com/starflows/library){ext}:
- [Parent flow](https://github.com/starflows/library/blob/master/loop_parent.py){ext}
- [Child flow](https://github.com/starflows/library/blob/master/loop_child.py){ext}

If you are not looking for code, but for example use cases, please take a look at these [example use cases](/site/Example+use+cases).

## Parent flow

```python
# This flow script exemplifies the usage of a for-loop to execute several REST
# API calls. The calls loop through a list of input variables that are defined
# in a setting. The calls are defined in a separate flow script that is called
# from this parent flow script. This enables faster parallel processing of the
# REST calls, and showcases the interaction between flow scripts.

# In this example, we use the goenames REST API, which you might know from
# other examples already. We will loop through a list of countries that are
# provided in a setting. The geonames API doesn't allow bulk requests, so calls
# can only ever request information about one single country.
# Other useful applications of such loops could be to copy data from and to
# different systems, install components on different servers, run a set of test
# cases etc.

# A note on the limitations of for loops: they only comfortably allow to loop
# through a list of one single parameter. The Cloudomation clone execution
# function enables the handling of more advanced situations in which several
# parameters have to be changed, and/or different parameters are kept and
# changed for different runs of an execution. The clone function allows for
# "templating" of executions that can then be called again with different
# parameters. Look for the clone example for details.
# Another limitation of loops is that you have to be careful with exception
# handling. If you loop through a list and you have a typo in one value, it
# will crash and not process the rest of the list, unless you handle this
# properly (as showcased in this example).

# (1) Define handler function which receives the Cloudomation System
# object (system) and an Execution object of this execution (this)
def handler(system, this):

# (2) Create a setting with country names
    # In a real-life application of this functionality, this setting would
    # probably be created by another flow script, or be defined manually once.
    # First, we check if the setting already exists. If it doesn't, we create
    # it. Feel free to change the selection of countries.
    # Note that we create a setting that contains a list. Settings can contain
    # any object that can be serialised into a yaml - lists, json etc.

    geonames_countrynames = system.setting('geonames_countrynames')
    if not geonames_countrynames.exists():
        geonames_countrynames.save(value=["Austria", "Latvia", "Azerbaijan"])

    countrynames = geonames_countrynames.get('value')

# (3) Loop through the countries
    # In order to get the information we want, we need to do several API calls.
    # To speed this up, we parallelise the API calls by executing them in a
    # separate flow script, which we start as child executions.

    # We create an empty list to which we will append our child execution
    # objects in the for loop.
    calls = []

    # We create a separate empty list to which we will append inputs that are
    # not valid countries.
    invalids = []

    for countryname in countrynames:
        # We call the flow script that contains the REST calls with the c.flow
        # function. We store the execution object returned by the c.flow
        # function in the call variable.
        call = this.flow(
            'loop_child',
            # I can add any number of parameters here. As long as they are not
            # called the same as the defined parameters for the flow function,
            # the are appended to the input dictionary that is passed to the
            # child execution.
            # In this example, the child execution will be passed a key-value
            # pair with countryname as the key, and the first value in the
            # countryname setting as the value.
            # If I added another argument weather = nice, a second key-value
            # pair would be added to the input dictionary for the child
            # execution, with the key weather and the value nice.
            # Note that I can also pass the same input as a dictionary with the
            # inputs parameter. The below line is equivalent to
            # input_value = { 'countryname': countryname }
            countryname = countryname,
            run=False,
        # run_async() starts the child execution and then immediately returns.
        # This means that the for loop continues and the next child execution
        # is started right away - the REST calls will be executed in parallel.
        ).run_async()
        # All execution objects are appended to the calls list.
        calls.append(call)

# (4) Wait for all child executions to finish

    # Here, I tell the flow script to wait for all elements in the calls list
    # to finish before it continues. Remember that the calls list contains all
    # execution objects that we started in the for loop.
    this.wait_for(*calls)

# (5) Get outputs of child executions, and set outputs of parent execution

    # Now, we take all the execution objects and get their outputs. Depending
    # on whether or not there was an error, we treat the results differently.
    for call in calls:
        # Get all outputs from all child executions
        result = call.load('output_value')
        # If there was an error, append the output of the erroneous execution
        # to our list of invalid country names.
        if 'error' in result:
            invalids.append(result['error'])
        # If there was no error, we directly set the output of the flow script
        # to the output of the child executions.
        else:
            this.log(result)

    # The errors need a bit more processing: here, we set an output that
    # contains the key "warning", information about the number of failed calls,
    # and the country names for which there was an error.
    if len(invalids) > 0:
        this.log(
            f'warning: no information was found for {len(invalids)} countries'
        )
        this.log(invalid_countries=invalids)

# (6) Once we're done we end the execution.
    this.success(message='all done')
```

## Child flow

```python
# This flow script is called by the loop_parent.py flow script. It executes a
# number of REST calls to the geonames API. You cannot execute this flow script
# as it is on its own, as it requires inputs that are passed on from the parent
# flow.
# In this example, we are interested in the coordinates of each country's
# capital city.
# Due to the structure of the API calls available in the geonames API, we
# have several steps to complete: starting with the country name (which is
# our input), we need to get the country code, then the capital's name, and
# then the capital's coordinates.
# Here, we can begin to see why looping is useful: even for fairly simple
# REST calls, it is often necessary to chain together several calls to get
# the information you need, so writing a loop can save a lot of lines in your
# script - and parallelising the calls can save you a lot of time.
# Note that after the first API call, we add a check if there was a valid
# result and set the result to a warning if there isn't. This is to make
# sure that the loop runs through all input values even if there are invalid
# values in the input list.
# Exception handling depends on the API: the geonames API simply returns an
# empty object for invalid search queries like the ones we are executing,
# with a success status code. For other errors in the call (e.g. missing
# parameters) it would return a status code that you could use to catch
# exceptions. In our case, we assume that we need to ensure that errors in
# the input list don't trip up the loop, but assume that other parameters
# are correct, such as the username and the call syntax. Assuming that this
# runs automatically, the input list is the only thing that will change from
# run to run so it is the most likely source of errors.

# (1) Define handler function which receives the Cloudomation System
# object (system) and an Execution object of this execution (this)
def handler(system, this):

# (2) Set username for geonames API
    geonames_username = system.setting('geonames_username')
    if not geonames_username.exists():
        geonames_username.save(value='demo')

    username = geonames_username.get('value')

# (3) get inputs from parent execution

    # The parent execution passed inputs to this execution, therefore we
    # don't need to specify an execution ID from which to get the inputs.
    # c.get_inputs() will capture the inputs given by the parent execution.
    countryname = this.get('input_value')['countryname']

# (4) call the geonames API

    countrycode_response = this.task(
        'REST',
        url=(f'http://api.geonames.org/search?'
             f'name={countryname}&'
             f'featureCode=PCLI'
             f'&type=JSON'
             f'&username={username}')
    ).run(
    ).get('output_value')['json']['geonames']

    # Check if the result contains something
    if not countrycode_response:
        # If it doesn't, we set the output to error and send back the
        # invalid country name
        this.save(output_value={'error': countryname})

    else:
        # If there is a valid response, we continue with the API calls
        countrycode = countrycode_response[0]['countryCode']
        capitalname = this.task(
            'REST',
            url=(f'http://api.geonames.org/countryInfo?'
                 f'country={countrycode}'
                 f'&type=JSON'
                 f'&username={username}')
        ).run(
        ).get('output_value')['json']['geonames'][0]['capital']

        capitalcoordinates_response = this.task(
            'REST',
            url=(f'http://api.geonames.org/search?'
                 f'name={capitalname}&'
                 f'featureCode=PPLC'
                 f'&type=JSON'
                 f'&username={username}')
        ).run(
        ).get('output_value')['json']['geonames'][0]

        # The coordinates are two values. To access them by key in the json
        # which is returned by the geonames API, we need to loop through
        # the result.
        capitalcoordinates = {
            k: float(v)
            for k, v
            in capitalcoordinates_response.items()
            if k
            in ('lat', 'lng')
        }

# (5) Set outputs
        this.save(output_value={capitalname: capitalcoordinates})

# (6) Once we're done we end the execution.
    this.success(message='all done')
```
