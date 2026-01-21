<%-- 
    Document   : profileMentor
    Description: Mentor Profile Page (Fixed Layout + Change Password)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Mentor Panel</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentor.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        /* --- GENERAL LAYOUT FIXES --- */
        .dashboard-main-content { display: flex; min-height: 100vh; }
        .content-area { flex: 1; padding: 40px; background-color: #f8f9fa; }

        /* --- FORM GRID & SPACING --- */
        .form-section { margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid #eee; }
        .form-section:last-child { border-bottom: none; }
        .form-section-title { margin-bottom: 20px; color: #2c3e50; font-size: 1.2rem; font-weight: 600; }

        /* The Grid System for Inputs */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .full-width { grid-column: 1 / -1; }

        /* Input Styling */
        .form-group { display: flex; flex-direction: column; }
        .form-label { margin-bottom: 8px; font-weight: 600; color: #555; font-size: 0.9rem; }
        .form-input, .form-textarea, .form-select {
            width: 100%; padding: 10px 12px;
            border: 1px solid #ddd; border-radius: 6px;
            font-size: 1rem; transition: border-color 0.2s;
            background-color: #fff; box-sizing: border-box;
        }
        .form-input:focus, .form-textarea:focus, .form-select:focus { border-color: #0d6efd; outline: none; }
        .form-textarea { min-height: 120px; resize: vertical; font-family: inherit; }

        /* --- PROFESSION CARD STYLES --- */
        .profession-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 15px; margin-top: 10px; }
        .profession-label {
            display: flex; flex-direction: column; justify-content: center; position: relative;
            cursor: pointer; border: 2px solid #e9ecef; border-radius: 8px; padding: 15px;
            background: #fff; transition: all 0.2s ease; height: 100%;
        }
        .profession-label:hover { border-color: #cbd3da; background-color: #f8f9fa; }
        .hidden-input { display: none; }

        /* Selected State */
        .hidden-input:checked + .profession-label { border-color: #0d6efd; background-color: #f0f7ff; box-shadow: 0 2px 5px rgba(13, 110, 253, 0.1); }
        .hidden-input:checked + .profession-label .check-icon { opacity: 1; transform: scale(1); }
        .check-icon { position: absolute; top: 10px; right: 10px; color: #0d6efd; opacity: 0; transform: scale(0); transition: all 0.2s; }
        .prof-name { font-weight: 600; font-size: 1rem; color: #333; margin-bottom: 4px; }
        .prof-cat { font-size: 0.8rem; color: #6c757d; text-transform: uppercase; letter-spacing: 0.5px; }
        
        /* Action Buttons */
        .form-actions { margin-top: 20px; text-align: right; }
        .btn-primary { background-color: #0d6efd; color: white; border: none; padding: 12px 24px; border-radius: 6px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .btn-primary:hover { background-color: #0b5ed7; }
        
        /* Avatar Container */
        .profile-image-container { display: flex; justify-content: center; margin-bottom: 30px; }
        .profile-image { border-radius: 50%; border: 4px solid #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

    <header class="main-header">
        <div class="logo-area"><h1>MentorshipApp</h1></div>
        <nav class="user-nav">
            <a href="${pageContext.request.contextPath}/MentorServlet?action=profile" class="nav-link active">My Profile</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-logout">Logout</a> 
        </nav>
        <button class="menu-toggle">☰</button>
    </header>

    <main class="dashboard-main-content">

        <aside class="sidebar">
            <div class="sidebar-header"><h3 class="role-title">Welcome Mentor ${sessionScope.user.name}</h3></div>
            <nav class="role-nav">
                <a href="${pageContext.request.contextPath}/MentorServlet?action=dashboard" class="nav-item">🏠 Dashboard</a>
                <a href="${pageContext.request.contextPath}/MentorServlet?action=my_mentees" class="nav-item">👥 My Mentees</a>
                <a href="${pageContext.request.contextPath}/MentorServlet?action=requests" class="nav-item">📩 Pending Requests</a>
                <a href="${pageContext.request.contextPath}/MentorServlet?action=schedule" class="nav-item">📅 Schedule Meeting</a>
                <a href="${pageContext.request.contextPath}/MentorServlet?action=announcements" class="nav-item">📢 Announcements</a>
                <a href="${pageContext.request.contextPath}/MentorServlet?action=notes" class="nav-item">📝 Notes & Files</a>
            </nav>
        </aside>

        <section class="content-area">
            <h2 id="page-title" style="margin-bottom: 20px; font-size: 1.8rem; color: #333;">Edit Profile</h2>

            <% if(request.getParameter("msg") != null) { %>
                <div style="padding: 15px; background: #d4edda; color: #155724; margin-bottom: 20px; border-radius: 6px; border: 1px solid #c3e6cb; display:flex; align-items:center; gap:10px;">
                    <i class="fas fa-check-circle"></i> <%= request.getParameter("msg") %>
                </div>
            <% } %>

            <div class="profile-container" style="max-width: 900px; margin: 0 auto;">
                <div class="profile-card" style="background: white; padding: 40px; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.05);">
                    
                        <div class="profile-image-container">
                            <img src="https://ui-avatars.com/api/?name=${sessionScope.user.name}&background=0d6efd&color=fff&size=128&font-size=0.4" alt="Profile" class="profile-image">
                        </div>

                    <form action="${pageContext.request.contextPath}/MentorServlet" method="POST" class="profile-form">
                        <input type="hidden" name="action" value="update_profile">
                        
                        <div class="form-section">
                            <h3 class="form-section-title">Personal Information</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" name="fullName" class="form-input" value="${sessionScope.user.name}" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Phone Number</label>
                                    <input type="text" name="noPhone" class="form-input" value="${sessionScope.user.noPhone}" placeholder="+60...">
                                </div>
                                <div class="form-group full-width">
                                    <label class="form-label">Email Address <span style="font-weight: normal; color: #888; font-size: 0.85em;">(Read-only)</span></label>
                                    <input type="email" name="email" class="form-input" value="${sessionScope.user.email}" readonly style="background-color: #f8f9fa; color: #6c757d; cursor: not-allowed;">
                                </div>
                            
                        </div>
                        <div class="form-section">
                            <h3 class="form-section-title">Change Password</h3>
                            <div class="form-grid">
                                <div class="form-group full-width">
                                    <label class="form-label">Current Password</label>
                                    <input type="password" name="currentPassword" class="form-input" placeholder="Enter current password">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">New Password</label>
                                    <input type="password" name="newPassword" class="form-input" placeholder="Enter new password">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Confirm Password</label>
                                    <input type="password" name="confirmPassword" class="form-input" placeholder="Confirm new password">
                                </div>
                            
                        </div>
                                
                        <div class="form-section">
                            <h3 class="form-section-title">Professional Details</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">Department / Faculty</label>
                                    <select name="department" class="form-select">
                                        <option value="" disabled>Select Department...</option>
                                        <c:forEach var="dept" items="${departmentList}">
                                            <option value="${dept}" ${sessionScope.user.department == dept ? 'selected' : ''}>
                                                ${dept}
                                            </option>
                                        </c:forEach>
                                        <c:if test="${not empty sessionScope.user.department and not fn:contains(departmentList, sessionScope.user.department)}">
                                             <option value="${sessionScope.user.department}" selected>${sessionScope.user.department} (Legacy)</option>
                                        </c:if>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Years of Experience</label>
                                    <input type="number" name="experience" class="form-input" value="${sessionScope.user.yearsExperience}" min="0">
                                </div>
                                
                                <div class="form-group full-width">
                                    <label class="form-label">Bio / Expertise</label>
                                    <textarea name="bio" class="form-textarea" placeholder="Describe your background and areas of mentorship...">${sessionScope.user.bio}</textarea>
                                </div>

                                <div class="form-group full-width">
                                    <label class="form-label">Specialties / Professions</label>
                                    <div class="profession-grid">
                                        <c:forEach var="p" items="${professionList}">
                                            <input type="checkbox" class="hidden-input" name="qualification" id="prof_${p.professionID}" value="${p.professionName}"
                                                ${fn:contains(sessionScope.user.qualification, p.professionName) ? 'checked' : ''}>
                                            <label class="profession-label" for="prof_${p.professionID}">
                                                <i class="fas fa-check-circle check-icon"></i>
                                                <span class="prof-name">${p.professionName}</span>
                                                <span class="prof-cat">${p.category}</span>
                                            </label>
                                        </c:forEach>
                                    </div>
                                </div>
                           
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </section>
    </main>

</body>
</html>