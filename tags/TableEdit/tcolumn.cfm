<cfoutput>
<cfif ThisTag.ExecutionMode == "Start">

	<cfparam name="Attributes.value" type="string"/>

	<cfparam name="Attributes.type" type="string" default="text"/> <!--- textarea, text, money, number, select, select2, checkbox, document: for images, template: to show multiple fields in readonly format --->
	<cfparam name="Attributes.format" type="string" default=""/>

	<cfparam name="Attributes.nowrap" type="boolean" default="false"/>

	<cfparam name="Attributes.class" type="string" default=""/>

	<cfparam name="Attributes.elementStyle" type="string" default="width:100%"/>

	<cfparam name="Attributes.readOnlyIf" type="string" default=""/>
	<cfparam name="Attributes.readOnly" type="boolean" default="false"/>
	<cfparam name="Attributes.autocomplete" type="boolean" default="false"/>

	<cfparam name="Attributes.width" type="string" default=""/>
	<cfparam name="Attributes.required" type="boolean" default="false"/>
	<cfparam name="Attributes.hidden" type="boolean" default="false"/> <!--- use to store key field --->
	<cfparam name="Attributes.help" type="string" default=""/> <!--- describe the caption more --->

	<cfparam name="Attributes.onChange" type="string" default=""/> <!--- a js function when the value of the  --->

	<!--- Textarea ---->

	<cfswitch expression="#Attributes.type#">

		<cfcase value="checkbox,check">
			<cfparam name="Attributes.inline" type="boolean" default="false"/>
		</cfcase>
		<cfcase value="textarea">
			<cfparam name="Attributes.rows" type="boolean" default="2"/>
		</cfcase>
		<cfcase value="select">
			<cfif request.TableEdit.tag.name != "">
				<cfparam name="Attributes.name" type="string" default="#request.TableEdit.tag.name#_#Attributes.selected#"/>
			</cfif>

			<cfparam name="Attributes.caption" type="string" default="#Attributes.selected#"/>
			<cfparam name="Attributes.id" type="string" default="_#Attributes.selected#"/>
		</cfcase>
		<cfcase value="select2">

			<cfparam name="Attributes.URL" type="string"/> <!--- remote search function --->
			<cfparam name="Attributes.tagging" type="boolean" default="false"/>
			<cfparam name="Attributes.multiple" type="boolean" default="false"/>
			<cfparam name="Attributes.value" type="string" default="" />
			<cfparam name="Attributes.Text" type="string" default="" />
			<cfparam name="Attributes.Text2" type="string" default="" />
			<cfparam name="Attributes.selection" type="numeric" default="1"/>
			<cfparam name="Attributes.jsparam" type="string" default="p1:''" />
			
		</cfcase>
		<cfcase value="money">
			<cfparam name="Attributes.currency" type="string" default="$"/>
			<cfparam name="Attributes.align" type="string" default="right"/>
		</cfcase>
		<cfcase value="integer,number" delimiters=",">
			<cfparam name="Attributes.align" type="string" default="right"/>
		</cfcase>
		<cfcase value="document">
			<cfparam name="Attributes.sessionid" type="string"/> <!--- this is used in the temp table to save the files --->
		</cfcase>
	</cfswitch>

	<cfswitch expression="#Attributes.type#">

		<cfcase value="checkbox,check,select,select2">
			<cfparam name="Attributes.delimiters" type="string" default=","/>
		</cfcase>

	</cfswitch>

	<cfswitch expression="#Attributes.type#">

		<cfcase value="checkbox,check,select">
			<cfparam name="Attributes.selected" type="string" />
			<cfparam name="Attributes.name" type="string" default="#Attributes.selected#"/>
			<cfparam name="Attributes.delimiters" type="string" default=","/>
			<cfparam name="Attributes.display" type="string" default="#Attributes.value#"/>
		</cfcase>

	</cfswitch>


	<cfparam name="Attributes.min" type="string" default=""/>

	<cfparam name="Attributes.align" type="string" default=""/>

	<cfparam name="Attributes.id" type="string" default="_#Attributes.value#"/>
	<cfif request.TableEdit.tag.name == "">
		<cfparam name="Attributes.name" type="string" default="#Attributes.value#"/>
	<cfelse>
		<cfparam name="Attributes.name" type="string" default="#request.TableEdit.tag.name#_#Attributes.value#"/>
	</cfif>

	<cfparam name="Attributes.caption" type="string" default="#listlast(Attributes.name,'_')#"/>

	<cfif request.TableEdit.tag.name != "">
		<!--- check that tag is not already in the name --->
		<cfif (Attributes.name DOES NOT CONTAIN request.TableEdit.tag.name)>
			<cfset Attributes.name = "#request.TableEdit.tag.name#_#Attributes.name#"/>
		</cfif> 
	</cfif>


	<cfassociate basetag="cf_tColumns" />

	<cfif !Attributes.hidden>
		<cfset request.TableEdit.totalcolumn++/>
	</cfif>

	<cfset ArrayAppend(request.TableEdit.columns,Attributes)/>

</cfif>
</cfoutput>