<%@ page language="java" contentType="application/json"
    pageEncoding="UTF-8"%>
<%
// Check the refresh token in the request header matches to one in session object.
// Get the refresh token in the request header.
String refreshTokenInParam = request.getParameter("refresh_token");
// Get the refresh token in session object.
String refreshTokenInSession = (String)session.getAttribute("RefreshToken");

String usernameInParam = request.getParameter("username");
String usernameInSession = (String)session.getAttribute("username");
if (refreshTokenInSession == null || usernameInSession == null) { // Refresh token is not in session object.
	// Probably user is not logged in and need authentication (login).
	response.setStatus(401);
%>
{"error-msg": "No refresh token in session data", "error-code": 5}
<%
} else if (!refreshTokenInSession.equals(refreshTokenInParam) || !usernameInSession.equals(usernameInParam)) { // The refresh token in the request header is invalid.
	// Need authentication to get a valid refresh token.
	response.setStatus(401);
%>
{"error-msg": "Invalid refresh token", "error-code": 6}
<%
} else {
	// The refresh token is valid and proceed to renew ID token.
	// Never cache the content of this page (URL).
	response.setHeader("Cache-Control", "private, no-store, no-cache, must-revalidate");
	// Get the counter for ID token to renew the token.
	Integer tokenSequenceNum = (Integer)session.getAttribute("token_sequential_num");
	// Increment the couter value.
	tokenSequenceNum = new Integer(tokenSequenceNum.intValue() + 1);
	// A new ID token is "token" + <Token Sequential Number>.
	String idToken = "token" + tokenSequenceNum.toString();
	// Store the new ID token in session object.
	session.setAttribute("IdToken", idToken);
	// Store the new counter value to session object.
	session.setAttribute("token_sequential_num", tokenSequenceNum);
	// Reset the counter for counting how many times ID token is used (set it to 0).
	session.setAttribute("token_usage_counter", new Integer(0));
%>
{"IdToken": "<%= idToken %>"}
<%
}
%>