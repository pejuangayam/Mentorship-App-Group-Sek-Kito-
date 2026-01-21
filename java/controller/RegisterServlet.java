package controller;

import dao.UserDAO;
import model.User;
import model.Profession; 
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import utils.DBConnection; // Only used for GET method (loading form options)

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();

            // 1. Fetch Professions
            ResultSet rsProf = stmt.executeQuery("SELECT * FROM PROFESSION ORDER BY PROFESSIONNAME");
            List<Profession> professionList = new ArrayList<>();
            while(rsProf.next()){
                Profession p = new Profession();
                p.setProfessionID(rsProf.getInt("PROFESSIONID"));
                p.setProfessionName(rsProf.getString("PROFESSIONNAME"));
                p.setCategory(rsProf.getString("CATEGORY")); 
                professionList.add(p);
            }
            rsProf.close();

            // 2. Fetch Departments
            ResultSet rsDept = stmt.executeQuery("SELECT * FROM DEPARTMENT ORDER BY DEPT_NAME");
            List<String> departmentList = new ArrayList<>();
            while(rsDept.next()){
                departmentList.add(rsDept.getString("DEPT_NAME"));
            }
            rsDept.close();
            
            request.setAttribute("professionList", professionList);
            request.setAttribute("departmentList", departmentList);
            
            request.getRequestDispatcher("register.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String noPhone = request.getParameter("noPhone");
        
        // Basic Validation
        if (role == null || name == null || email == null || password == null) {
            request.setAttribute("errorMessage", "All required fields must be filled.");
            doGet(request, response); 
            return;
        }

        UserDAO userDAO = new UserDAO();

        // 1. Check Duplicates
        if (userDAO.isEmailRegistered(email, role)) {
            request.setAttribute("errorMessage", "Email already registered.");
            doGet(request, response);
            return;
        }

        // 2. Prepare User Object
        User newUser = new User();
        newUser.setName(name);
        newUser.setEmail(email);
        newUser.setPassword(password);
        newUser.setNoPhone(noPhone);
        newUser.setAddress(request.getParameter("address"));
        newUser.setEducationalLevel(request.getParameter("educationalLevel"));
        
        String dobStr = request.getParameter("dateOfBirth");
        if(dobStr != null && !dobStr.isEmpty()) {
            newUser.setDateOfBirth(Date.valueOf(dobStr));
        }

        boolean isRegistered = false;

        // 3. Role Specific Handling
        if ("mentor".equals(role)) {
            String yearsExpStr = request.getParameter("yearsExperience");
            if (yearsExpStr != null && !yearsExpStr.isEmpty()) {
                newUser.setYearsExperience(Integer.parseInt(yearsExpStr));
            }
            newUser.setDepartment(request.getParameter("department"));
            newUser.setBio(request.getParameter("bio"));
            
            // Handle Checkboxes
            String[] selectedProfs = request.getParameterValues("qualification");
            String profString = (selectedProfs != null) ? String.join(", ", selectedProfs) : "General";
            newUser.setQualification(profString);

            isRegistered = userDAO.registerMentor(newUser);

        } else if ("mentee".equals(role)) {
            newUser.setStudentId(request.getParameter("studentId"));
            // Mentee uses 'department' dropdown to fill 'program' column
            newUser.setProgram(request.getParameter("department")); 
            
            isRegistered = userDAO.registerMentee(newUser);
        }

        // 4. Final Result
        if (isRegistered) {
            response.sendRedirect("login.jsp?msg=Registration Successful! Please Login.");
        } else {
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            doGet(request, response);
        }
    }
}