<cfoutput>

	<cfif ThisTag.ExecutionMode == "Start">

		<cfparam name="Attributes.TagName" type="string" default="ModalBackButton"/>
		<cfparam name="Attributes.id" type="string" default="#application.fn.getRandomvariable()#"/>
		<cfparam name="Attributes.url" type="string"/>
		<cfparam name="Attributes.param" type="string" default=""/>
		<cfparam name="Attributes.title" type="string"/>
		<cfparam name="Attributes.position" type="string" default="left"/>
		
		<cfset deChar = "~"/>
		<!--- close tag --->
			
		<cfif listFindNoCase(request.user.pageURLs, listfirst(Attributes.url,deChar))>
			<cfset back_id = application.fn.getRandomvariable()/>
			<cfset back_id2 = application.fn.getRandomvariable()/>
			<script>
				//$(function() {
					var #back_id2# = $("##__app_modal_back_container");

					#back_id2#.html("<a class='back' aria-hidden='true' title='back to #attributes.title#' id='#back_id#'><i class='fal fa-arrow-left'></i></a>");
	
					$("###back_id#").click(function() {
						#back_id2#.html("");
						showModal('#attributes.url#', {
							'title' : '#attributes.title#',
							'param' : '#attributes.param#',
							'position' : '#attributes.position#'
						})
					});
				//});
			</script>

		</cfif>

	</cfif>
</cfoutput>