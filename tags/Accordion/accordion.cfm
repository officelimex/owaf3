<cfoutput>

	<cfif thisTag.ExecutionMode == 'start'>

		<cfparam name="Attributes.TagName" type="string" default="Accordion"/>
		<cfparam name="Attributes.iconprefix" type="string" default="fal fa-"/>
		<cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
		<cfparam name="Attributes.style" type="string" default="default"/>
		<cfparam name="Attributes.class" type="string" default="card"/>

		<cfset request.accordion.item = ArrayNew(1)/>

	<cfelse>

		<div class="accordion" id="#Attributes.id#">

			<!--- display the items --->
			<cfloop array="#request.accordion.item#" item="x">

				<div class="#Attributes.class#">

					<!--- title --->
					<div class="card-header" id="#x.id#H">
						<div class="card-title">
							<a style="display:block" data-toggle="collapse" data-url="#x.url#" data-toggle="collapse" data-target="###x.id#" href="###x.id#" aria-expanded="true" aria-controls="#x.id#" class="text-left #Attributes.id# <cfif !x.IsActive>collapsed</cfif> btn btn-link" data-urlparam="#x.urlparam#">
								<cfif x.icon neq "">
									<i class="#Attributes.iconprefix##x.icon#"></i>
								</cfif> #x.title#
							</a>
						</div>
					</div>

					<!--- content --->
					<div id="#x.id#" aria-controls="#x.id#" class="collapse <cfif x.isActive>show</cfif>" aria-labelledby="#x.id#H" data-parent="###Attributes.id#">
						<div class="card-body #x.contentClass#">
							#x.content#
						</div>
					</div>

				</div>

			</cfloop>

		</div>

		<script type="text/javascript">
			$(document).ready(function() {

				<cfloop array="#request.accordion.item#" item="x">
					<cfif x.isactive && x.url != "">
						var a = $('###x.id#');
						loadPage('#x.url#', {
							'renderTo': a.attr('aria-controls') + ' div.card-body',
							'changeURL':false, 'samePage': true,
							'param': a.attr('data-urlparam')}
						);
					</cfif>
				</cfloop>

				$('a.#Attributes.id#').click(function (e) {
					e.preventDefault();

					<cfset  a = application.fn.GetRandomVariable()/>
					<cfset  u = application.fn.GetRandomVariable()/>

					var #a# = $(this), #u# = #a#.attr('data-url');

					if(#u#!="") {
						loadPage(#u#, {
							'renderTo': #a#.attr('aria-controls') + ' div.card-body',
							'changeURL':false, 'samePage': true,
							'param': #a#.attr('data-urlparam')}
						);
					}
					//$(this).collapse('show');
				});

			});

		</script>

	</cfif>

</cfoutput>