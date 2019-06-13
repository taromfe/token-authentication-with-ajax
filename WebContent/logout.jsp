<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// Clear session object for logout.
session.invalidate();
// Redirect to the top page of the web app.
response.sendRedirect(request.getContextPath());
%>