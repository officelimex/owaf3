<cfoutput>

	<cfif ThisTag.ExecutionMode == "Start">

		<cfparam name="Attributes.TagName" type="string" default="ModalCloseButton"/>
		<cfparam name="Attributes.id" type="string" default="#application.fn.getRandomvariable()#"/>
		<cfparam name="Attributes.message" type="string" default="Are you sure, you any unsaved data will be lost"/>
		
			<cfset cls_cont = application.fn.getRandomvariable()/>
			<cfset closeid = application.fn.getRandomvariable()/>
			<script>
				$(function() {
					var #cls_cont# = $("##__app_modal_close_container");
					#cls_cont#.html("<a class='close ' title='Close' id='#closeid#'><i class='fal fa-times'></i></a>")
	
					$("###closeid#").click(function() {

						if(confirm('#attributes.message#'))	{
							#cls_cont#.html("<a class='close ' title='Close' data-dismiss='modal' aria-hidden='true'><i class='fal fa-times'></i></a>");
							closeModal();
						}
						
					});
				});
			</script>

	</cfif>
</cfoutput>