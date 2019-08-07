<%@ page language="java" contentType="application/json"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date,java.io.*,java.util.Properties" %>
<%
// get token info from properties
Properties prop = new Properties();
long tokenIssuedTime = 0;
String idToken = null;
long milliSecToLive = 60 * 1000; // 1 minute.
//Is authentication required?
boolean authenticationRequired = true;

try (InputStream is = new FileInputStream("C:/Temp/dynamic_token.properties")){
	prop.load(is);
	tokenIssuedTime = Long.parseLong(prop.getProperty("token_issued_time"));
	idToken = prop.getProperty("id_token");
	milliSecToLive = Long.parseLong(prop.getProperty("token_time_to_live_in_sec")) * 1000;
	authenticationRequired = Boolean.parseBoolean(prop.getProperty("authentication_required"));
} catch (Exception e) {
}
// No cache for this URL content.
response.setHeader("Cache-Control", "private, no-store, no-cache, must-revalidate");

// Request paramtere.
String param = request.getParameter("param");

if (!authenticationRequired) {
%>
{"msg": "<%= param %>"}
<%
} else {
		
	// Check as if user is logged in.
	String username = (String)session.getAttribute("username");
	if (username == null || "".equals(username)) { // User is not logged in.
		// Need authentication.
		response.setStatus(401);
%>
{"error-msg": "no username", "error-code": 0}
<%
	} else {
		if (tokenIssuedTime <= ((new Date().getTime()) - milliSecToLive)) { // Is the token expired?
			// Need authentication again or renew the ID token.
			response.setStatus(401);
%>
{"error-msg": "need refresh token", "error-code": 2}
<%
		} else {
			// Check as if ID token in Autherntication header matches to one in session object.
			// Retrieve ID token from session object.
			if (idToken == null) { // No ID token in properties.
				response.setStatus(401);
%>
{"error-msg": "ID token is not set", "error-code": 3}
<%
			} else {
				// Get ID token from Authentication header.
				String idTokenInReq = request.getHeader("Authentication");
				if (idTokenInReq == null || idTokenInReq.equals("")) { // No Authentication header
%>
{"errpr-msg": "No Authentication header", "error-code": 7}
<%		
				} else {
					if (!idToken.equals(idTokenInReq)) { // ID token in the header does not match to one in session object.
						// Need authentication for getting valid ID token.
						response.setStatus(401);
%>
{"error-msg": "Invalid Authentication token", "error-code": 4}
<%
					} else {
					// echo the message.
%>
{"msg": "<%= param %>"}
<%
					}
				}
			}
		}
	}
}
%>	