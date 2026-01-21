
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>View User | Mentorship Platform</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardAdmin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/viewUser.css">
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
            </div>
                </div>
                <nav class="role-nav">
                    <a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard">
                        <span class="nav-icon">🏠</span> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/AdminServlet?action=list_professions">
                        <span class="nav-icon">🧰</span> Profession & Department 
                    </a>              
                    <a href="${pageContext.request.contextPath}/admin/profileAdmin.jsp">
                        <span class="nav-icon">👤</span> Profile
                    </a>
                </nav>
            </aside>

            <section class="content-area">
                <h2 id="page-title">User Information</h2>

                <div class="simple-user-card">
                    <div class="user-basic-info">
                        <div class="user-details">
                            <h1 class="user-name">${viewUser.name}</h1>
                            <div class="user-role-badge">${viewUser.role}</div>
                        </div>
                    </div>

                    <div class="user-info-grid">
                        <div class="info-row">
                            <span class="info-label">Name:</span>
                            <span class="info-value">${viewUser.name}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Email:</span>
                            <span class="info-value">${viewUser.email}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">User ID:</span>
                            <span class="info-value">#${viewUser.id}</span>
                        </div>
                    </div>

                    <div class="back-button-container">
                        <a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard" class="btn btn-outline">Back to List</a>
                    </div>
                </div>
            </section>
        </main>
    </body>
</html>