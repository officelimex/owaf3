<cfcomponent>

	<cffunction name="Pmt" returntype="numeric" access="public">

		<cfargument name="r" required="no" type="any">
		<cfargument name="np" required="no" type="any">
		<cfargument name="pv" required="no" type="any">
		<cfargument name="fv" required="no" type="any" default="0">
		
		<cfif r == 0>
			<cfset pmt = abs(pv/np)/>
		<cfelse>
			<cfset r = r / 1200 />
			<cfset pmt = - ( r * (fv + power((1 + r), np) * pv) / (-1 + power((1 + r), np))) />
		</cfif>

		<cfreturn pmt />

	</cffunction>

	<cffunction name="power" returntype="any" access="public">

		<cfargument name="a"  type="numeric" required="yes" />
		<cfargument name="b" type="numeric" required="yes" />

		<cfset temp = a />

		<cfif b GT 1>

			<cfloop from="1" to="#b-1#" index="i">
				<cfset temp = temp * a />
			</cfloop>

		</cfif>

		<cfreturn temp />

	</cffunction>

</cfcomponent>