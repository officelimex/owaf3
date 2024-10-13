<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="DocumentHistory"/>
    <cfparam name="Attributes.versions" type="query"/>
    <cfparam name="Attributes.title" type="string" default="Document History"/>
    <cfparam name="Attributes.avatar" type="string" default="" />
    <cfparam name="Attributes.surname" type="string" default=""/>
    <cfparam name="Attributes.othernames" type="string" default=""/>
    <cfparam name="Attributes.name" type="string" />
    <cfparam name="Attributes.printURL" type="string" default=""/>
    <cfparam name="Attributes.VersionFieldName" type="string"/>
    <cfparam name="Attributes.LastIsCurrent" type="boolean" default="false"/>

    <cfset Attributes.printURL = replace(Attributes.printURL, '.','/','all')/>

    <!---cfparam name="link" type="string"/---->

 <!--- close tag --->
<cfelse>



	<cfif attributes.versions.recordcount>

		<h4><i class="fal fa-code-fork"></i> #attributes.title#</h4>
			<div class="the-timeline">
			<ul>
				<cfloop query="attributes.versions">
					<li>
						<div class="the-date">
							<cfset email = attributes.versions[#attributes.avatar#]/>
							<img class="media-object img-circle" width="50px" src="https://www.gravatar.com/avatar/#lcase(hash(email))#?s=50&d=mm">
						</div>
						<div>
							<strong>
								<cfif attributes.surname is not "">
									#attributes.versions[attributes.surname]#
								</cfif>
								<cfif attributes.surname is not "">
									#attributes.versions[attributes.othernames]#
								</cfif>
							</strong>
						</div>
						<div>#Attributes.versions.Comment#</div>
						<small class="text-muted">#DateTimeFormat(Attributes.versions.modified,'medium')#</small>
						<br/>
						<!---- show this as overlay --->
						<cfif Attributes.printURL eq "">
							#Attributes.name# version #Attributes.versions.currentrow#
						<cfelse>
							<!---cfif recordcount eq currentrow--->
							<cfif currentrow EQ 1>
								<!---cfif Attributes.LastIsCurrent--->
									Current #Attributes.name# version
								<!---cfelse>
									<a href="views/inc/print/print.cfm?page=#lcase(request.user.usertype)#/#Attributes.printURL#&key=#attributes.versions[Attributes.VersionFieldName]#&version=#Attributes.versions.currentrow#" target="_blank">#Attributes.name# version #Attributes.versions.currentrow#</a>
								</cfif--->
							<cfelse>
								<cfset vs = (Attributes.versions.recordcount+1)-Attributes.versions.currentrow/>
								<a href="views/inc/print/print.cfm?page=#lcase(request.user.usertype)#/#Attributes.printURL#&key=#attributes.versions[Attributes.VersionFieldName]#&version=#vs#" target="_blank">#Attributes.name# version #vs#</a>
							</cfif>
						</cfif>
					</li>
				</cfloop>
			</ul>

		</div>


	</cfif>

</cfif>
</cfoutput>