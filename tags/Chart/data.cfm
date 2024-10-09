<cfoutput>

	<cfif ThisTag.ExecutionMode EQ "Start">

	    <cfparam name="Attributes.TagName" type="string" default="data"/>
	    <cfparam name="Attributes.labels" type="string" />

	 <!--- close tag --->
	<cfelse>

		<cfset Content = THISTAG.GeneratedContent />
		<cfset THISTAG.GeneratedContent = "" />

		{
			labels: [
				<cfloop list="#Attributes.labels#" item="x">
					"#x#",
				</cfloop>
			],
			datasets: [

				#Content#

			]
    	}

	</cfif>

</cfoutput>