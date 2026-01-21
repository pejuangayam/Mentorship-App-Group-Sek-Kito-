
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Online Class Schedule | Mentorship Platform</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentee.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/meetingMentee.css" />
    </head>
    <body>
        <header class="main-header">
            <div class="logo-area"><h1>MentorshipApp</h1></div>
            <nav class="user-nav">
                <a href="${pageContext.request.contextPath}/MenteeServlet?action=profile">My Profile</a>
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
                    <a href="${pageContext.request.contextPath}/MenteeServlet?action=meetings" class="active-link">📷 Join Meet</a>
                    <a href="${pageContext.request.contextPath}/MenteeServlet?action=find_mentor">👥 Find Mentor</a>
              <a href="${pageContext.request.contextPath}/MenteeServlet?action=inbox" style="display: flex; align-items: center; justify-content: space-between;">
                  <span>📩 My Inbox</span>
                  <c:if test="${not empty sessionScope.inboxCount && sessionScope.inboxCount > 0}">
                      <span style="background-color: #dc3545; color: white; font-size: 0.75rem; padding: 2px 8px; border-radius: 50%; font-weight: bold;">
                          ${sessionScope.inboxCount}
                      </span>
                  </c:if>
              </a>
                </nav>
            </aside>

            <section class="content-area">
                <div class="schedule-wrapper">
                    <div class="schedule-header">
                        <h2>📅 Online Class Schedule</h2>
                        <p class="schedule-subtitle">Manage and track your mentorship sessions</p>
                    </div>

                    <div class="schedule-controls">
                        <div class="controls-left">
                            <div class="control-group status-group">
                                <label>Status</label>
                                <select class="control-select">
                                    <option>Show all</option>
                                    <option>Scheduled</option>
                                    <option>Completed</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="table-container">
                        <table class="schedule-table">
                            <thead>
                                <tr>
                                    <th class="col-num">#</th>
                                    <th class="col-class">Topic / Title</th>
                                    <th class="col-class">Mentor</th> <th class="col-date">Date</th>
                                    <th class="col-time">Time</th>
                                    <th class="col-platform">Platform</th>
                                    <th class="col-link">Link</th>
                                    <th class="col-status">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty meetingList}">
                                    <tr>
                                        <td colspan="8" style="text-align:center; padding: 20px;">No upcoming meetings scheduled.</td>
                                    </tr>
                                </c:if>

                                <c:forEach var="mt" items="${meetingList}" varStatus="status">
                                    <tr>
                                        <td class="col-num">${status.count}</td>
                                        <td class="col-class"><span class="class-badge">${mt.title}</span></td>
                                        <td class="col-class">${mt.menteeName}</td> <td class="col-date">${mt.meetingDate}</td>
                                        <td class="col-time">${mt.meetingTime}</td>
                                        
                                        <td class="col-platform">
                                            <span class="platform-tag google">Video Call</span>
                                        </td>
                                        
                                        <td class="col-link">
                                            <a href="${mt.link}" target="_blank" class="link-btn">Join Class</a>
                                        </td>
                                        
                                        <td class="col-status">
                                            <span class="status-badge" 
                                                  style="
                                                  <c:choose>
                                                      <c:when test="${mt.status == 'Scheduled'}">background:#d1e7dd; color:#0f5132;</c:when>
                                                      <c:when test="${mt.status == 'Completed'}">background:#cfe2ff; color:#084298;</c:when>
                                                      <c:otherwise>background:#f8d7da; color:#842029;</c:otherwise>
                                                  </c:choose>
                                                  ">
                                                ${mt.status}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                </div>
            </section>
        </main>
    </body>
</html>