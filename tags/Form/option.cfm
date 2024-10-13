<cfoutput>
<cfif ThisTag.ExecutionMode == "Start">

	<cfparam name="Attributes.TagName" type="string" default="Input"/>
	<cfparam name="Attributes.type" type="string" default="check"/><!--- select, radio, check, select2, tag --->
	<cfparam name="Attributes.help" type="string" default=""/>
	<cfparam name="Attributes.placeholder" type="string" default="Select an option"/>
	<cfparam name="Attributes.emptyValue" type="string" default=" - "/>

	<cfparam name="Attributes.name" type="string"/>

	<cfparam name="Attributes.required" type="boolean" default="false"/>
	<cfparam name="Attributes.readOnly" type="boolean" default="false"/>

	<cfparam name="Attributes.class" type="string" default=""/>

	<cfparam name="Attributes.label" type="string" default="#Attributes.name#"/>
	<cfparam name="Attributes.size" type="string" default="col-sm-6"/>
	<cfparam name="Attributes.inline" type="boolean" default="false"/>
	<cfparam name="Attributes.multiple" type="boolean" default="false"/>
	<cfparam name="Attributes.id" type="string" default="#application.fn.getRandomVariable()#"/>

	<cfparam name="Attributes.URL" type="string" default=""/>
	<cfparam name="Attributes.Tagging" type="boolean" default="false"/>
	<cfparam name="Attributes.maximumInputLength" type="numeric" default="0"/>
	<cfparam name="Attributes.maximumSelectionSize" type="numeric" default="0"/>

	<cfif Attributes.URL == "">
		<cfparam name="Attributes.value" type="string"/>
		<cfparam name="Attributes.selected" type="string" default=""/>
	<cfelse>
		<cfparam name="Attributes.value" type="string" default=""/>
		<cfparam name="Attributes.selected" type="string" default=":"/>
	</cfif>

	<cfparam name="Attributes.delimiters" type="string" default=""/>
	<cfparam name="Attributes.selectedDelimiters" type="string" default="#Attributes.delimiters#"/>

	<cfif Attributes.delimiters == "">
		<!--- get delimiters automatically --->
		<cfif listLen(Attributes.value, "`") gt 1>
			<cfset Attributes.delimiters = "`"/>
		<cfelse>
			<cfset Attributes.delimiters = ","/>
		</cfif>
		<!--- get selected delimiters automatically --->
		<cfif listLen(Attributes.selected, "`") gt 1>
			<cfset Attributes.selectedDelimiters = "`"/>
		<cfelse>
			<cfset Attributes.selectedDelimiters = ","/>
		</cfif>
	</cfif>

	<cfparam name="Attributes.display" type="string" default="#Attributes.value#"/>

    <cfswitch expression="#attributes.type#">
			<cfcase value="check">
			<cfset Attributes.type="checkbox"/>
			<cfset ArrayAppend(request.form.check,Attributes)/>
		</cfcase>
		<cfcase value="select">
			<cfset ArrayAppend(request.form.select,Attributes)/>
		</cfcase>
		<cfcase value="select2">
			<cfset ArrayAppend(request.form.select2,Attributes)/>
		</cfcase>
		<cfcase value="tag">
			<cfset ArrayAppend(request.form.tag,Attributes)/>
		</cfcase>
		<cfcase value="radio">
			<cfset ArrayAppend(request.form.radio,Attributes)/>
		</cfcase>
    </cfswitch>

	<cfif Attributes.type eq "check">
		<cfset Attributes.type = "checkbox"/>
	</cfif>

	<!---cfset cf_xform = getBaseTagData("cf_xform").Attributes/--->

	<cftry>

		<cfset cf_row = getBaseTagData("cf_frow").ATTRIBUTES.TagName/>
		<cfcatch type="any">
			<cfset cf_row = ""/>
		</cfcatch>

	</cftry>


<cfelse>


	<cfif cf_row == "">
		<div class="form-group">
	<cfelse>
		<div class="#Attributes.size# pad-top-10">
	</cfif>

		<cfif len(Attributes.label)>
			<label class="x#Attributes.type#" >#Attributes.label# <cfif Attributes.required><sup class="text-danger">●</sup></cfif></label>
		</cfif>
		<cfif listfindnocase('select,select2',Attributes.type)>
			<cfif Attributes.url.isempty()>
				<select id="#Attributes.id#" class="form-control" name="#Attributes.name#"
					<cfif Attributes.required> required </cfif>
					<cfif Attributes.multiple> multiple </cfif>>
				<option value=""> #Attributes.emptyValue# </option>
			<cfelse>
				<input type="hidden" class="form-control" id="#Attributes.id#" name="#Attributes.name#" value="#attributes.selected#"/>
			</cfif>
		</cfif>

		<cfif Attributes.type == "tag">

			<input type="hidden" class="form-control" id="#Attributes.id#" name="#Attributes.name#" value="#attributes.selected#"/>

		<cfelse>

			<cfloop list="#Attributes.value#" delimiters="#Attributes.delimiters#" item="x" index="j">
				<cfset x = trim(x)/>
				<cfset display_value = listgetat(Attributes.display,j,attributes.delimiters)/>
				<cfif listfindnocase('select,select2',Attributes.type)>

					<option value="#x#" <cfif listFindnocase(attributes.selected, x, attributes.selectedDelimiters)>selected</cfif>>#display_value#</option>

				<cfelse>

					<label class="<cfif !attributes.inline>#Attributes.type# d-block<cfelse>#Attributes.type# d-inlin mr-2 mt-1</cfif>">

						<input type="#Attributes.type#" name="#Attributes.name#" value="#x#" class="icheck #Attributes.class# #Attributes.id#"
						<cfif Attributes.readOnly> disabled </cfif>
						<cfif Attributes.required> required </cfif>
						<cfif listFindnocase(attributes.selected, x, attributes.delimiters)> checked </cfif>
						/> #display_value#

					</label>
				</cfif>

			</cfloop>

		</cfif>

		<cfif listfindnocase('select,select2',Attributes.type)>
			<cfif Attributes.url.isEmpty()>
				</select>
			</cfif>
		</cfif>
		<cfif Attributes.help != "">
			<small class="form-text text-muted">#Attributes.help#</small>
		</cfif>

	</div>

</cfif>
</cfoutput>