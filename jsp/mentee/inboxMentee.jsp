
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Inbox | Mentorship Platform</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentee.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/inboxMentee.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
  
  <style>
      /* --- Sidebar Badge Style --- */
      .nav-badge {
          background-color: #dc3545; /* Red */
          color: white;
          font-size: 0.75rem;
          padding: 2px 6px;
          border-radius: 50%;
          margin-left: auto; /* Pushes to right side of link */
          font-weight: bold;
          min-width: 18px;
          text-align: center;
          display: inline-block;
      }

      /* Existing Header Styles */
      .inbox-header {
          display: flex; justify-content: space-between; align-items: center;
          margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #f0f0f0;
      }
      .inbox-title-section h2 { margin: 0; color: #333; font-size: 1.8rem; }
      
      /* Modal */
      .mail-modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 1000; justify-content: center; align-items: center; }
      .modal-overlay { position: absolute; width: 100%; height: 100%; background: rgba(0,0,0,0.5); }
      .modal-content { position: relative; background: white; width: 90%; max-width: 600px; padding: 20px; border-radius: 8px; z-index: 1001; }
      .modal-header { display: flex; justify-content: space-between; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }
      .modal-close { background: none; border: none; font-size: 1.5rem; cursor: pointer; }
      .mail-icon i { font-style: normal; font-family: "Font Awesome 6 Free"; font-weight: 900; }
  </style>
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
              <a href="${pageContext.request.contextPath}/MenteeServlet?action=meetings">📷 Join Meet</a>
              <a href="${pageContext.request.contextPath}/MenteeServlet?action=find_mentor">👥 Find Mentor</a>
              
              <a href="${pageContext.request.contextPath}/MenteeServlet?action=inbox" class="active-link" style="display: flex; align-items: center;">
                  📩 My Inbox
                  <c:if test="${not empty sessionScope.inboxCount && sessionScope.inboxCount > 0}">
                      <span class="nav-badge">${sessionScope.inboxCount}</span>
                  </c:if>
              </a>
            </nav>
        </aside>

    <section class="content-area">
        <div class="inbox-title-section">
          <h2 id="page-title">📬 Inbox Messages</h2>
        </div>

      <div class="widget-section">
        <h3 class="section-header">All Messages</h3>
        
        <div class="mail-list">
          <c:if test="${empty inboxList}">
              <p style="padding: 20px; text-align: center; color: #777;">No new messages.</p>
          </c:if>

          <c:forEach var="msg" items="${inboxList}">
              <div class="mail-item ${msg.priority}">
                <div class="mail-icon">
                  <c:choose>
                      <c:when test="${msg.priority == 'urgent'}"><i class="fas fa-exclamation-circle" style="color:red;"></i></c:when>
                      <c:when test="${msg.priority == 'important'}"><i class="fas fa-star" style="color: #b35700;"></i></c:when>
                      <c:otherwise><i class="fas fa-envelope"></i></c:otherwise>
                  </c:choose>
                </div>
                
                <div class="mail-content">
                  <div class="mail-header">
                    <div class="mail-info">
                      <h4 class="mail-subject">${msg.title}</h4>
                      <p class="mail-sender">
                        <i class="fas fa-user-circle"></i> ${msg.audienceName} 
                        <span class="sender-role">(Mentor)</span>
                      </p>
                    </div>
                    <span class="mail-time">${msg.formattedDate}</span>
                  </div>
                  <p class="mail-preview">${msg.content}</p>
                  <div class="mail-tags">
                    <span class="tag tag-${msg.priority}">${msg.priority}</span>
                  </div>
                </div>
                
                <div class="mail-actions">
                  <button class="btn btn-small btn-view" 
                          onclick="openMessage('${msg.title}', '${msg.audienceName}', '${msg.formattedDate}', '${msg.content}')">
                      View Details
                  </button>
                </div>
              </div>
          </c:forEach>
        </div>
      </div>
    </section>
  </main>

  <div class="mail-modal" id="mailModal">
    <div class="modal-overlay" onclick="closeModal()"></div>
    <div class="modal-content">
      <div class="modal-header">
        <h3 id="modalSubject">Message Subject</h3>
        <button class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></button>
      </div>
      <div class="modal-body">
        <div class="modal-sender-info" style="margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
            <h4 id="modalSender" style="margin: 0;">Sender Name</h4>
            <p id="modalTime" style="margin: 0; color: #777; font-size: 0.9em;">Time</p>
        </div>
        <div class="modal-message-content">
          <div class="message-full-text" id="modalFullMessage" style="white-space: pre-wrap; line-height: 1.6;"></div>
        </div>
      </div>
      <div class="modal-footer" style="margin-top: 20px; text-align: right;">
        <button class="btn" onclick="closeModal()" style="padding: 8px 15px; cursor: pointer;">Close</button>
      </div>
    </div>
  </div>

  <script>
      function openMessage(title, sender, time, content) {
          document.getElementById('modalSubject').innerText = title;
          document.getElementById('modalSender').innerText = sender;
          document.getElementById('modalTime').innerText = time;
          document.getElementById('modalFullMessage').innerText = content;
          document.getElementById('mailModal').style.display = 'flex';
      }
      function closeModal() {
          document.getElementById('mailModal').style.display = 'none';
      }
  </script>
</body>
</html>