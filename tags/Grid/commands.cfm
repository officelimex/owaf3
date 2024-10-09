<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

   <cfparam name="Attributes.TagName" type="string" default="Commands"/>
   <cfparam name="Attributes.iconprefix" type="string" default="fal fa-"/>
   <cfparam name="Attributes.buttontypeprefix" type="string" default="btn-"/>

   <cfassociate basetag="cf_Columns"/>

   <cfset request.grid.commands = ArrayNew(1)/>

   <th>

 <cfelse>

   </th>

</cfif>
</cfoutput>
