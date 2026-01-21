package controller;

import dao.UserDAO;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Retrieve Parameters make sure user isi role
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("role"); 
        
        // 2. Validate Input if not select papar error message and redirect
        if (selectedRole == null || (!"mentor".equals(selectedRole) && !"mentee".equals(selectedRole) && !"admin".equals(selectedRole))) {
            request.setAttribute("errorMessage", "Please select a valid role.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 3. Call DAO untuk check kewujudan acc 
        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(email, password, selectedRole);

        // 4. Handle Result if wujud bagi pass
        if (user != null) {
            // Success: Create Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Redirect based on role depends pada type of users
            if ("admin".equals(selectedRole)) {
                response.sendRedirect("AdminServlet?action=dashboard");
            } else if ("mentor".equals(selectedRole)) {
                response.sendRedirect("MentorServlet?action=dashboard");
            } else {
                response.sendRedirect("MenteeServlet?action=dashboard");
            }
        } else {
            // Failure send back kat login
            request.setAttribute("errorMessage", "Invalid email or password for " + selectedRole);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}