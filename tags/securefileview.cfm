<cfoutput>

<cfinclude  template="tag_func.cfm">

<cfif ThisTag.ExecutionMode EQ "Start">

	<cfset skey = application.owaf.secretkey />

	<cfparam name="Attributes.TagName" type="string" default="FileView"/>
	<cfparam name="Attributes.fileid" type="numeric" default="0"/>
	<cfparam name="Attributes.repo" type="string" default="pvt"/>
	<cfparam name="Attributes.path" type="string" default=""/>
	<cfparam name="Attributes.tag" type="string" default=""/>
	<cfparam name="Attributes.max" type="numeric" default="100"/>

	<cfif Attributes.fileid == 0>
		<cfparam name="Attributes.modelid" type="numeric"/>
		<cfparam name="Attributes.key" type="numeric" />

		<cfquery name="qFiles">
			SELECT * FROM file
			WHERE `Key` = #Attributes.key# AND modelId = #Attributes.modelId#
			AND `TenantId` = #request.user.tenant.id#
			<cfif Attributes.tag != "">
				AND `Tag` = <cfqueryparam value="#Attributes.tag#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY FileId DESC
			LIMIT 0,#Attributes.max#
		</cfquery>

	<cfelse>
		<cfquery name="qFiles">
			SELECT * FROM file
			WHERE `FileId` = #Attributes.fileid#
				AND `TenantId` = #request.user.tenant.id#
			ORDER BY FileId DESC
			LIMIT 0,#Attributes.max#
		</cfquery>
	</cfif>
	<cfparam name="Attributes.display" type="string" default="list"/>
	<cfparam name="Attributes.iconclass" type="string" default=""/>
	<cfparam name="Attributes.columnsize" type="string" default="3"/>

	<cfswitch expression="#Attributes.display#">
		<cfcase value="list">
		 	<ul class="fa-ul">
			<cfloop query="qFiles">
				<cfif listlen(qFiles.File,'|') gt 1>
					<cfset i = 1  />
					<cfloop list="#qFiles.File#" item="fl" delimiters="|">
						<li>
							<span class="fa-li"><i class="#getfileType(File)# #Attributes.iconclass#"></i></span>
							<cfswitch expression="#qFiles.ModelId#">
								<cfcase value="9,19"> <!--- leave and handover on exit --->
									<cfset _key = encrypt(qFiles.FileId & "-" & request.user.userid & "-#i++#" , skey, 'AES/CBC/PKCS5Padding', 'Hex')/>
									<a href="attachment/index.cfm?file=#_key#" target="_blank">#fl#</a>
								</cfcase>
								<cfcase value="#application.MODELID.EXPENSE#"> 
									<cfset _key = encrypt(qFiles.FileId & "-" & request.user.userid & "-#i++#" , skey, 'AES/CBC/PKCS5Padding', 'Hex')/>
									<a href="attachment/index.cfm?file=#_key#" target="_blank">#fl#</a>
								</cfcase>
								<cfcase value="#application.MODELID.MEMO#"> 
									<a href="#application.s3.url#pvt/#request.user.Tenant.Id#/memo/#qFiles.Key#/#fl#" target="_blank">#fl#</a>
								</cfcase>
								<cfdefaultcase>
									<a href="#application.s3.url#pvt/#request.user.Tenant.Id#/employee/#qFiles.Key#/#fl#" target="_blank">#fl#</a>
								</cfdefaultcase>
							</cfswitch>
						</li>
					</cfloop>
				<cfelse>
					<li>
						<span class="fa-li"><i class="#getfileType(File)# #Attributes.iconclass#"></i></span>
						<cfset _key = encrypt(qFiles.FileId & "-" & request.user.userid, skey, 'AES/CBC/PKCS5Padding', 'Hex')/>
						<a href="attachment/index.cfm?file=#_key#" target="_blank">#listlast(File,'/')#</a>
					</li>
				</cfif>
			</cfloop>
			</ul>
			<cfif qFiles.recordcount eq 0>
				<p class="text-center">No document attached...</p>
			</cfif>
		</cfcase>
		<cfcase value="grid">
			<div class="row">
				<cfloop query="qFiles">
					<div class="col-sm-#Attributes.columnsize# thumb">
						<cfset _key = encrypt(qFiles.FileId & "-" & request.user.userid, skey, 'AES/CBC/PKCS5Padding', 'Hex')/>
						<a class="thumbnail" href="attachment/index.cfm?file=#_key#" target="_blank">
							#listlast(File,'/')#
						</a>
					</div>
				</cfloop>
				<cfif qFiles.recordcount eq 0>
					<div class="col-sm-12 text-center">No document attached...</div>
				</cfif>
			</div>
		</cfcase>

	</cfswitch>

</cfif>
</cfoutput>