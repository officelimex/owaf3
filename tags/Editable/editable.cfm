<cfoutput>
<!--- vitalets.github.io/x-editable/docs.html --->

<cfif ThisTag.ExecutionMode == "Start">

    <cfparam name="Attributes.TagName" type="string" default="Editable"/>

    <cfparam name="Attributes.id" type="string" default="#application.fn.getRandomVariable()#"/>
    <cfparam name="Attributes.name" type="string"/> <!--- the name of the field to save --->

    <cfparam name="Attributes.pk" type="string" default=""/>
    <cfparam name="Attributes.title" type="string" default=""/>
    <cfparam name="Attributes.rows" type="numeric" default="4"/>
    <cfparam name="Attributes.type" type="string" default="text"/>
    <cfparam name="Attributes.display" type="string" default=""/>
    <cfparam name="Attributes.secure" type="boolean" default="false"/>

    <cfparam name="Attributes.help" type="string" default=""/>
    <cfparam name="Attributes.label" type="string" default=""/>

    <cfparam name="Attributes.Min" type="string" default=""/>
    <cfparam name="Attributes.Max" type="numeric" default="0"/>

    <cfparam name="Attributes.viewFormat" type="string" default="d, mmm yyyy"/>

    <cfparam name="Attributes.value" type="string" default=""/>
    <cfswitch expression="#Attributes.type#">
		<cfcase value="combodate">
			<cfset Attributes.value = dateformat(Attributes.value, Attributes.viewFormat)/>
		</cfcase>
		<cfcase value="date">
			<cfset Attributes.value = dateformat(Attributes.value, Attributes.viewFormat)/>
		</cfcase>
    </cfswitch>
    <cfparam name="Attributes.defaultvalue" type="string" default="#attributes.value#"/>
    <cfparam name="Attributes.prepend" type="string" default=""/>
    <cfparam name="Attributes.emptyText" type="string" default="#Attributes.prepend#"/>

    <cfparam name="Attributes.model" type="string"/>

    <cfparam name="Attributes.template" type="string" default="D / MMM / YYYY"/>
    <cfparam name="Attributes.Animation" type="boolean" default="false"/>
    <cfparam name="Attributes.onSave" type="string" default=""/>  <!--- javascript function to do stuff you want after saving --->
    <cfparam name="Attributes.onSaveParam" type="string" default=""/>
    <!--- type of input
	text, textarea, select, date, datetime, dateui, combodate, html5types, checklist, wysihtml5, typeahead,typeaheadjs, select2
    end type --->
    <cfparam name="Attributes.showButtons" type="string" default="false"/>  <!---- boolean|position --->
    <cfparam name="Attributes.mode" type="string" default="inline"/> <!--- popup,inline --->


    <cfparam name="Attributes.source" type="any" default=""/>
    <!---
		If array - it should be in format: [{value: 1, text: "text1"}, {value: 2, text: "text2"}, ...]
		For compatibility, object format is also supported: {"1": "text1", "2": "text2" ...} but it does not guarantee elements order.
      --->

