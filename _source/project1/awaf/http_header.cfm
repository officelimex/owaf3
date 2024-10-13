<cfheader name="Vary" value="Accept-Encoding X-Device, X-Language, X-ABTests, X-Scenario, X-OS">
<cfheader name="Access-Control-Allow-Methods" value="POST, GET">
<cfheader name="strict-transport-security" value="max-age=15768000; includeSubDomains">
<!--- <cfheader name="X-Frame-Options" value="deny">
<cfheader name="X-XSS-Protection" value="1; mode=block;"> --->
<cfheader name="X-Content-Type-Options" value="nosniff">
<cfheader name="Server" value="Lucee">
<cfheader name="server_tokens" value="off">
<cfheader name="Referrer-Policy" value="same-origin">
<cfheader name="Content-Security-Policy" value="frame-ancestors 'none'">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate no-transform">