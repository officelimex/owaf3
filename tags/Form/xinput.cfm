<cfoutput>
<cfif ThisTag.ExecutionMode == "Start">

    <cfparam name="Attributes.TagName" type="string" default="Input"/>
    <cfparam name="Attributes.type" type="string" default="text"/><!--- number, text, date, (range, range-double), mask --->
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.value" type="string" default=""/>

    <cfparam name="Attributes.focus" type="boolean" default="false"/>

    <cfparam name="Attributes.required" type="boolean" default="false"/>
    <cfparam name="Attributes.readonly" type="boolean" default="false"/>
    <cfparam name="Attributes.min" type="any" default="0"/> <!--- numeric/date --->
    <cfparam name="Attributes.max" type="any" default="0"/> <!--- numeric/date --->
    <cfparam name="Attributes.length" type="any" default=""/> <!--- The maxlength attribute specifies the maximum number of characters allowed --->
    <cfparam name="Attributes.static" type="boolean" default="false"/> <!--- for datetime in a modal --->

    <cfparam name="Attributes.class" type="string" default=""/>

    <cfparam name="Attributes.help" type="string" default=""/>
    <cfparam name="Attributes.label" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.icon" type="string" default=""/>
    <cfparam name="Attributes.iconClass" type="string" default=""/>
    <cfparam name="Attributes.autocomplete" type="boolean" default="false"/>
    <cfparam name="Attributes.UCase" type="boolean" default="false"/>
    <cfparam name="Attributes.LCase" type="boolean" default="false"/>
    <cfparam name="Attributes.TCase" type="boolean" default="false"/>

    <cfparam name="Attributes.accept" type="string" default=""/>

    <cfparam name="Attributes.placeholder" type="string" default=""/>

		<cfif attributes.label == "">
			<cfset attributes.label = "&nbsp;"/>
		</cfif>

    <cfparam name="Attributes.hideLabel" type="boolean" default="false"/>
		<cfparam name="Attributes.size" type="string" default="col-sm-6"/>
		
    <cfparam name="Attributes.labelCol" type="string" default=""/>
		<cfparam name="Attributes.valueCol" type="string" default=""/>
		
    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>

    <cfparam name="Attributes.allowClear" type="boolean" default="false"/><!--- for date ---->

		<cfif left(Attributes.type, 5) == "range">
			<!--- range --->
    	<cfparam name="Attributes.from" type="string" default="0"/>
			<cfparam name="Attributes.to" type="string" default="0"/>
			
    	<cfparam name="Attributes.rangevalue" type="string" default=""/>
    	<cfparam name="Attributes.separator" type="string" default=""/>
			
			<!--- skin --->
			<cfparam name="Attributes.skin" type="string" default="round"/>
			<cfparam name="Attributes.suffix" type="string" default=""/>
		</cfif>

	<!--- date- ---->

		<cfparam name="Attributes.displayFormat" type="string" default="F j, Y"/>
		<cfparam name="Attributes.dateFormat" type="string" default="yyyy-mm-dd"/>
		<cfparam name="Attributes.startDate" type="string" default=""/>

		<cfparam name="Attributes.Range" type="string" default="false"/> <!--- true, false, later - implement year, month range --->
		<cfparam name="Attributes.Multiple" type="string" default="false"/> <!--- true, false, later - implement year, month range --->
		<cfparam name="Attributes.inline" type="string" default="false"/>

		<cfparam name="Attributes.defaultDate" type="string" default=""/>
		<cfparam name="Attributes.disabledDate" type="string" default=""/> <!--- make some date not click able --->


    <cfparam name="Attributes.hideInputField" type="string" default=""/> <!--- style of the input for date --->

		<cfif isdate(attributes.min)>
			<cfset Attributes.startDate = dateFormat(Attributes.min, 'yyyy-mm-dd')/>
		</cfif>

		<cfif isdate(attributes.max)>
			<cfset Attributes.endDate = dateFormat(Attributes.max, 'yyyy-mm-dd')/>
		</cfif>


		<!---
			0 or 'hour' for the hour view
			1 or 'day' for the day view
			2 or 'month' for month view (the default)
			3 or 'year' for the 12-month overview
			4 or 'decade' for the 10-year overview. Useful for date-of-birth datetimepickers.
		--->

	<!---- datetime ----->

		<cfparam name="Attributes.datetimeformat" type="string" default="yyyy-mm-dd H:ii P"/>

	<!-------------------->

	<!--- money ---->
    <cfparam name="Attributes.precision" type="numeric" default="2"/>
    <cfparam name="Attributes.prefix" type="string" default=""/>
	<!-------------->

	<!--- number --->
		<cfparam name="Attributes.step" type="numeric" default="0"/>
	<!------------->

    <cfif attributes.type == 'date'>
			<cfif isdate(attributes.value)>
				<cfset Attributes.value = dateFormat(Attributes.value,'yyyy-mm-dd')/>
			</cfif>
		</cfif>
		
	<cfset ArrayAppend(request.form.input, Attributes)/>

	<cfset cf_xform = getBaseTagData("cf_xform").Attributes/>

	<cftry>

		<cfset cf_row = getBaseTagData("cf_frow").ATTRIBUTES.TagName/>
		<cfcatch type="any">
			<cfset cf_row = ""/>
		</cfcatch>

	</cftry>


