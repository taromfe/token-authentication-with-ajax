<%@ page language="java" contentType="application/json"
    pageEncoding="UTF-8"%>
<%
// No cache for this URL content.
response.setHeader("Cache-Control", "private, no-store, no-cache, must-revalidate");

// Set maximum value how many times ID token can be used.
final int maxTokenUsageCounter = 1;
		
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
	// Check how many times the ID token was used.
	// Get the counter for that from session object.
	Integer tokenUsageCounter = (Integer)session.getAttribute("token_usage_counter");
	if (tokenUsageCounter == null) { // The counter is not set.
		// Probably user is not logged in and need authentication.
		response.setStatus(401);
%>
{"error-msg": "token usage counter is not set", "error-code": 1}
<%
	} else {
		if (tokenUsageCounter.intValue() >= maxTokenUsageCounter) { // The ID token is used too much times and need renewal.
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
					// The ID token is valid and proceed to process the request.
					// Increment the counter for counting how many times the ID token was used.
					session.setAttribute("token_usage_counter", new Integer(tokenUsageCounter.intValue() + 1));
%>
{"msg": "<%= param %>", "token_usage_counter": <%= session.getAttribute("token_usage_counter") %>}
<%
					}
				}
			}
		}
	}
}
}
%>	