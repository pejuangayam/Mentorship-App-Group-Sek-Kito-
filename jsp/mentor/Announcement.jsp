
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Announcements | Mentorship Platform</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Announcement.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentor.css">
  
  <style>
      /* --- CHECKBOX STYLES --- */
      .mentee-selection-box { border: 1px solid #ddd; border-radius: 8px; padding: 15px; background: #fcfcfc; margin-top: 5px; }
      .select-all-wrapper { padding-bottom: 10px; margin-bottom: 10px; border-bottom: 1px solid #eee; font-weight: bold; color: #0d6efd; }
      .mentee-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 10px; max-height: 150px; overflow-y: auto; }
      .mentee-checkbox-label { display: flex; align-items: center; background: white; border: 1px solid #e0e0e0; padding: 8px 12px; border-radius: 6px; cursor: pointer; transition: all 0.2s; font-size: 0.9em; color: #555; }
      .mentee-checkbox-label:hover { background: #f0f7ff; border-color: #b3d7ff; color: #0d6efd; }
      .mentee-checkbox-label input { margin-right: 10px; accent-color: #0d6efd; transform: scale(1.1); }

      /* --- WIZARD / STEP STYLES --- */
      .step-section { transition: opacity 0.3s ease-in-out; }
      .hidden-step { display: none; }
      .btn-next { background-color: #0d6efd; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; font-weight: 600; margin-top: 15px; float: right;}
      .btn-back { background-color: #6c757d; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; font-weight: 600; margin-right: 10px; }
      .step-indicator { margin-bottom: 15px; font-weight: bold; color: #555; border-bottom: 2px solid #eee; padding-bottom: 5px; }
      .step-indicator span.active { color: #0d6efd; border-bottom: 2px solid #0d6efd; padding-bottom: 5px; margin-bottom: -7px; display: inline-block;}
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
        <a href="${pageContext.request.contextPath}/MentorServlet?action=schedule" class="nav-item">📅 Schedule Meeting</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=announcements" class="nav-item active-link">📢 Announcements</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=notes" class="nav-item">📝 Notes & Files</a>
      </nav>
    </aside>

    <section class="content-area">
      <h2 id="page-title">📢 Announcements</h2>

      <c:if test="${not empty param.msg}">
          <div style="padding: 15px; background: #d4edda; color: #155724; border-radius: 5px; margin-bottom: 20px;">
              ✅ ${param.msg}
          </div>
      </c:if>

      <div class="widget-section" style="margin-bottom: 30px;">
        <h3 class="section-header">✏️ Create New Announcement</h3>
        
        <form action="${pageContext.request.contextPath}/MentorServlet" method="POST" id="announcementForm">
            <input type="hidden" name="action" value="post_announcement">

            <div class="announcement-form">
              
              <div id="step1" class="step-section">
                  <div class="step-indicator"><span class="active">Step 1: Recipients</span> &gt; Step 2: Content</div>
                  
                  <div class="form-group">
                    <label for="announcementTitle">Announcement Title *</label>
                    <input type="text" id="announcementTitle" name="title" class="form-input" placeholder="e.g., Important Update on Mentorship Sessions" required>
                  </div>

                  <div class="form-group">
                    <label>Send To *</label>
                    <div class="mentee-selection-box">
                        <div class="select-all-wrapper">
                            <label style="cursor: pointer;">
                                <input type="checkbox" id="selectAll" onclick="toggleAll(this)"> Select All Mentees
                            </label>
                        </div>
                        <div class="mentee-grid">
                            <c:forEach var="m" items="${menteeList}">
                                <label class="mentee-checkbox-label">
                                    <input type="checkbox" name="audience" value="${m.id}">
                                    ${m.name}
                                </label>
                            </c:forEach>
                            <c:if test="${empty menteeList}">
                                <p style="color: #999; font-style: italic; padding: 5px;">No active mentees found.</p>
                            </c:if>
                        </div>
                    </div>
                    <small style="color: #666; font-size: 0.85em;">Select one or more mentees.</small>
                  </div>

                  <div style="overflow: auto;">
                      <button type="button" class="btn-next" onclick="goToStep2()">Next ➡️</button>
                  </div>
              </div>

              <div id="step2" class="step-section hidden-step">
                  <div class="step-indicator">Step 1: Recipients &gt; <span class="active">Step 2: Content</span></div>

                  <div class="form-group">
                    <label for="announcementPriority">Priority Level</label>
                    <select id="announcementPriority" name="priority" class="form-input">
                      <option value="normal">Normal</option>
                      <option value="important">Important</option>
                      <option value="urgent">Urgent</option>
                    </select>
                  </div>

                  <div class="form-group">
                    <label for="announcementContent">Message *</label>
                    <textarea id="announcementContent" name="content" class="form-textarea" rows="6" placeholder="Type your announcement message here..." required></textarea>
                  </div>

                  <div class="form-actions">
                    <button type="button" class="btn-back" onclick="goToStep1()">⬅️ Back</button>
                    <button type="submit" class="btn btn-accept btn-large">📤 Post Announcement</button>
                  </div>
              </div>

            </div>
        </form>
      </div>

      <div class="widget-section">
        <h3 class="section-header">📋 Recent Announcements</h3>

        <c:if test="${empty announcementList}">
            <p style="padding: 20px; color: #666; text-align: center;">No announcements posted yet.</p>
        </c:if>

        <c:forEach var="ann" items="${announcementList}">
            <div class="announcement-card ${ann.priority}">
              <div class="announcement-header">
                <div class="announcement-priority-badge ${ann.priority}">
                    <c:choose>
                        <c:when test="${ann.priority == 'urgent'}">🔥 URGENT</c:when>
                        <c:when test="${ann.priority == 'important'}">⚠️ IMPORTANT</c:when>
                        <c:otherwise>📌 NOTICE</c:otherwise>
                    </c:choose>
                </div>
                <div class="announcement-date">Posted: ${ann.formattedDate}</div>
              </div>
              
              <h4 class="announcement-title">${ann.title}</h4>
              <p class="announcement-author">By: You (Mentor)</p>
              
              <div class="announcement-content">
                <p>${ann.content}</p>
              </div>
              
              <div class="announcement-footer">
                <div class="announcement-stats">
                  <span>👥 Sent to: ${ann.audienceDisplay}</span>
                </div>
                
                <div class="announcement-actions">                      
                    <form action="${pageContext.request.contextPath}/MentorServlet" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this announcement?');">
                        <input type="hidden" name="action" value="delete_announcement">
                        <input type="hidden" name="id" value="${ann.announcementID}">
                        <button type="submit" class="btn-text" style="color: #dc3545; border:none; background:none; cursor:pointer;">🗑️ Delete</button>
                    </form>
                </div>
              </div>
            </div>
        </c:forEach>

      </div>
    </section>
  </main>

  <script>
      function toggleAll(source) {
          var checkboxes = document.getElementsByName('audience');
          for(var i=0, n=checkboxes.length;i<n;i++) {
              checkboxes[i].checked = source.checked;
          }
      }

      function goToStep2() {
          var title = document.getElementById("announcementTitle").value;
          if(title.trim() === "") {
              alert("Please enter a title before proceeding.");
              return;
          }
          
          document.getElementById("step1").classList.add("hidden-step");
          document.getElementById("step2").classList.remove("hidden-step");
      }

      function goToStep1() {
          document.getElementById("step2").classList.add("hidden-step");
          document.getElementById("step1").classList.remove("hidden-step");
      }
  </script>

</body>
</html>