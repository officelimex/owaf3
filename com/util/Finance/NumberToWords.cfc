<!------------------------------------------//--- 
	Author: Arowolo Michael A.
--------------------------------------------//--->	

<cfcomponent displayname="Number to Words">

	<cffunction name="init" access="remote" returntype="NumberToWords" hint="initialize the component">
		<cfargument name="Number" type="string" required="yes">
        <cfargument name="Currency1" type="string" required="no" default="Naira">
        <cfargument name="Currency2" type="string" required="no" default="Kobo">
        
        <cfset this.number = replacenocase(arguments.Number,',','','all') />
        <cfif listLen(this.number,'.') eq 2>
			<cfset this.numberpart = ListLast(this.number,'.') />
        <cfelse>
        	<cfset this.numberpart = "" />
        </cfif>
        <cfset this.number = ListFirst(this.number,'.') />  
        <cfset variables.Words = "" /> 
        <cfset this.currency1 = arguments.currency1 />
        <cfset this.currency2 = arguments.currency2 /> 
        
		<cfreturn this />
	</cffunction>
    
    <cffunction name="Convert" access="remote" returntype="string">
    	<cfargument name="number" required="no" type="string" />
        
    	<cfif Not(structkeyexists(this,'number'))>
        	<cfset init(arguments.number) />
        </cfif>
        <cfset W1 = Process(this.number) />  
        <cfset W2 = Process(this.numberpart) />
        <cfset fullWord = W1 & " " & this.Currency1 />
        <cfif W2 neq "">
        	<cfset fullWord = fullWord & " " & W2 & " " & this.Currency2 />
        </cfif>
        
        <cfreturn fullWord/>
    </cffunction>
    
    <cffunction name="process" access="private" returntype="string" >
    	<cfargument name="iNumber" type="string" required="yes" />
        
        <cfset variables.Words = "" />
    	<cfswitch expression="#len(arguments.iNumber)#" >
        	<cfcase value="1"><cfset getUnit(right(iNumber,1)) /></cfcase>
            <cfcase value="2"><cfset getTens(right(iNumber,2)) /></cfcase>
            <cfcase value="3"><cfset getHundred(right(iNumber,3)) /></cfcase>
            <cfcase value="4"><cfset getThousand(right(iNumber,4)) /></cfcase>
            <cfcase value="5"><cfset getTenThousand(right(iNumber,5)) /></cfcase>
            <cfcase value="6"><cfset getHundredThousand(right(iNumber,6)) /></cfcase>
            <cfcase value="7"><cfset getMillion(right(iNumber,7)) /></cfcase>
            <cfcase value="8"><cfset getTenMillion(right(iNumber,8)) /></cfcase>
            <cfcase value="9"><cfset getHundredMillion(right(iNumber,9)) /></cfcase>
            <cfcase value="10"><cfset getBillion(right(iNumber,10)) /></cfcase>
        </cfswitch>
        
        <cfreturn variables.Words />
    </cffunction>

    <cffunction access="private" name="getBillion" returntype="void">
    	<cfargument name="stemp" required="yes" type="string" /> 
        
        <cfset var bil = left(arguments.stemp,1) />
        <cfset var hundmil = mid(arguments.stemp,2,9) />
        <cfset getUnit(bil) />
        <cfif val(bil) neq 0>
        	<cfset variables.Words = variables.Words & " Billion " /> 
        </cfif>
        <cfset getHundredMillion(hundmil) />
        
    </cffunction>
    
    <cffunction access="private" name="getHundredMillion" returntype="void">
    	<cfargument name="stemp" required="yes" type="string" /> 
        
        <cfset var hundmil = left(arguments.stemp,3) />
        <cfset var hundthou = mid(arguments.stemp,4,6) />
        <cfset getHundred(hundmil) />
        <cfif val(hundmil) neq 0>
        	<cfset variables.Words = variables.Words & " Million " /> 
        </cfif>
        <cfset getHundredThousand(hundthou) />
        
    </cffunction>
    
    <cffunction access="private" name="getTenMillion" returntype="void">
    	<cfargument name="stemp" required="yes" type="string" /> 
        
        <cfset var tenmil = left(arguments.stemp,2) />
        <cfset var hundthou = mid(arguments.stemp,3,6) />
        <cfset getTens(tenmil) />
        <cfif val(tenmil) neq 0>
        	<cfset variables.Words = variables.Words & " Million " /> 
        </cfif>
        <cfset getHundredThousand(hundthou) />
        
    </cffunction>
    
    <cffunction access="private" name="getMillion" returntype="void">
    	<cfargument name="stemp" required="yes" type="string" /> 
        
        <cfset var mil = left(arguments.stemp,1) />
        <cfset var hundthou = mid(arguments.stemp,2,6) />
        <cfset getUnit(mil) />
        <cfif val(mil) neq 0>
        	<cfset variables.Words = variables.Words & " Million " /> 
        </cfif>
        <cfset getHundredThousand(hundthou) />
        
    </cffunction>
    
    <cffunction access="private" name="getHundredThousand" returntype="void">
    	<cfargument name="stemp" required="yes" type="string" /> 
        
        <cfset var hundthou = left(arguments.stemp,3) />
        <cfset var hund = mid(arguments.stemp,4,3) />
        <cfset getHundred(hundthou) />
        <cfif val(hundthou) neq 0>
        	<cfset variables.Words = variables.Words & " Thousand " /> 
        </cfif>
        <cfset getHundred(hund) />
        
    </cffunction>
    
    <cffunction access="private" name="getTenThousand" returntype="void">
    	<cfargument name="stemp" required="yes" type="string" /> 
        
        <cfset var tenthou = left(arguments.stemp,2) />
        <cfset var hund = mid(arguments.stemp,3,3) />
        <cfset getTens(tenthou) />
        <cfif val(tenthou) neq 0>
        	<cfset variables.Words = variables.Words & " Thousand " /> 
        </cfif>
        <cfset getHundred(hund) />
        
    </cffunction>
    
    <cffunction access="private" name="getThousand" returntype="void">
    	<cfargument name="stemp" required="yes" type="string" /> 
        
        <cfset var thou = left(arguments.stemp,1) />
        <cfset var hund = mid(arguments.stemp,2,3) />
        <cfset getUnit(thou) />
        <cfif val(thou) neq 0>
        	<cfset variables.Words = variables.Words & " Thousand " /> 
        </cfif>
        <cfset getHundred(hund) />
        
    </cffunction>
    
    <cffunction access="private" name="getHundred" returntype="void">
    	<cfargument name="stemp" required="yes" type="string" /> 
        
        <cfargument name="bHundAnd" required="no" type="boolean" default="true" /> 
        <cfset var hund = left(arguments.stemp,1) />
        <cfset var tens = mid(arguments.stemp,2,2) />
        <cfset getUnit(hund) />
        <cfif val(hund) neq 0>
        	<cfset variables.Words = variables.Words & " Hundred " />
        </cfif>
        <cfif val(tens) neq 0>
        	<cfif arguments.bHundAnd>
        		<cfset variables.Words = variables.Words & " And " />
            </cfif>
        </cfif>
        <cfset getTens(tens) />
        
    </cffunction>
    
    <cffunction access="private" name="getTens" returntype="void">
    	<cfargument name="stemp" required="yes" type="string" /> 
        
        <cfset var unit = right(arguments.stemp,1) />
        <cfif arguments.stemp gt 9 and arguments.stemp lt 20> 
			<cfset getSpecialTens(arguments.stemp) /> 
        <cfelse>
            <cfswitch expression="#left(arguments.stemp,1)#">  
                <cfcase value="2"><cfset variables.Words = ListAppend(variables.Words,"Twenty"," ") /></cfcase>
                <cfcase value="3"><cfset variables.Words = ListAppend(variables.Words,"Thirty"," ") /></cfcase>
                <cfcase value="4"><cfset variables.Words = ListAppend(variables.Words,"forty"," ") /></cfcase>
                <cfcase value="5"><cfset variables.Words = ListAppend(variables.Words,"Fifty"," ") /></cfcase>
                <cfcase value="6"><cfset variables.Words = ListAppend(variables.Words,"Sixty"," ") /></cfcase>
                <cfcase value="7"><cfset variables.Words = ListAppend(variables.Words,"Seventy"," ") /></cfcase>
                <cfcase value="8"><cfset variables.Words = ListAppend(variables.Words,"Eighty"," ") /></cfcase>
                <cfcase value="9"><cfset variables.Words = ListAppend(variables.Words,"Ninety"," ") /></cfcase>
                <!--- special tens --->
            </cfswitch>
            <cfset getUnit(unit) />
        </cfif>
        
    </cffunction>

    <cffunction access="private" name="getSpecialTens" returntype="void">
    	<cfargument name="stemp" required="yes" type="string" /> 
        
        <cfswitch expression="#arguments.stemp#">
        	<cfcase value="10"><cfset variables.Words = ListAppend(variables.Words,"Ten"," ") /></cfcase>
        	<cfcase value="11"><cfset variables.Words = ListAppend(variables.Words,"Eleven"," ") /></cfcase>
            <cfcase value="12"><cfset variables.Words = ListAppend(variables.Words,"Twelve"," ") /></cfcase>
            <cfcase value="13"><cfset variables.Words = ListAppend(variables.Words,"thirteen"," ") /></cfcase>
            <cfcase value="14"><cfset variables.Words = ListAppend(variables.Words,"Fourteen"," ") /></cfcase>
            <cfcase value="15"><cfset variables.Words = ListAppend(variables.Words,"Fifteen"," ") /></cfcase>
            <cfcase value="16"><cfset variables.Words = ListAppend(variables.Words,"Sixteen"," ") /></cfcase>
            <cfcase value="17"><cfset variables.Words = ListAppend(variables.Words,"Seventeen"," ") /></cfcase>
            <cfcase value="18"><cfset variables.Words = ListAppend(variables.Words,"Eighteen"," ") /></cfcase>
            <cfcase value="19"><cfset variables.Words = ListAppend(variables.Words,"Nineteen"," ") /></cfcase> 
        </cfswitch>
        
    </cffunction>
          
    <cffunction access="private" name="getUnit" returntype="void">
    	<cfargument name="stemp" required="yes" type="string" /> 
        
        <cfswitch expression="#arguments.stemp#">
        	<cfcase value="1"><cfset variables.Words = ListAppend(variables.Words,"One"," ") /></cfcase>
            <cfcase value="2"><cfset variables.Words = ListAppend(variables.Words,"Two"," ") /></cfcase>
            <cfcase value="3"><cfset variables.Words = ListAppend(variables.Words,"Three"," ") /></cfcase>
            <cfcase value="4"><cfset variables.Words = ListAppend(variables.Words,"Four"," ") /></cfcase>
            <cfcase value="5"><cfset variables.Words = ListAppend(variables.Words,"Five"," ") /></cfcase>
            <cfcase value="6"><cfset variables.Words = ListAppend(variables.Words,"Six"," ") /></cfcase>
            <cfcase value="7"><cfset variables.Words = ListAppend(variables.Words,"Seven"," ") /></cfcase>
            <cfcase value="8"><cfset variables.Words = ListAppend(variables.Words,"Eight"," ") /></cfcase>
            <cfcase value="9"><cfset variables.Words = ListAppend(variables.Words,"Nine"," ") /></cfcase>
        </cfswitch>
        
    </cffunction>
    
</cfcomponent>