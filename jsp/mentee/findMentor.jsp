<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Find Mentor | Mentorship Platform</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notesMentee.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/find.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardMentee.css" />
    
    <style>
        /* --- Filter Styles --- */
        .filter-container {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            border: 1px solid #eee;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            flex-wrap: wrap;
        }
        .filter-group { flex: 1; min-width: 200px; }
        .filter-select, .search-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 0.95em;
            color: #555;
            background-color: #f9f9f9;
            transition: all 0.3s;
        }
        .filter-select:focus, .search-input:focus {
            background-color: #fff;
            border-color: #0d6efd;
            outline: none;
        }

        /* --- Mentor Card Improvements --- */
        .mentor-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }
        
        .mentor-card {
            background: #fff;
            border: 1px solid #eee;
            border-radius: 16px;
            padding: 25px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
            position: relative;
            overflow: hidden;
        }
        
        .mentor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.08);
            border-color: #dbeaff;
        }

        .mentor-avatar {
            width: 80px; height: 80px;
            background: linear-gradient(135deg, #e0e0e0 0%, #f5f5f5 100%);
            border-radius: 50%;
            margin: 0 auto 15px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.5rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        }

        .mentor-name {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        /* Tags for Dept & Profession */
        .tag-container {
            display: flex;
            justify-content: center;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 15px;
        }
        .badge-tag {
            font-size: 0.75rem;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .badge-dept { background-color: #e3f2fd; color: #0d47a1; }
        .badge-prof { background-color: #fff3cd; color: #856404; }
        .badge-exp { background-color: #e8f5e9; color: #1b5e20; border: 1px solid #c8e6c9; }

        /* Bio Text Limit */
        .bio-text {
            font-size: 0.9rem;
            color: #666;
            line-height: 1.5;
            margin-bottom: 20px;
            display: -webkit-box;
            -webkit-line-clamp: 2; /* Limits to 2 lines */
            -webkit-box-orient: vertical;
            overflow: hidden;
            flex-grow: 1; /* Pushes button to bottom */
        }

        /* --- Modern Button Styles --- */
        .btn-action-container {
            margin-top: auto; /* Ensures button stays at bottom */
        }

        .btn-modern {
            width: 100%;
            padding: 12px 20px;
            border: none;
            border-radius: 50px; /* Pill Shape */
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        /* Connect Button */
        .btn-connect {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            color: white;
            box-shadow: 0 4px 6px rgba(13, 110, 253, 0.2);
        }
        .btn-connect:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(13, 110, 253, 0.3);
        }
        .btn-connect:active { transform: translateY(0); }

        /* Disabled / Status Buttons */
        .btn-status { cursor: default; }
        .btn-status.pending { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .btn-status.active { background: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; }

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
                <a href="${pageContext.request.contextPath}/MenteeServlet?action=notes" >📝 Notes</a>
                <a href="${pageContext.request.contextPath}/MenteeServlet?action=meetings">📷 Join Meet</a>
                <a href="${pageContext.request.contextPath}/MenteeServlet?action=find_mentor" class="active-link">👥 Find Mentor</a>
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
            
            <c:if test="${not empty param.msg}">
                <div style="padding: 15px; background: #d4edda; color: #155724; border-radius: 5px; margin-bottom: 20px;">
                    ✅ ${param.msg}
                </div>
            </c:if>

            <div class="notes-container widget-section mb-5">
                <h2 id="page-title" class="content-header">My Requests Status</h2>
                
                <div class="table-wrapper">
                    <table class="notes-table" id="notes-table">
                        <thead>
                            <tr class="text-center">
                                <th class="col-no">No</th> <th class="col-name">Mentor Name</th>
                                <th class="col-status">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty myRequests}">
                                <tr><td colspan="3" style="text-align:center; padding: 20px; color:#777;">You haven't sent any requests yet.</td></tr>
                            </c:if>

                            <c:forEach var="req" items="${myRequests}" varStatus="status">
                                <tr>
                                    <td class="col-no">${status.count}</td> <td class="col-name" style="font-weight:600;">${req.mentorName}</td>
                                    <td class="col-status">
                                        <span style="padding: 5px 12px; border-radius: 20px; font-size: 0.85em; font-weight: bold;
                                            <c:choose>
                                                <c:when test="${req.status == 'Active'}">background:#d1e7dd; color:#0f5132;</c:when>
                                                <c:when test="${req.status == 'Rejected'}">background:#f8d7da; color:#842029;</c:when>
                                                <c:otherwise>background:#fff3cd; color:#664d03;</c:otherwise>
                                            </c:choose>">
                                            ${req.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="mentor-section widget-section">
                <h2 class="content-header">Find a Mentor</h2>
                <p class="text-secondary mb-4">Browse expert mentors and book your learning session</p>

                <div class="filter-container">
                    <div class="filter-group" style="flex: 2;">
                        <input type="text" placeholder="🔍 Search by name..." id="mentor-search-input" class="search-input" onkeyup="filterMentors()" />
                    </div>
                    <div class="filter-group">
                        <select id="dept-filter" class="filter-select" onchange="filterMentors()">
                            <option value="all">All Departments</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <select id="prof-filter" class="filter-select" onchange="filterMentors()">
                            <option value="all">All Professions</option>
                        </select>
                    </div>
                </div>

                <div class="mentor-cards-grid" id="mentor-list">
                    
                    <c:forEach var="m" items="${allMentors}">
                        <div class="mentor-card" 
                             data-name="${m.name.toLowerCase()}" 
                             data-dept="${m.department}" 
                             data-prof="${m.qualification}">
                             
                            <div class="mentor-avatar">👤</div>
                            
                            <div class="mentor-name">${m.name}</div>
                            
                            <div class="tag-container">
                                <span class="badge-tag badge-dept">${m.department}</span>
                                <span class="badge-tag badge-prof">${m.qualification}</span>
                                <span class="badge-tag badge-exp">📅 ${m.yearsExperience} Yrs Exp</span>
                            </div>
                            
                            <div class="bio-text">
                                <c:choose>
                                    <c:when test="${not empty m.bio}">${m.bio}</c:when>
                                    <c:otherwise>No bio available.</c:otherwise>
                                </c:choose>
                            </div>
                            
                            <c:set var="existingStatus" value="" />
                            <c:forEach var="req" items="${myRequests}">
                                <c:if test="${req.mentorName eq m.name}">
                                    <c:set var="existingStatus" value="${req.status}" />
                                </c:if>
                            </c:forEach>

                            <div class="btn-action-container">
                                <c:choose>
                                    <c:when test="${existingStatus == 'Active'}">
                                        <button type="button" class="btn-modern btn-status active" disabled>
                                            ✅ Already Active
                                        </button>
                                    </c:when>
                                    <c:when test="${existingStatus == 'Pending'}">
                                        <button type="button" class="btn-modern btn-status pending" disabled>
                                            ⏳ Request Pending
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/MenteeServlet" method="POST">
                                            <input type="hidden" name="action" value="send_request">
                                            <input type="hidden" name="mentorId" value="${m.id}">
                                            
                                            <button type="submit" class="btn-modern btn-connect"
                                                    onclick="return confirm('Send mentorship request to ${m.name}?')">
                                                <span>Connect</span> <i class="fas fa-arrow-right" style="font-size:0.8em;"></i>
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>

                    <div id="no-results" style="display:none; width:100%; text-align:center; padding:40px; color:#888; font-size:1.1em;">
                        No mentors match your current filters.
                    </div>

                </div>
            </div>

        </section>
    </main>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            populateFilters();
        });

        function populateFilters() {
            const cards = document.querySelectorAll('.mentor-card');
            const deptSet = new Set();
            const profSet = new Set();

            cards.forEach(card => {
                const dept = card.getAttribute('data-dept');
                const prof = card.getAttribute('data-prof');
                if(dept) deptSet.add(dept);
                if(prof) {
                    // Split in case user selected multiple professions (e.g. "Java, SQL")
                    const profs = prof.split(',').map(p => p.trim());
                    profs.forEach(p => profSet.add(p));
                }
            });

            const deptSelect = document.getElementById('dept-filter');
            deptSet.forEach(dept => {
                const option = document.createElement('option');
                option.value = dept;
                option.textContent = dept;
                deptSelect.appendChild(option);
            });

            const profSelect = document.getElementById('prof-filter');
            profSet.forEach(prof => {
                const option = document.createElement('option');
                option.value = prof;
                option.textContent = prof;
                profSelect.appendChild(option);
            });
        }

        function filterMentors() {
            const searchName = document.getElementById('mentor-search-input').value.toLowerCase();
            const selectedDept = document.getElementById('dept-filter').value;
            const selectedProf = document.getElementById('prof-filter').value;
            
            const cards = document.querySelectorAll('.mentor-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const name = card.getAttribute('data-name');
                const dept = card.getAttribute('data-dept');
                const prof = card.getAttribute('data-prof');

                const matchesName = name.includes(searchName);
                const matchesDept = (selectedDept === 'all' || dept === selectedDept);
                const matchesProf = (selectedProf === 'all' || prof.includes(selectedProf));

                if (matchesName && matchesDept && matchesProf) {
                    card.style.display = "flex"; /* Changed from block to flex to keep layout */
                    visibleCount++;
                } else {
                    card.style.display = "none";
                }
            });

            document.getElementById('no-results').style.display = (visibleCount === 0) ? 'block' : 'none';
        }
    </script>
</body>
</html>