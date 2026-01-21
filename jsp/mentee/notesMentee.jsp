
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Notes Content | Mentorship Platform</title>
  
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentee.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  
  <style>
      /* --- Page Layout --- */
      .notes-container { 
          padding: 30px; 
          max-width: 1200px; 
          margin: 0 auto; 
      }
      
      /* --- FIXED HEADER STYLE (Matched to Dashboard Overview) --- */
      .page-header-container {
          display: flex;
          align-items: center; /* Ensures vertical centering */
          gap: 15px; /* Space between icon and text */
          padding-bottom: 15px;
          border-bottom: 4px solid #2563eb; /* Thick blue line */
          margin-bottom: 30px;
          width: 100%;
      }
      
      .page-header-title { 
          font-size: 2rem; 
          color: #1f2937; 
          font-weight: 700; 
          margin: 0;
          line-height: 1;
      }

      .header-icon {
          font-size: 2rem; /* Matches text size */
          display: flex;
          align-items: center;
      }

      /* --- Search Bar --- */
      .search-bar-container { margin-bottom: 25px; position: relative; }
      .search-input {
          width: 100%; 
          padding: 15px 20px 15px 45px; 
          border: 1px solid #e5e7eb; 
          border-radius: 8px; 
          font-size: 1rem; 
          background-color: #fff;
          transition: all 0.3s ease;
          box-shadow: 0 1px 2px rgba(0,0,0,0.05);
      }
      .search-input:focus { 
          border-color: #2563eb; 
          outline: none; 
          box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1); 
      }
      .search-icon {
          position: absolute;
          left: 15px;
          top: 50%;
          transform: translateY(-50%);
          color: #9ca3af;
      }

      /* --- Table Styling --- */
      .table-wrapper {
          background: white; 
          border-radius: 10px; 
          overflow: hidden; 
          box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); 
          border: 1px solid #e5e7eb;
      }
      
      .notes-table { width: 100%; border-collapse: collapse; }
      
      .notes-table th {
          background-color: #f9fafb; 
          color: #4b5563; 
          text-transform: uppercase; 
          font-size: 0.75rem; 
          font-weight: 700; 
          padding: 16px 24px; 
          text-align: left; 
          border-bottom: 1px solid #e5e7eb;
          letter-spacing: 0.05em;
      }
      
      .notes-table td { 
          padding: 16px 24px; 
          border-bottom: 1px solid #f3f4f6; 
          color: #374151; 
          vertical-align: middle; 
          font-size: 0.95rem;
      }
      
      .notes-table tr:last-child td { border-bottom: none; }
      .notes-table tr:hover { background-color: #f8fafc; }

      /* --- File Name & Icons --- */
      .cell-name { font-weight: 600; color: #111827; }
      .table-link { 
          text-decoration: none; 
          color: inherit; 
          transition: color 0.2s; 
          display: flex; 
          align-items: center; 
          gap: 12px;
      }
      .table-link:hover { color: #2563eb; }
      .table-link:hover .file-text { text-decoration: underline; }

      /* Icon Colors */
      .fa-file-pdf { color: #ef4444; font-size: 1.4rem; }   
      .fa-file-word { color: #2563eb; font-size: 1.4rem; }  
      .fa-file-image { color: #8b5cf6; font-size: 1.4rem; } 
      .fa-file { color: #9ca3af; font-size: 1.4rem; }       
      .fa-folder { color: #f59e0b; font-size: 1.4rem; }     

      /* Creator Column */
      .cell-creator { 
          display: flex; 
          align-items: center; 
          gap: 8px; 
          color: #4b5563;
      }
      
      /* Empty State */
      .empty-state { text-align: center; padding: 60px; color: #9ca3af; }
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
              <a href="${pageContext.request.contextPath}/MenteeServlet?action=notes" class="active-link">📝 Notes</a>
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
      <div class="notes-container">
          
          <div class="page-header-container">
              <span class="header-icon">📝</span>
              <h2 class="page-header-title">Notes & Resources</h2>
          </div>
          
          <div class="search-bar-container">
              <i class="fas fa-search search-icon"></i>
              <input type="text" placeholder="Search file or mentor name..." id="search-input" onkeyup="filterTable()" class="search-input" />
          </div>
          
          <div class="table-wrapper">
              <table class="notes-table" id="notes-table">
                <thead>
                  <tr>
                    <th style="width: 45%;">Name</th>
                    <th style="width: 15%; text-align: center;">Type</th>
                    <th style="width: 25%;">Shared By</th>
                    <th style="width: 15%;">Date Uploaded</th>
                  </tr>
                </thead>
                <tbody>
                    <c:if test="${empty notesList}">
                        <tr>
                            <td colspan="4" class="empty-state">
                                <i class="far fa-folder-open" style="font-size: 3rem; margin-bottom: 15px; display: block; opacity: 0.5;"></i>
                                No notes have been shared with you yet.
                            </td>
                        </tr>
                    </c:if>

                    <c:forEach var="note" items="${notesList}">
                        <c:set var="fname" value="${fn:toLowerCase(note.filePath)}" />
                        
                        <tr class="note-row">
                            <td class="cell-name">
                                <c:url value="/MenteeServlet" var="viewLink">
                                    <c:param name="action" value="${note.type == 'folder' ? 'view_folder' : 'view_file'}" />
                                    <c:param name="id" value="${note.id}" />
                                </c:url>
                                
                                <a href="${viewLink}" class="table-link" title="Click to open/download">
                                    
                                    <c:choose>
                                        <c:when test="${note.type == 'folder'}">
                                            <i class="fas fa-folder"></i>
                                        </c:when>
                                        <c:when test="${fn:endsWith(fname, '.pdf')}">
                                            <i class="fas fa-file-pdf"></i>
                                        </c:when>
                                        <c:when test="${fn:endsWith(fname, '.doc') || fn:endsWith(fname, '.docx')}">
                                            <i class="fas fa-file-word"></i>
                                        </c:when>
                                        <c:when test="${fn:endsWith(fname, '.png') || fn:endsWith(fname, '.jpg') || fn:endsWith(fname, '.jpeg')}">
                                            <i class="fas fa-file-image"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-file"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <span class="file-text">${note.name}</span>
                                </a>
                            </td>

                            <td style="text-align: center;">
                                <span style="background: #eef2ff; color: #4f46e5; padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: 700;">
                                    <c:choose>
                                        <c:when test="${note.type == 'folder'}">FOLDER</c:when>
                                        <c:otherwise>FILE</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>

                            <td>
                                <div class="cell-creator">
                                    <i class="fas fa-user-circle" style="color: #9ca3af; font-size: 1.2rem;"></i>
                                    <span>${note.createdBy}</span>
                                </div>
                            </td>

                            <td class="col-date">
                                ${note.dateUploaded}
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
              </table>
          </div>
      </div>
    </section>
  </main>
  
  <script>
    function filterTable() {
        const input = document.getElementById("search-input");
        const filter = input.value.toLowerCase();
        const table = document.getElementById("notes-table");
        const tr = table.getElementsByTagName("tr");

        for (let i = 1; i < tr.length; i++) { 
            const tdName = tr[i].getElementsByTagName("td")[0];
            const tdCreator = tr[i].getElementsByTagName("td")[2];
            
            if (tdName || tdCreator) {
                const txtName = tdName.textContent || tdName.innerText;
                const txtCreator = tdCreator.textContent || tdCreator.innerText;
                
                if (txtName.toLowerCase().indexOf(filter) > -1 || txtCreator.toLowerCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }       
        }
    }
  </script>
</body>
</html>