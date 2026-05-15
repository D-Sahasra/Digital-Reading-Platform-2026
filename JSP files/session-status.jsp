<%@ page contentType="application/json; charset=UTF-8" %>
<%
boolean loggedIn = session.getAttribute("username") != null;
out.print("{\"loggedIn\":" + loggedIn + "}");
%>