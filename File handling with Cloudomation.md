# File handling with Cloudomation

Cloudomation offers several options for working with files and file systems. This article describes the file handling functionality available to you on the Cloudomation platform, which allow you to work with files without needing a separate environment (e.g. a remote server) on which your file operations happen.

#### system.file  
The file function allows you to create file objects.

**Inputs:**
* `file_path` - string  
  The relative path to the file location. If it doesn't exist, it will be created.
* `file_content` - string, default: None  
  The content of the file. If no content is given, the file will be read. If content is given, the file will be written. **Note:** file contents will be overwritten without warning if a file of the same name already exists in the target directory.

**Returns:**
* The file content when reading a file, otherwise None

**Example:**
```python
def handler(system, this):
    write_file = system.file(
        path='myfiles/myfile.txt',
        content='This is a file.'
    )
    read_file = system.file(
        path='myfiles/myfile.txt'
    )
    this.log(read_file.get('content'))
    this.success(message='all done')
```  

#### system.files
List all files in a directory.

 files = system.files(dir='flows', glob='\*\*/\*.py')

**Inputs:**
* \*\*filters - dictionary
    Filters to limit the search results. Possible filters are:
    * `dir` - string, default: '.'
        The relative path to the directory for which contents will be listed.
    * `glob` - string, default: '\*'
        A glob pattern. If specified only matching entries are returned.

**Returns:**
* A list of all matching entries in the directory - and subdirectory if a ** glob is used.

**Example:**
```python
def handler(system, this):
    # list the contents of the myfiles directory
    myfiles = system.files(dir='myfiles')
    this.log(myfiles=myfiles)
    # use a pattern to recursively list all files in all folders
    files = system.files(glob='**/*')
    this.log(files=files)
    # use a pattern to recursively list all python files in all folders
    python_files = system.files(dir='.', glob='**/*.py')
    this.log(python_files=python_files)
    this.success(message='all done')
```

Take a look at the [GIT file sync flow script](https://github.com/starflows/library/blob/master/sync%20flow%20scripts.py) in the public flow script library for an example of how to use the list_dir function to perform operations on several files.
