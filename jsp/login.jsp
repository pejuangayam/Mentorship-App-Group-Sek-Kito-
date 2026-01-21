
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/login.css">
    </head>
    <body>
        <div class="login-container">
            <h1 class="logo">Student Mentorship System</h1>
            <p class="welcome-subtitle">Please login to continue</p>
            
            <%-- Only change: Added this message display block --%>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div style="background-color: #f8d7da; color: #721c24; padding: 12px; border-radius: 5px; margin-bottom: 15px; border: 1px solid #f5c6cb;">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("successMessage") != null) { %>
                <div style="background-color: #d4edda; color: #155724; padding: 12px; border-radius: 5px; margin-bottom: 15px; border: 1px solid #c3e6cb;">
                    <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>
            
            <% if ("registration_success".equals(request.getParameter("message"))) { %>
                <div style="background-color: #d4edda; color: #155724; padding: 12px; border-radius: 5px; margin-bottom: 15px; border: 1px solid #c3e6cb;">
                    Registration successful! Please login with your credentials.
                </div>
            <% } %>
            
            <% if ("logout_success".equals(request.getParameter("message"))) { %>
                <div style="background-color: #d1ecf1; color: #0c5460; padding: 12px; border-radius: 5px; margin-bottom: 15px; border: 1px solid #bee5eb;">
                    You have been logged out successfully.
                </div>
            <% } %>

            <form action="LoginServlet" method="post">
                <fieldset class="role-fieldset">
                    <legend>Select Role</legend>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="role" id="admin" value="admin" required>
                        <label class="form-check-label" for="admin">Admin</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="role" id="mentor" value="mentor" required>
                        <label class="form-check-label" for="mentor">Mentor</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="role" id="mentee" value="mentee" required>
                        <label class="form-check-label" for="mentee">Mentee</label>
                    </div>
                </fieldset>

                <hr>

                <div class="input-group">
                    <label for="email">Email</label>
                    <%-- Fixed: Changed id from "username" to "email" --%>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>

                <div class="input-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                    <div class="show-password-wrapper">
                        <input type="checkbox" id="showPassword" onclick="togglePassword()">
                        <label for="showPassword">Show Password</label>
                    </div>
                </div>

                <button type="submit" class="btn btn-login">Login</button>

                <p class="register-prompt">
                    Don't have an account? 
                    <a href="RegisterServlet" class="btn-register">Register</a>
                </p>
            </form>
        </div>
        <script>
            function togglePassword() {
              var pwdField = document.getElementById('password');
              if (pwdField.type === "password") {
                    pwdField.type = "text";
                } else {
                    pwdField.type = "password";
                }
            }
        </script>   
    </body>
</html>