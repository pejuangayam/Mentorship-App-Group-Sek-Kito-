
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Profile | Admin Panel</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardAdmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        /* --- GENERAL LAYOUT FIXES --- */
        .dashboard-main-content { display: flex; min-height: 100vh; }
        .content-area { flex: 1; padding: 40px; background-color: #f8f9fa; }

        /* --- PROFILE CARD --- */
        .profile-container { max-width: 900px; margin: 0 auto; }
        .profile-card { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        
        .profile-image-container { display: flex; justify-content: center; margin-bottom: 30px; }
        .profile-image { border-radius: 50%; border: 4px solid #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }

        /* --- FORM STYLES --- */
        .form-section { margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid #eee; }
        .form-section:last-child { border-bottom: none; }
        
        .form-section-title { margin-bottom: 20px; color: #2c3e50; font-size: 1.2rem; font-weight: 600; }

        /* GRID SYSTEM (The Key Fix) */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr; /* Two Equal Columns */
            gap: 20px;
        }
        
        .form-group { display: flex; flex-direction: column; }
        .form-label { margin-bottom: 8px; font-weight: 600; color: #555; font-size: 0.9rem; }
        
        .form-input {
            width: 100%; padding: 10px 12px;
            border: 1px solid #ddd; border-radius: 6px;
            font-size: 1rem; background-color: #fff;
            transition: border-color 0.2s; box-sizing: border-box;
        }
        .form-input:focus { border-color: #4e73df; outline: none; } /* Admin Blue */
        
        /* Buttons */
        .form-actions { margin-top: 20px; text-align: right; display: flex; justify-content: flex-end; gap: 10px;}
        
        .btn-primary { 
            background-color: #4e73df; color: white; border: none; 
            padding: 12px 24px; border-radius: 6px; font-size: 1rem; font-weight: 600; 
            cursor: pointer; transition: background 0.2s; 
        }
        .btn-primary:hover { background-color: #2e59d9; }

        .btn-outline {
            background-color: transparent; color: #666; border: 1px solid #ddd;
            padding: 12px 24px; border-radius: 6px; font-size: 1rem; font-weight: 600;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-outline:hover { background-color: #f8f9fa; border-color: #bbb; }
    </style>
</head>
<body>

    <header class="main-header">
        <div class="logo-area"><h1>MentorshipApp</h1></div>
        <nav class="user-nav">
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-logout">Logout</a> 
        </nav>
    </header>

    <main class="dashboard-main-content">

        <aside class="sidebar">
            <div class="sidebar-header">
                <h3 class="role-title">Welcome ${sessionScope.user.name}</h3>
                <p class="role-subtitle">Administrator Panel</p>
            </div>

            <nav class="role-nav">
                <a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard">
                    <span class="nav-icon">🏠</span> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/AdminServlet?action=list_professions">
                    <span class="nav-icon">🧰</span> Profession & Department 
                </a>
                <a href="${pageContext.request.contextPath}/admin/profileAdmin.jsp" class="active-link">
                    <span class="nav-icon">👤</span> Profile
                </a>
            </nav>
        </aside>

        <section class="content-area">
            <h2 id="page-title" style="margin-bottom: 20px; color: #333; font-size: 1.8rem;">My Profile</h2>
            
            <% if(request.getParameter("msg") != null) { %>
                <div style="padding: 15px; background-color: #d1e7dd; color: #0f5132; border-radius: 6px; margin-bottom: 20px; border: 1px solid #badbcc;">
                    ✅ <%= request.getParameter("msg") %>
                </div>
            <% } %>

            <div class="profile-container">
                <div class="profile-card">
                    
                    <div class="profile-image-container">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.user.name}&background=4e73df&color=fff&size=128" alt="Admin Profile" class="profile-image">
                    </div>

                    <form id="editProfileForm" class="profile-form" action="${pageContext.request.contextPath}/AdminServlet" method="POST">
                        <input type="hidden" name="action" value="update_profile">
                        
                        <div class="form-section">
                            <h3 class="form-section-title">Personal Information</h3>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="firstName" class="form-label">Full Name *</label>
                                    <input type="text" id="firstName" name="fullName" class="form-input" value="${sessionScope.user.name}" required>
                                </div>

                                <div class="form-group">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="tel" id="phone" name="noPhone" class="form-input" value="${sessionScope.user.noPhone}">
                                </div>

                                <div class="form-group" style="grid-column: 1 / -1;">
                                    <label for="email" class="form-label">Email Address <span style="font-weight: normal; color: #888; font-size: 0.85em;">(Read Only)</span></label>
                                    <input type="email" id="email" name="email" class="form-input" value="${sessionScope.user.email}" readonly style="background-color: #f8f9fa; color: #6c757d; cursor: not-allowed;">
                                </div>
                            
                        </div>

                        <div class="form-section">
                            <h3 class="form-section-title">Change Password</h3>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="currentPassword" class="form-label">Current Password</label>
                                <input type="password" id="currentPassword" name="currentPassword" class="form-input" placeholder="Enter current password to verify changes">
                            </div>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <input type="password" id="newPassword" name="newPassword" class="form-input" placeholder="Min. 8 characters">
                                </div>

                                <div class="form-group">
                                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Re-enter new password">
                                </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn btn-outline" onclick="window.history.back()">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>

        </section>
    </main>

</body>
</html>