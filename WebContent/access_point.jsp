<%@ page language="java" contentType="application/json"
    pageEncoding="UTF-8"%>
<%
response.setHeader("Cache-Control", "private, no-store, no-cache, must-revalidate");
final int maxTokenUsageCounter = 3;
String username = (String)session.getAttribute("username");
if (username == null || "".equals(username)) {
	response.setStatus(401);
%>
{"error-msg": "no username", "error-code": 0}
<%
} else {
	Integer tokenUsageCounter = (Integer)session.getAttribute("token_usage_counter");
	if (tokenUsageCounter == null) {
		response.setStatus(401);
%>
{"error-msg": "token usage counter is not set", "error-code": 1}
<%
	} else {
		if (tokenUsageCounter.intValue() >= 3) {
			response.setStatus(401);
%>
{"error-msg": "need refresh token", "error-code": 2}
<%
		} else {
			String idToken = (String)session.getAttribute("IdToken");
			if (idToken == null) {
				response.setStatus(401);
%>
{"error-msg": "ID token is not set", "error-code": 3}
<%
			} else {
				String idTokenInReq = request.getHeader("Authentication");
				if (!idToken.equals(idTokenInReq)) {
					response.setStatus(401);
%>
{"error-msg": "Invalid Authentication token", "error-code": 4}
<%
				} else {
					session.setAttribute("token_usage_counter", new Integer(tokenUsageCounter.intValue() + 1));
%>
{"msg": "OK", "token_usage_counter": <%= session.getAttribute("token_usage_counter") %>}
<%
				}
			}
		}
	}
}
%>