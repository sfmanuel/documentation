# Quick start

The automation in Cloudomation is done by running flow scripts which are
defined as Python handler functions.

To quickly get started:

1. Switch to the [Flows](/flows) list.
2. Click on "New" to create a new flow script.
3. The flow object will be opened automatically and already contains a
handler function:
```python
def handler(system, this):
    # TODO: write your automation
    return this.success('all done')
```
4. Replace the comment `# TODO: write your automation` with a statement to print a hello world log message:
```python
def handler(system, this):
    this.log('Hello World!')
    return this.success('all done')
```
5. Click on "Save"
6. Click on "Run"
7. The execution object will be opened automatically. It shows the current state of the execution and will update with any change.
8. In the "Outputs" field you'll see the log message:
```yaml
logging:
  - '2018-12-29 21:20:01':
      - Hello World!
```

There is much more to discover. Check out the [Tutorial](/documentation/Tutorial) to explore further!
