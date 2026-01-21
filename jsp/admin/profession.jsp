<%-- 
    Document   : profession
    Description: Manage Professions & Departments (Compact & Consistent Design)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Manage Content | Admin Panel</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardAdmin.css">
  
  <style>
    .content-area { padding: 30px; background-color: #f8f9fc; min-height: 100vh; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    
    #page-title { margin-bottom: 25px; color: #5a5c69; font-size: 1.75rem; font-weight: 700; }
    
    .success-message { padding: 15px 20px; background-color: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; border-radius: 6px; margin-bottom: 25px; font-weight: 600; display: flex; align-items: center; gap: 10px; }
    
    .dashboard-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 25px; margin-bottom: 30px; }
    .side-column-container { display: flex; flex-direction: column; gap: 25px; }
    .full-width { grid-column: 1 / -1; }
    
    .form-card { background: white; border-radius: 10px; box-shadow: 0 0.15rem 1.75rem 0 rgba(58,59,69,0.1); padding: 25px; border-top: 4px solid #4e73df; height: fit-content; }
    .form-card.secondary { border-top-color: #36b9cc; }
    .form-card.success { border-top-color: #1cc88a; }
    
    .form-section-title { font-size: 1.1rem; color: #4e73df; margin-bottom: 15px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: flex; align-items: center; gap: 8px; }
    .form-section-title.secondary { color: #36b9cc; }
    .form-section-title.success { color: #1cc88a; }
    
    .form-group { margin-bottom: 12px; }
    .form-label { display: block; margin-bottom: 5px; font-weight: 600; color: #6e707e; font-size: 0.9rem; }
    
    .form-input, .form-select, .form-textarea { 
        width: 100%; padding: 10px 12px; 
        border: 1px solid #d1d3e2; border-radius: 6px; 
        font-size: 0.95rem; color: #495057; 
        font-family: inherit; 
        transition: border-color 0.2s; box-sizing: border-box;
    }
    
    .form-input:focus, .form-select:focus, .form-textarea:focus { border-color: #4e73df; outline: none; box-shadow: 0 0 0 0.2rem rgba(78,115,223,0.1); }
    
    .form-textarea { resize: vertical; min-height: 80px; height: 80px; } 

    .btn-primary { background-color: #4e73df; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 600; width: 100%; transition: all 0.2s; font-size: 0.95rem; margin-top: 5px; }
    .btn-primary:hover { background-color: #2e59d9; }
    .btn-primary.secondary { background-color: #36b9cc; }
    .btn-primary.secondary:hover { background-color: #2c9faf; }
    
    .tags-container { display: flex; flex-wrap: wrap; gap: 8px; }
    .tag-wrapper { display: inline-flex; align-items: center; gap: 6px; background-color: #e3f2fd; color: #0d47a1; padding: 6px 12px; border-radius: 50px; font-size: 0.85rem; font-weight: 600; border: 1px solid #bbdefb; }
    .tag-cat { background-color: #e8f5e9; color: #1b5e20; border-color: #c8e6c9; }
    
    .btn-delete-mini { background: none; border: none; color: #ff6b6b; cursor: pointer; font-size: 1.1rem; line-height: 1; padding: 0; display: flex; align-items: center; }
    .btn-delete-mini:hover { color: #c0392b; transform: scale(1.1); }
    
    .professions-list { border-top: 1px solid #eaecf4; margin-top: 10px; }
    .prof-item { display: flex; justify-content: space-between; align-items: center; padding: 15px; border-bottom: 1px solid #eaecf4; transition: background 0.2s; }
    .prof-item:hover { background-color: #fafafa; }
    .prof-item:last-child { border-bottom: none; }
    .prof-name { font-weight: 700; color: #5a5c69; font-size: 1rem; margin-bottom: 4px; }
    .prof-desc { color: #858796; font-size: 0.85rem; }
    .prof-meta { display: flex; align-items: center; gap: 10px; }
    .prof-cat-badge { background-color: #f1f3f5; color: #6c757d; padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; border: 1px solid #e9ecef; }
    
    .btn-delete-prof { color: white; background-color: #e74a3b; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.75rem; font-weight: 600; transition: background 0.2s; }
    .btn-delete-prof:hover { background-color: #be2617; }
    
    .empty-state { padding: 40px; text-align: center; color: #858796; font-style: italic; }

    #newCategoryInput { animation: fadeIn 0.3s ease-in-out; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }

    @media (max-width: 992px) { .dashboard-grid { grid-template-columns: 1fr; } }
  </style>
</head>
<body>

  <header class="main-header">
    <div class="logo-area"><h1>MentorshipApp</h1></div>
    <nav class="user-nav">
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-logout">Logout</a> 
    </nav>
  </header>

  <main class="dashboard-main-content">
    <aside class="sidebar">
            <div class="sidebar-header">
                <h3 class="role-title">Welcome ${sessionScope.user.name}</h3>
                <p class="role-subtitle">Administrator Panel</p>
            </div>      <nav class="role-nav">
        <a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/AdminServlet?action=list_professions" class="active-link">🧰 Profession & Department </a>
        <a href="${pageContext.request.contextPath}/admin/profileAdmin.jsp">👤 Profile</a>
      </nav>
    </aside>
    
    <section class="content-area">
      <h2 id="page-title">Manage Professions & Departments</h2>
      
      <c:if test="${not empty param.msg}">
        <div class="success-message">
            ✅ ${param.msg}
        </div>
      </c:if>
      
      <div class="dashboard-grid">
        
        <div class="form-card">
          <h3 class="form-section-title">➕ Add New Profession</h3>
          <form action="${pageContext.request.contextPath}/AdminServlet" method="POST">
            <input type="hidden" name="action" value="add_profession">
            
            <div class="form-group">
              <label class="form-label">Profession Name</label>
              <input type="text" name="professionName" class="form-input" placeholder="e.g. Software Engineer" required>
            </div>
            
            <div class="form-group">
              <label class="form-label">Category</label>
              <select id="professionCategory" name="professionCategory" class="form-select" onchange="toggleCategoryInput()" required>
                <c:forEach var="cat" items="${categoryList}">
                  <option value="${cat}">${cat}</option>
                </c:forEach>
                <option value="Other" style="font-weight: bold; color: #4e73df;">+ Create New Category</option>
              </select>
              
              <div id="newCategoryInput" style="display: none; margin-top: 10px;">
                <input type="text" id="customCategory" name="customCategory" class="form-input" placeholder="Enter new category name">
              </div>
            </div>
            
            <div class="form-group">
              <label class="form-label">Description</label>
              <textarea name="professionDescription" class="form-textarea" placeholder="Brief description of the profession..." required></textarea>
            </div>
            
            <button type="submit" class="btn-primary">Save Profession</button>
          </form>
        </div>

        <div class="side-column-container">
          
          <div class="form-card secondary">
            <h3 class="form-section-title secondary">🏢 Add Department</h3>
            <form action="${pageContext.request.contextPath}/AdminServlet" method="POST">
              <input type="hidden" name="action" value="add_department">
              <div class="form-group">
                <input type="text" name="deptName" class="form-input" placeholder="e.g. Faculty of Science" required>
              </div>
              <button type="submit" class="btn-primary secondary">Add Department</button>
            </form>
          </div>

          <div class="form-card secondary">
            <h3 class="form-section-title secondary" style="margin-bottom: 15px;">🏫 Departments</h3>
            <div class="tags-container">
              <c:forEach var="dept" items="${deptList}">
                <div class="tag-wrapper">
                  ${dept}
                  <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" onsubmit="return confirm('Delete department: ${dept}?');" style="display:inline; margin:0;">
                    <input type="hidden" name="action" value="delete_department">
                    <input type="hidden" name="name" value="${dept}">
                    <button type="submit" class="btn-delete-mini" title="Delete">×</button>
                  </form>
                </div>
              </c:forEach>
              <c:if test="${empty deptList}"><em style="color:#999; font-size:0.9rem;">No departments found.</em></c:if>
            </div>
          </div>

          <div class="form-card">
            <h3 class="form-section-title" style="margin-bottom: 15px;">📂 Categories</h3>
            <div class="tags-container">
              <c:forEach var="cat" items="${categoryList}">
                <div class="tag-wrapper tag-cat">${cat}</div>
              </c:forEach>
            </div>
          </div>
        </div>
      </div>

      <div class="form-card full-width success">
        <h3 class="form-section-title success">📋 Registered Professions</h3>
        <div class="professions-list">
          <c:forEach var="p" items="${profList}">
            <div class="prof-item">
              <div style="flex: 1; padding-right: 15px;">
                <div class="prof-name">${p[0]}</div>
                <div class="prof-desc">${p[2]}</div>
              </div>
              <div class="prof-meta">
                <span class="prof-cat-badge">${p[1]}</span>
                <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" onsubmit="return confirm('Delete profession: ${p[0]}?');" style="margin:0;">
                  <input type="hidden" name="action" value="delete_profession">
                  <input type="hidden" name="name" value="${p[0]}">
                  <button type="submit" class="btn-delete-prof">Delete</button>
                </form>
              </div>
            </div>
          </c:forEach>
          <c:if test="${empty profList}">
            <div class="empty-state">No professions added yet.</div>
          </c:if>
        </div>
      </div>
    </section>
  </main>

  <script>
    function toggleCategoryInput() {
      const select = document.getElementById("professionCategory");
      const inputDiv = document.getElementById("newCategoryInput");
      const inputField = document.getElementById("customCategory");
      if (select.value === "Other") {
        inputDiv.style.display = "block";
        inputField.required = true; 
      } else {
        inputDiv.style.display = "none";
        inputField.required = false;
        inputField.value = ""; 
      }
    }
  </script>
</body>
</html>