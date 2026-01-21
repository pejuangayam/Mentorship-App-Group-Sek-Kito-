
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Mentees | Mentorship Platform</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MyMentees.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentor.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

  <header class="main-header">
    <div class="logo-area"><h1>MentorshipApp</h1></div>
    <nav class="user-nav">
      <a href="${pageContext.request.contextPath}/MentorServlet?action=profile" class="nav-link">My Profile</a>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-logout">Logout</a> 
    </nav>
    <button class="menu-toggle">☰</button>
  </header>

  <main class="dashboard-main-content">

    <aside class="sidebar">
      <div class="sidebar-header">
        <h3 class="role-title">Welcome Mentor ${sessionScope.user.name}</h3>
      </div>
      
      <nav class="role-nav">
        <a href="${pageContext.request.contextPath}/MentorServlet?action=dashboard" class="nav-item">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=my_mentees" class="active-link">👥 My Mentees</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=requests" class="nav-item">📩 Pending Requests</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=schedule" class="nav-item">📅 Schedule Meeting</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=announcements" class="nav-item">📢 Announcements</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=notes" class="nav-item">📝 Notes & Files</a>
      </nav>
    </aside>

    <section class="content-area">
      <h2 id="page-title">👥 My Mentees</h2>

      <c:if test="${not empty param.msg}">
          <div style="padding: 10px; background: #d4edda; color: #155724; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
              ✅ ${param.msg}
          </div>
      </c:if>

      <div class="summary-cards">
        <div class="card">
          <h3>Total Mentees</h3>
          <p class="count">${myMenteesList.size()}</p>
        </div>
        <div class="card">
          <h3>Active Pairs</h3>
          <p class="count">${myMenteesList.size()}</p>
        </div>
      </div>

      <div class="widget-section">
        <h3 class="section-header">👥 All Active Mentees</h3>
        
        <c:forEach var="m" items="${myMenteesList}">
            <div class="mentee-card">
              <div class="mentee-header">
                <div class="mentee-avatar">
                    <img src="https://ui-avatars.com/api/?name=${m.name}&background=random&color=fff&size=50" style="border-radius: 50%;">
                </div>
                
                <div class="mentee-basic-info">
                  <h4>${m.name}</h4>
                  <p class="mentee-details">${m.program}</p>
                  <p class="mentee-status"><span class="status-badge active">Active</span></p>
                </div>
              </div>
              
              <div class="mentee-body">
                <div class="info-row">
                  <span class="info-label">📧 Email:</span>
                  <span>${m.email}</span>
                </div>

                <div class="info-row">
                  <span class="info-label">📞 Phone:</span>
                  <span>${not empty m.noPhone ? m.noPhone : "Not Available"}</span>
                </div>

                <div class="info-row">
                   <span class="info-label">🎓 Year:</span>
                   <span>${not empty m.currentYear ? "".concat(m.currentYear) : "-"}</span>
                </div>

                <div class="info-row">
                   <span class="info-label">🆔 Student ID:</span>
                   <span style="font-family: monospace; background: #f0f0f0; padding: 2px 5px; border-radius: 3px;">
                       ${not empty m.studentId ? m.studentId : "N/A"}
                   </span>
                </div>
                
                <div class="info-row" style="margin-top: 15px; display: flex; gap: 10px;">
                   <a href="mailto:${m.email}" class="btn btn-small" style="flex: 1; background:#0d6efd; color:white; padding:8px; text-decoration:none; border-radius:4px; font-size: 0.9em; text-align:center; border: none; cursor: pointer;">
                       <i class="fas fa-envelope"></i> Email
                   </a>

                   <form action="${pageContext.request.contextPath}/MentorServlet" method="POST" onsubmit="return confirm('Are you sure you want to remove ${m.name}? This cannot be undone.');" style="flex: 1;">
                       <input type="hidden" name="action" value="delete_mentee">
                       <input type="hidden" name="menteeId" value="${m.id}">
                       <button type="submit" class="btn btn-small" style="width: 100%; background:#dc3545; color:white; padding:8px; border:none; border-radius:4px; font-size: 0.9em; cursor:pointer; text-align: center;">
                           <i class="fas fa-trash-alt"></i> Remove
                       </button>
                   </form>
                </div>

              </div>
            </div>
        </c:forEach>

        <c:if test="${empty myMenteesList}">
            <div style="padding: 40px; text-align: center; color: #666; background: white; border-radius: 8px;">
                <p>You do not have any active mentees yet.</p>
                <p>Go to <a href="${pageContext.request.contextPath}/MentorServlet?action=requests">Pending Requests</a> to accept new students.</p>
            </div>
        </c:if>

      </div>
    </section>
  </main>
</body>
</html>