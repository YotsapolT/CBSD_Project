<%-- 
    Document   : Catalog
    Created on : Oct 6, 2023, 9:26:44 AM
    Author     : Tong
--%>

<%@page import="controller.Product_Controller"%>
<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="controller.Product_ShoppingCart_Table"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DVD Shopping</title>
    </head>
    <body>
        <script>
            function enableSubmitBtn(){
                console.log(1);
                var idList = document.querySelectorAll("[id]");
                var isDisable = true;
                for(let i = 0; i < idList.length; i++){
                    if(document.getElementById(idList[i].id).checked && document.getElementById(idList[i].id + "_Qtt").value !== ""){
                        isDisable = false;
                    }else if(document.getElementById(idList[i].id).checked && document.getElementById(idList[i].id + "_Qtt").value === ""){
                        isDisable = true;
                        break;
                    }
                }
                document.getElementById("submit").disabled = isDisable;
            }
            function enableTextInput(){
                var idList = document.querySelectorAll("[id]");
                console.log(idList);
                for(let i = 0; i < idList.length; i++){
                    if(document.getElementById(idList[i].id).checked){
                        document.getElementById(idList[i].id + "_Qtt").disabled = false;
                    }else if (!document.getElementById(idList[i].id).checked && !idList[i].id.includes("_Qtt") && idList[i].id !== "submit"){
                        document.getElementById(idList[i].id + "_Qtt").value = "";
                        document.getElementById(idList[i].id + "_Qtt").disabled = true;
                    }
                }
                enableSubmitBtn();
            }
        </script>
        <center>
            <h1>DVD Catalog</h1>
            <form name="firstForm" action="catalogController" method="POST">
                <table border="1" style="width:40%" >
                    <tr>
                        <th style="width:40%">DVD Names</th>
                        <th style="width:20%">Rating</th>
                        <th style="width:20%">Year</th>
                        <th style="width:10%">Price</th>
                        <th style="width:10%">Quantity</th>
                    </tr>
                    <jsp:useBean id="products" class="controller.Product_Controller" scope="page"/>
                    <%
                        List<Product_Controller> prodList = Product_ShoppingCart_Table.getAllProduct();
                        Iterator<Product_Controller> itr = prodList.iterator();
                        while(itr.hasNext()) {
                            products = itr.next();
                            out.println("<tr>");
                            out.println("   <td> <input type=\"checkbox\"" 
                                         + "name=\"" + products.getMovie()
                                         + "_ChB\" value=\"checked\""
                                         + "id=\"" + products.getMovie()
                                         + "\" onchange=\"enableTextInput()\" />" + products.getMovie() + "</td>");
                            out.println("   <td style=\"text-align:center\"> "+ products.getRating() + "</td>");
                            out.println("   <td style=\"text-align:center\"> "+ products.getYearcreate() + "</td>");
                            out.println("   <td style=\"text-align:center\"> "+ products.getPrice() + "</td>");
                            out.println("   <td> <input type=\"text\" name=\"" + products.getMovie() + "_Qtt\" value=\"\" " + "id=\"" + products.getMovie() + "_Qtt\" size=\"5\""
                                         + "style=\"text-align:right\" pattern=\"[1-9]+\" title=\"Please Enter a Number More than 1!\" onchange=\"enableSubmitBtn()\" disabled/></td>");
                            out.println("<tr>");
                        }
                        session = request.getSession();
                        if(session.isNew()){
                            out.println("<script>");
                            for(Product_Controller prod : prodList){
                                out.println("document.getElementById(\"" + prod.getMovie() + "\").checked = false;");
                            }
                            out.println("</script>");
                        }else {
                            out.println("<script>");
                            Enumeration<String> session_params = session.getAttributeNames();
                            while(session_params.hasMoreElements()){
                                String single_session_param = session_params.nextElement();
                                if(!single_session_param.equals("WELD_S_HASH") && single_session_param.contains("_ChB")){
                                    out.println("document.getElementById(\"" + single_session_param.replace("_ChB", "") + "\").checked = " + (Boolean) session.getAttribute(single_session_param) + ";");
                                }else if(!single_session_param.equals("WELD_S_HASH") && single_session_param.contains("_Qtt")){
                                    out.println("document.getElementById(\"" + single_session_param + "\").value = \"" + Integer.valueOf((String) session.getAttribute(single_session_param)) + "\";");
                                }
                            }
                            out.println("</script>");
                        }
                    %>
                </table>
                    <br> <input  type="submit" value="Add To Cart" name="submitBTN" id="submit" disabled />
                    <%
                        out.println("<script>enableTextInput();</script>");
                    %>
            </form>
        </center>
    </body>
</html>
