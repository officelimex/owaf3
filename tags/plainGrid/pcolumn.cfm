<cfoutput>
	<cfif ThisTag.ExecutionMode EQ "Start">

	<cfparam name="Attributes.value" type="string"/>
	<cfparam name="Attributes.template" type="string" default=""/>
	<!---use this to construct a nice output, using the name of the field from the query on the pgrid attribute [ use %% to indicate variable --->
	<cfparam name="Attributes.caption" type="string" default="#listlast(Attributes.value,'_')#"/>
	<cfparam name="Attributes.format" type="string" default="string"/> <!--- rating,link, money, html, status, number --->
	<cfparam name="Attributes.nowrap" type="boolean" default="false"/>
	<cfparam name="Attributes.delimiters" type="string" default="|"/>
	<cfparam name="Attributes.class" type="string" default=""/>

	<cfswitch expression="#attributes.format#">
		<cfcase value="money,number" delimiters=",">

			<cfparam name="Attributes.align" type="string" default="right"/>
			<cfset request.pGrid.sum[Attributes.value] = 0/>

		</cfcase>
		<cfcase value="rating">
			<cfparam name="Attributes.ratinglist" type="string"/><!--- e.g  - Fail-0,Average-1,Good-2,Excellent-3 --->
			<cfparam name="Attributes.ratingcolor" type="string" style=""/>
		</cfcase>
		<cfcase value="status">
			<cfparam name="Attributes.status" type="struct"/><!--- e.g  - {status-value:status-color} --->
		</cfcase>
		<cfcase value="link,url,modal" delimiters=",">
			<cfparam name="Attributes.url" type="string"/>
		</cfcase>
		<cfdefaultcase>

		</cfdefaultcase>
	</cfswitch>

		<cfparam name="Attributes.align" type="string" default=""/>

		<cfassociate basetag="cf_pColumns" />

		<cfset ArrayAppend(request.PlainGrid.columns,Attributes)/>

	</cfif>
</cfoutput>