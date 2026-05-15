<%@ page contentType="application/json; charset=UTF-8" %>
<%
session.invalidate();
out.print("{\"success\":true}");
%>