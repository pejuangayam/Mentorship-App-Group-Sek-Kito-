package controller;

import dao.MenteeDAO;
import model.User;
import model.Meeting;
import model.Announcement;
import model.Mentorship; 
import model.Note; 
import java.io.IOException;
import java.io.File; 
import java.io.FileInputStream; 
import java.io.OutputStream; 
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "MenteeServlet", urlPatterns = {"/MenteeServlet"})
public class MenteeServlet extends HttpServlet {

    //  GET REQUESTS 
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

        try { updateSidebarCount(request); } catch (Exception e) { e.printStackTrace(); }

        try {
            switch (action) {
                case "dashboard": loadDashboard(request, response); break;
                case "find_mentor": loadFindMentorPage(request, response); break;
                case "meetings": loadMyMeetings(request, response); break;
                case "inbox": loadInbox(request, response); break;
                case "profile": loadMenteeProfile(request, response); break;
                case "notes": loadNotesPage(request, response); break;
                case "view_file": downloadFile(request, response); break; 
                case "view_folder": loadNotesPage(request, response); break; 
                default: loadDashboard(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    //  POST REQUESTS 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try { updateSidebarCount(request); } catch (Exception e) {}

        try {
            if ("send_request".equals(action)) { sendMentorshipRequest(request, response); } 
            else if ("update_profile".equals(action)) { updateProfile(request, response); }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void updateSidebarCount(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) return;

        MenteeDAO dao = new MenteeDAO();
        int count = dao.getInboxCount(user.getId());
        session.setAttribute("inboxCount", count);
    }

    // 1. DASHBOARD LOGIC
    private void loadDashboard(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        MenteeDAO dao = new MenteeDAO();

        int pendingReq = dao.getPendingRequestsCount(user.getId());
        int upcomingMeetings = dao.getUpcomingMeetingsCount(user.getId());
        List<Mentorship> myMentorsList = dao.getMyMentors(user.getId());
        List<User> recommendedMentors = dao.getRecommendedMentors(user.getProgram(), user.getId());
        
        request.setAttribute("pendingReq", pendingReq);
        request.setAttribute("upcomingCount", upcomingMeetings);
        request.setAttribute("myMentorsList", myMentorsList);        
        request.setAttribute("recommendedMentors", recommendedMentors); 
        
        request.getRequestDispatcher("/mentee/index.jsp").forward(request, response);
    }

    // 2. FIND MENTOR LOGIC
    private void loadFindMentorPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        MenteeDAO dao = new MenteeDAO();
        List<Mentorship> myRequests = dao.getMyRequests(user.getId());
        List<User> allMentors = dao.getAllMentors();

        request.setAttribute("myRequests", myRequests);
        request.setAttribute("allMentors", allMentors);
        request.getRequestDispatcher("/mentee/findMentor.jsp").forward(request, response);
    }

    private void sendMentorshipRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String mentorIdStr = request.getParameter("mentorId");

        if(mentorIdStr == null || mentorIdStr.isEmpty()){
             response.sendRedirect("MenteeServlet?action=find_mentor&msg=Error: No Mentor Selected");
             return;
        }
        
        int mentorId = Integer.parseInt(mentorIdStr);
        MenteeDAO dao = new MenteeDAO();
        
        if (dao.requestExists(user.getId(), mentorId)) {
            response.sendRedirect("MenteeServlet?action=find_mentor&msg=Request Already Pending or Active");
            return;
        }

        dao.sendRequest(user.getId(), mentorId);
        response.sendRedirect("MenteeServlet?action=find_mentor&msg=Request Sent Successfully");
    }

    // 3. MEETINGS LOGIC
    private void loadMyMeetings(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        MenteeDAO dao = new MenteeDAO();
        List<Meeting> meetingList = dao.getMyMeetings(user.getId());

        request.setAttribute("meetingList", meetingList);
        request.getRequestDispatcher("/mentee/meetingMentee.jsp").forward(request, response);
    }

    // 4. INBOX LOGIC
    private void loadInbox(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        MenteeDAO dao = new MenteeDAO();
        List<Announcement> inboxList = dao.getInbox(user.getId());

        request.setAttribute("inboxList", inboxList);
        request.getRequestDispatcher("/mentee/inboxMentee.jsp").forward(request, response);
    }

    // 5. PROFILE LOGIC
    private void loadMenteeProfile(HttpServletRequest request, HttpServletResponse response) throws Exception {
        MenteeDAO dao = new MenteeDAO();
        List<String> departmentList = dao.getAllDepartments();
        
        request.setAttribute("departmentList", departmentList);
        request.getRequestDispatcher("mentee/profileMentee.jsp").forward(request, response);
    }

    // UPDATED: Captures Student ID & Handles Password Change
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        MenteeDAO dao = new MenteeDAO();
        
        // 1. Update Basic Profile Info
        user.setName(request.getParameter("fullName"));
        // user.setEmail(request.getParameter("email")); // Usually read-only
        user.setNoPhone(request.getParameter("phone"));
        user.setProgram(request.getParameter("program")); 
        user.setStudentId(request.getParameter("studentId")); 

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

        response.sendRedirect("MenteeServlet?action=profile&msg=" + msg);
    }

    // 6. NOTES LOGIC 
    private void loadNotesPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        MenteeDAO dao = new MenteeDAO();
        List<Note> notesList = dao.getMyNotes(user.getId());
        
        request.setAttribute("notesList", notesList);
        request.getRequestDispatcher("/mentee/notesMentee.jsp").forward(request, response);
    }

    private void downloadFile(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. Get Note ID
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("MenteeServlet?action=notes&msg=Error");
            return;
        }
        
        // 2. Fetch File Details from DB
        int noteId = Integer.parseInt(idStr);
        MenteeDAO dao = new MenteeDAO();
        Note note = dao.getNoteById(noteId);
        
        if (note == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Note not found in database.");
            return;
        }

        // 3. Locate File on Server
        String fileName = note.getFilePath();
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File file = new File(uploadPath + File.separator + fileName);

        // 4. Check if file exists physically
        if (!file.exists()) {
             response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found on server disk. Path checked: " + file.getAbsolutePath());
             return;
        }

        // 5. Set Response Headers for Download
        response.setContentType("application/octet-stream"); 
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        response.setContentLength((int) file.length());

        // 6. Stream content
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}