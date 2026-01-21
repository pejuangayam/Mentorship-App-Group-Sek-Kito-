
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Schedule Meeting | Mentorship Platform</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentor.css">
  
  <style>
      /* --- Page Layout --- */
      .schedule-container {
          display: flex;
          flex-direction: column;
          gap: 30px;
          max-width: 1000px; /* Limits overall width */
          margin: 0 auto;
      }

      /* --- 1. NEAT FORM BOX DESIGN --- */
      .schedule-form-section {
          background: #ffffff;
          border-radius: 12px;
          padding: 25px 30px;
          box-shadow: 0 4px 15px rgba(0,0,0,0.03); /* Subtle shadow */
          border: 1px solid #f0f0f0;
      }

      .form-section-title {
          font-size: 1.3rem;
          color: #2c3e50;
          margin-bottom: 20px;
          border-bottom: 2px solid #f0f0f0;
          padding-bottom: 10px;
          font-weight: 700;
      }

      .form-group {
          margin-bottom: 18px;
      }

      .form-group label {
          display: block;
          margin-bottom: 6px;
          font-weight: 600;
          color: #555;
          font-size: 0.9em;
      }

      .form-input {
          width: 100%;
          padding: 10px 12px;
          border: 1px solid #ddd;
          border-radius: 6px;
          font-size: 0.95em;
          transition: border-color 0.2s;
          background-color: #fcfcfc;
      }

      .form-input:focus {
          border-color: #0d6efd;
          background-color: #fff;
          outline: none;
      }

      /* --- Compact Row for Date/Time/Duration --- */
      .form-row-compact {
          display: flex;
          gap: 20px;
      }
      .form-col {
          flex: 1; /* Equal width columns */
      }

      /* --- Mentee Selection Box (Neat & Scrollable) --- */
      .mentee-selection-box {
          border: 1px solid #e0e0e0;
          border-radius: 8px;
          padding: 12px;
          background: #fafafa;
      }

      .select-all-wrapper {
          padding-bottom: 8px;
          margin-bottom: 8px;
          border-bottom: 1px solid #eee;
          font-weight: 600;
          color: #0d6efd;
          font-size: 0.9em;
      }

      .mentee-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
          gap: 8px;
          max-height: 120px; /* Limits height to make it neat */
          overflow-y: auto;
          padding-right: 5px;
      }

      .mentee-checkbox-label {
          display: flex;
          align-items: center;
          background: white;
          border: 1px solid #ddd;
          padding: 6px 10px;
          border-radius: 5px;
          cursor: pointer;
          font-size: 0.85em;
          color: #444;
          transition: all 0.2s;
      }

      .mentee-checkbox-label:hover {
          background: #e8f4fd;
          border-color: #0d6efd;
          color: #0d6efd;
      }

      .mentee-checkbox-label input {
          margin-right: 8px;
          accent-color: #0d6efd;
      }

      /* --- Buttons --- */
      .form-actions {
          display: flex;
          gap: 15px;
          margin-top: 25px;
      }

      .btn-large {
          padding: 10px 20px;
          font-size: 0.95em;
          border-radius: 6px;
          cursor: pointer;
          border: none;
          font-weight: 600;
          flex: 1;
      }

      .btn-accept { background: #0d6efd; color: white; transition: background 0.2s; }
      .btn-accept:hover { background: #0b5ed7; }

      .btn-decline { background: #f8f9fa; color: #555; border: 1px solid #ddd; }
      .btn-decline:hover { background: #e2e6ea; }

      /* --- Upcoming Meetings Section --- */
      .upcoming-meetings-section {
          background: #fff;
          border-radius: 12px;
          padding: 25px;
          border: 1px solid #f0f0f0;
      }
      
      .meeting-list { display: flex; flex-direction: column; gap: 15px; }
      
      .meeting-item {
          display: flex;
          border: 1px solid #eee;
          border-radius: 8px;
          padding: 15px;
          align-items: center;
          background: #fff;
      }
      
      .meeting-time {
          min-width: 80px;
          text-align: center;
          padding-right: 15px;
          border-right: 1px solid #eee;
          margin-right: 15px;
      }
      
      .meeting-date { font-weight: bold; color: #333; }
      .meeting-hour { font-size: 0.85em; color: #777; margin-top: 4px; }
      
      .meeting-details h4 { margin: 0 0 5px 0; font-size: 1em; color: #2c3e50; }
      .meeting-mentee { margin: 0 0 5px 0; font-size: 0.9em; color: #666; }
      .meeting-badge { font-size: 0.75em; padding: 3px 8px; border-radius: 4px; font-weight: bold; }

  </style>
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
        <a href="${pageContext.request.contextPath}/MentorServlet?action=my_mentees" class="nav-item">👥 My Mentees</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=requests" class="nav-item">📩 Pending Requests</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=schedule" class="nav-item active-link">📅 Schedule Meeting</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=announcements" class="nav-item">📢 Announcements</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=notes" class="nav-item">📝 Notes & Files</a>

      </nav>
    </aside>

    <section class="content-area">
      <h2 id="page-title">📅 Schedule Meeting</h2>

      <c:if test="${not empty param.msg}">
          <div style="padding: 15px; background: #d4edda; color: #155724; border-radius: 6px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
              ✅ ${param.msg}
          </div>
      </c:if>

      <div class="schedule-container">
        
        <div class="schedule-form-section">
          <h3 class="form-section-title">Create New Meeting</h3>
          
          <form action="${pageContext.request.contextPath}/MentorServlet" method="POST">
             <input type="hidden" name="action" value="save_meeting">

             <div class="form-group">
                <label for="meetingTitle">Meeting Title / Topic</label>
                <input type="text" id="meetingTitle" name="title" class="form-input" placeholder="e.g., Weekly Progress Review" required>
             </div>

             <div class="form-group">
                <label>Select Participants</label>
                <div class="mentee-selection-box">
                    <div class="select-all-wrapper">
                        <label style="cursor: pointer; display: flex; align-items: center;">
                            <input type="checkbox" id="selectAll" onclick="toggleAll(this)" style="margin-right: 8px;"> Select All
                        </label>
                    </div>
                    <div class="mentee-grid">
                        <c:forEach var="m" items="${menteeList}">
                            <label class="mentee-checkbox-label">
                                <input type="checkbox" name="menteeIds" value="${m.id}">
                                ${m.name}
                            </label>
                        </c:forEach>
                        <c:if test="${empty menteeList}">
                            <div style="font-size:0.9em; color:#888; padding:5px;">No active mentees.</div>
                        </c:if>
                    </div>
                </div>
             </div>

             <div class="form-row-compact">
                <div class="form-col">
                    <div class="form-group">
                        <label for="meetingDate">Date</label>
                        <input type="date" id="meetingDate" name="date" class="form-input" required>
                    </div>
                </div>
                <div class="form-col">
                    <div class="form-group">
                        <label for="meetingTime">Start Time</label>
                        <input type="time" id="meetingTime" name="time" class="form-input" required>
                    </div>
                </div>
                <div class="form-col">
                    <div class="form-group">
                        <label for="duration">Duration</label>
                        <select id="duration" class="form-input">
                            <option value="30">30 mins</option>
                            <option value="60" selected>1 hour</option>
                            <option value="90">1.5 hours</option>
                            <option value="120">2 hours</option>
                        </select>
                    </div>
                </div>
             </div>

             <div class="form-group">
                <label for="meetingLocation">Location / Link</label>
                <input type="text" id="meetingLocation" name="link" class="form-input" placeholder="e.g., Google Meet Link or Room 301" required>
             </div>

             <div class="form-actions">
                <button type="submit" class="btn btn-accept btn-large">Schedule Meeting</button>
                <button type="reset" class="btn btn-decline btn-large">Reset</button>
             </div>
          </form>
        </div>

        <div class="upcoming-meetings-section">
          <h3 class="form-section-title">📆 Upcoming Schedule</h3>
          
          <div class="meeting-list">
            <c:if test="${empty meetingList}">
                <p style="text-align: center; color: #888; padding: 15px;">No upcoming meetings.</p>
            </c:if>

            <c:forEach var="mt" items="${meetingList}">
                <div class="meeting-item">
                  <div class="meeting-time">
                    <div class="meeting-date">${mt.meetingDate}</div>
                    <div class="meeting-hour">${mt.meetingTime}</div>
                  </div>
                  <div class="meeting-details">
                    <h4>${mt.title}</h4>
                    <p class="meeting-mentee">Participant: ${mt.menteeName}</p>
                    <p class="meeting-location">
                        <a href="${mt.link}" target="_blank" style="color:#007bff; text-decoration:none; font-size:0.9em;">
                           📍 Join / View Location
                        </a>
                    </p>
                  </div>
                  <div style="margin-left:auto;">
                      <span class="meeting-badge" style="background:#e0e0e0; color:#333;">${mt.status}</span>
                  </div>
                </div>
            </c:forEach>
          </div>
        </div>

      </div>
    </section>
  </main>

  <script>
      function toggleAll(source) {
          var checkboxes = document.getElementsByName('menteeIds');
          for(var i=0, n=checkboxes.length;i<n;i++) {
              checkboxes[i].checked = source.checked;
          }
      }
  </script>

</body>
</html>