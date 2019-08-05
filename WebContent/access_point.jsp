<%@ page language="java" contentType="application/json"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%
// No cache for this URL content.
response.setHeader("Cache-Control", "private, no-store, no-cache, must-revalidate");

// Set maximum value how many times ID token can be used.
final int maxTokenUsageCounter = 3;
		
final long milliSecToLive = 60 * 1000; // 1 minute.
		
// Is authentication required?
boolean authenticationRequired = true;

// Request paramtere.
String param = request.getParameter("param");

if (!authenticationRequired) {
%>
{"msg": "<%= param %>", "token_usage_counter": 0}
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
	// Check token issued time.
	// Get the time for that from session object.
	Long tokenIssuedTime = (Long)session.getAttribute("token_issued_time");
	if (tokenIssuedTime == null) { // The time is not set.
		// Probably user is not logged in and need authentication.
		response.setStatus(401);
%>
{"error-msg": "token issued time is not set", "error-code": 1}
<%
	} else {
		if (tokenIssuedTime.longValue() <= ((new Date().getTime()) - milliSecToLive)) { // Is the token expired?
			// Need authentication again or renew the ID token.
			response.setStatus(401);
%>
{"error-msg": "need refresh token", "error-code": 2}
<%
		} else {
			// Check as if ID token in Autherntication header matches to one in session object.
			// Retrieve ID token from session object.
			String idToken = (String)session.getAttribute("IdToken");
			if (idToken == null) { // No ID token in session object.
				// Probably user is not logged in and need authentication.
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
}
%>	