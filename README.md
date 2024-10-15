# Getting Started with OWAF

This guide will walk you through the steps to set up a web application using the Officelime Web Application Framework (OWAF) development environment.

## Requirements

To successfully run OWAF, you will need the following:

- **[Lucee Server 5](https://cdn.lucee.org/lucee-express-5.4.6.9.zip)** (version 6 is not supported)
- **[MySQL 8+](https://dev.mysql.com/downloads/installer/)**
- **[OWAF code base](https://github.com/officelimex/owaf3)**

## Setup

1. **Download the Source Code**

   Download the OWAF source code from the [Officelime OWAF3 GitHub repository](https://github.com/officelimex/owaf3) to your Lucee server's ROOT directory.

2. **Copy the Example Project**

   Copy the `project1` folder inside the `_example` folder to the Lucee server's ROOT directory. Your directory structure should look like the following:
  
    ROOT/
      - project1/
      - owaf3/
      - WEB-INF/
      - favicon.ico
      - assets/
      - Application.cfc
      - index.cfm

3. **Rename the Project Folder (Optional)**

You can rename the `project1` folder to match your project's name. For this demonstration, we'll continue using `project1`.

## Project Folder Structure

Within your project folder, you will find the following important directories:

- **assets/**  
This folder contains your app's assets (JavaScript, CSS, images, fonts, etc.).

- **controllers/**  
OWAF uses the MVC (Model-View-Controller) approach, and this folder houses all your controller `.cfc` files.

- **owaf/**  
This is a crucial folder for OWAF's functionality. It contains core components, tags, and helper functions that link to the main OWAF framework outside of your project directory.

- **models/**  
This folder holds the `.cfc` files for the models used in your project.

- **views/**  
This folder contains the views, designs, and UI elements of your app.

## Using OWAF in your project

## Model

The model class is an abstract of your data.

### Usage

To create a new model, you do the following:

- Create a cfc file inside your `models/` directory in your project
- extend `project1.owaf.com.Model`
- create an init function to accept the name of the table to store the model data

  ``` js
  // Article model
  component extend='project1.owaf.com.Model'  {
    public Article function init(string table_name = 'article')  {
      this = super.init(arguments.table_name);
      return this;
    }
  }
  ```


### Consuming the Model

#### `model(model_desc)` -> `Model Object`

Create a modal object

##### Parameters

| Name        | Type   | Description                                                                     |
|-------------|--------|---------------------------------------------------------------------------------|
| model_desc* | String | The model description in the following format -> `model table_name table_alias` |



##### Example

``` js
  // create invoice
  var invoice = model('Invoice');
```

#### `enableVersioning()`

The call of this method will automatically enable the version tracking on the model (db table), but the requirement to make this work is that there need to be an history table in the database that matched the main table. if your table name is `payroll` you need to create another table that has the exact table attributes of `payroll` and call it `payroll_history`, we add the surffix `_history` so the model can know where to store the history change on the model.

##### Example

  ``` js
  // Article model
  component extend='project1.owaf.com.Model'  {
    public Article function init(string table_name = 'article')  {
      this = super.init(arguments.table_name);
      enableVersioning(); // 👈 this will enable versioning
      return this;

    }
  }
  ```

#### `hasMany(table_name)`

Sets up a hasMany association between this model and the specified one.

##### Parameters

| Name       | Required | Type   | Description                   |
|------------|----------|--------|-------------------------------|
| table_name | Yes      | String | The table name in plural form |

##### Exmple

```javascript
// Article model
component extend='project1.owaf.com.Model'  {
  public Article function init(string table_name = 'article')  {
    this = super.init(arguments.table_name);
    // association
    hasMany('comments');
    return this;
  }
}
```

#### `mayHaveOne(model_desc, foreign_key, deep_rel)`

Sets up a mayHaveOne association between this model and the specified one.

##### Parameters

| Name        | Type    | Description                                                                                                     |
|-------------|---------|-----------------------------------------------------------------------------------------------------------------|
| model_desc* | String  | The model description in the following format -> model `table_name` `table_alias`                               |
| foreign_key | String  | the foreign key on the associate table. **Default**: default it is the primary key in the `model_desc` argument |
| deep_rel    | Boolean | Deep assocation with other model if setup **Default**: `false`                                                  |

##### Exmple

```javascript
// Book model
component extend='project1.owaf.com.Model'  {
  public Book function init(string table_name = 'book')  {
    this = super.init(arguments.table_name);
    // association
    mayHaveOne('Publisher');
    return this;
  }
}
```

### Methods


#### `delete()`

Delete the model object from the database

##### Example

```javascript
  // create the model
  var article = model('Article')
  article = article.find(20)
  article.delete()
```

#### `deleteAll(where)`

Delete all records in the model using the where clause

| Name    | Type   | Description                                            |
|---------|--------|--------------------------------------------------------|
| where * | String | write you normal sql where clause. e.g `Gender="Male"` |

##### Example

```javascript
  var article = model('Article');
  article.deleteAll(where : 'Author = 8');
```

#### `deleteAllInKey(keys)`

Delete all records in the model using the where clause

| Name   | Type | Description                         |
|--------|------|-------------------------------------|
| keys * | List | Keys for the model separated by `,` |

##### Example

```javascript
  var article = model('Article');
  article.deleteAllInKey('20,21,22');
```

#### `find(value, key)` -> `Model Object`

Find a record in the model data set

| Name    | Type   | Description                                                             |
|---------|--------|-------------------------------------------------------------------------|
| value * | String | The value to find using the model primary                               |
| key     | String | The key you will like to use as criteria to search the model record set |

##### Example

```javascript
  var article = model('Article');
  article = article.find(20);
```

#### `findAll(where, select, order, group, limit)` -> `Query`

Find all record in the model data set

| Name   | Type   | Description                                                        |
|--------|--------|--------------------------------------------------------------------|
| where  | Any    | write you normal sql where clause. e.g `Gender="Male"`             |
| select | Any    | Specify custom field to select. you can use this to combine fields |
| order  | String | SQL order clause without using the `order` word                    |
| group  | String | SQL group clause without using the `group` word                    |
| limit  | String | Number of records to return (use `mysql` limit format e.g `0,10`)  |

##### Example

```javascript
  // create the model
  var article = model('Article');
  // find records in article where AuthorId = 8, order by Title and limit the records to 20
  article = article.findAll(
    where : 'AuthorId = 8',
    order : 'Title',
    limit : '0,20'
  );
```

#### `findByKeyIn(keys, where, select, order, group)` -> `Query`

Find all record in the model data set

| Name   | Type   | Description                                                        |
|--------|--------|--------------------------------------------------------------------|
| keys * | List   | Keys for the model separated by `,`                                |
| where  | Any    | write you normal sql where clause. e.g `Gender="Male"`             |
| select | String | Specify custom field to select. you can use this to combine fields |
| order  | String | SQL order clause without using the `order` word                    |
| group  | String | SQL group clause without using the `group` word                    |

#### `findQ(key)` -> `Query`

Find all record in the model data set

| Name  | Type   | Description                                                             |
|-------|--------|-------------------------------------------------------------------------|
| key * | String | The key you will like to use as criteria to search the model record set |

#### `getCurrentVersion()` -> `Numeric`

Get the current version number of the model if versioning is enabled. see [enableVersioning()](#enableVersioning)

#### `getKeyValue()` -> `String`

Get the primary key value of a model table

#### `getVersions()` -> `Query`

Get the current version of the model if versioning is enabled. see [enableVersioning()](#enableVersioning)

#### `isEmpty()` -> `Boolean`

Check if a modal object exist

#### `join(model_desc, foreign_key, deep_rel)`

join a model together using `INNER JOIN`

##### Parameters

| Name        | Type    | Description                                                                                                   |
|-------------|---------|---------------------------------------------------------------------------------------------------------------|
| model_desc* | String  | The model description in the following format -> model `table_name` `table_alias`                             |
| foreign_key | String  | the foreign key on the associate table. Default: default it is the `primary key` in the `model_desc` argument |
| deep_rel    | Boolean | Deep assocation with other model if setup **Default**: `false`                                                |

##### Example

```javascript
// create Book model
var book = model('Book');
// join a publisher model to the book
book = book.join('Publisher');

/*
 you can join more modals together.
 book = book.join('Publisher').join('AuthorId');
*/
```

#### `ljoin(model_desc, foreign_key, deep_rel)`

join a model together using `LEFT JOIN`

##### Parameters

| Name        | Type    | Description                                                                                                   |
|-------------|---------|---------------------------------------------------------------------------------------------------------------|
| model_desc* | String  | The model description in the following format -> model `table_name` `table_alias`                             |
| foreign_key | String  | the foreign key on the associate table. Default: default it is the `primary key` in the `model_desc` argument |
| deep_rel    | Boolean | Deep assocation with other model if setup **Default**: `false`                                                |

##### Example

```javascript
// create Book model
var book = model('Book');
// join a publisher model to the book
book = book.ljoin('Publisher');

/*
 you can join more modals together.
 book = book.ljoin('Publisher').join('AuthorId');
*/
```


#### `max(field, where)` -> `Numeric`

join a model together using `LEFT JOIN`

##### Parameters

| Name   | Type   | Description                                            |
|--------|--------|--------------------------------------------------------|
| field* | String | The field to check the maxinum value for               |
| where  | String | write you normal sql where clause. e.g `Gender="Male"` |

##### Example

```javascript
// create invoice
var invoice = model('Invoice');
// get the max total price of an invoice
var max_invoice_value = invoice.max(
  field: 'TotalPrice'
  where : 'Date > 2015/10/01'
);
```


#### `count(field_to_count, fields, where, group, order)` -> `Query`

Count the occurance a field in a model/table

##### Parameters

| Name           | Type   | Description                                              |
|----------------|--------|----------------------------------------------------------|
| field_to_count | String | The field to count. **Default**: primary key name        |
| fields         | String | write you normal `sql` where clause. e.g `Gender="Male"` |
| group          | String | `SQL` group clause without using the `group` word        |
| order          | String | `SQL` order clause without using the `order` word        |

##### Example

```javascript
// create employee
var employee = model('Employee');
// count the gender of employee where locationid = 6
var query_employee = employee.count(
  field_to_count : 'Gender',
  where : 'LocationId = 6'
);

// the counted value can be access in "query_employee.result"
```


#### `min(field, where)` -> `Numeric`

join a model together using `LEFT JOIN`

##### Parameters

| Name   | Type   | Description                                            |
|--------|--------|--------------------------------------------------------|
| field* | String | The field to check the maxinum value for               |
| where  | String | write you normal sql where clause. e.g `Gender="Male"` |

##### Example

```javascript
// create invoice
var invoice = model('Invoice');
// get the max total price of an invoice
var min_invoice_value = invoice.min(
  field: 'TotalPrice'
  where : 'Date > 2015/10/01'
);
```


#### `sum()` -> `Numeric` 

Sum records in a table

##### Parameters

| Name   | Type   | Description                                          |
|--------|--------|------------------------------------------------------|
| field* | String | The field to sum                                     |
| where  | String | write you normal sql where clause. e.g Gender="Male" |

##### Example

```javascript
  // create invoice
  var invoice = model('Invoice');
  // sum all invoice
  var total_price = invoice.sum(
    field: 'TotalPrice'
    where : 'Date > 2015/10/01'
  );
```


#### `new(formData)` -> `Model Object`

Create new data in to the modal object. but does not saves into the database

##### Parameters

| Name      | Type   | Description                                                                                                                                               |
|-----------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| formData* | Struct | This should contain field and value of the data structure you want to create. it should also be identical to the name used in your database for the model |

##### Example

```javascript
  // create invoice
  var book = model('Book');
  // this does not save into the database
  book = book.new(
    Title: 'Hello World'
    Description : '...'
  );
```

#### `save(versionData)` -> `Model Object`

Save data to the database.

##### Parameters

| Name        | Type   | Description                                                                                                                                   |
|-------------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| versionData | Struct | This is used if versioning are enabled on the model. Use this argument to pass field that is in the model history table and not in the model. |

##### Example

```javascript
  // create invoice
  var book = model('Book');
  book = book.find(2);
  book.Title = "Hello World";
  book.Description = "...";
  // save the new data
  book = book.save();
```


#### `saveDirect(data)` 

Save data to the database directly. If versioning is enabled on this model, using this function will not cause a new version to be created.

##### Parameters

| Name  | Type   | Description                                                                |
|-------|--------|----------------------------------------------------------------------------|
| data* | Struct | A struct data containing the field and value of the data you want to save. |

##### Example

```javascript
  // create invoice
  var book = model('Book');
  book = book.find(2);
  book.saveDirect(
    Title: 'Hello World'
    Description : '...'
  );
```


#### `saveWithOutHistory()` -> `Model Object` 

Save data to the database, without creating an history record

##### Parameters

| Name  | Type   | Description                                                                |
|-------|--------|----------------------------------------------------------------------------|
| data* | Struct | A struct data containing the field and value of the data you want to save. |

##### Example

```javascript
  // create invoice
  var book = model('Book');
  book = book.find(2);
  book.Title = "Hello World";
  book.Description = "...";
  // save the new data
  book = book.saveWithOutHistory();
```

#### `trash()`  

Send a Model Object record to the trash. For the `trash()` function to work, you will need to create another table for the model with the word `deleted_` at the begining of the table. e.g. if your model table name is book, then table to hold the deleted record will be called `deleted_book`

##### Example

```javascript
  // create the model
  var article = model('Article');
  article = article.find(20);
  article.trash();
```

## Controller

### `countEditTableItemInForm(fieldnames)` -> `Numeric`

Count and Return the maximum number of items in an `EditTable` tag within a form 

#### Parameters

| Name        | Type   | Description                        |
|-------------|--------|------------------------------------|
| fieldnames* | String | This should be the form.fieldnames |


### `maxEditTableItems(field_names, field_name)` -> `Numeric`

Count and Return the maximum number of items in an `EditTable` tag within a form 

#### Parameters

| Name        | Type   | Description                        |
|-------------|--------|------------------------------------|
| fieldnames* | String | This should be the form.fieldnames |
| field_name  | String | One of the field in the editable   |


### `maxValueOfSubItemInForm(fieldnames)` -> `Numeric`

Count and Return the maximum number of items in an `EditTable` tag within a form 

#### Parameters

| Name        | Type   | Description                        |
|-------------|--------|------------------------------------|
| fieldnames* | String | This should be the form.fieldnames |

### `model(model_desc)` -> `Model Object`

Create a modal object

#### Parameters

| Name        | Type   | Description                                                                     |
|-------------|--------|---------------------------------------------------------------------------------|
| model_desc* | String | The model description in the following format -> `model table_name table_alias` |

#### Example
```javascript
  var invoice = model('Invoice invoice inv');
  // or 
  var book = model('Book');

```

### `saveModelItem(model_desc, form_field, fixed_field, form, versionData)` -> `Model Object`

Save Model Item data into the database

#### Parameters

| Name        | Type   | Description                                                                                                                                   |
|-------------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| model_desc* | String | The model description in the following format -> `model table_name table_alias`                                                               |
| form_field* | String | List of the names of the filed you wish to save into the database                                                                             |
| fixed_field | String | List of the names of the filed you wish to save into the database that is not in the `EditTable` tag                                          |
| form*       | Struct | The form struct : you can just use `form`                                                                                                     |
| versionData | Struct | This is used if versioning are enabled on the model. Use this argument to pass field that is in the model history table and not in the model. |


### `sendMail(subject, to, body, bcc, cc, attachments)`

Send an e-mail

#### Parameters

| Name        | Type   | Description         |
|-------------|--------|---------------------|
| subject*    | String | Subject of the mail |
| to*         | List   | Receipiant email    |
| body*       | String | Content of the mail |
| bcc         | List   | Blind Cabon Copy    |
| cc          | List   | Cabon Copy          |
| attachments | Array  | Attachement         |

## Tag (Used in view)

### BlockItem
wrap string in a block view, lable and value display

#### Attributes

| Name        | Type    | Description                                                                                        |
|-------------|---------|----------------------------------------------------------------------------------------------------|
| label*      | String  | label to display                                                                                   |
| format      | String  | The format in which to display the value. accepted format are `address`, `email`, `date`, `money`  |
| icon        | String  | fontawsome icon name to display before the label                                                   |
| iconclass   | String  | The css class to wrap the icon attribute with                                                      |
| itemclass   | String  | the css class to for the value element. this is not applicable when `format` is defined            |
| lableclass  | String  | The css class for the label                                                                        |
| prefix      | String  | This will be display in-fornt of the `value` attribure                                             |
| removeblank | Boolean | This attribute removes the view entirely if the value in the attribute is empty. Default : `false` |
| suffix      | String  | Add to the end of the `value` attrubite                                                            |
| textClass   | String  | class name that will be associated with the value. this is only used in when the format is `email` |
| value       | String  | value to display                                                                                   |

#### Example
```html
  <cf_blockitem 
    label="Label to display" 
    value="Value to display"/>

```

### Buttons
A wapper for button tag `cf_button`

#### Attributes

| Name         | Type   | Description                                                                                                                                  |
|--------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------|
| align        | String | Where to align the content of the buttons too : left, right or center Default: `right`                                                       |
| buttonPrefix | String | The prefix to use for all the button class inside cf_button. Default: `btn-`                                                                 |
| class        | String | html class                                                                                                                                   |
| iconPrefix   | String | The prefix to use for all the icons inside `cf_button` Default: `fa fa-`                                                                     |
| size         | String | The default size of all the buttons within this tag : `btn-group-sm`, `btn-group-xs`, `btn-group-md`, `btn-group-lg` Default: `btn-group-sm` |

#### Example
```html
  <cf_buttons>

    <!--- your butttons goes in here ---> 

  </cf_buttons>
```

### Button
Create a button

#### Attributes

| Name        | Type   | Description                                                                                                                                         |
|-------------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| url*        | String | Where to link to                                                                                                                                    |
| action      | String | Process an ajax request. Usage: `Component.cfc?method=method1&arg=param_value`                                                                      |
| confirm     | String | A confirmation message that display after a the button is clicked. Click Ok to execute, and cancel to stop the action. Default: `Are you sure`      |
| icon        | String | The icon to display on the button                                                                                                                   |
| modalTitle  | String | The title of the dialog box/window. Default: use the title attribute                                                                                |
| modalurl    | String | URL of the modal window                                                                                                                             |
| redirect    | String | Once an action is performed, use the redirect attribute to specify the URL where you want to goto next. Works only when action attribute is specify |
| renderTo    | String | where to render the redirect url page too                                                                                                           |
| responseMsg | String | Response message after an action has been executed                                                                                                  |
| style       | String | The design of the button : `link`, `primary`, `success`, `danger`, `warning` Default: `link`                                                        |
| title       | String | the title of the button                                                                                                                             |
| urlParam    | String | Add varialbe to your url e.g. `abc=123&id=122`                                                                                                      |

#### Example
```html
  <cf_buttons>

    <cf_button title="Edit" url="quote.edit@412"/> 

  </cf_buttons>

```

### Form
Use for form manipulations

#### xForm

Create a form header

##### Attributes

| Name | Type   | Description                                                                            |
|------|--------|----------------------------------------------------------------------------------------|
| id   | String | A unique identifier for the form element to be created. Default: `getRandomVariable()` |

##### Example
```html
  <cf_xform>

    <!--- the content of you form goes in here --->

  </cf_xform>

```

#### fSubmit

Render a Submit Button and perform form submit function

##### Attributes

| Name         | Type    | Description                                                                                                   |
|--------------|---------|---------------------------------------------------------------------------------------------------------------|
| url*         | String  | `CFC` method to post your form to. you could also post to a `cfm` page                                        |
| clearForm    | Boolean | Clear the form once the form has been submitted. Default: `false`                                             |
| flashMessage | String  | A message that will be displayed to the user once the form is submitted. Default: `Data was saved succesfuly` |
| icon         | String  | Add an icon before the submit button text value. Default: `save`                                              |
| id           | String  | A unique identifier for the submit button element to be created. Default: `getRandomVariable()`               |
| redirectURL  | String  | Where to goto after the form has ben submitted successfuly                                                    |
| value        | String  | The value of Submit button                                                                                    |

##### Example
```html
<cf_xform>

  <!--- add input elements here --->

  <cf_fsubmit 
    value="Create" 
    flashmessage="New Item was created successfuly" 
    url="Controller_Path.cfc?method=SaveMethod"/>

  <!--- the method SaveMethod in the Controller_Path.cfc should be a remote function --->

</cf_xform>

```

#### InputButton

Combination of a button with a textbox

##### Attributes

| Name     | Type    | Description                                                                                         |
|----------|---------|-----------------------------------------------------------------------------------------------------|
| name*    | String  | The name of the input button element                                                                |
| button   | String  | The name of the input button element. Default: `Go`                                                 |
| click    | String  | javascript function to run onclick                                                                  |
| help     | String  | This is like a tip, it will be rendered below the inputbutton element                               |
| id       | String  | A unique identifier for the submit button element to be created. Default: `getRandomVariable()`     |
| label    | String  | This is the label of the label element                                                              |
| required | Boolean | Specify if user input is required. Default: `false`                                                 |
| size     | String  | It puts the element into a grid form. Only use when you are in the cf_frow tag. Default: `col-sm-6` |
| value    | String  | The value of inputbutton                                                                            |

##### Example
```html
  <cf_xform>

    <cf_inputbutton name="keyword" 
      required 
      label=""
      button="Search" 
      click="enter_a_javascript_function_here()"/>

  </cf_xform>

```

#### option

Select option, checkbox radiobox, and autoselete form input

##### Attributes

| Name       | Type    | Description                                                                                                                            |
|------------|---------|----------------------------------------------------------------------------------------------------------------------------------------|
| name*      | String  | The name of the option element. This should be the same as the field in the database                                                   |
| delimiters | String  | This is the character you want to use as a separator of the value that you want to display to the user in the option box. Default: "," |
| help       | String  | This is like a tip, it will be rendered below the inputbutton element                                                                  |
| id         | String  | A unique identifier for the submit button element to be created. Default: `getRandomVariable()`                                        |
| label      | String  | This is the label of the label element                                                                                                 |
| multiple   | Boolean | This is for multiple selection of item in the option element. This attribute works when type is select, and select2. Default: `false`  |
| required   | Boolean | Specify if user input is required. Default: `false`                                                                                    |
| size       | String  | It puts the element into a grid form. Only use when you are in the cf_frow tag. Default: `col-sm-6`                                    |
| type       | String  | The type of option box to render : `radio` or `radiobox`, `checkbox`, `select`, `select2`. Default:`checkbox`                          |

##### Example
```html
  <cf_xform>

    <cf_option name="Gender" type="radio" value="M,F" display="Male,Female" required/>

    // using url attribute
    <cf_name="ClientId" url="Client.cfc?method=remoteSearch" label="Client" required type="select2"/>
    // remoteSearch function returns json data {"id":"01", "text": "xxx"} 

  </cf_xform>

```

#### xInput

Input form field

##### Attributes

| Name     | Type    | Description                                                                                                   |
|----------|---------|---------------------------------------------------------------------------------------------------------------|
| name*    | String  | The name of the option element. This should be the same as the field in the database                          |
| help     | String  | This is like a tip, it will be rendered below the inputbutton element                                         |
| id       | String  | A unique identifier for the submit button element to be created. Default: `getRandomVariable()`               |
| label    | String  | This is the label of the label element                                                                        |
| max      | String  | The maximum lenght of characters to allow in the textbox                                                      |
| min      | String  | The minimum lenght of characters to allow in the textbox                                                      |
| required | Boolean | Specify if user input is required. Default: `false`                                                           |
| size     | String  | It puts the element into a grid form. Only use when you are in the cf_frow tag. Default: `col-sm-6`           |
| type     | String  | The type of option box to render : `radio` or `radiobox`, `checkbox`, `select`, `select2`. Default:`checkbox` |
| value    | String  | The default value of the input element                                                                        |

##### Example
```html
  <cf_xform>

    <cf_xinput name="Email" type="email" required/>

  </cf_xform>

```


#### xTextarea

Textarea form input

##### Attributes

| Name     | Type    | Description                                                                                         |
|----------|---------|-----------------------------------------------------------------------------------------------------|
| name*    | String  | The name of the option element. This should be the same as the field in the database                |
| help     | String  | This is like a tip, it will be rendered below the inputbutton element                               |
| id       | String  | A unique identifier for the submit button element to be created. Default: `getRandomVariable()`     |
| label    | String  | This is the label of the label element                                                              |
| rows     | Numeric | Textarea number of rows. Default: `3`                                                               |
| required | Boolean | Specify if user input is required. Default: `false`                                                 |
| size     | String  | It puts the element into a grid form. Only use when you are in the cf_frow tag. Default: `col-sm-6` |
| style    | String  | Textarea CSS style                                                                                  |
| value    | String  | The default value of the textarea element                                                           |

##### Example
```html
  <cf_xform>

    <cf_xtextarea name="Address" required/>

  </cf_xform>

```


### Grid

Create tabular data/Grid control

#### Grid

Create a grid table

##### Attributes

| Name             | Type    | Description                                                                                                            |
|------------------|---------|------------------------------------------------------------------------------------------------------------------------|
| model*           | String  | The name of the model you want to display records from                                                                 |
| bordered         | Boolean | Add border to the Grid. Default: `false`                                                                               |
| condensed        | Boolean | make compact. Default: `false`                                                                                         |
| deepRelationship | Boolean | Check the associate setup on the model and create the relationship between the models. Default: `false`                |
| export           | List    | Specify the file format you want to export the table Grid to. The current supported option are `excel` and `html`      |
| filter           | String  | Filter the result of the Grid. `=` is `:`, `<>` is `!:`, `""` is `[]` example filter: `user.Surname:[James]`           |
| groupBy          | String  | Works like SQL Group by, you just specify the field you want to group by                                               |
| hover            | Boolean | Hover effect. Default: `true`                                                                                          |
| key              | String  | The Primary Key of the Data in the Grid. Default: The first column in the Grid row                                     |
| responsive       | Boolean | Make the Grid responsive for mobile and table use. Default: `true`                                                     |
| rows             | Numeric | The default number of record to display per page. Default: `20`                                                        |
| sortBy           | Numeric | Specify the column to sort with by representing it with the column index. the first index start from `0`. Default: `0` |
| sortDirection    | String  | Default sort diection `ASC`, `DESC`. Default: `DESC`                                                                   |
| striped          | Boolean | Add strips to the grid. Default: `true`                                                                                |

##### Example
```html
  <cf_grid model="Quote" sortby="4" filter="ClientId:1">

    <!--- the content of you grid goes in here --->

  </cf_grid>

```

#### GJoin
It is used to join another model to the Grid

##### Attributes

| Name   | Type    | Description                                                                                                                  |
|--------|---------|------------------------------------------------------------------------------------------------------------------------------|
| model* | String  | The name of the model you want to join to the Grid                                                                           |
| deep   | Boolean | determine if the tag should join foreign keys associated with this model. Default: `false`                                   |
| fkey   | String  | the name of the foreign keys on the Grid model to join too, Default: Default to the primary key of the model on the cf_gjoin |

##### Example

```html
  <cf_grid model="Quote">

    <cf_gjoin model="Client">

    <!--- the rest of the tag goes here --->

  </cf_grid>

```

#### GCustomJoin
It is used for more complex join of table for the Grid

##### Attributes

| Name   | Type   | Description                                                                                                              |
|--------|--------|--------------------------------------------------------------------------------------------------------------------------|
| join*  | String | sql join clause                                                                                                          |
| select | String | The field you wish to select from the table NB: Your selected field must conform with owaf style of naming a table field |

##### Example

```html
  <cf_grid model="Quote">

    <cf_gcustom_join select="
      vendor.Company vendor_Company,
      currency.Sign Currency_Sign
    " join="
      INNER JOIN vendor ON quote.VendorId = vendor.VendorId
      INNER JOIN currency ON currency.CurrencyId = quote.CurrencyId
    ">

    <!--- the rest of the tag goes here --->

  </cf_grid>

```

#### Columns

This is a wraper for cf_column

##### Column

This is responsible for displaying individual column

###### Attributes

| Name     | Type    | Description                                                                                                                                                            |
|----------|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| name*    | String  | The name of the field in the database                                                                                                                                  |
| align    | String  | text alignment - `left`, `center`, `right`. Default: `left`                                                                                                            |
| caption  | String  | The caption of the column. Default: the name of the coulmn                                                                                                             |
| field    | String  | The real name of the field in the sql query generated by the system. this is to avaoid ambiguity. its usaully the tablename.fieldname. Default: the name of the coulmn |
| hide     | Boolean | Hide the column from rendering into the browser, Default: `false`                                                                                                      |
| nowrap   | Boolean | Dont allow wrap, Default: `false`                                                                                                                                      |
| template | String  | Use this to write javascript. row[index] is javascript name of the current item in the column                                                                          |


###### Example
```javascript
  // Quote model
  component extend='project1.com.owaf.Model'  {
    public Quote function init(string table_name = 'quote')  {
      // this code below is required
      this = super.init(arguments.table_name);
      // link client model
      hasOne('Client');

      return this;
    }
  }

```


```html
  <!--- quote list file --->
  <cf_grid model="Quote" sortby="4" filter="ClientId:1">

    <cf_columns>

      <cf_column name="Quoteid" hide/>
      <cf_column name="QuoteNumber" caption="##"/> 
      <cf_column name="client_Code" caption="Client"/>
      <cf_column name="Note" caption="Note" field="quote.Note"/>
      <cf_column name="Date" nowrap/>
      <cf_column name="TotalPrice" caption="Total" field="quote.TotalPrice" template="row[8].formatMoney()" align="right"/>

    </cf_columns>

  </cf_grid>

```

##### Commands

This is a wraper for cf_command

###### Commands

This is responsible for displaying the link/button on individual column

###### Attributes

| Name     | Type   | Description                                                                                                                      |
|----------|--------|----------------------------------------------------------------------------------------------------------------------------------|
| url*     | String | Where to link to                                                                                                                 |
| icon     | String | The icon to display                                                                                                              |
| style    | String | The style of the command button that will be rendered on the grid, Default: `link`                                               |
| title    | String | What to display on as the link or on the button                                                                                  |
| type     | String | The type of window that will display after clicking on the button: `model`, `load` or `ajax`, `execute`, `print` Default: `load` |
| urlParam | String | The url arguments to pass to the url attribute of the button. e.g. `urlparam="arg1=123"`                                         |


###### Example
```html
  <cf_grid model="Quote" sortby="4" filter="ClientId:1">

    <cf_columns>
      <!--- the content of you grid goes in here --->

      <cf_commands>
        <cf_command title="view" url="quote.view"/>
      </cf_commands>
    </cf_columns>

  </cf_grid>

```

#### Toolbar
A wrapper for cf_search and cf_buttons tags

##### Search
Allow you to search through the grid


##### GButtons
Warpper for cf_button

###### GButton
Create a button on top of the Grid

###### Attributes

| Name  | Type   | Description                       |
|-------|--------|-----------------------------------|
| url*  | String | Where to link to                  |
| icon  | String | The icon to display on the button |
| title | String | The title of the button           |

###### Example

```html
  <cf_grid model="Quote">

    <cf_toolbar>
      <cf_search />
      <cf_gbuttons>
          <cf_gbutton title="New" url="quote.new" style="default"/>
      </cf_gbuttons>
    </cf_toolbar>

  </cf_grid>
```

##### filters
Allow you to create a filter dropdown for the grid. this can also serve as the filter group

###### Attributes

| Name   | Type    | Description                       |
|--------|---------|-----------------------------------|
| column | Numeric | the column to filter from         |
| name   | String  | the name to display on the filter |

###### filter
filter item

###### Attributes

| Name   | Type   | Description                                                    |
|--------|--------|----------------------------------------------------------------|
| title* | String | what to show the user                                          |
| value  | String | the value to use as filter, uses what is in `title` by default |

###### Example

```html
  <!--- quote list file --->
  <cf_grid model="Quote" sortby="4" filter="ClientId:1">

    <cf_toolbar>
      <cf_search />
      <cf_gbuttons>
        <cf_filters column="2" name="Company">
          <cf_filter title="ABC Limited" value="ABC">
          <cf_filter title="XYZ Limited" value="XYZ">
        </cf_filters>
      </cf_gbuttons>
    </cf_toolbar>

    <cf_columns>

      <cf_column name="Quoteid" hide/>
      <cf_column name="QuoteNumber" caption="##"/> 
      <cf_column name="client_Code" caption="Client"/>
      <cf_column name="Note" caption="Note" field="quote.Note"/>
      <cf_column name="Date" nowrap/>
      <cf_column name="TotalPrice" caption="Total" field="quote.TotalPrice" template="row[8].formatMoney()" align="right"/>

    </cf_columns>

  </cf_grid>

```

### Chart

### Comment

### Link

### PlainGrid

### Tab

### TableEdit

## Contribute to the Documentation

If you have suggestions to improve this documentation, feel free to contribute by submitting an issue or a pull request on the [OWAF GitHub repository](https://github.com/officelimex/owaf3).
