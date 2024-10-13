<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Button"/>
    <cfparam name="Attributes.title" type="string" default=""/>
    <cfparam name="Attributes.help" type="string" default="#Attributes.title#"/>
    <cfparam name="Attributes.tip" type="string" default="#Attributes.help#"/>

    <cfparam name="Attributes.isDivider" type="boolean" default="false"/>
    <cfparam name="Attributes.url" type="string" default=""/>
    <cfparam name="Attributes.class" type="string" default=""/>
    <cfparam name="Attributes.cssStyle" type="string" default=""/>

    <cfparam name="Attributes.printURL" type="string" default=""/> <!--- for printing out --->
    <cfparam name="Attributes.blankPageURL" type="string" default=""/> <!--- for opening a new blank page --->

    <cfparam name="Attributes.urlparam" type="string" default=""/>

    <cfparam name="Attributes.modalurl" type="string" default=""/>
    <cfparam name="Attributes.modalTitle" type="string" default="#Attributes.help#"/>
    <cfparam name="Attributes.modalposition" type="string" default=""/>

    <cfparam name="Attributes.icontype" type="string" default="fal fa-" />
    <cfparam name="Attributes.icon" type="string" default="" />
    <cfparam name="Attributes.type" type="string" default=""/> <!--- ajax,link,external,modal,print,modal --->

    <cfswitch expression="#Attributes.type#">
        <cfcase value="modal">
            <cfset Attributes.modalurl = Attributes.url/>
            <cfset Attributes.url = ""/>
        </cfcase>
        <cfcase value="print">
            <cfset Attributes.printurl = Attributes.url/>
            <cfset Attributes.url = ""/>
        </cfcase>
        <cfcase value="blank,blankpage">
            <cfset Attributes.blankpageurl = Attributes.url/>
        </cfcase>
        <cfdefaultcase></cfdefaultcase>
    </cfswitch>
    <cfparam name="Attributes.style" type="string" default="default"/>
    <cfparam name="Attributes.size" type="string" default=""/><!--- btn-sm, btn-sm --->

    <cfparam name="Attributes.action" type="string" default=""/><!--- process ajax request --->
    <cfparam name="Attributes.redirect" type="string" default=""/><!--- depreciate --->
    <cfparam name="Attributes.redirectURL" type="string" default="#Attributes.redirect#"/>
    <cfparam name="Attributes.renderTo" type="string" default=""/><!--- where to render the page to --->
    <cfif Attributes.renderTo neq "">
        <cfparam name="Attributes.changeURL" type="boolean" default="false"/>
    <cfelse>
        <cfparam name="Attributes.changeURL" type="boolean" default="true"/>
    </cfif>

    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
    <cfparam name="Attributes.responseMsg" type="string" default=""/><!--- depreciate --->
    <cfparam name="Attributes.flashMessage" type="string" default="#Attributes.responsemsg#"/>
    <cfparam name="Attributes.forcePageReload" type="boolean" default="false"/> <!--- depreciate, change force --->
    <cfparam name="Attributes.force" type="boolean" default="#Attributes.forcePageReload#"/> <!--- depreciate --->

    <cfif attributes.action is not "">
        <cfparam name="Attributes.confirm" type="string" default="Are you sure"/>
    </cfif>
    <cfif Attributes.forcePageReload>
        <cfparam name="Attributes.confirm" type="string" default="Are you sure you want to reload the content of this section. any unsaved content will be lost?"/>
    <cfelse>
        <cfparam name="Attributes.confirm" type="string" default=""/>
    </cfif>

    <cfparam name="Attributes.disableAfterSuccess" type="boolean" default="false"/>

    <!--- check the role permission --->

    <cfif Attributes.action neq "">
        <cfparam name="Attributes.closeModal" type="boolean" default="true"/>
    </cfif>

    <cfparam name="Attributes.closeModal" type="boolean" default="false"/>

    <cfset nurl = Attributes.url/>
    <cfif Attributes.printurl is not "">
        <cfset nurl = Attributes.printurl/>
        <cfset Attributes.printurl = replace(Attributes.printurl,'.','/','all')/>
        <cfset Attributes.printurl = replace(Attributes.printurl,'@','&key=')/>
    </cfif>

    <cfif Attributes.blankpageurl is not "">
        <cfset Attributes.blankpageurl = replace(Attributes.blankpageurl,'.','/','all')/>
    </cfif>

    <cfif Attributes.modalurl is not "">
        <cfset nurl = Attributes.modalurl/>
    </cfif>

    <cfif Attributes.action neq "">

        <cfset method =  listlast(listfirst(listlast(Attributes.action,'?'),'&'),'=')/>
        <cfset control = replace(listFirst(Attributes.action,'.'),'/','.')/>

        <cfset nurl = control & '.' & method/>

    </cfif>

    <cfif listFindNoCase(request.user.pageURLs, listfirst(nurl,'@')) or Attributes.IsDivider>
        <!---cfassociate basetag="cf_Buttons" /--->
        <cfset ArrayAppend(request.buttons,Attributes)/>
    </cfif>

</cfif>
</cfoutput>