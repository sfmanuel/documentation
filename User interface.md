# User interface

The Cloudomation user interface exposes the same functionality as the [Cloudomation REST API](/explorer).  
This page contains documentation about
- the [top pane](#toppane) of the user interface
- general information about [content display and editing](#contentdisplayandediting)
- [flow scripts used in the user interface](#flowscriptsusedintheuserinterface)

## Top pane
The first table describes the elements of the top hand pane. The sections of the left hand menu are documented separately in the menu documentation.

|element|description|
|:-----:|:----------|
|<i class="fa fa-fw fa-bars"></i>|open or close left hand menu pane|
|<span class="fa-stack"><i class="fa fa-stack-2x fa-cloud" style="color: #5e8ebd"></i><i class="fa fa-stack-1x fa-star fa-inverse"></i></span>| go to home screen |
|<i class="fa fa-fw fa-tachometer"></i><span class="ml-1" data-bind="text: capacityPercent">10</span><span class="ml-1">%</span>| your current token usage - see also [token usage calculation](Token+usage+calculation)|
|<i class="fa fa-fw fa-envelope-o"></i><span class="ml-1 badge badge-pill badge-danger">3</span>|new error messages - clicking this button will direct you to your messages, where you can acknowledge new message. Note that you are only notified of new error messages here, any other type of message (information or success) does not lead to a notification in the top pane.|  
|<i class="fa fa-user"></i><span class="ml-1 d-none d-sm-inline-block">username</span>| your user name - if you click this button, you will be directed to your user settings|  
|<span class="ml-1 text-warning"><i class="fa fa-vcard-o"></i></span>| you are logged in as a client administrator |
|<span class="ml-1 text-danger"><i class="fa fa-vcard"></i></span>| you are logged in as a system administrator |
|<i class="fa fa-fw fa-question-circle"></i>| link to the service desk where you can ask questions, report issues, and make suggestions how we can improve Cloudomation|  
|<i class="fa fa-fw fa-sign-out"></i>| log out|

## Content display and editing

**Views**  
There are three types of views: list, record, and field views. In all views, any field with a ligh yellow background can be edited directly. Example: Flow names in the Flow section.  
The left hand menu pane by default shows all list views: Executions, Flows, Settings, Inputs, and Messages. Once you open a record, the record will also be displayed in the left hand pane until you close it. Which records (flow scripts, settings, executions) you have open is persisted, so if you refresh the page, or log out and log in again, the same records will still be open.  
**Hint**: The most recently opened record will always be displayed on top of the list of open records in the left hand pane. If you want to customise the order in which open flow scripts and other open records are displayed in the left hand menu pane, you can simply close and reopen a record to have it displayed on top of the list.   

*List views*  

Used for Executions, Flows, Settings, Inputs, Messages. Here, you have an overview of all existing resources in that category. All editable fields of a resource can be edited in the list view, for example the name of flow scripts in the Flows view, or the flow script content once unfolded. In list views, you can select several records or resources and perform bulk operations on them, such as deleting or executing a number of flow scripts.  
**Note**: actions are only executed on checked records on the current page, i.e. records that are visible. If a record is checked and then you switch to a different page (or it gets automatically scrolled onto another page because more messages or executions come in), the record will stay checked but no action will be performed on it. The list view follows a table layout.  

List views feature some fields with a "show" button. These are fields that can potentially contain larger content.
  - Content fields with a white background can be edited directly. Example: content in the Flow view.
  - Content fields with a grey background cannot be edited. Example: script in the executions view. This shows the  exact version of the script which was executed, which cannot be edited.

*Record views*  

Used for individual flow scripts, executions, and messages open in a record view. Here, the information about the record is displayed in rows (correspondent to the columns in the list view). In the records view, you can edit all editable fields as well. The record view offers the same functionality as the list view (edit content, execute, delete) - available for the specific record (and not all records, as in the field view).

*Field views*

Some fields can be opened individually, intended for fields with potentially large content such as flow scripts and settings. Field views can be opened via the link symbol next to the show/hide button in both the list and the record view. This will open an individual view containing only the field content, e.g. a flow script or a record. Functionally, this is equivalent to both the list and the record view: you can edit, execute and delete flow scripts, or edit and delete settings - but only for the content of the opened individual field.

*Customise views*  

The list and record views can be customised to show more or less fields. Fields are displayed as columns in the list view, as rows in the record view.
  - The list view (Executions, Flows, Settings, Inputs, Messages) features a button in the bottom right: "x of n columns". Clicking this button opens a field selection view. Here, you can select which fields (columns) should be displayed for this view.
  - The records view features a "show default fields" or "show all fields" toggle button at the bottom left of the display. Clicking this button switches between a display of all fields (rows) or only a selection of default fields.  

*Quick filter and search*

For each view, there is a quick filter or search bar available at the top of the view. The quick filter is not case sensitive. It searches through visible as well as hidden columns. Search starts with the first entered character. Both field values as well as field names are searched. The quick filter or search can be cleared with the "x" at the  right end of the search/quick filter bar. The "x" is only displayed when the search/quick filter bar is active (i.e. selected, and/or containing a search string).  
List view: the search filters records that contain the string. All records that containt the quick filter string, as well as checked records will be displayed.  
Record view: the quick filter filters all rows that contain the quick filter string.  
Field view: the quick filter highlights all matches in the displayed content.

##  Flow scripts used in the user interface
The following flow scripts are used to provide functionality in the user interface:
- [Create user](https://github.com/starflows/library/blob/master/Create%20User.py) (external link to flow script in public flow script library on github)  
The create user flow script is loaded dynamically from the public flow script library and executed without being saved on the Cloudomation platform. Refer to [using flow scripts from git](Using flow scripts from git) to learn how to use this functionality in your own flow scripts.
