<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="Data"/>
		<cfparam name="Attributes.name" type="string" default=""/>
		<cfparam name="Attributes.value" type="string" />
 
 
			data:[
       #Attributes.value#
      ]
		

	</cfif>

</cfoutput>