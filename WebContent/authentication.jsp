<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
final String USERNAME = "foo";
final String PASSWORD = "foo";

String username = request.getParameter("username");
String password = request.getParameter("password");

if (!(USERNAME.equals(username)) || !(PASSWORD.equals(password))) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
} else {
	session.setAttribute("username", username);
	session.setAttribute("token_usage_counter", new Integer(0));
	session.setAttribute("token_sequencial_num", new Integer(0));
	Integer tokenSequencialNum = (Integer)session.getAttribute("token_sequencial_num");
	String idToken = "token" + tokenSequencialNum.toString();
	session.setAttribute("IdToken", idToken);
	String refreshToken = "r-token";
	session.setAttribute("RefreshToken", refreshToken);
	
%>
<!DOCTYPE html>
<html>
<body onload="init();">
<script type="text/javascript">
function init() {
localStorage.setItem("IdToken", "<%= idToken %>");
localStorage.setItem("RefreshToken", "<%= refreshToken %>");
window.location.replace("<%= request.getContextPath() %>");
};
</script>
</body>
</html>
<%
}
%>