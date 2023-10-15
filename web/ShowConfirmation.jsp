<%-- 
    Document   : ShowConfirmation
    Created on : Oct 14, 2023, 11:39:13 PM
    Author     : Tong
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DVD Shopping</title>
    </head>
    <body>
        <h1>Your Order is confirmed!</h1>
        <%
            out.println("<h1>The total amount is $" + request.getAttribute("totalPrice") + "</h1>");
        %>
        <a href="catalog.jsp">back to Catalog</a>
    </body>
</html>
