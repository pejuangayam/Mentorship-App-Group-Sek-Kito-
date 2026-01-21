<%-- 
    Document   : PendingRequest
    Description: Dynamic list of pending mentorship requests
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pending Requests | Mentorship Platform</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/PendingRequest.css">
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
                    <a href="${pageContext.request.contextPath}/MentorServlet?action=dashboard" class="nav-item">
                        🏠 Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/MentorServlet?action=my_mentees" class="nav-item">
                        👥 My Mentees
                    </a>
                    <a href="${pageContext.request.contextPath}/MentorServlet?action=requests" class="nav-item active-link">
                        📩 Pending Requests 
                        <c:if test="${requestList.size() > 0}">
                            <span class="badge">${requestList.size()}</span>
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
                <h2 id="page-title">📩 Pending Mentorship Requests</h2>
                
                <c:if test="${not empty param.msg}">
                    <div style="padding: 15px; background: #d4edda; color: #155724; border-radius: 5px; margin-bottom: 20px;">
                        ✅ ${param.msg}
                    </div>
                </c:if>

                <div class="filter-section">
                    <div class="filter-group">
                        <label for="filterYear">Filter by Year:</label>
                        <select id="filterYear" class="filter-select">
                            <option value="all">All Years</option>
                            <option value="1">Year 1</option>
                            <option value="2">Year 2</option>
                            <option value="3">Year 3</option>
                            <option value="4">Year 4</option>
                        </select>
                    </div>
                </div>

                <div class="widget-section">
                    <h3 class="section-header">New Requests (${requestList.size()})</h3>

                    <c:if test="${empty requestList}">
                        <div style="text-align: center; padding: 40px; color: #666; background: white; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05);">
                            <h3>No pending requests</h3>
                            <p>You're all caught up! Check back later for new students.</p>
                        </div>
                    </c:if>

                    <c:forEach var="req" items="${requestList}">
                        <div class="request-card">
                            <div class="request-card-header">
                                <div class="request-avatar">
                                    <img src="https://ui-avatars.com/api/?name=${req.menteeName}&size=50&background=random&color=fff&rounded=true" alt="Avatar">
                                </div>
                                <div class="request-info-main">
                                    <h4>${req.menteeName}</h4>
                                    <p class="request-meta">${req.menteeProgram}</p>
                                    <p class="request-date">Status: <span style="color:orange; font-weight:bold;">${req.status}</span></p>
                                </div>
                            </div>

                            <div class="request-card-body">
                                <div class="request-section">
                                    <h5>📧 Contact</h5>
                                    <p>${not empty req.menteeEmail ? req.menteeEmail : "Email not available"}</p>
                                </div>
                            </div>

                            <div class="request-card-footer">
                                <a href="MentorServlet?action=accept&id=${req.mentorshipID}" class="btn btn-accept" style="text-decoration:none; display:inline-block; text-align:center;">
                                    ✓ Accept Request
                                </a>
                                <a href="MentorServlet?action=decline&id=${req.mentorshipID}" class="btn btn-decline" style="text-decoration:none; display:inline-block; text-align:center;">
                                    ✗ Decline
                                </a>
                            </div>
                        </div>
                    </c:forEach>

                </div>
            </section>
        </main>
    </body>
</html>