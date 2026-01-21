
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mentor Dashboard | Mentorship Platform</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentor.css">
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
        <a href="${pageContext.request.contextPath}/MentorServlet?action=dashboard" class="nav-item active-link">
            🏠 Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=my_mentees" class="nav-item">
            👥 My Mentees
        </a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=requests" class="nav-item">
            📩 Pending Requests 
            <c:if test="${pendingRequests > 0}">
                <span class="badge">${pendingRequests}</span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=schedule" class="nav-item">
            📅 Schedule Meeting
        </a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=announcements" class="nav-item">📢 Announcements</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=notes" class="nav-item">📝 Notes & Files</a>      
      </nav>
    </aside>

    <section class="content-area">
      <h2 id="page-title">👋 Mentor Dashboard</h2>

      <c:if test="${not empty param.msg}">
        <div style="margin-bottom: 20px; padding: 15px; background: #d4edda; color: #155724; border-radius: 5px;">
             ✅ ${param.msg}
        </div>
      </c:if>

      <div class="summary-cards">
        <div class="card">
          <h3>Current Mentees</h3>
          <p class="count">${myMenteesCount}</p>
          <a href="${pageContext.request.contextPath}/MentorServlet?action=my_mentees">Manage Pairs</a>
        </div>
        <div class="card">
          <h3>New Requests</h3>
          <p class="count">${pendingRequests}</p>
          <a href="#pendingSection">Review Now</a>
        </div>
      </div>

      <div class="widget-section" id="pendingSection">
        <h3 class="section-header">📩 Pending Mentorship Requests</h3>
        
        <div class="request-list">
            <c:if test="${empty requestList}">
                <div class="request-item" style="justify-content: center; color: #666; padding: 20px;">
                    <p>No pending requests at the moment.</p>
                </div>
            </c:if>

            <c:forEach var="req" items="${requestList}">
                <div class="request-item">
                    <div class="request-info">
                      <h4 style="margin-bottom:4px;">${req.menteeName}</h4>
                      <span style="color:#666; font-size:0.9em; display:block;">
                          <i class="fas fa-graduation-cap"></i> Course: ${req.menteeProgram}
                      </span>
                      <small style="color:#888;">Message: "${req.message}"</small>
                    </div>
                    <div class="request-actions">
                      <a href="MentorServlet?action=accept&id=${req.mentorshipID}" class="btn btn-accept">Accept</a>
                      <a href="MentorServlet?action=decline&id=${req.mentorshipID}" class="btn btn-decline">Decline</a>
                    </div>
                </div>
            </c:forEach>
        </div>
      </div>

      <div class="widget-section" style="margin-top: 40px;">
        <h3 class="section-header">👥 Your Current Mentorship Pairs</h3>
        
        <table class="mentee-table">
          <thead>
            <tr>
              <th>Mentee Name</th>
              <th>Program</th>
              <th>Email</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="m" items="${myMenteesList}">
                <tr>
                  <td>
                      <div style="display:flex; align-items:center; gap:10px;">
                          <img src="https://ui-avatars.com/api/?name=${m.name}&size=30&background=random&color=fff&rounded=true" alt="Avatar">
                          ${m.name}
                      </div>
                  </td>
                  <td>${m.program}</td>
                  <td>${m.email}</td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty myMenteesList}">
                <tr>
                    <td colspan="4" style="text-align: center; padding: 20px; color: #777;">
                        No active mentees found. (Check Servlet 'loadMentorDashboard' logic)
                    </td>
                </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </section>
  </main>

</body>
</html>