<cfelse>


	<cfif cf_row == "">
		<div class="form-group <cfif attributes.labelCol != ''>row align-items-center</cfif> ">
	<cfelse>
		<div class="#Attributes.size# pad-top-10">
	</cfif>
			<cfif Attributes.type is "hidden">
				<cfset Attributes.hidelabel = true/>
			</cfif>
			<cfset cls = "form-control"/>
				<cfif Attributes.type is "date">
					<cfset cls = ""/>
				</cfif>

			<cfset focus = ""/>
			<cfif attributes.focus>
				<cfset focus = " autofocus "/>
			</cfif>

			<cfif !Attributes.hidelabel>

				<cfif !cf_xform.useplaceholder>
					<label for="#Attributes.id#" class="#attributes.labelCol#">
						<cfif len(Attributes.icon)>
							<i class="#Attributes.iconClass# fal fa-#Attributes.icon#"></i>
						</cfif>
						#Attributes.label# <cfif Attributes.required><sup class="text-danger">●</sup></cfif>
					</label>
				</cfif>

			</cfif>

			<cfset place_holder_att = ''/>
			<cfif cf_xform.useplaceholder>
				<cfset place_holder_att = 'placeholder="#Attributes.label#"'/>
			<cfelse>
				<cfif Attributes.placeholder != "">
					<cfset place_holder_att = 'placeholder="#Attributes.placeholder#"'/>
				</cfif>
			</cfif>

			<cfswitch expression="#Attributes.type#">
				
				<cfcase value="range,range-double" delimiters=",">
					<input type="text"
						class="js-range-slider"
						id="#Attributes.id#"
						name="#Attributes.name#"
						value="#Attributes.value#"
						data-min="#Attributes.min#"
						data-max="#Attributes.max#"
						data-from="#attributes.from#"
						data-step="#attributes.step#"
						<cfif attributes.separator != "">
							data-input-values-separator="#attributes.separator#"
						</cfif>
						<cfif attributes.to != "">
							data-to="#attributes.to#"
						</cfif>
						<cfif Attributes.rangevalue != "">
							data-values="#attributes.rangevalue#"
						</cfif>
						<cfif attributes.type != "range">
							data-type="#listlast(attributes.type,'-')#"
						</cfif>
						<cfif attributes.suffix != "">
							data-postfix=" #Attributes.suffix#"
						</cfif>
						data-skin="#Attributes.skin#"
						data-grid="true" />
				</cfcase>

				<cfcase value="date">
					<div class="date form_date #attributes.valueCol#" id="dtp#Attributes.id#">
						<input class="form-control  #Attributes.class#" id="#Attributes.id#" value="#Attributes.value#" name="#Attributes.name#" type="text" <cfif Attributes.autocomplete == false>autocomplete="off"</cfif> <cfif Attributes.readonly>readonly</cfif> <cfif Attributes.required>required readonly</cfif> >
					</div>
				</cfcase>

				<cfcase value="datetime">
					<div class=" date form_datetime" id="dtp#Attributes.id#">
						<input class="form-control #Attributes.class#" id="#Attributes.id#" value="#Attributes.value#" name="#Attributes.name#" type="text" <cfif Attributes.autocomplete == false>autocomplete="off"</cfif> <cfif Attributes.readonly>readonly</cfif> <cfif Attributes.required>required readonly</cfif> >
					</div>
				</cfcase>

				<cfcase value="money">
					<div class="#attributes.valueCol#">
						<input
							type="text"
							<cfif Attributes.autocomplete == false>autocomplete="off"</cfif>
							<cfif Attributes.prefix != "">data-prefix="#Attributes.prefix# "</cfif>
							<cfif Attributes.readonly>readonly</cfif>
							value="#trim(numberformat(attributes.value,'9,999.9999'))#" class="#cls# tag-xmoney text-right"
							name="#Attributes.name#"
							id="#Attributes.id#"
							data-precision="#Attributes.precision#"
								#place_holder_att#
								<cfif Attributes.required>required </cfif>
							<!---TODO: min and max not supported yet because of the , in the money --->
								<!----cfif val(Attributes.min)>min="#Attributes.min#"</cfif>
								<cfif val(Attributes.max)>max="#Attributes.max#"</cfif---->
							/>
					</div>
				</cfcase>

				<cfcase value="mask">
					<input
						type="text"
						<cfif Attributes.autocomplete == false>autocomplete="off"</cfif>
						<cfif Attributes.readonly>readonly</cfif>
						data-mask="#Attributes.format#" 
						<cfif Attributes.format == "____/__/__">
							value="#dateformat(attributes.value,'yyyy/mm/dd')#"
						<cfelse>
							value="#attributes.value#"
						</cfif>class="#cls#"
						name="#Attributes.name#"
						id="#Attributes.id#" 
							<cfif Attributes.required>required </cfif>
						/>
				</cfcase>

				<cfcase value="number">
					<div class="#attributes.valueCol#">
						<input type="number" #focus# <cfif Attributes.autocomplete == false>autocomplete="off"</cfif> value="#attributes.value#" <cfif Attributes.readonly>readonly</cfif> class="#cls# #Attributes.class#" name="#Attributes.name#" id="#Attributes.id#"
							#place_holder_att#
							<cfif val(Attributes.step)> step="#Attributes.step#" </cfif>
							<cfif Attributes.required> required </cfif>
							<cfif val(Attributes.min)>min="#Attributes.min#"</cfif>
							<cfif val(Attributes.max)>max="#Attributes.max#"</cfif>
							<cfif val(Attributes.length)>maxlength="#Attributes.length#"</cfif>
						/>
					</div>
				</cfcase>

				<cfcase value="hidden">
					<input type="hidden" value="#encrypt(attributes.value, application.awaf.secretkey, 'AES/CBC/PKCS5Padding', 'HEX')#" name="___$#encrypt(attributes.name, application.awaf.secretkey, 'AES/CBC/PKCS5Padding', 'HEX')#"/>
				</cfcase>

				<cfdefaultcase>
					<div class="#attributes.valueCol#">
						<input
						type="#Attributes.type#"
						#focus#
						<cfif Attributes.accept neq "">accept="#attributes.accept#"</cfif>
						<cfif Attributes.UCase>onblur="this.value = this.value.toUpperCase()"</cfif>
						<cfif Attributes.LCase>onblur="this.value = this.value.toLowerCase()"</cfif>
						<cfif Attributes.TCase>onblur="this.value = toTitleCase(this.value)"</cfif>
						<cfif Attributes.autocomplete == false>autocomplete="off"</cfif> <cfif Attributes.readonly>readonly</cfif> value="#attributes.value#" class="#cls# #Attributes.class#" name="#Attributes.name#" id="#Attributes.id#"
							#place_holder_att#
							<cfif Attributes.required>required </cfif>
							<cfif val(Attributes.min)>minlength="#Attributes.min#"</cfif>
							<cfif val(Attributes.max)>maxlength="#Attributes.max#"</cfif>
						/>
					</div>
				</cfdefaultcase>
			</cfswitch>

			<cfif Attributes.help != "">
				<cfif attributes.labelCol == "">
					<small class="form-text text-muted">#Attributes.help#</small>
				<cfelse>
					<div class="#attributes.labelCol#"></div>
					<div class="#attributes.valueCol#"><small class="form-text text-muted">#Attributes.help#</small></div>
				</cfif>
			</cfif>

	</div>

	<cfswitch expression="#attributes.type#">

		<cfcase value="date,datetime" delimiters=",">
			<script type="text/javascript">
				$('###Attributes.id#').flatpickr({
					<cfif attributes.type == "date">
						altFormat: "#Attributes.displayFormat#",
						dateFormat: "Y-m-d",
						<cfif isdate(attributes.max)>
							maxDate : '#attributes.endDate#',
						</cfif>
						<cfif isdate(attributes.min)>
							minDate : '#attributes.startDate#',
						</cfif>
					<cfelse>
						enableTime : true,
						dateFormat: "Y-m-d H:i",
						<cfif attributes.static>
							static: true,
						</cfif>
					</cfif>
					<cfif attributes.Range == "true">
						mode : 'range',
					</cfif>
					<cfif attributes.multiple == "true">
						mode : 'multiple',
						<cfif attributes.defaultDate != "">
							defaultDate : #attributes.defaultDate#,
						</cfif>
					</cfif>
					<cfif attributes.inline == "true">
						inline : true,
					</cfif>
					<cfif attributes.disabledDate != "">
						disable: #attributes.disabledDate#,
					</cfif>
    			altInput: true
				});
			</script>
		</cfcase>

	</cfswitch>

</cfif>
</cfoutput>