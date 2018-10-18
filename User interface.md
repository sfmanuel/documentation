# User interface

## User interface elements
This section will describe the elements of the user interface, starting at the top left and moving to the right and down.

|element|description|
|:---:|:---|
|<i class="fa fa-fw fa-bars"></i>|open or close left hand menu pane|
|<span class="fa-stack"><i class="fa fa-stack-2x fa-cloud" style="color: #5e8ebd"></i><i class="fa fa-stack-1x fa-star fa-inverse"></i></span>| go to home screen |
|<a class="nav-link btn btn-xs btn-transparent ml-3"><i class="fa fa-fw fa-tachometer"></i><span class="ml-1" data-bind="text: capacityPercent">10</span><span class="ml-1">%</span></a>| your current token usage - see also [token usage calculation](Token+usage+calculation)|  
|<a class="nav-link btn btn-xs btn-transparent ml-3"><i class="fa fa-user"></i><span class="ml-1 d-none d-sm-inline-block">username</span></a>| your user name - if you click this button, you will be directed to your user settings|  
|<i class="fa fa-vcard-o"></i>| you are logged in as a user |
|<i class="fa fa-vcard"></i>| you are logged in as a client administrator |
|<i class="fa fa-fw fa-question-circle"></i>| link to the service desk where you can ask questions, report issues, and make suggestions how we can improve Cloudomation|  
|<i class="fa fa-fw fa-sign-out"></i>| log out|  

## Content display and editing
- Any field with a ligh yellow background can be edited through the user interface. Example: Flow names in the Flow section.
- There are three types of views:
  - List views: Executions, Flows, Settings, Inputs, Messages. Here, you have an overview of all existing resources in that category. All editable fields of a resource can be edited in the list view, for example the name of flow scripts in the Flows view, or the flow script content once unfolded. In list views, you can select several records or resources and perform bulk operations on them, such as deleting or executing a number of flow scripts. The list view follows a table layout.
  - Record views: individual flow scripts, executions, and messages open in a record view. Here, the information about the record is displayed in rows (correspondent to the columns in the list view). In the records view, you can edit all editable fields as well. The record view offers the same functionality as the list view (edit content, execute, delete) - available for the specific record (and not all records, as in the field view).
  - Field view: some fields can be opened individually, intended for fields with potentially large content such as flow scripts and settings. Field views can be opened via the link symbol next to the show/hide button in both the list and the record view. This will open an individual view containing only the field content, e.g. a flow script or a record. Functionally, this is equivalent to both the list and the record view: you can edit, execute and delete flow scripts, or edit and delete settings - but only for the content of the opened individual field.
- List views feature some fields with a "show" button. These are fields that can potentially contain larger content.
   - Content fields with a white background can be edited directly. Example: content in the Flow view.
   - Content fields with a grey background cannot be edited. Example: script in the executions view. This shows the  exact version of the script which was executed, which cannot be edited.
- The list and record views can be customised to show more or less fields. Fields are displayed as columns in the list view, as rows in the record view.
  - The list view (Executions, Flows, Settings, Inputs, Messages) features a button in the bottom right: "x of n columns". Clicking this button opens a field selection view. Here, you can select which fields (columns) should be displayed for this view.
  - The records view features a "show default fields" or "show all fields" toggle button at the bottom left of the display. Clicking this button switches between a display of all fields (rows) or only a selection of default fields.


##  Coming soon:
  - user interface elements: current token usage, open user record, support, log out, home button, toggle menu, menu
  - how to connect and disconnect the user interface
  - list of flow scripts which are used in the user interface
