<%@ page language="java" contentType="application/json"
    pageEncoding="UTF-8"%>
<%
String refreshTokenInHeader = request.getHeader("Authentication");
String refreshToken = (String)session.getAttribute("RefreshToken");
if (refreshToken == null) {
	response.setStatus(401);
%>
{"error-msg": "No refresh token in session data", "error-code": 5}
<%
} else if (!refreshToken.equals(refreshTokenInHeader)) {
	response.setStatus(401);
%>
{"error-msg": "Invalid refresh token", "error-code": 6}
<%
} else {
	response.setHeader("Cache-Control", "private, no-store, no-cache, must-revalidate");
	response.setStatus(200);
	Integer tokenSequenceNum = (Integer)session.getAttribute("token_sequencial_num");
	String idToken = "token" + (new Integer(tokenSequenceNum.intValue() + 1)).toString();
	session.setAttribute("IdToken", idToken);
	session.setAttribute("token_sequencial_num", new Integer(tokenSequenceNum.intValue() + 1));
	session.setAttribute("token_usage_counter", new Integer(0));
%>
{"IdToken": "<%= idToken %>"}
<%
}
%>