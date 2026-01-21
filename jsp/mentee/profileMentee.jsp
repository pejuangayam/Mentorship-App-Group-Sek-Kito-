<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>My Profile | Mentorship Platform</title>
  
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentee.css" />
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

      /* GRID SYSTEM */
      .form-grid {
          display: grid;
          grid-template-columns: 1fr 1fr; /* Two Equal Columns */
          gap: 20px;
      }
      
      .form-group { display: flex; flex-direction: column; }
      .form-label { margin-bottom: 8px; font-weight: 600; color: #555; font-size: 0.9rem; }
      
      .form-input, .form-select {
          width: 100%; padding: 10px 12px;
          border: 1px solid #ddd; border-radius: 6px;
          font-size: 1rem; background-color: #fff;
          transition: border-color 0.2s; box-sizing: border-box;
      }
      .form-input:focus { border-color: #0d6efd; outline: none; }
      
      /* Buttons */
      .form-actions { margin-top: 20px; text-align: right; }
      .btn-primary { background-color: #0d6efd; color: white; border: none; padding: 12px 24px; border-radius: 6px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: background 0.2s; }
      .btn-primary:hover { background-color: #0b5ed7; }
  </style>
</head>
<body>

  <header class="main-header">
    <div class="logo-area"><h1>MentorshipApp</h1></div>
    <nav class="user-nav">
      <a href="${pageContext.request.contextPath}/MenteeServlet?action=profile" class="nav-link active">My Profile</a>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-logout">Logout</a> 
    </nav>
    <button class="menu-toggle">☰</button>
  </header>

  <main class="dashboard-main-content">
    <aside class="sidebar">
      <h3 class="role-title">Welcome Mentee ${sessionScope.user.name}!</h3>
      <nav class="role-nav">
        <a href="${pageContext.request.contextPath}/MenteeServlet?action=dashboard">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/MenteeServlet?action=notes">📝 Notes</a>
        <a href="${pageContext.request.contextPath}/MenteeServlet?action=meetings">📷 Join Meet</a>
        <a href="${pageContext.request.contextPath}/MenteeServlet?action=find_mentor">👥 Find Mentor</a>
        <a href="${pageContext.request.contextPath}/MenteeServlet?action=inbox">📩 My Inbox</a>
      </nav>
    </aside>
    
    <section class="content-area">
      <h2 id="page-title" style="margin-bottom: 20px; color: #333;">Edit Profile</h2>
      
      <c:if test="${not empty param.msg}">
          <div style="padding: 15px; background: #d4edda; color: #155724; border-radius: 6px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
              ✅ ${param.msg}
          </div>
      </c:if>
      
      <div class="profile-container">
        <div class="profile-card">
            
            <div class="profile-image-container">
              <img src="https://ui-avatars.com/api/?name=${sessionScope.user.name}&background=0d6efd&color=fff&size=128" alt="Profile" class="profile-image">
            </div>
          
          <form id="editProfileForm" class="profile-form" action="${pageContext.request.contextPath}/MenteeServlet" method="POST">
            <input type="hidden" name="action" value="update_profile">

            <div class="form-section">
              <h3 class="form-section-title">Personal Information</h3>
              
              <div class="form-grid">
                <div class="form-group">
                  <label for="fullName" class="form-label">Full Name *</label>
                  <input type="text" id="fullName" name="fullName" class="form-input" value="${sessionScope.user.name}" required>
                </div>
              
                <div class="form-group">
                  <label for="phone" class="form-label">Phone Number</label>
                  <input type="tel" id="phone" name="phone" class="form-input" value="${sessionScope.user.noPhone}">
                </div>

                <div class="form-group" style="grid-column: 1 / -1;">
                  <label for="email" class="form-label">Email Address <span style="font-weight: normal; color: #999; font-size: 0.85em;">(Read Only)</span></label>
                  <input type="email" id="email" name="email" class="form-input" value="${sessionScope.user.email}" readonly style="background-color: #f8f9fa; color: #6c757d; cursor: not-allowed;">
                </div>
              </div>
            </div>

            <div class="form-section">
                <h3 class="form-section-title">Academic Details</h3>
                <div class="form-grid">
                    
                    <div class="form-group">
                        <label for="studentId" class="form-label">Student ID</label>
                        <input type="text" id="studentId" name="studentId" class="form-input" value="${sessionScope.user.studentId}">
                    </div>

                    <div class="form-group">
                        <label for="program" class="form-label">Program / Department</label>
                        <select id="program" name="program" class="form-select">
                            <option value="" disabled>Select your program...</option>
                            
                            <c:forEach var="dept" items="${departmentList}">
                                <option value="${dept}" ${sessionScope.user.program == dept ? 'selected' : ''}>
                                    ${dept}
                                </option>
                            </c:forEach>
                            
                            <c:if test="${empty sessionScope.user.program}">
                                <option value="" selected disabled>Please select a program</option>
                            </c:if>
                        </select>
                    </div>
                </div>
            </div>
            
            <div class="form-section">
                <h3 class="form-section-title">Change Password</h3>
                <div class="form-grid">
                    <div class="form-group" style="grid-column: 1 / -1;">
                        <label for="currentPassword" class="form-label">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" class="form-input" placeholder="Enter current password">
                    </div>
                    <div class="form-group">
                        <label for="newPassword" class="form-label">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" class="form-input" placeholder="Enter new password">
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Confirm new password">
                    </div>
                </div>
            </div>
            
            <div class="form-actions">
              <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
          </form>
        </div>
      </div>

    </section>
  </main>

</body>
</html>