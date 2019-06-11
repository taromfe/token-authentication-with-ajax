# token-authentication-with-ajax
A test web app for token based authentication with AJAX.

# What the web app do?

The web app issues requests to access a resource (access_point.jsp) with "Authentication" header whose value is a token (ID token) for authentication. An ID token is provided when login to the app and stored in local storage.

The ID token is expired when it was used three times and a new ID token is provided automatically using another token, Refresh token. When an ID token was expired, web browser (JavaScript code running in web browser) requests a new ID token to refresh_token.jsp by passing a refresh token as the value of "Authentication" header. A refresh token is provided when login to the app and stored in local storage.

## Workflow of the web app

1. A user access to index.jsp of the web app by a web browser.

1. The web app redirects to login.jsp for prompting a user to login with the user's credentials (their default values are "foo"/"foo").

1. The user inputs username and password then click "login" button.

1. The login request is sent to authentication.jsp.

1. If the username and the password is valid, authentication.jsp creates an ID token and a refresh token and store them in "session" object (server side) and local storage (web browser side).

1. After login, the user see a page (index.jsp) with "click this" button.

1. A request to access_point.jsp is issued with "Authentication" header whose value is the ID token

1. access_point.jsp responds to the request if the ID token is valid.

1. If the ID token was expired (used three times), access_point.jsp returns 401 and inform the token was expired.

1. Client side code (JavaScript in web browser) issues a request to renew the ID token to refresh_token.jsp. The request has "Authentication" header with the refresh token.

1. refresh_token.jsp returns a new ID token if the refresh token is valid.

