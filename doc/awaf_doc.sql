# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# Sequel Pro SQL dump
# Version 4541
#
# http:/ / www.sequelpro.com /
# https:/ / github.com / sequelpro / sequelpro
#
# Host: 127.0.0.1 (MySQL 5.6.41)
# Database:owaf_doc
# Generation Time:2018 -09 -06 10:57:53 am + 0000
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */
;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */
;
/*!40101 SET NAMES utf8 */
;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */
;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */
;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */
;

# Dump of table component
# ------------------------------------------------------------

DROP TABLE IF EXISTS `component`;

CREATE TABLE `component` (
  `ComponentId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ComponentTypeId` int(10) unsigned NOT NULL,
  `Title` varchar(200) NOT NULL DEFAULT '',
  `Type` enum('Plugin','Class','Tag') NOT NULL DEFAULT 'Class',
  `BaseComponent` varchar(200) DEFAULT NULL,
  `Description` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`ComponentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `component` WRITE;
/*!40000 ALTER TABLE `component` DISABLE KEYS */
;

INSERT INTO `component` (`ComponentId`, `ComponentTypeId`, `Title`, `Type`, `BaseComponent`, `Description`)
VALUES
	(1,1,'Model','Class',NULL,'This model class is an abstract of your data.'),
	(2,2,'Controller','Class',NULL,NULL),
	(3,3,'Form','Tag',NULL,'Use for form manipulations'),
	(4,3,'Grid','Tag',NULL,'Create tabular data/Grid control'),
	(5,3,'Button','Tag',NULL,NULL),
	(6,3,'Chart','Tag',NULL,NULL),
	(7,3,'PlainGrid','Tag',NULL,NULL),
	(8,3,'Tab','Tag',NULL,NULL),
	(9,3,'TableEdit','Tag',NULL,'Edit data in tabular form'),
	(10,3,'Breadcrumb','Tag',NULL,NULL),
	(11,3,'Comment','Plugin',NULL,NULL),
	(12,3,'DocumentHistory','Plugin',NULL,NULL),
	(13,3,'Link','Tag',NULL,NULL),
	(14,3,'BlockItem','Tag',NULL,'wrap string in a block view');

/*!40000 ALTER TABLE `component` ENABLE KEYS */
;

UNLOCK TABLES;

# Dump of table component_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `component_type`;

CREATE TABLE `component_type` (
  `ComponentTypeId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Title` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`ComponentTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `component_type` WRITE;
/*!40000 ALTER TABLE `component_type` DISABLE KEYS */
;

INSERT INTO `component_type` (`ComponentTypeId`, `Title`)
VALUES
	(1,'Model'),
	(2,'Controller'),
	(3,'View');

/*!40000 ALTER TABLE `component_type` ENABLE KEYS */
;

UNLOCK TABLES;

# Dump of table method
# ------------------------------------------------------------

DROP TABLE IF EXISTS `method`;

CREATE TABLE `method` (
  `MethodId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `MethodTypeId` int(10) unsigned DEFAULT NULL,
  `ComponentId` int(10) unsigned NOT NULL,
  `Name` varchar(100) NOT NULL DEFAULT '',
  `Description` text,
  `Example` text,
  `Returns` varchar(200) DEFAULT '',
  PRIMARY KEY (`MethodId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `method` WRITE;
/*!40000 ALTER TABLE `method` DISABLE KEYS */
;

INSERT INTO `method` (`MethodId`, `MethodTypeId`, `ComponentId`, `Name`, `Description`, `Example`, `Returns`)
VALUES
	(1,1,1,'init','This is to use to initialize the model class.\nIt is use when creatinf a new model','component extend=\'com.owaf.Model\'  {\n  public Article function init(string table_name = \'article\')  {\n    // this code below is required\n    this = super.init(arguments.table_name);\n\n    return this;\n  }\n}','Model Object'),
	(2,4,1,'find','Find a record in the model data set','// create the model\nvar article = model(\'Article\');\narticle = article.find(20);','Model Object'),
	(3,4,1,'findAll','Find all record in the model data set','// create the model\nvar article = model(\'Article\');\n// find records in article where AuthorId = 8, order by Title and limit the records to 20\narticle = article.findAll(\n  where : \'AuthorId = 8\',\n  order : \'Title\',\n  limit : \'0,20\'\n);','<code>Query</code>'),
	(4,4,1,'findQ','Find a record in the model data set',NULL,'<code>Query</code>'),
	(5,4,1,'isEmpty','Check if a modal object exist',NULL,'<code>Boolean</code>'),
	(6,4,1,'fieldExists','Determine if a field exist',NULL,'<code>Boolean</code>'),
	(7,2,1,'enableVersioning','Enable Versioning on the <code>Model</code><br/>\nYou need to create another <code>table</code> for the model with the word <code>\'history_\'</code> at the end of the table. e.g. if your model table name is <code>payroll</code>, then table to store the changes will be called <code>payroll_history</code>','// Article model\ncomponent extend=\'com.owaf.Model\'  {\n  public Article function init(string table_name = \'article\')  {\n    this = super.init(arguments.table_name);\n    enableVersioning();\n    return this;\n  }\n}','<code>Void</code>'),
	(8,4,1,'getTableAlias','Get the Alias of the <code>table</code> to the model',NULL,'<code>String</code>'),
	(9,4,1,'Model','Create a modal object','// create invoice\nvar invoice = model(\'Invoice\');','Model Object'),
	(10,4,1,'trash','Send a Model Object record to the trash. \nFor the <code>trash()</code> function to work, you will need to create another <code>table</code> for the model with the word <code>\'deleted_\'</code> at the begining of the table. e.g. if your model table name is <code>book</code>, then table to hold the deleted record will be called <code>deleted_book</code>','// create the model\nvar article = model(\'Article\');\narticle = article.find(20);\narticle.trash();',''),
	(11,4,1,'delete','Delete the model object from the database','// create the model\nvar article = model(\'Article\');\narticle = article.find(20);\narticle.delete();',''),
	(12,4,1,'deleteAll','Delete all records in the model using the where clause','// create the model\nvar article = model(\'Article\');\narticle.deleteAll(where : \'Author = 8\');',''),
	(13,4,1,'deleteAllInKey','Delete all records in the model using the using the primary keys','// create the model\nvar article = model(\'Article\');\n// delete article with primary key 20, 21, 22\narticle.deleteAllInKey(\'20,21,22\');',''),
	(14,4,1,'findByKeyIn','Find all record in the model data set using the primary key',NULL,'<code>Query</code>'),
	(15,4,1,'getKeyValue','Get the primary key value of a model table',NULL,'<code>String</code>'),
	(16,4,1,'getCurrentVersion','Get the current version number of the model if versioning is enabled. see <code>enableVersioning()</code>',NULL,'<code>Numeric</code>'),
	(17,4,1,'getVersions','Get the current version of the model if versioning is enabled. see <code>enableVersioning()</code>',NULL,'<code>Query</code>'),
	(18,2,1,'hasMany','Sets up a <code>hasMany</code> association between this model and the specified one.','// Article model\ncomponent extend=\'com.owaf.Model\'  {\n  public Article function init(string table_name = \'article\')  {\n    this = super.init(arguments.table_name);\n    // association\n    hasMany(\'comments\');\n    return this;\n  }\n}',''),
	(19,4,1,'count','Count the occurance a field in a model/table','// create employee\nvar employee = model(\'Employee\');\n// count the gender of employee where locationid = 6\nvar query_employee = employee.count(\n  field_to_count : \'Gender\',\n  where : \'LocationId = 6\'\n);\n\n// the counted value can be access in \"query_employee.result\"','<code>Query</code>'),
	(20,4,1,'sum','Sum records in a table','// create invoice\nvar invoice = model(\'Invoice\');\n// sum all invoice\nvar total_price = invoice.sum(\n  field: \'TotalPrice\'\n  where : \'Date > 2015/10/01\'\n);','<code>Numeric</code>'),
	(21,2,1,'mayHaveOne','Sets up a <code>mayHaveOne</code> association between this model and the specified one.','// Book model\ncomponent extend=\'com.owaf.Model\'  {\n  public Book function init(string table_name = \'book\')  {\n    this = super.init(arguments.table_name);\n    // association\n    mayHaveOne(\'Publisher\');\n    return this;\n  }\n}',''),
	(22,4,1,'join','join a model together using <code>INNER JOIN</code>','// create Book model\nvar book = model(\'Book\');\n// join a publisher model to the book\nbook = book.join(\'Publisher\');\n\n/*\n you can join more modals together.\n book = book.join(\'Publisher\').join(\'AuthorId\');\n*/',''),
	(23,4,1,'ljoin','join a model together using <code>LEFT JOIN</code>','// create Book model\nvar book = model(\'Book\');\n// join a publisher model to the book\nbook = book.ljoin(\'Publisher\');\n\n/*\n you can join more modals together.\n book = book.ljoin(\'Publisher\').join(\'AuthorId\');\n*/',''),
	(24,4,1,'max','Maximum record in a table','// create invoice\nvar invoice = model(\'Invoice\');\n// get the max total price of an invoice\nvar max_invoice_value = invoice.max(\n  field: \'TotalPrice\'\n  where : \'Date > 2015/10/01\'\n);','<code>Numeric</code>'),
	(25,4,1,'min','Minimum record in a table','// create invoice\nvar invoice = model(\'Invoice\');\n// get the max total price of an invoice\nvar min_invoice_value = invoice.min(\n  field: \'TotalPrice\'\n  where : \'Date > 2015/10/01\'\n);','<code>Numeric</code>'),
	(26,4,1,'saveDirect','Save data to the database directly.\nIf versioning is enabled on this model, using this function will not cause a new version to be created.','// create invoice\nvar book = model(\'Book\');\nbook = book.find(2);\nbook.saveDirect(\n  Title: \'Hello World\'\n  Description : \'...\'\n);',''),
	(27,4,1,'save','Save data to the database.','// create invoice\nvar book = model(\'Book\');\nbook = book.find(2);\nbook.Title = \"Hello World\";\nbook.Description = \"...\";\n// save the new data\nbook = book.save();','Model Object.'),
	(28,4,1,'saveWithOutHistory','Save data to the database, without creating an history record','// create invoice\nvar book = model(\'Book\');\nbook = book.find(2);\nbook.Title = \"Hello World\";\nbook.Description = \"...\";\n// save the new data\nbook = book.saveWithOutHistory();','Model Object.'),
	(29,4,1,'new','Create new data in to the modal object. but does not saves into the database','// create invoice\nvar book = model(\'Book\');\n// this does not save into the database\nbook = book.new(\n  Title: \'Hello World\'\n  Description : \'...\'\n);','Model Object.'),
	(30,4,1,'toggle','Toggle fields in the database.The field will be toggled using boolean operations [true, false], [yes, no]','// create Order\nvar order = model(\'Order\');\norder = order.find(4311);\n// change the status of the field \'IsApproved\' if false to true, if no to yes\norder.toggle(\'IsApproved\');',''),
	(31,4,2,'Model','Create a modal object','// create invoice\nvar invoice = model(\'Invoice\');','Model Object'),
	(32,4,2,'maxValueOfSubItemInForm','Return the maximum number of items in EditTable form','','<code>Numeric</code>'),
	(33,4,2,'countEditTableItemInForm','Return the maximum number of items in EditTable form','','<code>Numeric</code>'),
	(34,4,2,'saveModelItem','Save Model Item data into the database',NULL,'Model Object'),
	(35,4,2,'sendMail','Send e-mail',NULL,''),
	(36,4,2,'maxEditTableItems','Return the maximum number of items in EditTable',NULL,'<code>Numeric</code>');

/*!40000 ALTER TABLE `method` ENABLE KEYS */
;

UNLOCK TABLES;

# Dump of table method_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `method_type`;

CREATE TABLE `method_type` (
  `MethodTypeId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Title` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`MethodTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `method_type` WRITE;
/*!40000 ALTER TABLE `method_type` DISABLE KEYS */
;

INSERT INTO `method_type` (`MethodTypeId`, `Title`)
VALUES
	(1,'Initialization'),
	(2,'Settings'),
	(3,'Members'),
	(4,'Methods');

/*!40000 ALTER TABLE `method_type` ENABLE KEYS */
;

UNLOCK TABLES;

# Dump of table parameter
# ------------------------------------------------------------

DROP TABLE IF EXISTS `parameter`;

CREATE TABLE `parameter` (
  `ParameterId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `MethodId` int(10) unsigned DEFAULT NULL,
  `TagId` int(10) unsigned DEFAULT NULL,
  `Name` varchar(30) NOT NULL DEFAULT '',
  `Description` text,
  `Required` enum('true','false') NOT NULL DEFAULT 'false',
  `Type` enum('List','Any','String','Array','Struct','Numeric','Date','Boolean') NOT NULL DEFAULT 'Any',
  `Default` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ParameterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `parameter` WRITE;
/*!40000 ALTER TABLE `parameter` DISABLE KEYS */
;

INSERT INTO `parameter` (`ParameterId`, `MethodId`, `TagId`, `Name`, `Description`, `Required`, `Type`, `Default`)
VALUES
	(1,2,NULL,'value','The value to find using the model primary','true','String',NULL),
	(2,2,NULL,'key','The key you will like to use as criteria to search the model record set','false','String',NULL),
	(3,3,NULL,'where','write you normal sql where clause. e.g <code>Gender=\"Male\"</code>','false','Any',NULL),
	(4,3,NULL,'select','Specify custom field to select. you can use this to combine fields','false','Any',NULL),
	(5,3,NULL,'order','<code>SQL</code> order clause without using the \'order\' word','false','Any',NULL),
	(6,3,NULL,'group','<code>SQL</code> group clause without using the \'group\' word','false','Any',NULL),
	(7,3,NULL,'limit','Number of records to return (use mysql <code>limit</code> format e.g 0,10)','false','String',NULL),
	(8,6,NULL,'field_name','The name of the field to check for','true','String',NULL),
	(9,9,NULL,'model_desc','The model description in the following format -> <code>model table_name table_alias</code> ','true','String',NULL),
	(10,12,NULL,'where','write you normal sql where clause. e.g <code>Gender=\"Male\"</code>','true','String',NULL),
	(11,13,NULL,'keys','Keys for the model separated by \",\"','true','List',NULL),
	(12,4,NULL,'key','The key you will like to use as criteria to search the model record set','true','String',NULL),
	(13,14,NULL,'keys','Keys for the model separated by \",\"','true','String',NULL),
	(14,14,NULL,'where','write you normal sql where clause. e.g <code>Gender=\"Male\"</code>','false','String',NULL),
	(15,14,NULL,'select','Specify custom field to select. you can use this to combine fields','false','String',NULL),
	(16,14,NULL,'order','<code>SQL</code> order clause without using the \'order\' word','false','String',NULL),
	(17,14,NULL,'group','<code>SQL</code> group clause without using the \'group\' word','false','String',NULL),
	(18,18,NULL,'model_name','The model name in plural form','true','String',NULL),
	(19,1,NULL,'table_name','Name of the table that you want to create the model for','false','String',NULL),
	(20,19,NULL,'field_to_count','The field to count','false','String','primary key'),
	(21,19,NULL,'fields','Fields to return form the table','false','String',NULL),
	(22,19,NULL,'where','write you normal sql where clause. e.g <code>Gender=\"Male\"</code>','false','String',NULL),
	(23,19,NULL,'group','<code>SQL</code> group clause without using the \'group\' word','false','String',NULL),
	(24,19,NULL,'order','<code>SQL</code> order clause without using the \'order\' word','false','String',NULL),
	(25,20,NULL,'field','The field to sum','true','String',NULL),
	(26,20,NULL,'where','write you normal sql where clause. e.g <code>Gender=\"Male\"</code>','false','String',NULL),
	(27,21,NULL,'model_desc','The model description in the following format -> <code>model table_name table_alias</code> ','true','String',NULL),
	(28,21,NULL,'foreign_key','the foreign key on the associate table.','false','String','default it is the primary key in the <code>model_desc</code> argument'),
	(29,21,NULL,'deep_rel','Deep assocation with other model if setup','false','Boolean','<code>false</code>'),
	(30,22,NULL,'model_desc','The model description in the following format -> <code>model table_name table_alias</code> ','true','String',NULL),
	(31,22,NULL,'foreign_key','the foreign key on the associate table.','false','String','default it is the primary key in the <code>model_desc</code> argument'),
	(32,22,NULL,'deep_rel','Deep assocation with other model if setup','false','Boolean','<code>false</code>'),
	(33,23,NULL,'model_desc','The model description in the following format -> <code>model table_name table_alias</code> ','true','String',NULL),
	(34,23,NULL,'foreign_key','the foreign key on the associate table.','false','String','default it is the primary key in the <code>model_desc</code> argument'),
	(35,23,NULL,'deep_rel','Deep assocation with other model if setup','false','Boolean','<code>false</code>'),
	(36,24,NULL,'field','The field to check the maxinum value for','true','String',NULL),
	(37,25,NULL,'field','The field to check the minimum value for','true','String',NULL),
	(38,24,NULL,'where','write you normal sql where clause. e.g <code>Gender=\"Male\"</code>','false','String',NULL),
	(39,25,NULL,'where','write you normal sql where clause. e.g <code>Gender=\"Male\"</code>','false','String',NULL),
	(40,26,NULL,'data','A struct data containing the field and value of the data you want to save.','true','Struct',NULL),
	(41,27,NULL,'versionData','This is used if versioning are enabled on the model.\nUse this argument to pass field that is in the model history table and not in the model.','false','Struct',NULL),
	(42,29,NULL,'formData','This should contain field and value of the data structure you want to create. it should also be identical to the name used in your database for the model','true','Struct',NULL),
	(43,30,NULL,'fields','List of fields to toggle.','false','List',NULL),
	(44,31,NULL,'model_desc','The model description in the following format -> <code>model table_name table_alias</code> ','true','String',NULL),
	(45,32,NULL,'fieldnames','This should be the form.fieldnames','true','String',''),
	(46,33,NULL,'fieldnames','This should be the form.fieldnames','true','String',''),
	(47,34,NULL,'model_desc','The model description in the following format -> <code>model table_name table_alias</code> ','true','String',NULL),
	(48,34,NULL,'form_field','List of the names of the filed you wish to save into the database','true','String',NULL),
	(49,34,NULL,'fixed_field','List of the names of the filed you wish to save into the database that is not in the EditTable tag','false','String',NULL),
	(50,34,NULL,'form','The form struct : you can just use <code>form</code>','true','Struct',NULL),
	(51,34,NULL,'versionData','This is used if versioning are enabled on the model.\nUse this argument to pass field that is in the model history table and not in the model.','false','Struct',NULL),
	(52,35,NULL,'subject','Subject of the mail','true','String',NULL),
	(53,35,NULL,'to','Receipiant email','true','String',NULL),
	(54,35,NULL,'body','Content of the mail','true','String',NULL),
	(55,35,NULL,'bcc','Blind Cabon Copy','false','String',NULL),
	(56,35,NULL,'cc','Cabon Copy','false','String',NULL),
	(57,35,NULL,'attachments','Attachement','false','Array',NULL),
	(58,NULL,1,'id','A unique identifier for the form element to be created','false','String','<code>getRandomVariable()</code>'),
	(59,NULL,2,'id','A unique identifier for the input element to be created','false','String','<code>getRandomVariable()</code>'),
	(60,NULL,2,'name','The name of the input box. This should be the same as the field in the database','true','String',''),
	(61,NULL,2,'type','The type of input box to render : <code>text, date, password, email</code>','false','String','<code>text</code>'),
	(62,NULL,2,'value','The default value of the input element','false','String',''),
	(63,NULL,2,'help','This is like a tip, it will be rendered below the input box','false','String',''),
	(64,NULL,2,'label','This is the label of the input element','false','String','It uses the name attribute'),
	(65,NULL,2,'required','Specify if user input is required','false','Boolean','<code>false</code>'),
	(66,NULL,3,'rows','Textarea number of rows','false','Numeric','<code>3</code>'),
	(67,NULL,3,'name','The name of the textarea. This should be the same as the field in the database','true','String',''),
	(68,NULL,3,'value','The default value of the textarea element','false','String',''),
	(69,NULL,3,'help','This is like a tip, it will be rendered below the textarea element','false','String',''),
	(70,NULL,3,'label','This is the label of the textarea element','false','String','It uses the name attribute'),
	(71,NULL,3,'id','A unique identifier for the textarea element to be created','false','String','<code>getRandomVariable()</code>'),
	(72,NULL,3,'required','Specify if user input is required','false','Boolean','<code>false</code>'),
	(73,NULL,4,'id','A unique identifier for the option element to be created','false','String','<code>getRandomVariable()</code>'),
	(74,NULL,3,'style','Textarea CSS style ','false','String',''),
	(75,NULL,3,'size','It puts the element into a grid form. Only use when you are in the <code>cf_frow</code> tag','false','String','<code>col-sm-6</code>'),
	(76,NULL,2,'size','It puts the element into a grid form. Only use when you are in the <code>cf_frow</code> tag','false','String','<code>col-sm-6</code>'),
	(77,NULL,4,'type','The type of option box to render : <code>radio|radiobox, checkbox, select, select2</code>','false','String','<code>checkbox</code>'),
	(78,NULL,4,'help','This is like a tip, it will be rendered below the option box','false','String',''),
	(79,NULL,4,'name','The name of the option element. This should be the same as the field in the database','true','String',''),
	(80,NULL,4,'required','Specify if user input is required','false','Boolean','<code>false</code>'),
	(81,NULL,4,'delimiters','This is the character you want to use as a separator of the value that you want to display to the user in the option box','false','String','<code>\",\"</code>'),
	(82,NULL,4,'label','This is the label of the option element','false','String',''),
	(83,NULL,4,'size','It puts the element into a grid form. Only use when you are in the <code>cf_frow</code> tag','false','String','<code>col-sm-6</code>'),
	(84,NULL,4,'multiple','This is for multiple selection of item in the option element. This attribute works when type is <code>select, and select2</code>','false','Boolean','<code>false</code>'),
	(85,NULL,5,'value','The value of Submit button','false','String',''),
	(86,NULL,5,'flashmessage','A message that will be displayed to the user once the form is submitted','false','String','Data was saved succesfuly'),
	(87,NULL,5,'clearform','Clear the form once the form has been submitted','false','Boolean','<code>false</code>'),
	(88,NULL,5,'icon','Add an icon before the submit button text value','false','String','save'),
	(89,NULL,5,'redirectURL','Where to goto after the form has ben submitted successfuly','false','String',''),
	(90,NULL,5,'id','A unique identifier for the submit button element to be created','false','String','<code>getRandomVariable()</code>'),
	(91,NULL,5,'url','CFC method to post your form to. you could also post to a cfm page','true','String',''),
	(92,NULL,6,'name','The name of the input button element.','true','String',''),
	(93,NULL,6,'value','The value of inputbutton','false','String',''),
	(94,NULL,6,'required','Specify if user input is required','false','Boolean','<code>false</code>'),
	(95,NULL,6,'help','This is like a tip, it will be rendered below the inputbutton element','false','String',''),
	(96,NULL,6,'label','This is the label of the {{TAG_NAME}} element','false','String',''),
	(97,NULL,6,'size','It puts the element into a grid form. Only use when you are in the <code>cf_frow</code> tag','false','String','<code>col-sm-6</code>'),
	(98,NULL,6,'button','The name of the input button element.','false','String','Go!'),
	(99,NULL,6,'click','javascript function to run onclick','false','String',NULL),
	(100,NULL,6,'id','A unique identifier for the input box element to be created','false','String','<code>getRandomVariable()</code>'),
	(101,NULL,7,'model','The name of the model you want to display records from','true','String',''),
	(102,NULL,7,'sortdirection','Default sort diection <code>ASC, DESC</code>','false','String','<code>DESC</code>'),
	(103,NULL,7,'sortby','Specify the column to sort with by representing it with the column index. the first index start from \"0\"','false','Numeric','<code>\"0\"</code>'),
	(104,NULL,7,'hover','Hover effect','false','Boolean','<code>true</code>'),
	(105,NULL,7,'condensed','make compact','false','Boolean','<code>false</code>'),
	(106,NULL,7,'striped','Add strips','false','Boolean','<code>true</code>'),
	(107,NULL,7,'bordered','Add border to the Grid','false','Boolean','<code>false</code>'),
	(108,NULL,7,'rows','The default number of record to display per page','false','Numeric','<code>20</code>'),
	(109,NULL,7,'deepRelationship','Check the associate setup on the model and create the relationship between the models','false','Boolean','<code>false</code>'),
	(110,NULL,8,'name','The name of the field in the database','true','String',''),
	(111,NULL,8,'hide','Hide the column from rendering into the browser','false','Boolean','<code>false</code>'),
	(112,NULL,8,'caption','The caption of the column','false','String','the name of the coulmn'),
	(113,NULL,8,'field','The real name of the field in the sql query generated by the system. this is to avaoid ambiguity. its usaully the <code>tablename.fieldname</code>','false','String','the name of the coulmn'),
	(114,NULL,8,'nowrap','Dont allow wrap','false','Boolean','<code>false</code>'),
	(115,NULL,8,'template','Use this to write javascript. oData[index] is javascript name of the current item in the column','false','String',''),
	(116,NULL,8,'align','text alignment - left, center, right','false','String','<code>left</code>'),
	(117,NULL,7,'export','Specify the file format you want to export the the Grid to. The current supported option is <code>\"excel\"</code>','false','String',''),
	(118,NULL,2,'min','The minimum lenght of characters to allow in the textbox','false','String',''),
	(119,NULL,2,'max','The maximum lenght of characters to allow in the textbox','false','String',''),
	(120,NULL,11,'title','What to display on as the link or on the button','false','String',''),
	(121,NULL,11,'url','Where to link to','true','String',''),
	(122,NULL,11,'icon','The icon to display','false','String',''),
	(123,NULL,12,'model','The name of the model you want to <code>join</code> to the <code>Grid</code>','true','String',''),
	(124,NULL,12,'deep','determine if the tag should join foreign keys associated with this model','false','Boolean','<code>false</code>'),
	(125,NULL,12,'fkey','the name of the foreign keys on the Grid model to join too','false','String','Default to the primary key of the model on the cf_gjoin'),
	(126,NULL,16,'url','Where to link to','true','String',''),
	(127,NULL,16,'title','the title of the button','false','String',''),
	(128,NULL,16,'icon','The icon to display on the button','false','String',''),
	(129,NULL,17,'iconprefix','The prefix to use for all the icons inside <code>cf_button</code>','false','String','<code>\"fa fa-\"</code>'),
	(130,NULL,17,'buttonprefix','The prefix to use for all the button class inside <code>cf_button</code>','false','String','<code>\"btn-\"</code>'),
	(131,NULL,17,'align','Where to align the content of the buttons too : left, right, center','false','String','<code>\"right\"</code>'),
	(132,NULL,17,'size','The default size of all the buttons within this tag : <code>btn-group-sm, btn-group-xs, btn-group-md, btn-group-lg</code>','false','String','<code>\"btn-group-sm\"</code>'),
	(133,NULL,18,'title','the title of the button','false','String',''),
	(134,NULL,18,'url','Where to link to','true','String',''),
	(135,NULL,18,'type','type of link to create\n<ul>\n <li>link : regular link from on page to another.</li>\n <li>ajax: perform an ajax action without leaving the current page</li>\n <li>external: open the link in another window</li>\n <li>modal: pop up a dialog box</li>\n <li>print: open the page use the print plugin</li>\n</ul>','false','String','<code>\"link\"</code>'),
	(136,NULL,18,'urlparam','Add varialbe to your url e.g. <code>\"abc=123&id=122\"</code>','false','String',''),
	(137,NULL,18,'modalTitle','The title of the dialog box/window','false','String','use the <code>title</code> attribute'),
	(138,NULL,18,'icon','The icon to display on the button','false','String',''),
	(139,NULL,18,'style','The design of the button :\r\n<ul>\r\n<li>default</li>\r\n<li>link</li>\r\n<li>primary</li>\r\n<li>success</li>\r\n<li>danger</li>\r\n<li>warning</li>\r\n</ul>','false','String','<code>link</code>'),
	(140,NULL,19,'datasource','Where to pull data from','true','Any',NULL),
	(141,NULL,19,'striped','table property, add alternating color to the table row','false','Boolean','<code>true</code>'),
	(142,NULL,19,'hover','Add hover effect to the table row','false','Boolean','<code>true</code>'),
	(143,NULL,19,'compressed','Compress the table','false','Boolean','<code>false</code>'),
	(144,NULL,19,'bordered','Add border arround the table','false','Boolean','<code>false</code>'),
	(145,NULL,21,'value','the field in the query to display on the column','true','String',''),
	(146,NULL,21,'caption','the caption to the column','false','String','the value passed to the <code>cf_pCoulmn</code>'),
	(147,NULL,21,'nowrap','dont allow wrap on the column','false','Boolean','<code>false</code>'),
	(148,NULL,21,'format','How the value of the column should be formated\n<ul>\n<li>money</li>\n<li>date</li>\n<li>text</li>\n<li>html</li>\n<li>link</li>\n</ul>','false','String','<code>text</code>'),
	(149,NULL,21,'class','the class for the column','false','String',''),
	(150,NULL,22,'class','the class to apply to the div arround the chart','false','String',''),
	(151,NULL,22,'type','The type of chart to rendar<ul>\n<li> Doughnut2d </li>\n<li>Line</li>\n<li>StackedColumn2D</li>\n<li>StackedColumn3D</li>\n<li>MSColumn2d</li>\n<li>MultiAxisLine</li>\n<li>pie3d</li>\n<li>pie2d</li>\n</ul>','true','String',''),
	(152,NULL,7,'key','The Primary Key of the Data in the Grid','false','String','The first column in the Grid row'),
	(153,NULL,7,'responsive','Make the Grid responsive for mobile and table use','false','Boolean','<code>true</code>'),
	(154,NULL,7,'filter','Filter the result of the Grid.<br/>\r\n<code>=</code> is <code>:</code><br>\r\n<code><></code> is <code>!:</code><br>\r\n<code>\"\"</code> is <code>[]</code>\r\nexample filter: <code>user.Surname:[James]</code>','false','String',''),
	(155,NULL,7,'groupby','Works like <code>SQL Group by</code>, you just specify the field you want to group by','false','String',''),
	(156,NULL,17,'class','html class','false','String',''),
	(157,36,NULL,'field_names','The name of the field to check for','true','String',NULL),
	(158,36,NULL,'field_name','One of the field in the editable','true','String',NULL),
	(159,NULL,23,'url','Where to link to','true','String',NULL),
	(160,NULL,23,'icon','Icon to display before the text of the link','false','String',''),
	(161,NULL,25,'title','the title on the tab','true','String',''),
	(162,NULL,24,'justified','justification of the tab','false','Boolean','<code>true</code>'),
	(163,NULL,25,'isactive','make the tab item active','false','Boolean','<code>true</code>'),
	(164,NULL,25,'icon','Icon to display before the tab title','false','String',''),
	(165,NULL,25,'url','Source of the tab content','false','String',NULL),
	(166,NULL,26,'name','the name to display on the filter','false','String',''),
	(167,NULL,26,'column','the column to filter from','false','Numeric',''),
	(168,NULL,18,'action','Process and ajax request.\r\n\r\nUsage: <code>Component.cfc?method=method1&arg=param_value</code>','false','String',''),
	(169,NULL,18,'redirect','Once an action is performed, use the redirect attribute to specify the URL where you want to goto next.\r\n\r\nWorks only when <code>action</code> attribute is specify','false','String',''),
	(170,NULL,18,'confirm','A confirmation message that display after a the button is clicked.\r\nClick Ok to execute, and cancel to stop the action','false','String','Are you sure'),
	(171,NULL,18,'modalurl','URL of the modal window','false','String',''),
	(172,NULL,18,'responsemsg','Response message after an action has been executed','false','String',''),
	(173,NULL,28,'label','label to display','true','String',''),
	(174,NULL,28,'value','value to display','false','String',NULL),
	(175,NULL,28,'textclass','class name that will be associated with the value. this is only used in when the format is <code>email</code>','false','String',''),
	(176,NULL,28,'format','The format in which to display the value.\r\naccepted format are <code>address, email, date, money</code>','false','String',''),
	(177,NULL,28,'prefix','This will be display in-fornt of the <code>value</code> attribure','false','String',''),
	(178,NULL,28,'removeblank','This attribute removes the view entirely if the <code>value</code> in the attribute is empty','false','Boolean','<code>false</code>'),
	(179,NULL,28,'icon','fontawsome icon name to display before the label','false','String',''),
	(180,NULL,28,'itemclass','the css class to for the value element. this is not applicable when <code>format</code> is defined','false','String',''),
	(181,NULL,28,'lableclass','The css class for the label','false','String',''),
	(182,NULL,28,'iconclass','The css class to wrap the <code>icon</code> attribute with ','false','String',''),
	(183,NULL,28,'suffix','Add to the end of the <code>value</code> attrubite','false','String',''),
	(184,NULL,18,'renderTo','where to render the redirect url page too','false','String',''),
	(185,NULL,29,'name','This use differentiate the tableedit tag from other onces in the same page. the name will be reference when trying to save the data into the database','false','String',NULL),
	(186,NULL,31,'caption','The header title for the column','false','String','<code>name</code> attribute of this tag'),
	(187,NULL,31,'name','the name of the field in the database you want to update','true','String',''),
	(188,NULL,31,'required','Make entry for the field required','false','Boolean','<code>false</code>'),
	(189,NULL,31,'type','The type of element to render while performing data entry. The following type are valid;\r\n<ul>\r\n<li><code>text</code></li>\r\n<li><code>textarea</code></li>\r\n<li><code>money</code></li>\r\n<li><code>number</code></li>\r\n<li><code>select</code></li>\r\n<li><code>select2</code></li>\r\n</ul>','false','String','<code>text</code>'),
	(190,NULL,29,'id','javascript id of the entire component. the id is generated automaticaly','true','String','<code>getRandomVariable()</code>'),
	(191,NULL,29,'datatype','the data type you want to provide to the tag','true','String','<code>query</code>'),
	(192,NULL,29,'datasource','the source of the data to edit','true','Any',''),
	(193,NULL,29,'striped','Add strips to the table','false','String','<code>true</code>'),
	(194,NULL,29,'hover','Add hover style to the table','false','String','<code>true</code>'),
	(195,NULL,29,'compressed','compress the table','false','String','<code>false</code>'),
	(196,NULL,29,'bordered','add border to the table','false','String','<code>false</code>'),
	(197,NULL,29,'defaultview','determin which view should be rendered. text or edit\n<ul>\n<li><code>text</code> display the table in text form with no input element</li>\n<li>while the <code>edit</code> mode display the table in an input form, waiting for the user to start making changes</li>\n</ul>','false','String','<code>text</code>'),
	(198,NULL,29,'allowNewLineItem','Allow user to add new item to table','false','String','<code>true</code>'),
	(199,NULL,29,'candelete','Allow user to be able to delete row/record from the table','false','Boolean','<code>true</code>'),
	(200,NULL,29,'editall','convert the table to edit mode, user can start making changes on the table without clicking on the edit button/link first','false','Boolean','<code>false</code>'),
	(201,NULL,31,'nowrap','don\'t wrap the content','false','Boolean','<code>false</code>'),
	(202,NULL,31,'readonly','make the column readonly','false','Boolean','<code>false</code>'),
	(203,NULL,31,'width','The width of the column in % or px','false','String',''),
	(204,NULL,31,'hidden','Use attribute to store key field/primary key value','false','String','<code>false</code>'),
	(205,NULL,31,'rows','only applies if attribute <code>type</code> is <code>textarea</code>','false','Numeric','<code>2</code>'),
	(206,NULL,31,'selected','only applies if attribute <code>type</code> is <code>select</code>','true','String',''),
	(207,NULL,31,'display','only applies if attribute <code>type</code> is <code>select</code>','false','List','<code>attribute.value</code>'),
	(208,NULL,31,'delimiters','only applies if attribute <code>type</code> is <code>select</code>','false','String','<code>,</code>'),
	(209,NULL,31,'id','javascript id of the element','false','String',''),
	(210,NULL,31,'url','only applies if attribute <code>type</code> is <code>select2</code>','true','String',''),
	(211,NULL,31,'currency','only applies if attribute <code>type</code> is <code>money</code>','false','String','<code>$</code>'),
	(212,NULL,31,'align','how to align the content of the column','false','String',''),
	(213,NULL,31,'min','The minimum value that can be accepted by the input field','false','Numeric',''),
	(214,NULL,11,'type','The type of window that will display after clicking on the button:\r\n<ul>\r\n<li><code>model</code></li>\r\n<li><code>load</code> or <code>ajax</code></li>\r\n<li><code>execute</code></li>\r\n<li><code>print</code></li>\r\n</ul>','false','String','<code>load</code>'),
	(215,NULL,11,'style','The style of the command button that will be rendered on the grid;\r\n<ul>\r\n<li><code>link</code></li>\r\n</ul>','false','String','<code>link</link>'),
	(216,NULL,11,'urlparam','The url arguments to pass to the <code>url</code> attribute of the button. e.g. <code>urlparam=\"arg1=123\"</code>','false','String',''),
	(217,NULL,23,'type','The type of action to perform when clicked\r\n<ul>\r\n<li><code>load|ajax</code> - link to another page</li>\r\n<li><code>execute</code> - run a command somewhere with out reloading the page</li>\r\n<li><code>modal</code> - display a modal window</li>\r\n<li><code>print</code> - sends to pdf output</li>\r\n</ul>','false','String','<code>load</code>'),
	(218,NULL,32,'select','The field you wish to select from the <code>table</code><br/>\r\nNB: You select field must conform with <code>owaf</code> style of naming a table field','false','String',''),
	(219,NULL,32,'join','join clause goes  in here','true','String',''),
	(220,NULL,4,'selected','The value that will be selected by default when the component is rendered.<br/>\r\nwhen the option type is <code>select2</code> and the <code>url</code> attribute is use, kindly use the following format to specify Id and Text for <code>selected</code> attribute<br/>\r\n<code>\r\nselected = \"123:Hello\" \r\n</code>\r\n<br/>\r\n123: will be the value<br/>\r\nHello: will be the display text','false','String','');

/*!40000 ALTER TABLE `parameter` ENABLE KEYS */
;

UNLOCK TABLES;

# Dump of table tag
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tag`;

CREATE TABLE `tag` (
  `TagId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ParentTagId` int(10) unsigned DEFAULT NULL,
  `ComponentId` int(10) unsigned NOT NULL,
  `Name` varchar(100) NOT NULL DEFAULT '',
  `Description` text,
  `TagExample` text,
  `ScriptExample` text,
  PRIMARY KEY (`TagId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */
;

INSERT INTO `tag` (`TagId`, `ParentTagId`, `ComponentId`, `Name`, `Description`, `TagExample`, `ScriptExample`)
VALUES
	(1,NULL,3,'xForm','Create a form header','<cf_xform>\n\n  <!--- the content of you form goes in here --->\n\n</cf_xform>',NULL),
	(2,1,3,'xInput','Input form field','<cf_xform>\n\n  <cf_xinput name=\"Email\" type=\"email\" required/>\n\n</cf_xform>',NULL),
	(3,1,3,'xTextarea','Textarea form input','<cf_xform>\n\n  <cf_xtextarea name=\"Address\" required/>\n\n</cf_xform>',NULL),
	(4,1,3,'option','Select option, checkbox radiobox, and autoselete form input','<cf_xform>\n\n  <cf_option name=\"Gender\" type=\"radio\" value=\"M,F\" display=\"Male,Female\" required/>\n\n  // using url attribute\n  <cf_name=\"ClientId\" url=\"Client.cfc?method=remoteSearch\" label=\"Client\" required type=\"select2\"/>\n  // remoteSearch function returns json data {\"id\":\"01\", \"text\": \"xxx\"} \n\n</cf_xform>\n\n',NULL),
	(5,1,3,'fSubmit','Render a Submit Button and perform form submit function','<cf_xform>\r\n\r\n  <!--- add input elements here --->\r\n\r\n  <cf_fsubmit value=\"Create\" flashmessage=\"New Item was created successfuly\" url=\"Controller_Path.cfc?method=SaveMethod\"></cf_fsubmit>\r\n\r\n  <!--- the method SaveMethod in the Controller_Path.cfc should be a remote function --->\r\n\r\n</cf_xform>',''),
	(6,1,3,'InputButton','Combination of a button with a textbox','<cf_xform>\n\n  <cf_inputbutton name=\"keyword\" \n	required \n	label=\"\"\n	button=\"Search\" \n	click=\"enter_a_javascript_function_here()\"/>\n\n</cf_xform>',NULL),
	(7,NULL,4,'Grid','Create a grid table','<cf_grid model=\"Quote\" sortby=\"4\" filter=\"ClientId:1\">\r\n\r\n  <!--- the content of you grid goes in here --->\r\n\r\n</cf_grid>',''),
	(8,9,4,'Column','This is responsible for displaying individual column ','<!--- quote list file --->\n<cf_grid model=\"Quote\" sortby=\"4\" filter=\"ClientId:1\">\n\n  <cf_columns>\n\n    <cf_column name=\"Quoteid\" hide/>\n    <cf_column name=\"QuoteNumber\" caption=\"##\"/> \n    <cf_column name=\"client_Code\" caption=\"Client\"/>\n    <cf_column name=\"Note\" caption=\"Note\" field=\"quote.Note\"/>\n    <cf_column name=\"Date\" nowrap/>\n    <cf_column name=\"TotalPrice\" caption=\"Total\" field=\"quote.TotalPrice\" template=\"oData[8].formatMoney()\" align=\"right\"/>\n\n  </cf_columns>\n\n</cf_grid>','// Quote model\ncomponent extend=\'com.owaf.Model\'  {\n  public Quote function init(string table_name = \'quote\')  {\n    // this code below is required\n    this = super.init(arguments.table_name);\n    // link client model\n    hasOne(\'Client\');\n\n    return this;\n  }\n}'),
	(9,7,4,'Columns','This is a wraper for <code>cf_column</code>','<cf_grid model=\"Quote\" sortby=\"4\" filter=\"ClientId:1\">\n\n  <cf_columns>\n    <!--- the content of you grid goes in here --->\n  </cf_columns>\n\n</cf_grid>',''),
	(10,7,4,'Commands','This is a wraper for <code>cf_command</code>','<cf_grid model=\"Quote\" sortby=\"4\" filter=\"ClientId:1\">\n\n  <cf_columns>\n    <!--- the content of you grid goes in here --->\n\n    <cf_commands>\n      <!--- cf_command goes here --->\n    </cf_commands>\n  </cf_columns>\n\n\n\n</cf_grid>',''),
	(11,10,4,'Command','This is responsible for displaying the link/button on individual column ','<cf_grid model=\"Quote\" sortby=\"4\" filter=\"ClientId:1\">\n\n  <cf_columns>\n    <!--- the content of you grid goes in here --->\n\n    <cf_commands>\n      <cf_command title=\"view\" url=\"quote.view\"/>\n    </cf_commands>\n  </cf_columns>\n\n</cf_grid>',''),
	(12,7,4,'GJoin','It is used to join another <code>model</code> to the <code>Grid</code>','<cf_grid model=\"Quote\">\n\n  <cf_gjoin model=\"Client\">\n\n  <!--- the rest of the tag goes here --->\n\n</cf_grid>',''),
	(13,7,4,'toolbar','A wrapper for <code>cf_search</code> and <code>cf_buttons</code> tags','<cf_grid model=\"Quote\">\n\n  <cf_toolbar>\n    <!--- toolbar content goes in here --->\n  </cf_toolbar>\n\n</cf_grid>',''),
	(14,13,4,'search','Allow you to search through the grid','<cf_grid model=\"Quote\">\n\n  <cf_toolbar>\n    <cf_search />\n  </cf_toolbar>\n\n</cf_grid>',''),
	(15,7,4,'GButtons','Warpper for <code>cf_button</code>','<cf_grid model=\"Quote\">\n\n  <cf_toolbar>\n    <cf_search />\n    <cf_gbuttons>\n        <!--- your buttons goes in here --->\n    </cf_gbuttons>\n  </cf_toolbar>\n\n</cf_grid>',''),
	(16,7,4,'GButton','Create a button on top of the Grid','<cf_grid model=\"Quote\">\n\n  <cf_toolbar>\n    <cf_search />\n    <cf_gbuttons>\n        <cf_gbutton title=\"New\" url=\"quote.new\" style=\"default\"/>\n    </cf_gbuttons>\n  </cf_toolbar>\n\n</cf_grid>',''),
	(17,NULL,5,'Buttons','A wapper for <code>cf_button</code>','<cf_buttons>\n\n  <!--- your butttons goes in here ---> \n\n</cf_buttons>',''),
	(18,17,5,'Button','Create a button','<cf_buttons>\n\n  <cf_button title=\"Edit\" url=\"quote.edit@412\"/> \n\n</cf_buttons>',''),
	(19,NULL,7,'pGrid','Create a flat grid / table','<cf_pgrid datasource=\"#view.items#\">\n\n  <!--- the content of you plain grid goes in here --->\n\n</cf_pgrid>',NULL),
	(20,19,7,'pColumns','This is a wraper for <code>cf_pColumn</code>','<cf_pGrid datasource=\"#view.items#\">\n\n  <cf_pColumns>\n    <!--- the content of you plain grid goes in here --->\n  </cf_pColumns>\n\n</cf_pGrid>',''),
	(21,19,7,'pColumn','This is responsible for displaying individual column ','<cf_pGrid datasource=\"#view.items#\" bordered>\n\n  <cf_pColumns>\n\n    <cf_pColumn value=\"Currentrow\" caption=\"##\"/>\n    <cf_pColumn value=\"Description\"/> \n    <cf_pColumn value=\"Quantity\" caption=\"Qty\" nowrap/>\n    <cf_pColumn value=\"UnitPrice\" caption=\"Price\" format=\"money\"/>\n    <cf_pColumn value=\"UnitPrice*Quantity\" caption=\"Amount $\" nowrap format=\"money\"/>\n\n  </cf_pColumns>\n\n</cf_pGrid>',''),
	(22,NULL,6,'Chart','Create a graphical chart','<cf_Chart type=\"doughnut2d\" height=\"270px\">\n\n  <!--- the content of you chart goes in here --->\n\n</cf_Chart>',NULL),
	(23,NULL,13,'Link',NULL,NULL,NULL),
	(24,NULL,8,'ttab','Create a tab','<cf_ttab>\n\n</cf_ttab>',NULL),
	(25,24,8,'titem','Create a tab item/content','<cf_ttab>\n  <cf_titem title=\"Title1\" isActive icon=\"file-text\">\n    <!---- tab item content --->\n  </cf_titem>\n  <cf_titem title=\"Title2\" url=\"controller.method\" icon=\"\"/>\n</cf_ttab>',NULL),
	(26,13,4,'filters','Allow you to create a filter dropdown for the grid. this can also serve as the filter group','<cf_grid model=\"Quote\">\n\n  <cf_toolbar>\n    <cf_search />\n    <cf_gbuttons>\n      <cf_filters column=\"10\" name=\"Company\">\n	<!--- filer items goes in here ---->\n      </cf_filters>\n    <cf_gbuttons>\n  </cf_toolbar>\n\n</cf_grid>',''),
	(27,26,4,'filter','filter item','<cf_grid model=\"Quote\">\n\n  <cf_toolbar>\n    <cf_search />\n    <cf_gbuttons>\n      <cf_filters column=\"10\" name=\"Company\">\n        <cf_filter title=\"ABC Limited\" value=\"101\">\n        <cf_filter title=\"XYZ Limited\" value=\"102\">\n      </cf_filters>\n    </cf_gbuttons>\n  </cf_toolbar>\n\n</cf_grid>',''),
	(28,NULL,14,'BlockItem','wrap string in a block view','<cf_blockitem label=\"Label to display\" value=\"Value to display\"/>\n',''),
	(29,NULL,9,'TableEdit','wrapper','<cf_tableedit name=\"users\">\r\n  <!--- other stuff goes in here --->\r\n</cf_tableedit>',''),
	(30,29,9,'tColumns','wrapper for table columns','<cf_tableedit name=\"users\">\n  <cf_tcolumns>\n    <!--- list of columns goes in here --->\n  </cf_tcolumns>\n</cf_tcolumns>',NULL),
	(31,30,9,'tColumn','Column for the table edit','<cf_tableedit name=\"users\">\r\n  <cf_tcolumns>\r\n\r\n    <cf_tcolumn value=\"Quantity\" caption=\"QTY\" width=\"8%\" required type=\"number\" name=\"Quantity\" />\r\n    <cf_tcolumn caption=\"Description\" width=\"55%\" required type=\"textarea\" value=\"Description\"/>\r\n\r\n  </cf_tcolumns>\r\n</cf_tcolumns>',''),
	(32,7,4,'GCustomJoin','It is used for more complex join of <code>table</code> for the <code>Grid</code>','<cf_grid model=\"Quote\">\r\n\r\n  <cf_gcustom_join select=\"\r\n    vendor.Company vendor_Company,\r\n    currency.Sign Currency_Sign\r\n  \" join=\"\r\n    INNER JOIN vendor ON quote.VendorId = vendor.VendorId\r\n    INNER JOIN currency ON currency.CurrencyId = quote.CurrencyId\r\n  \">\r\n\r\n  <!--- the rest of the tag goes here --->\r\n\r\n</cf_grid>','');

/*!40000 ALTER TABLE `tag` ENABLE KEYS */
;

UNLOCK TABLES;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */
;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */
;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */
;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */
;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */
;