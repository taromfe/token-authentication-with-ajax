<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String username = (String)session.getAttribute("username");
if (username == null || "".equals(username)) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
} else {
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Pi</title>
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var refreshToken = function() {
		//alert('refreshToken() is invoked');
		rToken = localStorage.getItem("RefreshToken");
		//alert('refreshToken:' + rToken);
		$.ajax(
		{
			url: "<%= request.getContextPath() %>/refresh_token.jsp",
			dataType: 'json',
			headers: {
				"Authentication": rToken
			},
			success: function(data) {
				//alert("Got new token" + JSON.stringify(data));
				idToken = data["IdToken"];
				//alert("New ID token:" + idToken);
				localStorage.setItem("IdToken", idToken);
				$("#msg").text("INFO: token has been refreshed");
				$("#idToken").text("ID Token: " + idToken);
				$("button").click();
			},
			error: function(data) {
				$("#msg").text("ERROR: token refresh failed");
				//alert("ERROR:" + JSON.stringify(data));
			}
		});
	};
	$("button").click(function() {
		$.ajax(
		{
			url: "<%= request.getContextPath() %>/access_point.jsp",
			dataType: 'json',
			headers: {
				"Authentication": localStorage.getItem("IdToken")
			},
			success: function (data) {
				//alert("OK" + JSON.stringify(data));
				counter = data["token_usage_counter"];
				//alert("counter:" + counter)
				$("#counter").text(counter);
			},
			error: function (data) {
				//alert("ERROR:" + JSON.stringify(data));
				responseText = data["responseText"];
				//alert("responseText: " + responseText);
				errorCode = JSON.parse(responseText)["error-code"];
				$("#msg").text("ERROR: error-code=" + errorCode);
				//alert("error-code: " + errorCode);
				if (errorCode == 2) {
					refreshToken();
				}
			}
		});
	});
});
</script>
</head>
<body>
<div>user: <%= username %></div>
<div>Welcome to Pi!</div>
<div id="idToken">No ID Token</div>
<div id="refreshToken">No Refresh Token</div>
<div><button>click this</button></div>
<div>counter: <span id="counter">0</span></div>
<div id="msg"></div>
<div><a href="logout.jsp">logout</a></div>
<script type="text/javascript">
idToken = localStorage.getItem("IdToken");
refreshToken = localStorage.getItem("RefreshToken");
if (idToken != null || idToken == "") {
	document.getElementById("idToken").innerHTML = ("ID Token: " + idToken);
}
if (refreshToken != null || refreshToken == "") {
	document.getElementById("refreshToken").innerHTML = ("Refresh Token: " + refreshToken);
}
</script>
</body>
</html>
<%
}
%>