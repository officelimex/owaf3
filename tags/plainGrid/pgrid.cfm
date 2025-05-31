<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

	<cfparam name="Attributes.type" type="string" default="query"/>
	<cfparam name="Attributes.datasource" type="any"/>
	<cfparam name="Attributes.striped" type="boolean" default="true"/>
	<cfparam name="Attributes.hover" type="boolean" default="true"/>
	<cfparam name="Attributes.compressed" type="boolean" default="false"/>
	<cfparam name="Attributes.bordered" type="boolean" default="false"/>

	<cfset request.PlainGrid.footers = ArrayNew(1)/>

<cfelse>


<cfset cls = "table"/>
<cfif Attributes.striped><cfset cls = ListAppend(cls,"table-striped"," ")/></cfif>
<cfif Attributes.hover><cfset cls = ListAppend(cls,"table-hover"," ")/></cfif>
<cfif Attributes.compressed><cfset cls = ListAppend(cls,"table-condensed"," ")/></cfif>
<cfif Attributes.bordered><cfset cls = ListAppend(cls,"table-bordered"," ")/></cfif>

<!---<cfif Attributes.type eq "query">
	<cfset totalRecord = Attributes.datasource.recordcount/>
</cfif>--->
<div class="table-responsive">
<table class="#cls#">
<cfif isDefined("request.PlainGrid.caption")>
	<caption class="text-#request.PlainGrid.caption.align#" style="line-height:36px;">#request.PlainGrid.caption.Content#</caption>
</cfif>
<thead>
	<tr>
		<cfloop array="#request.PlainGrid.columns#" item="attr">
			<th class="#attr.class#"
				<cfif attr.align neq"">style="text-align:#attr.align#;"</cfif>
				<cfif attr.nowrap>  nowrap </cfif>
			>
				#attr.caption#
			</th>
		</cfloop>
	</tr>
