
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Notes & Materials | Mentorship Platform</title>
  
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Announcement.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentor.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NotesMentor.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  
</head>
<body>

  <header class="main-header">
    <div class="logo-area"><h1>MentorshipApp</h1></div>
    <nav class="user-nav">
      <a href="${pageContext.request.contextPath}/MentorServlet?action=profile">My Profile</a>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-logout">Logout</a> 
    </nav>
    <button class="menu-toggle">☰</button>
  </header>

  <main class="dashboard-main-content">

    <aside class="sidebar">
      <div class="sidebar-header"><h3 class="role-title">Welcome Mentor ${sessionScope.user.name}</h3></div>
      <nav class="role-nav">
        <a href="${pageContext.request.contextPath}/MentorServlet?action=dashboard" class="nav-item">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=my_mentees" class="nav-item">👥 My Mentees</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=requests" class="nav-item">📩 Pending Requests</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=schedule" class="nav-item">📅 Schedule Meeting</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=announcements" class="nav-item">📢 Announcements</a>
        <a href="${pageContext.request.contextPath}/MentorServlet?action=notes" class="nav-item active-link">📝 Notes & Files</a>
      </nav>
    </aside>

    <section class="content-area">
      <h2 id="page-title">📝 Learning Materials Management</h2>

      <!-- Statistics Cards -->
      <div class="stats-grid">
          <div class="stat-card">
              <div class="stat-label"><i class="fas fa-file-alt"></i> Total Files</div>
              <div class="stat-value">${fn:length(notesList)}</div>
          </div>
          <div class="stat-card green">
              <div class="stat-label"><i class="fas fa-users"></i> Active Mentees</div>
              <div class="stat-value">${fn:length(menteeList)}</div>
          </div>
          <div class="stat-card orange">
              <div class="stat-label"><i class="fas fa-calendar-week"></i> This Month</div>
              <div class="stat-value" id="monthCount">0</div>
          </div>
      </div>

      <c:if test="${not empty param.msg}">
          <div style="padding: 15px; background: #d4edda; color: #155724; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb; animation: fadeIn 0.5s;">
              ✅ ${param.msg}
          </div>
      </c:if>

      <div class="widget-section" style="margin-bottom: 30px;">
        <h3 class="section-header">📤 Upload New Material</h3>
        
        <form action="${pageContext.request.contextPath}/MentorServlet" method="POST" enctype="multipart/form-data" id="uploadForm">
            <input type="hidden" name="action" value="save_note">

            <div class="announcement-form">
              <div class="form-group">
                <label for="noteTitle">File Title / Topic *</label>
                <input type="text" id="noteTitle" name="title" class="form-input" placeholder="e.g., Chapter 1 Lecture Notes" required>
              </div>

              <div class="form-group">
                  <label>Select File (PDF, DOCX, PPT - Max 10MB) *</label>
                  <div class="file-upload-wrapper">
                      <label for="file" class="file-input-label" id="fileLabel">
                          <i class="fas fa-cloud-upload-alt"></i>
                          <div>Click to browse or drag & drop your file here</div>
                          <div style="font-size: 0.85rem; color: #999; margin-top: 5px;">Supported: PDF, DOCX, PPTX</div>
                      </label>
                      <input type="file" id="file" name="file" accept=".pdf,.doc,.docx,.ppt,.pptx" required>
                      <div class="file-info-display" id="fileInfo"></div>
                      <div class="file-validation-msg" id="validationMsg"></div>
                  </div>
              </div>

              <div class="form-group">
                <label>Share With *</label>
                <div class="mentee-selection-box">
                    <div class="select-all-wrapper">
                        <label style="cursor: pointer;">
                            <input type="checkbox" id="selectAll" onclick="toggleAll(this)"> Select All Mentees
                        </label>
                    </div>
                    <div class="mentee-grid">
                        <c:forEach var="m" items="${menteeList}">
                            <label class="mentee-checkbox-label">
                                <input type="checkbox" name="audience" value="${m.id}" class="mentee-check">
                                ${m.name}
                            </label>
                        </c:forEach>
                        <c:if test="${empty menteeList}">
                            <p style="color: #999; font-style: italic; padding: 5px;">No active mentees found.</p>
                        </c:if>
                    </div>
                </div>
              </div>

              <div class="form-actions">
                <button type="submit" class="btn btn-accept btn-large" id="submitBtn">🚀 Upload File</button>
              </div>
            </div>
        </form>
      </div>

      <div class="widget-section">
        <h3 class="section-header">📂 Your Uploaded Files</h3>

        <!-- Search & Controls -->
        <div class="controls-bar">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search by file name or recipient...">
                <i class="fas fa-search"></i>
            </div>
            <div class="view-toggle">
                <button class="view-btn active" onclick="switchView('table')" id="tableViewBtn">
                    <i class="fas fa-table"></i> Table
                </button>
                <button class="view-btn" onclick="switchView('grid')" id="gridViewBtn">
                    <i class="fas fa-th"></i> Grid
                </button>
            </div>
        </div>

        <c:if test="${empty notesList}">
            <div class="empty-state">
                <i class="fas fa-folder-open"></i>
                <h3>No Files Yet</h3>
                <p>Start sharing learning materials with your mentees!</p>
            </div>
        </c:if>

        <c:if test="${not empty notesList}">
            <!-- Table View -->
            <table class="uploads-table" id="tableView">
                <thead>
                    <tr>
                        <th style="width: 40%;" onclick="sortTable(0)">File Name <i class="fas fa-sort"></i></th>
                        <th style="width: 20%;" onclick="sortTable(1)">Shared With <i class="fas fa-sort"></i></th>
                        <th style="width: 15%;" onclick="sortTable(2)">Date Uploaded <i class="fas fa-sort"></i></th>
                        <th style="width: 25%; text-align: center;">Actions</th>
                    </tr>
                </thead>
                <tbody id="tableBody">
                    <c:forEach var="note" items="${notesList}">
                        <tr data-filename="${fn:toLowerCase(note.name)}" data-audience="${fn:toLowerCase(note.audienceName)}">
                            <td>
                                <div class="file-info">
                                    <c:choose>
                                        <c:when test="${fn:endsWith(fn:toLowerCase(note.filePath), '.pdf')}">
                                            <i class="fas fa-file-pdf file-icon pdf"></i>
                                        </c:when>
                                        <c:when test="${fn:endsWith(fn:toLowerCase(note.filePath), '.doc') || fn:endsWith(fn:toLowerCase(note.filePath), '.docx')}">
                                            <i class="fas fa-file-word file-icon doc"></i>
                                        </c:when>
                                        <c:when test="${fn:endsWith(fn:toLowerCase(note.filePath), '.ppt') || fn:endsWith(fn:toLowerCase(note.filePath), '.pptx')}">
                                            <i class="fas fa-file-powerpoint file-icon ppt"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-file-alt file-icon default"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    <div>
                                        <div class="file-name">${note.name}</div>
                                        <div class="file-sub">${note.filePath}</div>
                                    </div>
                                </div>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${note.audienceName == 'All Mentees'}">
                                        <span class="badge badge-all">
                                            <i class="fas fa-users"></i> All Mentees
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forTokens items="${note.audienceName}" delims="," var="name">
                                            <span class="badge badge-single">
                                                <i class="fas fa-user"></i> ${name}
                                            </span>
                                        </c:forTokens>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td style="color: #666; font-size: 0.9em;">
                                ${note.dateUploaded}
                            </td>

                            <td>
                                <div class="action-buttons">
                                    <button class="btn-icon btn-download" onclick="downloadFile('${note.filePath}')" title="Download">
                                        <i class="fas fa-download"></i>
                                    </button>
                                    <button class="btn-icon btn-delete" onclick="confirmDelete(${note.id}, '${note.name}')" title="Delete">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Grid View -->
            <div class="files-grid" id="gridView">
                <c:forEach var="note" items="${notesList}">
                    <div class="file-card" data-filename="${fn:toLowerCase(note.name)}" data-audience="${fn:toLowerCase(note.audienceName)}">
                        <div class="card-icon">
                            <c:choose>
                                <c:when test="${fn:endsWith(fn:toLowerCase(note.filePath), '.pdf')}">
                                    <i class="fas fa-file-pdf" style="color: #dc3545;"></i>
                                </c:when>
                                <c:when test="${fn:endsWith(fn:toLowerCase(note.filePath), '.doc') || fn:endsWith(fn:toLowerCase(note.filePath), '.docx')}">
                                    <i class="fas fa-file-word" style="color: #0d6efd;"></i>
                                </c:when>
                                <c:when test="${fn:endsWith(fn:toLowerCase(note.filePath), '.ppt') || fn:endsWith(fn:toLowerCase(note.filePath), '.pptx')}">
                                    <i class="fas fa-file-powerpoint" style="color: #fd7e14;"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-file-alt" style="color: #6c757d;"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-title">${note.name}</div>
                        <div class="card-meta">
                            <div><i class="fas fa-calendar"></i> ${note.dateUploaded}</div>
                            <div style="margin-top: 5px;">
                                <c:choose>
                                    <c:when test="${note.audienceName == 'All Mentees'}">
                                        <span class="badge badge-all"><i class="fas fa-users"></i> All Mentees</span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forTokens items="${note.audienceName}" delims="," var="name" varStatus="status">
                                            <c:if test="${status.index < 2}">
                                                <span class="badge badge-single">${name}</span>
                                            </c:if>
                                        </c:forTokens>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="card-actions">
                            <button class="btn-icon btn-download" onclick="downloadFile('${note.filePath}')">
                                <i class="fas fa-download"></i>
                            </button>
                            <button class="btn-icon btn-delete" onclick="confirmDelete(${note.id}, '${note.name}')">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

      </div>
    </section>
  </main>

  <!-- Delete Confirmation Modal -->
  <div id="deleteModal" class="modal">
      <div class="modal-content">
          <div class="modal-header">
              <h3><i class="fas fa-exclamation-triangle" style="color: #dc3545;"></i> Confirm Deletion</h3>
              <button class="close-btn" onclick="closeModal()">&times;</button>
          </div>
          <p>Are you sure you want to delete "<strong id="deleteFileName"></strong>"?</p>
          <p style="color: #dc3545; font-size: 0.9em;">This will remove the file for ALL selected students.</p>
          <div class="modal-footer">
              <button class="btn btn-reject" onclick="closeModal()">Cancel</button>
              <button class="btn btn-delete" onclick="executeDelete()">Delete</button>
          </div>
      </div>
  </div>

  <!-- Success Toast -->
  <div class="toast" id="toast">
      <i class="fas fa-check-circle"></i> <span id="toastMsg">Action completed successfully!</span>
  </div>

  <script>
      let deleteId = null;

      // File Upload Validation
      document.getElementById('file').addEventListener('change', function(e) {
          const file = e.target.files[0];
          const fileInfo = document.getElementById('fileInfo');
          const validation = document.getElementById('validationMsg');
          const label = document.getElementById('fileLabel');
          
          if (file) {
              const maxSize = 10 * 1024 * 1024; // 10MB
              const allowedTypes = ['application/pdf', 'application/msword', 
                                   'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                                   'application/vnd.ms-powerpoint',
                                   'application/vnd.openxmlformats-officedocument.presentationml.presentation'];
              
              // Validate file size
              if (file.size > maxSize) {
                  validation.textContent = '❌ File too large! Maximum size is 10MB.';
                  validation.style.display = 'block';
                  fileInfo.style.display = 'none';
                  e.target.value = '';
                  return;
              }
              
              // Validate file type
              if (!allowedTypes.includes(file.type)) {
                  validation.textContent = '❌ Invalid file type! Only PDF, DOCX, and PPT files allowed.';
                  validation.style.display = 'block';
                  fileInfo.style.display = 'none';
                  e.target.value = '';
                  return;
              }
              
              // Display file info
              validation.style.display = 'none';
              const sizeInMB = (file.size / (1024 * 1024)).toFixed(2);
              fileInfo.innerHTML = `
                  <i class="fas fa-file-check" style="color: #28a745;"></i>
                  <strong>${file.name}</strong> (${sizeInMB} MB)
              `;
              fileInfo.style.display = 'block';
              label.style.borderColor = '#28a745';
              label.style.background = '#d4edda';
          }
      });

      // Form Submission
      document.getElementById('uploadForm').addEventListener('submit', function(e) {
          const checkboxes = document.querySelectorAll('.mentee-check:checked');
          if (checkboxes.length === 0) {
              e.preventDefault();
              alert('Please select at least one mentee to share with!');
              return;
          }
      });

      // Toggle All Mentees
      function toggleAll(source) {
          const checkboxes = document.getElementsByName('audience');
          for(let i=0; i<checkboxes.length; i++) {
              checkboxes[i].checked = source.checked;
          }
      }

      // Search Functionality
      document.getElementById('searchInput').addEventListener('keyup', function() {
          const searchTerm = this.value.toLowerCase();
          const tableRows = document.querySelectorAll('#tableBody tr');
          const gridCards = document.querySelectorAll('.file-card');
          let visibleCount = 0;
          
          // Search in table view
          tableRows.forEach(row => {
              const filename = row.getAttribute('data-filename');
              const audience = row.getAttribute('data-audience');
              if (filename.includes(searchTerm) || audience.includes(searchTerm)) {
                  row.style.display = '';
                  visibleCount++;
              } else {
                  row.style.display = 'none';
              }
          });
          
          // Search in grid view
          gridCards.forEach(card => {
              const filename = card.getAttribute('data-filename');
              const audience = card.getAttribute('data-audience');
              if (filename.includes(searchTerm) || audience.includes(searchTerm)) {
                  card.style.display = '';
              } else {
                  card.style.display = 'none';
              }
          });
          
          // Show "no results" message if needed
          if (visibleCount === 0 && searchTerm !== '') {
              let noResultRow = document.querySelector('.no-results');
              if (!noResultRow) {
                  noResultRow = document.createElement('tr');
                  noResultRow.className = 'no-results';
                  noResultRow.innerHTML = '<td colspan="4" style="text-align: center; padding: 30px; color: #999;">No files found matching your search.</td>';
                  document.getElementById('tableBody').appendChild(noResultRow);
              }
          } else {
              const noResultRow = document.querySelector('.no-results');
              if (noResultRow) noResultRow.remove();
          }
      });

      // Switch View (Table/Grid)
      function switchView(view) {
          const tableView = document.getElementById('tableView');
          const gridView = document.getElementById('gridView');
          const tableBtn = document.getElementById('tableViewBtn');
          const gridBtn = document.getElementById('gridViewBtn');
          
          if (view === 'table') {
              tableView.style.display = 'table';
              gridView.classList.remove('active');
              tableBtn.classList.add('active');
              gridBtn.classList.remove('active');
          } else {
              tableView.style.display = 'none';
              gridView.classList.add('active');
              tableBtn.classList.remove('active');
              gridBtn.classList.add('active');
          }
      }

      // Sort Table
      let sortDirection = {};
      function sortTable(columnIndex) {
          const table = document.getElementById('tableBody');
          const rows = Array.from(table.rows);
          const direction = sortDirection[columnIndex] === 'asc' ? 'desc' : 'asc';
          sortDirection[columnIndex] = direction;
          
          rows.sort((a, b) => {
              const aValue = a.cells[columnIndex].textContent.trim();
              const bValue = b.cells[columnIndex].textContent.trim();
              
              if (direction === 'asc') {
                  return aValue.localeCompare(bValue);
              } else {
                  return bValue.localeCompare(aValue);
              }
          });
          
          rows.forEach(row => table.appendChild(row));
      }

      // Download File
      function downloadFile(filename) {
          const downloadUrl = '${pageContext.request.contextPath}/uploads/' + filename;
          const link = document.createElement('a');
          link.href = downloadUrl;
          link.download = filename;
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
          showToast('Download started!');
      }

      // Delete Modal
      function confirmDelete(id, filename) {
          deleteId = id;
          document.getElementById('deleteFileName').textContent = filename;
          document.getElementById('deleteModal').style.display = 'block';
      }

      function closeModal() {
          document.getElementById('deleteModal').style.display = 'none';
          deleteId = null;
      }

      function executeDelete() {
          if (deleteId) {
              const form = document.createElement('form');
              form.method = 'POST';
              form.action = '${pageContext.request.contextPath}/MentorServlet';
              
              const actionInput = document.createElement('input');
              actionInput.type = 'hidden';
              actionInput.name = 'action';
              actionInput.value = 'delete_note';
              
              const idInput = document.createElement('input');
              idInput.type = 'hidden';
              idInput.name = 'id';
              idInput.value = deleteId;
              
              form.appendChild(actionInput);
              form.appendChild(idInput);
              document.body.appendChild(form);
              form.submit();
          }
      }

      // Toast Notification
      function showToast(message) {
          const toast = document.getElementById('toast');
          const toastMsg = document.getElementById('toastMsg');
          toastMsg.textContent = message;
          toast.classList.add('show');
          setTimeout(() => toast.classList.remove('show'), 3000);
      }

      // Calculate Monthly Upload Count
      window.addEventListener('DOMContentLoaded', function() {
          const rows = document.querySelectorAll('#tableBody tr');
          const currentMonth = new Date().getMonth();
          const currentYear = new Date().getFullYear();
          let monthCount = 0;
          
          rows.forEach(row => {
              const dateCell = row.cells[2]?.textContent.trim();
              if (dateCell) {
                  const uploadDate = new Date(dateCell);
                  if (uploadDate.getMonth() === currentMonth && uploadDate.getFullYear() === currentYear) {
                      monthCount++;
                  }
              }
          });
          
          document.getElementById('monthCount').textContent = monthCount;
      });

      // Close modals when clicking outside
      window.onclick = function(event) {
          const deleteModal = document.getElementById('deleteModal');
          if (event.target === deleteModal) {
              closeModal();
          }
      }
  </script>

</body>
</html>