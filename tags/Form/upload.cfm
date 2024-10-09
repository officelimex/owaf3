<!-----
@error 				: error to report to the client
@file_path 			: dynamic file path to place the file
@save_to_temp_first	: 	save the uploaded file to a 
						temporary location first. needs confirmation
						form the save controller from the caller.
-------------------------------------------------------------------->
<cfparam name="url.save_to_temp_first" default="true" type="boolean"/>

<!---- upload file to the server --->

<cflock timeout="60"  name="file" throwontimeout="true" type="EXCLUSIVE">
	

<cfset file_path = randRange(100,999) & "/" & randRange(100,999) & "/"/>
<cfif url.save_to_temp_first>
	<cfset path_to_save = expandPath("attachment/temp/" & file_path)/>
<cfelse>
	<cfset path_to_save = expandPath("attachment/" & file_path)/>
</cfif>


<cfif !directoryExists(path_to_save)>
	<cfdirectory action="create" directory="#path_to_save#"/>
</cfif>

<cfset error = ""/>

<cfoutput>

	<cftry>
		<cffile action="uploadall" destination="#path_to_save#" >
		<!--- save to the database file or temp --->
		<cfif url.save_to_temp_first>


		</cfif>
		<cfcatch type="any">
			<cfset error = cfcatch.message/>
		</cfcatch>
	</cftry>

	<cfif error eq "">
		{}
	<cfelse>
		{"error": #serializeJSON(error)#}
	</cfif> 
</cfoutput>


</cflock>