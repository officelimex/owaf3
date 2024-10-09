<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="m_yAxis"/>

	<cfelse>
		<cfset Content = THISTAG.GeneratedContent />
		<cfset THISTAG.GeneratedContent = "" />

		<cfset cf_echart = getBaseTagData("cf_echart").Attributes/>

		yAxis : [
			#Content#
		],


		</cfif>

</cfoutput>