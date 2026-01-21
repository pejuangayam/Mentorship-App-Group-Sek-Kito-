package dao;

import java.io.File;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Mentorship;
import model.User;
import model.Meeting;
import model.Announcement;
import model.Profession;
import model.Note;
import utils.DBConnection;

public class MentorDAO {

    //  1. DASHBOARD STATS  //
    public int getCount(int mentorId, String status) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM MENTORSHIP WHERE MENTORID = ? AND STATUS = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mentorId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public List<Mentorship> getRecentPendingRequests(int mentorId) {
        List<Mentorship> list = new ArrayList<>();
        String sql = "SELECT ms.MENTORSHIPID, ms.MESSAGE, m.NAME AS MENTEE_NAME, m.PROGRAM, m.MENTEEID " +
                     "FROM MENTORSHIP ms " +
                     "JOIN MENTEE m ON ms.MENTEEID = m.MENTEEID " +
                     "WHERE ms.MENTORID = ? AND ms.STATUS = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mentorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Mentorship m = new Mentorship();
                m.setMentorshipID(rs.getInt("MENTORSHIPID"));
                m.setMessage(rs.getString("MESSAGE"));
                m.setMenteeName(rs.getString("MENTEE_NAME"));
                m.setMenteeProgram(rs.getString("PROGRAM"));
                m.setMenteeID(rs.getInt("MENTEEID"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    //  2. MENTEE MANAGEMENT  //
    public List<User> getMyMentees(int mentorId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT m.NAME, m.EMAIL, m.PROGRAM, m.NOPHONE, m.CURRENTYEAR, m.STUDENTID, m.MENTEEID " +
                     "FROM MENTORSHIP ms " +
                     "JOIN MENTEE m ON ms.MENTEEID = m.MENTEEID " +
                     "WHERE ms.MENTORID = ? AND ms.STATUS = 'Active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mentorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("MENTEEID"));
                u.setName(rs.getString("NAME"));
                u.setEmail(rs.getString("EMAIL"));
                u.setProgram(rs.getString("PROGRAM"));
                u.setNoPhone(rs.getString("NOPHONE"));
                u.setCurrentYear(rs.getString("CURRENTYEAR"));
                u.setStudentId(rs.getString("STUDENTID"));
                list.add(u);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void deleteMentorship(int mentorId, int menteeId) {
        String sql = "DELETE FROM MENTORSHIP WHERE MENTORID = ? AND MENTEEID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mentorId);
            ps.setInt(2, menteeId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    //  3. REQUEST HANDLING  //
    public List<Mentorship> getAllPendingRequests(int mentorId) {
        List<Mentorship> list = new ArrayList<>();
        String sql = "SELECT ms.MENTORSHIPID, ms.MESSAGE, ms.STATUS, m.NAME AS MENTEE_NAME, m.PROGRAM, m.EMAIL " +
                     "FROM MENTORSHIP ms " +
                     "JOIN MENTEE m ON ms.MENTEEID = m.MENTEEID " +
                     "WHERE ms.MENTORID = ? AND ms.STATUS = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mentorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Mentorship m = new Mentorship();
                m.setMentorshipID(rs.getInt("MENTORSHIPID"));
                m.setMessage(rs.getString("MESSAGE"));
                m.setStatus(rs.getString("STATUS"));
                m.setMenteeName(rs.getString("MENTEE_NAME"));
                m.setMenteeProgram(rs.getString("PROGRAM"));
                m.setMenteEmail(rs.getString("EMAIL"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void updateRequestStatus(int mentorshipId, String status) {
        String sql = "UPDATE MENTORSHIP SET STATUS = ? WHERE MENTORSHIPID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, mentorshipId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    //  4. MEETINGS  //
    public List<Meeting> getUpcomingMeetings(int mentorId) {
        List<Meeting> list = new ArrayList<>();
        String sql = "SELECT mt.*, m.NAME AS MENTEE_NAME " +
                     "FROM MEETINGS mt " +
                     "JOIN MENTEE m ON mt.MENTEEID = m.MENTEEID " +
                     "WHERE mt.MENTORID = ? ORDER BY mt.MEETING_DATE ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mentorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Meeting m = new Meeting();
                m.setMeetingId(rs.getInt("MEETINGID"));
                m.setTitle(rs.getString("TITLE"));
                m.setMeetingDate(rs.getDate("MEETING_DATE"));
                m.setMeetingTime(rs.getString("MEETING_TIME"));
                m.setLink(rs.getString("LINK"));
                m.setStatus(rs.getString("STATUS"));
                m.setMenteeName(rs.getString("MENTEE_NAME"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void saveMeetings(int mentorId, String[] menteeIds, String title, String date, String time, String link) {
        String sql = "INSERT INTO MEETINGS (MENTORID, MENTEEID, TITLE, MEETING_DATE, MEETING_TIME, LINK, STATUS) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'Scheduled')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String idStr : menteeIds) {
                ps.setInt(1, mentorId);
                ps.setInt(2, Integer.parseInt(idStr));
                ps.setString(3, title);
                ps.setDate(4, Date.valueOf(date));
                ps.setString(5, time);
                ps.setString(6, link);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) { e.printStackTrace(); }
    }

    //  5. ANNOUNCEMENTS  //
    public List<Announcement> getAnnouncements(int mentorId, List<User> menteeList) {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT * FROM ANNOUNCEMENTS WHERE MENTORID = ? ORDER BY POSTED_DATE DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mentorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Announcement a = new Announcement();
                a.setAnnouncementID(rs.getInt("ANNOUNCEMENTID"));
                a.setTitle(rs.getString("TITLE"));
                a.setContent(rs.getString("CONTENT"));
                a.setPriority(rs.getString("PRIORITY"));
                a.setPostedDate(rs.getTimestamp("POSTED_DATE"));
                
                String audId = rs.getString("AUDIENCE");
                a.setAudience(audId);
                if ("all".equalsIgnoreCase(audId)) {
                    a.setAudienceName("All Mentee");
                } else {
                    a.setAudienceName("Unknown ID: " + audId);
                    for (User u : menteeList) {
                        if (String.valueOf(u.getId()).equals(audId)) {
                            a.setAudienceName(u.getName());
                            break;
                        }
                    }
                }
                list.add(a);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void postAnnouncements(int mentorId, String title, String content, String priority, String[] audiences) {
        String sql = "INSERT INTO ANNOUNCEMENTS (MENTORID, TITLE, CONTENT, PRIORITY, AUDIENCE) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String aud : audiences) {
                ps.setInt(1, mentorId);
                ps.setString(2, title);
                ps.setString(3, content);
                ps.setString(4, priority);
                ps.setString(5, aud);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void deleteAnnouncement(int id) {
        String sql = "DELETE FROM ANNOUNCEMENTS WHERE ANNOUNCEMENTID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    //  6. PROFILE & UTILS  //
    public void updateProfile(User u) {
        String sql = "UPDATE MENTOR SET NAME=?, NOPHONE=?, DEPARTMENT=?, QUALIFICATION=?, BIO=?, YEARSEXPERIENCE=? WHERE MENTORID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getName());
            ps.setString(2, u.getNoPhone());
            ps.setString(3, u.getDepartment());
            ps.setString(4, u.getQualification());
            ps.setString(5, u.getBio());
            
            if(u.getYearsExperience() != null) ps.setInt(6, u.getYearsExperience());
            else ps.setNull(6, Types.INTEGER);
            
            ps.setInt(7, u.getId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public boolean verifyPassword(int mentorId, String currentPassword) {
        String sql = "SELECT PASSWORD FROM MENTOR WHERE MENTORID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mentorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String dbPass = rs.getString("PASSWORD");
                // In production, use BCrypt or similar hashing check
                return dbPass != null && dbPass.equals(currentPassword);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public void updatePassword(int mentorId, String newPassword) {
        String sql = "UPDATE MENTOR SET PASSWORD = ? WHERE MENTORID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, mentorId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<Profession> getAllProfessions() {
        List<Profession> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM PROFESSION ORDER BY PROFESSIONNAME")) {
            while(rs.next()){
                Profession p = new Profession();
                p.setProfessionID(rs.getInt("PROFESSIONID"));
                p.setProfessionName(rs.getString("PROFESSIONNAME"));
                p.setCategory(rs.getString("CATEGORY"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<String> getAllDepartments() {
        List<String> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM DEPARTMENT ORDER BY DEPT_NAME")) {
            while(rs.next()){
                list.add(rs.getString("DEPT_NAME"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    //  7. NOTES & FILE UPLOADS  //
    
    // Get notes + Grouping + File Size Calculation
    public List<Note> getMyUploadedNotes(int mentorId, String appPath) {
        Map<String, Note> groupedNotes = new LinkedHashMap<>();
        
        String sql = "SELECT n.*, m.NAME AS STUDENT_NAME " +
                     "FROM NOTES n " +
                     "LEFT JOIN MENTEE m ON n.AUDIENCE = CHAR(m.MENTEEID) " +
                     "WHERE n.MENTOR_ID = ? " +
                     "ORDER BY n.UPLOAD_DATE DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mentorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                String filePath = rs.getString("FILE_PATH");
                Timestamp date = rs.getTimestamp("UPLOAD_DATE");
                String uniqueKey = filePath + "_" + date.toString();
                
                String audCode = rs.getString("AUDIENCE");
                String studentName = rs.getString("STUDENT_NAME");
                String displayName;
                
                if ("all".equalsIgnoreCase(audCode)) {
                    displayName = "All Mentees";
                } else if (studentName != null) {
                    displayName = studentName;
                } else {
                    displayName = "ID:" + audCode;
                }

                if (groupedNotes.containsKey(uniqueKey)) {
                    Note existingNote = groupedNotes.get(uniqueKey);
                    String currentAudience = existingNote.getAudienceName();
                    if (!currentAudience.contains("All Mentees")) {
                        existingNote.setAudienceName(currentAudience + ", " + displayName);
                    }
                } else {
                    Note n = new Note();
                    n.setId(rs.getInt("NOTE_ID")); 
                    n.setName(rs.getString("TITLE"));
                    n.setFilePath(filePath);
                    n.setDateUploaded(date);
                    n.setAudienceName(displayName);
                    n.setCreatedBy(rs.getString("CREATED_BY"));
                    
                    if (appPath != null) {
                        String fullPath = appPath + File.separator + "uploads" + File.separator + filePath;
                        File f = new File(fullPath);
                        if (f.exists()) {
                            double sizeMB = f.length() / (1024.0 * 1024.0);
                            int displaySize = (sizeMB < 1) ? 1 : (int)Math.ceil(sizeMB);
                            n.setFilesCount(displaySize); 
                        } else {
                            n.setFilesCount(0);
                        }
                    }
                    
                    groupedNotes.put(uniqueKey, n);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return new ArrayList<>(groupedNotes.values());
    }

    public void uploadNote(int mentorId, String title, String filename, String[] audiences) {
        String sql = "INSERT INTO NOTES (MENTOR_ID, TITLE, TYPE, FILE_PATH, CREATED_BY, AUDIENCE) VALUES (?, ?, 'file', ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String mentorName = "Mentor"; 
            String nameSql = "SELECT NAME FROM MENTOR WHERE MENTORID = ?";
            try (PreparedStatement psName = conn.prepareStatement(nameSql)) {
                psName.setInt(1, mentorId);
                ResultSet rsName = psName.executeQuery();
                if(rsName.next()) mentorName = rsName.getString(1);
            }

            for (String aud : audiences) {
                ps.setInt(1, mentorId);
                ps.setString(2, title);
                ps.setString(3, filename);
                ps.setString(4, mentorName);
                ps.setString(5, aud); 
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void deleteNote(int id) {
        Connection conn = null;
        PreparedStatement psSelect = null;
        PreparedStatement psDelete = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String findSql = "SELECT FILE_PATH, MENTOR_ID FROM NOTES WHERE NOTE_ID = ?";
            psSelect = conn.prepareStatement(findSql);
            psSelect.setInt(1, id);
            rs = psSelect.executeQuery();
            
            if (rs.next()) {
                String filePath = rs.getString("FILE_PATH");
                int mentorId = rs.getInt("MENTOR_ID");
                String deleteSql = "DELETE FROM NOTES WHERE MENTOR_ID = ? AND FILE_PATH = ?";
                psDelete = conn.prepareStatement(deleteSql);
                psDelete.setInt(1, mentorId);
                psDelete.setString(2, filePath);
                psDelete.executeUpdate();
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { try { if(rs!=null) rs.close(); if(psSelect!=null) psSelect.close(); if(psDelete!=null) psDelete.close(); if(conn!=null) conn.close(); } catch(Exception e){} }
    }
}