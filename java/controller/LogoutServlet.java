package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/AdminServlet"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Fetch the current session if it exists (false = don't create a new one)
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. Destroy the session immediately
            session.invalidate();
        }
        
        // 3. Redirect the user back to the login page
        response.sendRedirect("login.jsp?msg=Logged Out Successfully");
    }
}