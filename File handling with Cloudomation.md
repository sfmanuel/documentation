# File handling with Cloudomation

Cloudomation offers several options for working with files and file systems. This article describes the file handling functionality available to you on the Cloudomation platform, which allow you to work with files without needing a separate environment (e.g. a remote server) on which your file operations happen.

#### c.file  
The file function allows you to read and write files.

**Inputs:**
* `file_path` - string  
  The relative path to the file location. If it doesn't exist, it will be created.
* `file_content` - string, default: None  
  The content of the file. If no content is given, the file will be read. If content is given, the file will be written. **Note:** file contents will be overwritten without warning if a file of the same name already exists in the target directory.

**Returns:**
* The file content when reading a file, otherwise None

**Example:**
```python
def handler(c):
    write_file = c.file(
        file_path = 'myfiles/myfile.txt',
        file_content = 'This is a file.'
    )
    read_file = c.file(
        file_path = 'myfiles/myfile.txt'
    )
    c.logln(read_file)
    c.success(message='all done')
```  

#### c.list_dir
List all files in a directory.

 flows = c.list_dir('flows', glob='**/*.py')

 **Inputs:**
 * `dir_path` - string  
   The relative path to the directory for which contents will be listed.
 * `glob` - string, default: None  
  A global pattern. If specified only matching entries are returned.

 **Returns:**
 * A list of all matching entries in the directory - and subdirectory if a ** glob is used.

 **Example:**
 ```python
def handler(c):
    # list the contents of the myfiles directory
    myfiles = c.list_dir('myfiles')
    c.set_output('myfiles', myfiles)
    # use a global pattern to recursively list all files in all folders
    files = c.list_dir('.', glob='**/*')
    c.set_output('files', files)
    # use a global pattern to recursively list all python files in all folders
    python_files = c.list_dir('.', glob='**/*.py')
    c.set_output('python_files', python_files)
    c.success(message='all done')
 ```  

Take a look at the [GIT file sync flow script](https://github.com/starflows/library/blob/master/sync%20flow%20scripts.py) in the public flow script library for an example of how to use the list_dir function to perform operations on several files.