<cfelse>
	<!---cfset new_value = replace(Attributes.value, chr(10), "<br/>", 'all')/--->
	<cfif Attributes.label != "">
		<div class="bold" style="padding:5px 0px;">#attributes.label#:</div>
	</cfif>
	<div class="#Attributes.type#">
		<cfswitch expression="#Attributes.type#">
			<cfcase value="select,select2">
				<a href="javascript:;" id="#Attributes.Id#" class="editable editable-click" style="display: inline; background-color: rgba(0, 0, 0, 0);"></a>
			</cfcase>
			<cfdefaultcase>
				<a href="javascript:;" <cfif Attributes.help <> "">title="#Attributes.help#"</cfif> id="#Attributes.Id#"  <cfif Attributes.type eq "number">data-oldvalue="#Attributes.value#"</cfif>  class="editable editable-click" style="display: inline; background-color: rgba(0, 0, 0, 0);">#replace(Attributes.value,chr(10),'<br/>&##13;','all')#</a>
			</cfdefaultcase>
		</cfswitch>
	<script>
	$(document).ready(function() {

		<cfif Attributes.onsave neq "">
			$('###Attributes.id#').on('save', function(event, param) {
			    //alert('Saved value: ' + param.newValue);
			    var x = "#Attributes.onsaveParam#";
					<cfloop list="#Attributes.onsave#" delimiters=";" item="fn">
						#fn#(event, param, x);
					</cfloop>
			});
		</cfif>


	    $('###Attributes.id#').editable({
	    	<cfif Attributes.pk neq "">
	    		'pk' : '#Attributes.pk#',
	    	</cfif>
	    	<cfif Attributes.title neq "">
	    		'title' : #Attributes.title#,
	    	</cfif>
	        <cfif !isEmpty(Attributes.source)>
				'source':
					<cfif isArray(attributes.Source)>
						[<cfset i=0/>
						<cfloop array="#attributes.Source#" item="src">
							<cfset i++/>
							{<cfif IsDefined("src.VALUE")>
								value: #serialize(src.VALUE)#,
							<cfelse>
								id: #serialize(src.id)#,
							</cfif>
							text: #serializeJSON(src.text)#}<cfif attributes.Source.len() neq i>,</cfif>
						</cfloop>
						]
					<cfelse>
						#attributes.Source#
					</cfif>,
			</cfif>
		    <!---cfif !Attributes.Animation>
		    	anim : #Attributes.animation#,
		    </cfif--->
    		<cfif Attributes.emptyText neq "">
    			'emptytext':'#Attributes.emptyText#',
    		</cfif>

		    <cfswitch expression="#attributes.type#">
		    	<cfcase value="textarea">
		    		'rows' : #attributes.rows#,
		    		'escape':true,
		    		'onblur': 'submit',
		    		'showbuttons' : '#Attributes.showbuttons#',
		    	</cfcase>
		    	<cfcase value="combodate">
		    		'viewFormat' : '#Attributes.viewFormat#',
		    		'template' : '#Attributes.template#',
		    		'onblur' : 'submit',
		    	</cfcase>
		    	<cfcase value="date">
		    		'viewFormat' : 'd, M yyyy',
		    		'format':'yyyy/m/d',
		    		'onblur' : 'submit',
		    		'datepicker':{startView:1},
		    	</cfcase>
		    	<cfcase value="text">
		    		'showbuttons' : '#Attributes.showbuttons#',
		    	</cfcase>
		    	<cfcase value="number">
						<cfif attributes.Max>
							'max' : #attributes.Max#,
						</cfif>
						<cfif val(attributes.Min)>
							'min' : #attributes.Min#,
						</cfif>
		    		'step':'any',
		    		'onblur': 'submit',
		    		'showbuttons' : '#Attributes.showbuttons#',
		    	</cfcase>
					<cfcase value="money">
						'step':'any',
						'maxlength':'7',
						'onblur':'submit',
						'display': function(value, response) {
							var k = moneyFormat(value);
							$(this).text(k);
						},
					</cfcase>
		    	<cfcase value="checklist">
						 
				 
					</cfcase>
		    	<cfcase value="select,select2">
						 
						 <cfif Attributes.value neq "">
							 'value':'#Attributes.value#',
						 <cfelse>
							 <cfif Attributes.defaultvalue neq "">
								 'defaultValue':'#Attributes.defaultvalue#',
							 </cfif>
						 </cfif>
						 <cfif Attributes.prepend neq "">
							 'prepend':'#Attributes.prepend#',
						 </cfif>
						 'showbuttons' : false,
					 </cfcase>
		    	<cfdefaultcase>
		    		'onblur': 'submit',
		    		'showbuttons' : '#Attributes.showbuttons#',
		    	</cfdefaultcase>
		    </cfswitch>

			'url'  : 'owaf/tags/Editable/ajax.cfm?model_desc=#attributes.model#&min=#attributes.Min#&max=#attributes.Max#',

			<cfswitch expression="#attributes.type#">
				<cfcase value="money">
					'type' : 'number',
				</cfcase>
				<cfdefaultcase>
					'type' : '#attributes.type#',
				</cfdefaultcase>
			</cfswitch>
			'mode' : '#attributes.mode#',
			'name' : '#Attributes.name#',
			'error': function(errors) { showError(errors);}
	    });

	});
	</script>
	</div>

</cfif>
</cfoutput>
