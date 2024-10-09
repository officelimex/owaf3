<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

	<cfparam name="Attributes.TagName" type="string" default="Column"/>
	<cfparam name="Attributes.name" type="string" />
	<cfparam name="Attributes.UseId" type="boolean" default="false"/> <!--- generate Id for column {td}--->

	<cfparam name="Attributes.field" type="string" default="#getField()#"/><!--- use this to search --->
	<cfparam name="Attributes.caption" type="string" default="#listLast(Attributes.name,'_')#"/>
	<cfparam name="Attributes.eCaption" type="string" default="#Attributes.caption#"/> <!--- caption to use in exported mode --->
	<cfparam name="Attributes.help" type="string" default=""/>
	<cfparam name="Attributes.class" type="string" default=""/>
	<cfparam name="Attributes.cssStyle" type="string" default=""/>
	<cfparam name="Attributes.nowrap" type="boolean" default="false"/>
	<cfparam name="Attributes.template" type="string" default=""/>
	<cfparam name="Attributes.align" type="string" default=""/>
	<cfparam name="Attributes.script" type="string" default=""/>
	<cfparam name="Attributes.sortable" type="boolean" default="true"/>
	<cfparam name="Attributes.searchable" type="boolean" default="true"/>
	<cfparam name="Attributes.exportable" type="boolean" default="true"/>
	<!--- <cfparam name="Attributes.hide" type="boolean" default="false"/> --->

	<cfif Attributes.exportable>
		<cfparam name="Attributes.hide" type="boolean" default="false"/>
	<cfelse>
		<cfparam name="Attributes.hide" type="boolean" default="true"/>
	</cfif>

	<cfparam name="Attributes.type" type="string" default="string"/> <!--- the type of date [string/text, money, date, datetime] --->
	<cfparam name="Attributes.format" type="string" default="d-mmm-yy"/> <!--- if the value is a date, this format will be implementated --->

	<cfif Attributes.format == "date">
		<cfset Attributes.format = "dd-mmm-yy"/>
	</cfif>

	<cfif Attributes.format == "">
		<cfswitch expression="#Attributes.type#">
			<cfcase value="date,datetime" delimiters=",">
				<cfset Attributes.format = "dd-mmm-yy">
			</cfcase>
		</cfswitch>
	</cfif>

	<cfparam name="Attributes.dateformat" type="string" default="#Attributes.format#"/> <!--- if the value is a date, this format will be implementated ---> <!---depreciate --->

		<cfparam name="Attributes.iseditable" type="string" default=""/> <!--- condition for editable to work --->
		<cfparam name="Attributes.editable" type="boolean" default="false"/> <!--- make grid editable  --->
		<cfif Attributes.iseditable != "">
		<cfset Attributes.editable = true/>
		</cfif>
		<cfparam name="Attributes.saveMethod" type="string" default="save"/> <!--- function to call when saving the data to db --->
		<cfparam name="Attributes.controller" type="string" default=""/> <!--- for editing --->
		<cfparam name="Attributes.keyRow" type="numeric" default="0"/> <!--- for editing --->
		<cfparam name="Attributes.updateField" type="string" default=""/> <!--- for editing: this is to update other fields in the table, x`y=value: for now, where x and y are row number --->

	<cfparam name="Attributes.width" type="string" default=""/> <!--- width of the column --->

	<cfassociate basetag="cf_Columns" />

	<!--- fix name --->
	<cfset attributes.name = replace(attributes.name, '.', '')/>
	<th>#Attributes.caption#</th>

   <cfset ArrayAppend(request.grid.columns,Attributes)/>

   <cfscript>
	  private string function getField()   {
		 var vl = "";
		 if(listlen(attributes.name,'_') gt 1)   {
			// change the last item to '.'
			lval = listLast(attributes.name,'_');
			vl = replace(attributes.name, lval, '.' & lval );
			vl = replace(vl, '_.', '.');
		 }
		 else    {
			vl = replace(Attributes.name,'_','.');
		 }

		 return vl;
	  }
   </cfscript>

</cfif>
</cfoutput>