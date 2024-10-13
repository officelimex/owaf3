<cfoutput>
<cfif ThisTag.ExecutionMode == "Start">

	<cfparam name="Attributes.TagName" type="string" default="BlockItem"/>
	<cfparam name="Attributes.label" type="string"/>
	<cfparam name="Attributes.value" type="string" default=""/>
	<cfparam name="Attributes.class" type="string" default=""/>
	<cfparam name="Attributes.textClass" type="string" default=""/>
	<cfparam name="Attributes.format" type="string" default=""/> <!--- money, email, address, phone, date --->
	<cfparam name="Attributes.prefix" type="string" default=""/>
	<cfparam name="Attributes.removeBlank" type="boolean" default="false"/>
	<cfparam name="Attributes.icon" type="string" default=""/>
	<cfparam name="Attributes.iconType" type="string" default="fal fa-"/>
	<cfparam name="Attributes.itemClass" type="string" default=""/>
	<cfparam name="Attributes.valueStyle" type="string" default=""/>
	<cfparam name="Attributes.lableClass" type="string" default=""/>
	<cfparam name="Attributes.iconClass" type="string" default=""/>
	<cfparam name="Attributes.suffix" type="string" default=""/>
	<cfparam name="Attributes.help" type="string" default=""/>
	<cfparam name="Attributes.showEmptyValue" type="boolean" default="false"/>
	<cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>

	<cfset allow_blank = true/>
	<cfif !(len(trim(Attributes.value)))>
	<cfif Attributes.removeBlank>
		<cfset allow_blank = false/>
	</cfif>
	</cfif>

	<cfif allow_blank>

		<cfswitch expression="#attributes.format#">
			<cfcase value="address">
				<address id="#Attributes.id#">
				<h6 class="header-pretitle #Attributes.lableClass#">
					<i class="#attributes.icontype#address-book #Attributes.iconclass#"></i>
					#__showInfo()#
				</h6>
				#replace(Attributes.value,chr(10),'<br/>','all')#
			</address>
			</cfcase>
			<cfcase value="email">
				<h6 class="header-pretitle #Attributes.lableClass#">
					<i class="#attributes.icontype#envelope #Attributes.iconclass#"></i>
					#__showInfo()#
				</h6>
			<p id="#Attributes.id#">
				<cfset emailList = replace(Attributes.value,";",",","all")/>
				<cfloop list="#emailList#" item="em">
					<a href="mailto:#em#" class="#Attributes.textclass#">#em#</a><br/>
				</cfloop>
			</p>
			</cfcase>
			<cfcase value="date">
			<h6 class="header-pretitle #Attributes.lableClass#">
				<cfif Attributes.icon != "">
						<i class="#attributes.icontype##Attributes.icon# #Attributes.iconclass#"></i>
				</cfif>
				#__showInfo()#
			</h6>
			<p id="#Attributes.id#" class="#Attributes.itemClass#">#Attributes.prefix# #dateFormat(Attributes.value,'dd-mmm-yyyy')#</p>
		</cfcase>
			<cfcase value="datetime">

			<h6 class="header-pretitle #Attributes.lableClass#">
				<cfif Attributes.icon != "">
						<i class="#attributes.icontype##Attributes.icon# #Attributes.iconclass#"></i>
				</cfif>
				#__showInfo()#
			</h6>
			<p id="#Attributes.id#">#Attributes.prefix# #dateTimeFormat(Attributes.value,'d, mmm yyyy — h:nn tt')#
			</p>
		</cfcase>
		<cfcase value="money">
			<div class="#attributes.class#">
				<cfif Attributes.prefix == "">
					<cfset Attributes.prefix = "₦"/>
				</cfif>

				<h6 class="header-pretitle #Attributes.lableClass#">
					<cfif Attributes.icon != "">
						<i class="#attributes.icontype##Attributes.icon# #Attributes.iconclass#"></i>
					</cfif>
					#__showInfo()#
				</h6>
				<p id="#Attributes.id#" <cfif Attributes.itemClass !="">class="#Attributes.itemClass#"</cfif> <cfif Attributes.valueStyle != "">style="#Attributes.valueStyle#"</cfif>>#Attributes.prefix# #numberFormat(Attributes.value,'9,999.99')# #Attributes.suffix#</p>
			</div>
		</cfcase>
		<cfcase value="phone">
			<h6 class="header-pretitle #Attributes.lableClass#">
				<i class="#attributes.icontype#phone #Attributes.iconclass#"></i>
				#__showInfo()#
			</h6>
			<p id="#Attributes.id#">#Attributes.prefix# #Attributes.value#</p>
		</cfcase>
		<cfdefaultcase>
			<div class="#attributes.class#">
				<h6 class="header-pretitle #Attributes.lableClass#">
					<cfif Attributes.icon != "">
						<i class="#attributes.icontype##Attributes.icon# #Attributes.iconclass#"></i>
					</cfif>
					#__showInfo()#
				</h6>
				<cfset _v = "#replace(Attributes.value,chr(10),'<br/>','all')# #Attributes.suffix#"/>
				<p id="#Attributes.id#" <cfif Attributes.itemClass !="">class="#Attributes.itemClass#"</cfif> <cfif Attributes.valueStyle != "">style="#Attributes.valueStyle#"</cfif>>
					#_v#
					<cfif !len(trim(_v)) && Attributes.showEmptyValue>
						EMPTY
					</cfif>
				</p>
				
			</div>
		</cfdefaultcase>
		</cfswitch>

   	</cfif>

</cfif>

	<cfscript>

		private void function __showInfo()	{
			if(Attributes.label != "")	{
				writeOutput(Attributes.label)
			}
			if(Attributes.help != "")	{
				writeOutput(' <i class="fas fa-info-circle text-info" title="#Attributes.help#"></i>')
			}
		}

	</cfscript>
</cfoutput>