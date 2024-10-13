<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Input"/>
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.value" type="string" default=""/>

    <cfparam name="Attributes.required" type="boolean" default="false"/>

    <cfparam name="Attributes.min" type="numeric" default="0"/>
    <cfparam name="Attributes.max" type="numeric" />
    <cfparam name="Attributes.step" type="numeric" default="1" />
    <cfparam name="Attributes.start" type="string" default="1"/> <!--- can also be 10, 30 --->

    <cfparam name="Attributes.label" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
    <cfparam name="Attributes.format" type="string" default="integer"/>
    <cfparam name="Attributes.surffix" type="string" default=""/>
    <cfparam name="Attributes.suffix" type="string" default="#Attributes.surffix#"/>
    <cfparam name="Attributes.brigde" type="string" default="to"/>


<cfelse>

    <div style="padding-bottom:14px;font-weight:bold;">#Attributes.label#</div>
    <div class="row">
        <div class="col-xs-1"></div>
        <div class="col-xs-10">
            <div id="#Attributes.id#"></div>
        </div>
        <div class="col-xs-1"></div>
    </div>
    <cfset i=0/>
    <div class="row" style="padding-top:10px;">
        <cfloop list="#Attributes.name#" item="v">
            <cfset i++/>
            <input type="hidden" name="#v#" value="#listgetat(attributes.start,i)#" id="#Attributes.id#-element-#i#"/>
            <div class="<cfif i eq 1>col-xs-5 text-right<cfelse>col-xs-4</cfif>"><small id="#Attributes.id#-display-#i#" class="gray">#listgetat(attributes.start,i)#</small></div>
            <cfif i eq 1><div class="col-xs-1">#Attributes.brigde#</div></cfif>
        </cfloop>
    </div>

    <script>
        <cfset displayEl = application.fn.GetRandomVariable()/>
        <cfset hiddenEl = application.fn.GetRandomVariable()/>
        var #displayEl# = [
            <cfset i=0/>
            <cfloop list="#Attributes.name#" item="v">
                <cfset i++/>
                document.getElementById('#Attributes.id#-display-#i#')<cfif listlen(Attributes.name) neq i>,</cfif>
            </cfloop>
        ];
        var #hiddenEl# = [
            <cfset i=0/>
            <cfloop list="#Attributes.name#" item="v">
                <cfset i++/>
                document.getElementById('#Attributes.id#-element-#i#')<cfif listlen(Attributes.name) neq i>,</cfif>
            </cfloop>
        ];
        noUiSlider.create(document.getElementById('#Attributes.id#'), {
            connect: true,
            start: [ #Attributes.start# ],
            step:  #Attributes.step#,
            range: {
                'min': [ #Attributes.min# ],
                'max': [ #Attributes.max# ]
            }
        });
        document.getElementById('#Attributes.id#').noUiSlider.on('update', function( values, handle ) {
            <cfswitch expression="#attributes.format#">
                <cfcase value="integer">
                    #displayEl#[handle].innerHTML = formatMoney(values[handle], 0)
                </cfcase>
                <cfdefaultcase>
                    #displayEl#[handle].innerHTML = formatMoney(values[handle], 0)
                </cfdefaultcase>
            </cfswitch> + " #Attributes.suffix#";
            #hiddenEl#[handle].value = values[handle];
        });
    </script>

</cfif>
</cfoutput>