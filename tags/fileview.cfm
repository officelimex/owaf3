<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="FileView"/>
    <cfparam name="Attributes.modelid" type="numeric"/>
    <cfparam name="Attributes.key" type="numeric"/>
    <cfparam name="Attributes.display" type="string" default="list"/>
    <cfparam name="Attributes.iconclass" type="string" default="fal fa-file-"/>
    <cfparam name="Attributes.columnsize" type="string" default=""/>
    <cfparam name="Attributes.href" type="string" default="attachment/"/>

	<cfquery name="qFiles">
		SELECT * FROM file
		WHERE `Key` = #Attributes.key# AND modelId = #Attributes.modelId#
	</cfquery>

	<cfswitch expression="#Attributes.display#">
		<cfcase value="list">
			<ul class="fa-ul">
			<cfloop query="qFiles">
				<li>
					<i class="fa-li fal fa-file #Attributes.iconclass##listlast(File,'.')#-o"></i>
					<cfset fl = replaceNocase(File, '%', '%25', 'all')/>
					<cfset fl = replaceNocase(fl, ' ', '%20', 'all')/>
					<a href="#Attributes.href##fl#" target="_blank">#listlast(File,'/')#</a>
				</li>
			</cfloop>
			</ul>
		</cfcase>
		<cfcase value="grid">
			<div class="row">
				<cfloop query="qFiles">
					<div class="col-sm-#Attributes.columnsize# thumb">
						<cfset fl = replaceNocase(File, '%', '%25', 'all')/>
						<a class="thumbnail" href="#Attributes.href##fl#" target="_blank">
							<img src="#Attributes.href##fl#" class="img-responsive"/>
						</a>
					</div>
				</cfloop>
				<cfif qFiles.recordcount == 0>
					<div class="col-sm-12 text-center">No document attached...</div>
				</cfif>
			</div>
		</cfcase>

	</cfswitch>

</cfif>
</cfoutput>