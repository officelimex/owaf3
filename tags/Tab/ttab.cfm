<cfoutput>
	<cfif thisTag.ExecutionMode == 'start'>

		<cfparam name="Attributes.TagName" type="string" default="tab"/>
		<cfparam name="Attributes.justified" type="boolean" default="true"/>
		<cfparam name="Attributes.stacked" type="boolean" default="false"/>
		<cfparam name="Attributes.position" type="string" default="left"/> <!--- the position of the tab button left, right --->
		<cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
		<cfparam name="Attributes.style" type="string" default=""/>
		<cfparam name="Attributes.tabStyle" type="string" default=""/>
		<cfparam name="Attributes.class" type="string" default="box-info full"/>
		<cfparam name="Attributes.stackClass" type="string" default=""/>

		<cfif attributes.stacked>
			<cfparam name="Attributes.padright" default="20px" type="string"/>
			<cfparam name="Attributes.padleft" default="15px" type="string"/>
			<cfparam name="Attributes.padtop" default="0px" type="string"/>

			<cfparam name="Attributes.menuClass" default="col-auto" type="string"/>
			<cfparam name="Attributes.contentClass" default="col" type="string"/>
			<!--- disable justified --->
			<cfset Attributes.justified = false/>

			<!---- write the css class needed --->
			<style>
				###Attributes.id# .xstacked-menu{
					padding-right: #Attributes.padright#;
					padding-bottom:100px;
					padding-left:#Attributes.padleft#;
					padding-top:#Attributes.padtop#;
					box-shadow: inset -8px 0 15px -10px rgba(0, 0, 0, 0.2);
				}
			</style>
		</cfif>

		<style>
			###Attributes.id#.card .nav {margin: 0px 20px 0px;}
		</style>
      	<cfset request.tab_item[Attributes.id] = ArrayNew(1)/>

    <cfelse>

        <script type="text/javascript">
            $(document).ready(function() {

               $('a.#Attributes.id#').click(function (e) {

                  e.preventDefault();

                  <cfset a = application.fn.GetRandomVariable()/>
                  <cfset u = application.fn.GetRandomVariable()/>

                  var #a# = $(this), #u# = #a#.attr('data-url');

                  if(#u#!="") {
                     loadPage(#u#, {
                        'renderTo':#a#.attr('data-renderTo'),
                        'changeURL':false,'samePage':true,
                        'param': #a#.attr('data-urlparam')});
                  	}
                  #a#.tab('show');
               });

            });

        </script>




        <div class="#Attributes.class#" id="#Attributes.id#" style="#Attributes.tabStyle#">

            <cfif attributes.stacked>
                <div class="row">
                    <div class="#Attributes.menuClass# xstacked-menu">
            </cfif>

							<ul class="#attributes.stackClass# nav <cfif attributes.stacked>nav-pills d-block<cfelse>nav-tabs</cfif> <cfif Attributes.justified>nav-justified</cfif> #Attributes.style#">
								<cfloop array="#request.tab_item[Attributes.id]#" item="x">

									<li <cfif x.help !="">title="#x.help#"</cfif> <cfif x.IsActive>class="nav-item active"<cfelse>class="nav-item"</cfif>>
										<a href="###x.id#" data-toggle="tab" data-url="#x.url#" data-urlparam="#x.urlparam#" data-renderTo="#x.id#"
										class="nav-link #Attributes.id# <cfif x.IsActive>active</cfif>"><cfif x.icon != ""><i class="#x.iconType##x.icon#"></i></cfif>#x.title#</a>
									</li>

								</cfloop>
							</ul>

            <cfif attributes.stacked>
              </div>

              <div class="#Attributes.contentClass# xstacked-content">
            </cfif>

									<!--- tab content ---->
									<div class="tab-content #Attributes.style#">
										<cfloop array="#request.tab_item[Attributes.id]#" item="x" index="j">

											<div class="tab-pane min-height-200 #x.class# <cfif x.IsActive> active</cfif>" id="#x.id#">
												#x.Content#<!---#x.class#--->
											</div>

										</cfloop>
									</div>

            <cfif attributes.stacked>
                </div>

              </div>
            </cfif>


        </div>




    </cfif>
</cfoutput>