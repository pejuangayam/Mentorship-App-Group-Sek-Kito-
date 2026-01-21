<%-- 
    Document   : index
    Description: Mentee Dashboard (Updated with Bio, Experience, and Improved Connect Button)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Dashboard | Mentorship Platform</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentee.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  
  <style>
      /* --- Dashboard Specific Styles --- */
      
      /* Grid Layout for Cards */
      .mentor-list {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
          gap: 25px;
      }

      /* Card Container */
      .mentor-card {
          background: #fff;
          border: 1px solid #e0e0e0;
          border-radius: 12px;
          padding: 20px;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          transition: transform 0.2s, box-shadow 0.2s;
          position: relative;
          overflow: hidden;
          height: 100%; /* Equal height */
      }
      .mentor-card:hover {
          transform: translateY(-3px);
          box-shadow: 0 10px 20px rgba(0,0,0,0.05);
          border-color: #b3d7ff;
      }

      /* Header: Avatar + Name */
      .card-header-flex {
          display: flex;
          align-items: center;
          gap: 15px;
          margin-bottom: 12px;
      }
      .mini-avatar {
          width: 55px; height: 55px;
          background: #f0f2f5;
          border-radius: 50%;
          display: flex; align-items: center; justify-content: center;
          font-size: 1.5rem;
          color: #555;
          flex-shrink: 0;
      }
      .mentor-details h4 {
          margin: 0 0 3px 0;
          font-size: 1.1rem;
          color: #333;
      }
      .mentor-details p {
          margin: 0;
          font-size: 0.85em;
          color: #777;
          font-weight: 500;
      }

      /* Badges (Experience & Match) */
      .badges-container {
          display: flex;
          gap: 8px;
          margin-bottom: 15px;
          flex-wrap: wrap;
      }
      .info-badge {
          font-size: 0.75em;
          padding: 4px 10px;
          border-radius: 6px;
          font-weight: 600;
          display: inline-flex;
          align-items: center;
          gap: 4px;
      }
      .badge-dept { background: #e3f2fd; color: #0d47a1; }
      .badge-exp { background: #f8f9fa; color: #495057; border: 1px solid #dee2e6; }
      
      /* Status Badges */
      .status-badge { padding: 4px 8px; border-radius: 4px; font-size: 0.75em; font-weight: bold; text-transform: uppercase; }
      .status-Active { background-color: #d1e7dd; color: #0f5132; }
      .status-Pending { background-color: #fff3cd; color: #856404; }

      /* Bio Text */
      .bio-snippet {
          font-size: 0.9em;
          color: #666;
          line-height: 1.5;
          margin-bottom: 20px;
          /* Truncate text to 2 lines */
          display: -webkit-box;
          -webkit-line-clamp: 2;
          -webkit-box-orient: vertical;
          overflow: hidden;
          height: 3em; /* Fixed height for alignment */
      }

      /* Improved Connect Button */
      .action-area {
          margin-top: auto; /* Pushes button to bottom */
      }
      .btn-connect {
          width: 100%;
          padding: 10px;
          background: linear-gradient(135deg, #0d6efd 0%, #0056b3 100%);
          color: white;
          border: none;
          border-radius: 50px;
          font-weight: 600;
          cursor: pointer;
          transition: all 0.2s;
          font-size: 0.9em;
          display: flex;
          justify-content: center;
          align-items: center;
          gap: 8px;
          text-decoration: none; /* In case it's an anchor tag */
      }
      .btn-connect:hover {
          box-shadow: 0 4px 8px rgba(13, 110, 253, 0.3);
          transform: translateY(-1px);
      }
      
      /* Schedule Button Style */
      .btn-schedule {
          display: block;
          text-align: center;
          width: auto;
          padding: 5px 15px;
          background: white;
          border: 1px solid #0d6efd;
          color: #0d6efd;
          border-radius: 50px;
          text-decoration: none;
          font-weight: 600;
          font-size: 0.9em;
      }
      .btn-schedule:hover { background: #f0f7ff; }
  </style>
</head>
<body>
  <header class="main-header">
        <div class="logo-area"><h1>MentorshipApp</h1></div>
        <nav class="user-nav">
          <a href="${pageContext.request.contextPath}/MenteeServlet?action=profile">My Profile</a>
          <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-logout">Logout</a> 
        </nav>
    </header>

    <main class="dashboard-main-content">
        <aside class="sidebar">
          <h3 class="role-title">Welcome Mentee ${sessionScope.user.name}!</h3>
            <nav class="role-nav">
              <a href="${pageContext.request.contextPath}/MenteeServlet?action=dashboard" class="active-link" >🏠 Dashboard</a>
                            <a href="${pageContext.request.contextPath}/MenteeServlet?action=notes">📝 Notes</a>
              <a href="${pageContext.request.contextPath}/MenteeServlet?action=meetings">📷 Join Meet</a>
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
      <h2 id="page-title">👋 Dashboard Overview</h2>

      <div class="summary-cards">
        <div class="card">
          <h3>Pending Requests</h3>
          <p class="count">${pendingReq}</p>
          <a href="${pageContext.request.contextPath}/MenteeServlet?action=find_mentor">View Details</a>
        </div>
        <div class="card">
          <h3>Upcoming Meetings</h3>
          <p class="count">${upcomingCount}</p>
          <a href="${pageContext.request.contextPath}/MenteeServlet?action=meetings">Join Now</a>
        </div>
      </div>

      <div class="widget-section" style="margin-top: 30px;">
        <h3 class="section-header">👥 Your Mentors</h3>
        
        <div class="mentor-list">
            <c:if test="${empty myMentorsList}">
                <div style="grid-column: 1 / -1; background: #f8f9fa; padding: 20px; border-radius: 8px; text-align: center; color: #666;">
                    You are not connected with any mentors yet. Check the recommendations below!
                </div>
            </c:if>

            <c:forEach var="my" items="${myMentorsList}">
                <div class="mentor-card" style="border-left: 4px solid #0d6efd;">
                    <div class="card-header-flex">
                        <div class="mini-avatar">🎓</div>
                        <div class="mentor-details">
                            <h4>${my.mentorName}</h4>
                            <p>${my.menteeProgram}</p> </div>
                    </div>
                    
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 10px;">
                        <span class="status-badge status-${my.status}">${my.status}</span>
                        <c:if test="${my.status == 'Active'}">
                            <a href="${pageContext.request.contextPath}/MenteeServlet?action=meetings" style="text-decoration:none; color:#0d6efd; font-weight:600; font-size:0.9em;">
                                Schedule <i class="fas fa-arrow-right"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
      </div>

      <div class="widget-section" style="margin-top: 30px;">
        <h3 class="section-header">
            ✨ Recommended for You 
            <small style="font-weight:normal; font-size:0.7em; color:#777; margin-left:5px;">
                (Based on ${sessionScope.user.program})
            </small>
        </h3>
        
        <div class="mentor-list">
          
          <c:if test="${empty recommendedMentors}">
              <div style="grid-column: 1 / -1; padding: 20px; text-align: center; color: #777;">
                  <p>No recommendations available. Please ensure your <strong>Program/Department</strong> is set in your profile.</p>
                  <a href="${pageContext.request.contextPath}/MenteeServlet?action=profile" class="btn-schedule" style="display:inline-block; margin-top:10px;">Update Profile</a>
              </div>
          </c:if>

          <c:forEach var="m" items="${recommendedMentors}">
              <div class="mentor-card">
                
                <div class="card-header-flex">
                    <div class="mini-avatar">👤</div>
                    <div class="mentor-details">
                        <h4>${m.name}</h4>
                        <p>${m.department}</p>
                    </div>
                </div>

                <div class="badges-container">
                    <span class="info-badge badge-dept"><i class="fas fa-check-circle"></i> Best Match</span>
                    <c:if test="${m.yearsExperience > 0}">
                        <span class="info-badge badge-exp"><i class="fas fa-briefcase"></i> ${m.yearsExperience} yrs exp</span>
                    </c:if>
                </div>

                <div class="bio-snippet">
                    <c:choose>
                        <c:when test="${not empty m.bio}">${m.bio}</c:when>
                        <c:otherwise>Experienced mentor specializing in ${m.department}. Ready to help you grow.</c:otherwise>
                    </c:choose>
                </div>
                
                <div class="action-area">
                    <form action="${pageContext.request.contextPath}/MenteeServlet" method="POST">
                        <input type="hidden" name="action" value="send_request">
                        <input type="hidden" name="mentorId" value="${m.id}">
                        
                        <button type="submit" class="btn-connect" onclick="return confirm('Send mentorship request to ${m.name}?')">
                            Connect <i class="fas fa-user-plus"></i>
                        </button>
                    </form>
                </div>

              </div>
          </c:forEach>

        </div>
      </div>
    </section>
  </main>
</body>
</html>