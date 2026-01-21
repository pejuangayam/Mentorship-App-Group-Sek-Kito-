
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Admin Dashboard | Mentorship Platform</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardAdmin.css">
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
                <nav class="role-nav">
                    <a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard" class="active-link">
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
                <h2 id="page-title">Admin Dashboard</h2>

                <div class="stats-grid">
                    <div class="stat-card">
                        <h3>Total Users</h3>
                        <div class="number">${totalCount}</div>
                    </div>
                    <div class="stat-card mentors">
                        <h3>Total Mentors</h3>
                        <div class="number">${mentorCount}</div>
                    </div>
                    <div class="stat-card mentees">
                        <h3>Total Mentees</h3>
                        <div class="number">${menteeCount}</div>
                    </div>
                </div>

                <div class="section-title-container">
                    <h3 class="section-title">Manage Users</h3>
                    <p class="section-subtitle">Manage all registered users</p>
                </div>

                <section class="user-table-container">
                    <table class="user-table">
                        <thead>
                            <tr>
                                <th width="50">ID</th>
                                <th>Name</th>
                                <th>Role</th>
                                <th>Email</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${allUsers}">
                                <tr>
                                    <td class="row-number">${u.id}</td>
                                    <td>${u.name}</td>
                                    <td>
                                        <span class="badge ${u.role == 'Mentor' ? 'it' : 'business'}">
                                            ${u.role}
                                        </span>
                                    </td>
                                    <td>${u.email}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/AdminServlet?action=viewUser&id=${u.id}&role=${u.role}" class="table-btn">View</a>
                                        
                                        <a href="${pageContext.request.contextPath}/AdminServlet?action=deleteUser&id=${u.id}&role=${u.role}" 
                                           class="table-btn delete"
                                           onclick="return confirm('Are you sure you want to delete ${u.name}?');">Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty allUsers}">
                                <tr>
                                    <td colspan="5" style="text-align:center;">No users found in database.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </section>

            </section>
        </main>
    </body>
</html>