</thead>
<tbody>
	<cfloop query="Attributes.datasource">
		<tr>
			<cfloop array="#request.PlainGrid.columns#" item="attr">
				<td class="#attr.class#"
					<cfif attr.align neq""> style="text-align:#attr.align#;" </cfif>
					<cfif attr.nowrap> nowrap </cfif>
				>
					<cfswitch expression="#attr.format#">
						<cfcase value="link">
							<cfset _id = evaluate(attr.value)/>
							<cfset _result = replace(attr.url,'@key','~' & _id)/>
							<a onclick="loadPage('#_result#',{})">#_id#</a>
						</cfcase>
						<cfcase value="modal">
							<cfset _id = evaluate(attr.value)/>
							<cfset _result = replace(attr.url,'@key','~' & _id)/>
							<a onclick="showModal('#_result#',{})">#_id#</a>
						</cfcase>
						<cfcase value="money">

							<cfset get_value = evaluate(attr.value)/>
							#numberformat(get_value,'_,___.00')#
							<cfset request.pGrid.sum[attr.value] = request.pGrid.sum[attr.value] + get_value/>

						</cfcase>
						<cfcase value="number">

							<cfset get_value = val(evaluate(attr.value))/>
							#numberformat(val(evaluate(attr.value)),'_,___')#
							<cfset request.pGrid.sum[attr.value] = request.pGrid.sum[attr.value] + get_value/>

						</cfcase>
						<cfcase value="date">
							#dateformat(evaluate(attr.value),'dd-mmm-yy')#
						</cfcase>
						<cfcase value="datetime">
							<cfset _vv = evaluate(attr.value)/>
							#dateformat(_vv,'dd-mmm-yy')#  #timeformat(_vv, 'hh:mm tt')#
						</cfcase>
						<cfcase value="html">
							<cfset rt = evaluate(attr.value)/>
							<cfset rt = replaceNoCase(rt, chr(10),'<br/>','all')/>
							#rt#
						</cfcase>
						<cfcase value="rating">
								<cfset rt = evaluate(attr.value)/>
								<cfset mx = val(right(attr.ratinglist,1))/>
								<cfloop list="#attr.ratinglist#" item="ritem">
								<cfif listfirst(ritem,'-') eq rt>
									<cfset count = listlast(ritem,'-')>
									<div>
									<cfloop from="1" to="#mx#" index="i">
											<cfif i gt count>
											<!---i class="fal fa-star-o" style="color:#attr.ratingcolor#"></i--->
											<i class="fal fa-star" style="color:gray"></i>
											<cfelse>
											<i class="fal fa-star" style="color:#attr.ratingcolor#"></i>
											</cfif>
									</cfloop>
									</div>
								</cfif>
								</cfloop>
							<cfif rt eq "">
									<cfloop from="1" to="#mx#" index="i">
										<i class="fal fa-star" style="color:gray"></i>
									</cfloop>
							</cfif>
							#rt#
						</cfcase>
						<cfcase value="status">
							<cfset rt = evaluate(attr.value)/>
							<span class="label label-#attr.status[rt]#">#rt#</span>
						</cfcase>
						<cfdefaultcase>
							<!--- check for template --->
							<cfif attr.template neq "">
								<!--- remove "]" --->
								<!---cfset ntemp = replace(attr.template,']','##','all')/>
								<cfset ntemp = replace(ntemp,'[','##','all')/--->
								<cfset ntemp = attr.template/>
								<cfloop list="#attr.template#" item="temp" delimiters="]">
									<!--- get the field name --->
									<cfset fld = listlast(temp,'[')/>
									<cfset fld_result = evaluate(fld)/>
									<cfif IsNumeric(fld_result)>
										<cfset fld_result = numberFormat(fld_result, '_,___')/>
									</cfif>
									<cfif isDate(fld_result)>
										<cfset fld_result = dateformat(fld_result, 'dd-mmm-yy')/>
									</cfif>
									<cfset ntemp = replaceNoCase(ntemp, '[' & fld & ']', fld_result)/>
								</cfloop>
								<cfset ntemp = replaceNoCase(ntemp, chr(10),'<br/>','all')/>
								#ntemp#
							<cfelse>
								<cfloop list="#attr.value#" delimiters="#attr.delimiters#" index="cur_value">
									<cfset rt = evaluate(cur_value)/>
									<cfset rt = replaceNoCase(rt, chr(10),'<br/>','all')/>
									#rt#
									<!---#evaluate(cur_value)#--->
								</cfloop>
							</cfif>
						</cfdefaultcase>
						</cfswitch>
				</td>
			</cfloop>
		</tr>
	</cfloop>
</tbody>
<!--- footer --->

<cfif request.PlainGrid.Footers.len()>
	<tfoot>
		<cfloop array="#request.PlainGrid.Footers#" item="attr_s">
			<tr class="#attr_s.class#">
				<cfloop array="#attr_s.footer#" item="attr">
					<td
						<cfif attr.span is not "">
							colspan="#attr.span#"
						</cfif>
						<cfif attr.style is not "">
							style="#attr.style#"
						</cfif>
						class="text-#attr.align# #attr.class# <cfif attr.clearborder>pg-clear-left-border</cfif> <cfif attr.nowrap>nowrap</cfif>"
					>
						<cfswitch expression="#attr.format#">
							<cfcase value="money">
								<cfif attr.sumColumn != "">
									<cfset _t = 0/>
									<cfloop list="#attr.sumColumn#" item="_sum">
										<cfset _t = _t + request.pGrid.sum[_sum]/>
									</cfloop>
									#numberFormat(_t ,'_,___.00')#
								<cfelse>
									#numberFormat(attr.content,'_,___.00')#
								</cfif>
							</cfcase>
							<cfdefaultcase>
								#attr.content#
							</cfdefaultcase>
						</cfswitch>
					</td>
				</cfloop>
			</tr>
		</cfloop>
	</tfoot>
</cfif>
</table>
</div>

</cfif>
</cfoutput>