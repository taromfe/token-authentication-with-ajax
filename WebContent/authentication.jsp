<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// Username and password are hard coded here.
final String USERNAME = "foo";
final String PASSWORD = "foo";

// Retrieve username and password from the request.
String username = request.getParameter("username");
String password = request.getParameter("password");

// Check as if credentials are valid.
if (!(USERNAME.equals(username)) || !(PASSWORD.equals(password))) { // Not valid.
	// Redirect to login page.
	response.sendRedirect(request.getContextPath() + "/login.jsp");
} else {
	// Store necessary info into session object.
	// Store username.
	session.setAttribute("username", username);
	// Set a counter for counting how many times ID token is used.
	// The counter's initial value is 1, then refresh ID token happens
	// in the first attempt to access to access_point.jsp.
	session.setAttribute("token_usage_counter", new Integer(1));
	// Set a counter for providing a new ID token. The counter value is added to the value of ID token and incremented when issued new one.
	Integer tokenSequentialNum = new Integer(0);
	session.setAttribute("token_sequential_num", tokenSequentialNum);
	// Set an initial ID token.
	// ID token is "token" + <Token Sequential Number>.
	String idToken = "token" + tokenSequentialNum.toString();
	// Store the ID token to session object.
	session.setAttribute("IdToken", idToken);
	// Refresh tokne is "r-token" and the token never changes.
	String refreshToken = "r-token";
	// Store the refresh token in session object.
	session.setAttribute("RefreshToken", refreshToken);
	
%>
<!DOCTYPE html>
<html>
<body>
<script type="text/javascript">
// Store ID token and Refresh token into local storage.
localStorage.setItem("IdToken", "<%= idToken %>");
localStorage.setItem("RefreshToken", "<%= refreshToken %>");
// Redirect to the top page of the web app (index.jsp).
window.location.replace("<%= request.getContextPath() %>");
</script>
</body>
</html>
<%
}
%>