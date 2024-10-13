<cfoutput>
	<cfif thisTag.ExecutionMode eq 'start'>

        <cfparam name="Attributes.TagName" type="string" default="orgchart"/>
        <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
        <cfparam name="Attributes.connector" type="string" default="step"/><!--- curve, bCurve, step, straight --->
        <cfparam name="Attributes.hoverCoverage" type="string" default="60"/>
        <cfparam name="Attributes.Orientation" type="string" default="NORTH"/><!--- NORTH, WEST, SOUTH, EAST --->

		<cfset request.org_chart_items = "root"/>
		<cfset config = application.fn.GetRandomVariable()/>

		<!--- node styling --->
		<cfparam name="Attributes.NodePadding" default="5px" type="string"/>
		<cfparam name="Attributes.NodeWidth" default="150px" type="string"/>
		<style>
			###Attributes.id# .collapse-switch {height: #Attributes.hoverCoverage#%;}
			###Attributes.id# .node {
				padding: #Attributes.NodePadding#;
				width: #Attributes.NodeWidth#;
			}
		</style>
		<div id="#Attributes.id#"></div>
		<script>
			<!---cfloop from="1" to="20" index="i">
				var _#i# = {};
			</cfloop--->
			var root = {};
			var #config# = {
				"container"				: "###Attributes.id#",
				"rootOrientation"		: "#ucase(Attributes.Orientation)#",
				"hideRootNode"			: true,
				"siblingSeparation"		: 40,
				"subTeeSeparation"		: 30,
				"animation": {
					"nodeAnimation"			: "easeOutBounce",
					"nodeSpeed"				: 200,
					"connectorsAnimation"	: "bounce",
					"connectorsSpeed"		: 200
				},
				"connectors": {
					"type": "#Attributes.connector#"
				},
				"node": {
					"collapsable"	: true
				}
			};
			root = {};

    <cfelse>
			var #application.fn.GetRandomVariable()# = new Treant([#config#, #request.org_chart_items#]);
		</script>
    </cfif>
</cfoutput>