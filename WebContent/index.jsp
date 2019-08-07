<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// Check session object to see as if user is logged in.
String username = (String)session.getAttribute("username");
if (username == null || "".equals(username)) { // User is not logged in.
	// Redirect to login page.
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
	// error counter for avoiding infinite loop
	var errorCounter = 0;
	// Function for refreshing ID token.
	var refreshToken = function(action) {
		// Retrirve a token from local storage for renewing (refreshing) ID token
		rToken = localStorage.getItem("RefreshToken");
		// AJAX call to refresh_token.jsp for renewing ID token.
		$.ajax(
		{
			url: "<%= request.getContextPath() %>/refresh_token.jsp",
			dataType: 'json',
			data: "refresh_token=" + localStorage.getItem("RefreshToken") + "&username=<%= username %>",
			success: function(data) {
				errorCounter = 0;
				// Retrieve new ID token from response.
				idToken = data["IdToken"];
				// Store the new ID token to local storage.
				localStorage.setItem("IdToken", idToken);
				// Show a message in this page.
				$("#msg").text("INFO: token has been refreshed");
				$("#idToken").text("ID Token: " + idToken);
				// Execute action
				if (action != null) {
					console.log("action is null.");
					if (action == "button_click") {
						// Click "button" again with the new ID token.
						$("button").click();
					} else {
						console.log("no matched action to " + action);
					}
				}
			},
			error: function(data) {
				// Show an error message in thie page.
				$("#msg").text("ERROR: token refresh failed");
			}
		});
	};
	
	// Access to access_point.jsp when clicking a button in this page.
	$("button").click(function() {
		$.ajax(
		{
			url: "<%= request.getContextPath() %>/access_point.jsp",
			data: "param=" + $("#text-input").val(), // pass a parameter, "param", whose value is set in the textbox of this page.
			dataType: 'json', // Return value format is JSON.
			// Add a header for authentication by ID token.
			headers: {
				"Authentication": localStorage.getItem("IdToken")
			},
			success: function (data) {
				// Show the message in the response.
				msg = data["msg"];
				$("#msg").html(msg); // XSS can happen here.
			},
			error: function (data) {
				// Get the error code.
				responseText = data["responseText"];
				errorCode = JSON.parse(responseText)["error-code"];
				$("#msg").text("ERROR: error-code=" + errorCode);
				if (errorCounter > 0) {
					// do nothing for avoiding infinit loop.
				} else {
					// Increment error counter.
					errorCounter += 1;
					if (errorCode == 2) { // ID token was expired.
						// Renew (refresh) ID token.
						refreshToken('button_click');
					}
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
<div><input type="text" id="text-input" /></div>
<div><button>click this</button></div>
<div id="msg"></div>
<div><a href="logout.jsp">logout</a></div>
<script type="text/javascript">
// Show ID token in this page.
idToken = localStorage.getItem("IdToken");
if (idToken != null || idToken == "") {
	document.getElementById("idToken").innerHTML = ("ID Token: " + idToken);
}
// Show Refresh token in this page.
refreshToken = localStorage.getItem("RefreshToken");
if (refreshToken != null || refreshToken == "") {
	document.getElementById("refreshToken").innerHTML = ("Refresh Token: " + refreshToken);
}
</script>
</body>
</html>
<%
}
%>