package controller;

import dao.MentorDAO;
import model.Mentorship;
import model.User;
import model.Meeting;
import model.Announcement;
import model.Note; 
import model.Profession;
import java.io.IOException;
import java.io.File; 
import java.io.InputStream; 
import java.nio.file.Files; 
import java.nio.file.Paths; 
import java.nio.file.StandardCopyOption; 
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig; 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part; 

@WebServlet(name = "MentorServlet", urlPatterns = {"/MentorServlet"})
@MultipartConfig 
public class MentorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            switch (action) {
                case "dashboard": loadMentorDashboard(request, response); break;
                case "profile": loadProfilePage(request, response); break;
                case "requests": loadPendingMentorships(request, response); break;
                case "accept": handleMentorshipStatus(request, response, "Active"); break;
                case "decline": handleMentorshipStatus(request, response, "Rejected"); break;
                case "my_mentees": loadMyMentees(request, response); break;
                case "schedule": loadSchedulePage(request, response); break;
                case "announcements": loadAnnouncementPage(request, response); break;
                case "notes": loadNotesPage(request, response); break; 
                default: loadMentorDashboard(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("update_profile".equals(action)) { updateProfile(request, response); } 
            else if ("save_meeting".equals(action)) { saveMeeting(request, response); } 
            else if ("post_announcement".equals(action)) { postAnnouncement(request, response); } 
            else if ("delete_announcement".equals(action)) { deleteAnnouncement(request, response); }
            else if ("save_note".equals(action)) { saveNote(request, response); } 
            else if ("delete_note".equals(action)) { deleteNote(request, response); } 
            else if ("delete_mentee".equals(action)) { removeMentee(request, response); } 
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MentorServlet?action=dashboard&msg=Error: " + e.getMessage());
        }
    }

    //  HELPER METHODS 
    
    private void loadMentorDashboard(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        MentorDAO dao = new MentorDAO();
        int myMenteesCount = dao.getCount(user.getId(), "Active");
        int pendingRequests = dao.getCount(user.getId(), "Pending");
        List<Mentorship> widgetList = dao.getRecentPendingRequests(user.getId());
        List<User> activeMentees = dao.getMyMentees(user.getId());
        request.setAttribute("myMenteesCount", myMenteesCount);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("requestList", widgetList);
        request.setAttribute("myMenteesList", activeMentees);
        request.getRequestDispatcher("/mentor/dashboardMentor.jsp").forward(request, response);
    }

    private void loadPendingMentorships(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        MentorDAO dao = new MentorDAO();
        List<Mentorship> reqList = dao.getAllPendingRequests(user.getId());
        request.setAttribute("requestList", reqList);
        request.getRequestDispatcher("/mentor/PendingRequest.jsp").forward(request, response);
    }

    private void handleMentorshipStatus(HttpServletRequest request, HttpServletResponse response, String newStatus) throws Exception {
        int mentorshipId = Integer.parseInt(request.getParameter("id"));
        MentorDAO dao = new MentorDAO();
        dao.updateRequestStatus(mentorshipId, newStatus);
        response.sendRedirect("MentorServlet?action=requests&msg=Mentorship " + newStatus);
    }

    private void loadMyMentees(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        MentorDAO dao = new MentorDAO();
        List<User> menteeList = dao.getMyMentees(user.getId());
        request.setAttribute("myMenteesList", menteeList);
        request.getRequestDispatcher("/mentor/MyMentees.jsp").forward(request, response);
    }

    //Handles Profile + Password Change
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        MentorDAO dao = new MentorDAO();

        // 1. Update Basic Info
        user.setName(request.getParameter("fullName"));
        user.setNoPhone(request.getParameter("noPhone"));
        user.setDepartment(request.getParameter("department"));
        user.setBio(request.getParameter("bio"));
        String[] qualArray = request.getParameterValues("qualification");
        user.setQualification((qualArray != null) ? String.join(", ", qualArray) : "");
        try { 
            user.setYearsExperience(Integer.parseInt(request.getParameter("experience"))); 
        } catch (Exception e) { 
            user.setYearsExperience(0); 
        }
        
        dao.updateProfile(user);
        
        String msg = "Profile Updated Successfully";

        // 2. Handle Password Change (If fields are filled)
        String currentPass = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");

        if (newPass != null && !newPass.trim().isEmpty()) {
            // Verify Current Password
            if (dao.verifyPassword(user.getId(), currentPass)) {
                // Verify Match
                if (newPass.equals(confirmPass)) {
                    // Update Password
                    dao.updatePassword(user.getId(), newPass);
                    msg = "Profile and Password Updated Successfully";
                } else {
                    msg = "Profile Updated, but Password Mismatch";
                }
            } else {
                msg = "Profile Updated, but Current Password Incorrect";
            }
        }

        response.sendRedirect("MentorServlet?action=profile&msg=" + msg);
    }

    private void loadSchedulePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        MentorDAO dao = new MentorDAO();
        List<User> menteeList = dao.getMyMentees(user.getId());
        List<Meeting> meetingList = dao.getUpcomingMeetings(user.getId());
        request.setAttribute("menteeList", menteeList);
        request.setAttribute("meetingList", meetingList);
        request.getRequestDispatcher("/mentor/ScheduleMeeting.jsp").forward(request, response);
    }

    private void saveMeeting(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String[] menteeIds = request.getParameterValues("menteeIds");
        if (menteeIds != null && menteeIds.length > 0) {
            MentorDAO dao = new MentorDAO();
            dao.saveMeetings(user.getId(), menteeIds, request.getParameter("title"), request.getParameter("date"), request.getParameter("time"), request.getParameter("link"));
        }
        response.sendRedirect("MentorServlet?action=schedule&msg=Meeting Scheduled Successfully");
    }

    private void loadAnnouncementPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        MentorDAO dao = new MentorDAO();
        List<User> menteeList = dao.getMyMentees(user.getId());
        List<Announcement> annList = dao.getAnnouncements(user.getId(), menteeList);
        request.setAttribute("menteeList", menteeList);
        request.setAttribute("announcementList", annList);
        request.getRequestDispatcher("/mentor/Announcement.jsp").forward(request, response);
    }

    private void postAnnouncement(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String[] audiences = request.getParameterValues("audience");
        if (audiences != null && audiences.length > 0) {
            MentorDAO dao = new MentorDAO();
            dao.postAnnouncements(user.getId(), request.getParameter("title"), request.getParameter("content"), request.getParameter("priority"), audiences);
        }
        response.sendRedirect("MentorServlet?action=announcements&msg=Announcement Posted Successfully");
    }
    
    private void deleteAnnouncement(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        MentorDAO dao = new MentorDAO();
        dao.deleteAnnouncement(id);
        response.sendRedirect("MentorServlet?action=announcements&msg=Announcement Deleted Successfully");
    }

    private void loadProfilePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        MentorDAO dao = new MentorDAO();
        List<Profession> professionList = dao.getAllProfessions();
        List<String> departmentList = dao.getAllDepartments();
        request.setAttribute("professionList", professionList);
        request.setAttribute("departmentList", departmentList); 
        request.getRequestDispatcher("mentor/profileMentor.jsp").forward(request, response);
    }

    //  NOTES LOGIC 
    private void loadNotesPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        MentorDAO dao = new MentorDAO();
        List<User> menteeList = dao.getMyMentees(user.getId());
        
        String appPath = request.getServletContext().getRealPath("");
        if (appPath == null) appPath = System.getProperty("user.home"); 
        
        List<Note> notesList = dao.getMyUploadedNotes(user.getId(), appPath);
        request.setAttribute("menteeList", menteeList);
        request.setAttribute("notesList", notesList);
        request.getRequestDispatcher("/mentor/NotesMentor.jsp").forward(request, response);
    }

    private void saveNote(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String title = request.getParameter("title");
        String[] audiences = request.getParameterValues("audience"); 
        Part filePart = request.getPart("file"); 

        if (audiences != null && filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String appPath = request.getServletContext().getRealPath("");
            if (appPath == null) appPath = System.getProperty("user.home"); 
            String uploadPath = appPath + File.separator + "uploads";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            File file = new File(uploadDir, fileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                MentorDAO dao = new MentorDAO();
                dao.uploadNote(user.getId(), title, fileName, audiences);
            } catch (IOException e) {
                e.printStackTrace();
                throw new IOException("Failed to save file: " + e.getMessage());
            }
        }
        response.sendRedirect("MentorServlet?action=notes&msg=File Uploaded Successfully");
    }

    private void deleteNote(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        MentorDAO dao = new MentorDAO();
        dao.deleteNote(id);
        response.sendRedirect("MentorServlet?action=notes&msg=File Deleted");
    }

    private void removeMentee(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int menteeId = Integer.parseInt(request.getParameter("menteeId"));
        
        MentorDAO dao = new MentorDAO();
        dao.deleteMentorship(user.getId(), menteeId);
        
        response.sendRedirect("MentorServlet?action=my_mentees&msg=Mentee Removed Successfully");
    }
}