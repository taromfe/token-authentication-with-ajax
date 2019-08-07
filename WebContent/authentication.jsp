<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date,java.io.*,java.util.Properties" %>
<%
// Username and password are hard coded here.
final String USERNAME = "foo";
final String PASSWORD = "foo";

Properties prop = new Properties();
String idToken = null;
int token_sequence_number = -1;
String errorMsg = "";
long token_time_to_live_in_milli_sec = 0;
long token_issued_time = 0;
try (InputStream is = new FileInputStream("C:/Temp/dynamic_token.properties")){
	prop.load(is);
	token_sequence_number = Integer.parseInt(prop.getProperty("token_sequence_number"));
	idToken = prop.getProperty("id_token");
	token_time_to_live_in_milli_sec = Long.parseLong(prop.getProperty("token_time_to_live_in_sec")) * 1000;
	token_issued_time = Long.parseLong(prop.getProperty("token_issued_time"));
} catch (Exception e) {
	errorMsg += " Exception at getting token_sequence_number.";
}

if ((token_issued_time + token_time_to_live_in_milli_sec) < (new Date().getTime())) {
	try (OutputStream os = new FileOutputStream("C:/Temp/dynamic_token.properties")) {
		int new_token_sequence_number = token_sequence_number + 1;
		prop.setProperty("token_sequence_number", Integer.toString(new_token_sequence_number));
		idToken = ("token" + new_token_sequence_number);
		prop.setProperty("id_token", idToken);
		prop.setProperty("token_issued_time", Long.toString(new Date().getTime()));
		prop.store(os, "");
	} catch (Exception e) {
		errorMsg += " Exception at setting token_sequence_number.";
	}
}

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
	// Refresh tokne is "r-token" and the token never changes.
	String refreshToken = "r-token";
	// Store the refresh token in session object.
	session.setAttribute("RefreshToken", refreshToken);
	
%>
<!DOCTYPE html>
<html>
<body>
<script type="text/javascript">
// token_sequence_number: <%= token_sequence_number %>
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