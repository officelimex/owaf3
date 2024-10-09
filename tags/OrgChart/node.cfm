<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="node"/>
    <cfparam name="Attributes.name" type="string" default=""/>
    <cfparam name="Attributes.title" type="string" default=""/>
    <cfparam name="Attributes.image" type="string" default=""/>
    <cfparam name="Attributes.contact" type="string" default=""/>
    <cfparam name="Attributes.parent" type="string" default="root"/>
    <cfparam name="Attributes.stackChildren" type="boolean" default="false"/>
    <cfparam name="Attributes.collapsed" type="boolean" default="true"/>

    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
    <cfif isNumeric(Attributes.id)>
        <cfset Attributes.id = "_" & Attributes.id/>
    </cfif>
    <cfif isNumeric(Attributes.parent)>
        <cfset Attributes.parent = "_" & Attributes.parent/>
    </cfif>
    <cfif Attributes.parent == "">
        <cfset Attributes.parent = "root"/>
    </cfif>
    <cfset request.org_chart_items = ListAppend(request.org_chart_items, Attributes.id)/>

    #Attributes.id# = {
        parent: #Attributes.parent#,
        <cfif attributes.image != "">
            image: "#attributes.image#",
        </cfif>
        <cfif attributes.stackChildren>
            "stackChildren" : #Attributes.stackChildren#,
        </cfif>
        text:{
            name: #serializejson(attributes.name)#,
            title: #serializejson(attributes.title)#,
            contact: #serializejson(attributes.contact)#
        },
        collapsed : #attributes.collapsed#
    }
 <!--- close tag --->
<cfelse>


</cfif>
</cfoutput>
