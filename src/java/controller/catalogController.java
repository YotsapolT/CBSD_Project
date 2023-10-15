/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.util.Enumeration;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Products;
import java.util.List;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Tong
 */
public class catalogController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        List<Products> prodList = Product_ShoppingCart_Table.findAllProduct();
        HttpSession session = request.getSession();

        //set every session params(_ChB) to false and params(_Qtt) to -1
        Enumeration<String> session_attrs = session.getAttributeNames();
        while(session_attrs.hasMoreElements()){        
            String single_session_attr = session_attrs.nextElement();
            if(!single_session_attr.equals("WELD_S_HASH") && single_session_attr.contains("_ChB")){   //this session param is movie_CheckBox
                session.setAttribute(single_session_attr, false);
            }else if(!single_session_attr.equals("WELD_S_HASH") && single_session_attr.contains("_Qtt")){ //this session param is movie_Quantity
                session.setAttribute(single_session_attr, "-1");
            }
        }

        //update session params that match request params
        Enumeration<String> req_params = request.getParameterNames();
        while(req_params.hasMoreElements()){             
            String single_req_param = req_params.nextElement();
            if(single_req_param.contains("_ChB")){  //this request param is movie_CheckBox
                session.setAttribute(single_req_param, true);
            }else if(single_req_param.contains("_Qtt")){    //this request param is movie_Quantity
                session.setAttribute(single_req_param, request.getParameter(single_req_param));
            }
        }

        //set request(for Result) params are used and delete (req_params and sess_params) which aren't used
        session_attrs = session.getAttributeNames();
        int totalPrice = 0;
        while(session_attrs.hasMoreElements()){    
            String single_session_attr = session_attrs.nextElement();
            if(!single_session_attr.equals("WELD_S_HASH") && single_session_attr.contains("_ChB")){
                if((boolean)session.getAttribute(single_session_attr) == true){
                    request.setAttribute(single_session_attr, true);
                }else{
                    session.removeAttribute(single_session_attr);
                    request.removeAttribute(single_session_attr);
                }
            }else if(!single_session_attr.equals("WELD_S_HASH") && single_session_attr.contains("_Qtt")){
                if(!((String)session.getAttribute(single_session_attr)).equals("-1")){
                    request.setAttribute(single_session_attr, (String)session.getAttribute(single_session_attr));
                    int quantity = Integer.valueOf((String)session.getAttribute(single_session_attr));
                    int pricePerUnit = Product_ShoppingCart_Table.findProductByMovie(single_session_attr.replace("_Qtt", "")).getPrice();
                    int totalPricePerMovie = Product_ShoppingCart_Table.calculatePrice(quantity, pricePerUnit);
                    request.setAttribute(single_session_attr.replace("_Qtt", "") + "_TotalPricePerMovie", totalPricePerMovie);
                    totalPrice += totalPricePerMovie;
                }else{
                    session.removeAttribute(single_session_attr);
                    request.removeAttribute(single_session_attr);
                }
            }
        }
        session.setAttribute("totalPrice", totalPrice);
        request.setAttribute("totalPrice", totalPrice);
        request.getRequestDispatcher("addToShoppingCart.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
