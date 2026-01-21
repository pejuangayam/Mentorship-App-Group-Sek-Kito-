<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="css/register.css">
        <style>
            /* Grid Layout */
            .profession-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 12px;
                margin-top: 10px;
            }
            
            /* Card Button Style */
            .profession-label {
                display: block;
                position: relative;
                cursor: pointer;
                border: 2px solid #e9ecef;
                border-radius: 8px;
                padding: 12px 15px;
                background: #fff;
                transition: all 0.2s ease;
                height: 100%;
            }
            
            .profession-label:hover {
                border-color: #cbd3da;
                background-color: #f8f9fa;
            }

            .hidden-input { display: none; }

            /* Selected State (Blue Border + Background) */
            .hidden-input:checked + .profession-label {
                border-color: #0d6efd;
                background-color: #f0f7ff;
                box-shadow: 0 4px 6px rgba(13, 110, 253, 0.1);
            }

            .hidden-input:checked + .profession-label .check-icon {
                opacity: 1;
                transform: scale(1);
            }

            .check-icon {
                position: absolute;
                top: 10px;
                right: 10px;
                color: #0d6efd;
                opacity: 0;
                transform: scale(0);
                transition: all 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            }

            .prof-name { font-weight: 600; display: block; color: #333; }
            .prof-cat { font-size: 0.8em; color: #6c757d; text-transform: uppercase; }
        </style>
    </head>
    <body>
        <form action="RegisterServlet" method="POST">
            <div class="register-container">
                <h1 class="logo">Register Users</h1>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>
                
                <div class="role-selection mb-4 p-3 bg-light rounded text-center">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="role" id="mentor" value="mentor" required>
                        <label class="form-check-label fw-bold" for="mentor">Mentor (Lecturer)</label>
                    </div>
                    <div class="form-check form-check-inline ms-4">
                        <input class="form-check-input" type="radio" name="role" id="mentee" value="mentee" required>
                        <label class="form-check-label fw-bold" for="mentee">Mentee (Student)</label>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Full Name *</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email *</label>
                        <input type="email" class="form-control" name="email" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Password *</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Phone Number *</label>
                        <input type="tel" class="form-control" name="noPhone" required>
                    </div>
                </div>

                <div class="form-group mt-3">
                    <label class="form-label">Department / Faculty *</label>
                    <select name="department" class="form-select" required>
                        <option value="" disabled selected>Select Department...</option>
                        <c:forEach var="dept" items="${departmentList}">
                            <option value="${dept}">${dept}</option>
                        </c:forEach>
                        <c:if test="${empty departmentList}">
                            <option disabled>No departments available. Contact Admin.</option>
                        </c:if>
                    </select>
                </div>

                <div class="form-group mt-4" id="professionSection">
                    <label class="form-label fw-bold mb-2">Select Specialties (Multi-select) *</label>
                    <div class="profession-grid">
                        <c:forEach var="p" items="${professionList}">
                            <input type="checkbox" class="hidden-input" name="qualification" id="prof_${p.professionID}" value="${p.professionName}">
                            
                            <label class="profession-label" for="prof_${p.professionID}">
                                <i class="fas fa-check-circle check-icon"></i>
                                <span class="prof-name">${p.professionName}</span>
                                <span class="prof-cat">${p.category}</span>
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <div id="mentorFields" class="role-specific-fields mt-4 p-3 border rounded bg-light" style="display: none;">
                    <h5 class="mb-3 text-primary">Mentor Details</h5>
                    <div class="mb-3">
                        <label class="form-label">Years of Experience</label>
                        <input type="number" class="form-control" name="yearsExperience">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Bio</label>
                        <textarea class="form-control" name="bio" rows="3"></textarea>
                    </div>
                </div>

                <div id="menteeFields" class="role-specific-fields mt-4 p-3 border rounded bg-light" style="display: none;">
                    <h5 class="mb-3 text-success">Mentee Details</h5>
                    <div class="mb-3">
                        <label class="form-label">Student ID</label>
                        <input type="text" class="form-control" name="studentId">
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 mt-4 py-2 fw-bold">Register Account</button>
                <div class="text-center mt-3">
                    Already have an account? <a href="login.jsp" class="text-decoration-none">Login here</a>
                </div>
            </div>
        </form>

        <script>
            const mentorRadio = document.getElementById('mentor');
            const menteeRadio = document.getElementById('mentee');
            const professionSection = document.getElementById('professionSection');
            const mentorFields = document.getElementById('mentorFields');
            const menteeFields = document.getElementById('menteeFields');

            function toggleFields() {
                if(mentorRadio.checked){
                    // Mentor: Show Profession & Bio fields
                    professionSection.style.display = 'block';
                    mentorFields.style.display = 'block';
                    menteeFields.style.display = 'none';
                } else {
                    // Mentee: Hide Profession, Show Student ID
                    professionSection.style.display = 'none';
                    menteeFields.style.display = 'block';
                    mentorFields.style.display = 'none';
                }
            }
            mentorRadio.addEventListener('change', toggleFields);
            menteeRadio.addEventListener('change', toggleFields);
            
            // Run on load to set initial state
            toggleFields(); 
        </script>
    </body>
</html>