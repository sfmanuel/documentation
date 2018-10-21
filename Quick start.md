# Quick start

The automation in cloudomation is done by running flow scripts which are
defined as python handler functions.

To quickly get started:

1. Switch to the [Flows](/flows) list.
2. Click on "New" to create a new flow script.
3. The flow object will be opened automatically and already contains a
handler function:
```python
def handler(c):
    # TODO: write your automation
    c.success(message='all done')
```
4. Replace the comment `# TODO: write your automation` with a statement to print a hello world log message:
```python
def handler(c):
    c.log('Hello World!')
    c.success(message='all done')
```
5. Click on "Run"
6. The execution object will be opened automatically. It shows the current state of the execution and will update with any change.
7. In the output field you'll see the log message:
```yaml
logging: Hello World!
```

There is much more to discover. Check out the [Tutorial](/documentation/Tutorial) to explore them!
