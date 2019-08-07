<%@ page language="java" contentType="application/json"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date,java.io.*,java.util.Properties" %>
<%
Properties prop = new Properties();
long tokenIssuedTime = 0;
int tokenSequenceNumber = -1;

try (InputStream is = new FileInputStream("C:/Temp/dynamic_token.properties")){
	prop.load(is);
	tokenIssuedTime = Long.parseLong(prop.getProperty("token_issued_time"));
	tokenSequenceNumber = Integer.parseInt(prop.getProperty("token_sequence_number"));
} catch (Exception e) {
}
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
	// Set new token sequece number.
	tokenSequenceNumber += 1;
	prop.setProperty("token_sequence_number", Integer.toString(tokenSequenceNumber));
	// Set ID token.
	String idToken = ("token" + tokenSequenceNumber);
	prop.setProperty("id_token", idToken);
	// Set token issued time.
	prop.setProperty("token_issued_time", Long.toString(new Date().getTime()));
%>
{"IdToken": "<%= idToken %>"}
<%
	// Store the properties.
	try (OutputStream os = new FileOutputStream("C:/Temp/dynamic_token.properties")) {
		prop.store(os, "");
	} catch (Exception e) {		
	}
}
%>