<%-- 
    Document   : err_sameSession
    Created on : Oct 15, 2023, 3:22:35 PM
    Author     : Tong
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Same session Handling</title>
    </head>
    <Script>
        function msgAlert(){
            alert("Your session has already ended!\nPlease select the product again.");
        }
    </Script>
    <body onload="msgAlert()">
        <center>            
            <jsp:include page="catalog.jsp" flush="true" />
        </center>
    </body>
</html>
