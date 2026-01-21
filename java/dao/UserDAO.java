package dao;

import java.sql.*;
import model.User;
import utils.DBConnection;

public class UserDAO {

    //  1. LOGIN LOGIC  //
    public User login(String email, String password, String role) {
        User user = null;
        String sql = "";

        // Select table based on role
        if ("admin".equals(role)) {
            sql = "SELECT * FROM admin WHERE email = ? AND password = ?";
        } else if ("mentor".equals(role)) {
            sql = "SELECT * FROM mentor WHERE email = ? AND password = ?";
        } else if ("mentee".equals(role)) {
            sql = "SELECT * FROM mentee WHERE email = ? AND password = ?";
        } else {
            return null; // Invalid role
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password")); 
                    user.setName(rs.getString("name"));
                    user.setNoPhone(rs.getString("noPhone"));
                    user.setRole(role);

                    if ("admin".equals(role)) {
                        user.setId(rs.getInt("adminID"));
                    } else if ("mentor".equals(role)) {
                        user.setId(rs.getInt("mentorID"));
                        // Map Mentor Specifics
                        user.setAddress(rs.getString("address"));
                        user.setDateOfBirth(rs.getDate("dateOfBirth"));
                        user.setEducationalLevel(rs.getString("educationalLevel"));
                        user.setMasteredSubjects(rs.getString("masteredSubjects"));
                        user.setYearsExperience(rs.getInt("yearsExperience"));
                        user.setDepartment(rs.getString("department"));
                        user.setQualification(rs.getString("qualification"));
                        user.setBio(rs.getString("bio"));
                    } else {
                        user.setId(rs.getInt("menteeID"));
                        // Map Mentee Specifics
                        user.setAddress(rs.getString("address"));
                        user.setDateOfBirth(rs.getDate("dateOfBirth"));
                        user.setEducationalLevel(rs.getString("educationalLevel"));
                        user.setSubjectsToLearn(rs.getString("subjectsToLearn"));
                        user.setStudentId(rs.getString("studentId"));
                        user.setCurrentYear(rs.getString("currentYear"));
                        user.setProgram(rs.getString("program"));
                        user.setLearningGoals(rs.getString("learningGoals"));
                        user.setAvailability(rs.getString("availability"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    //  2. EMAIL CHECK LOGIC  //
    public boolean isEmailRegistered(String email, String role) {
        String sql = "SELECT 1 FROM " + role + " WHERE email = ?"; 
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Returns true if email exists
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    //  3. REGISTRATION LOGIC  //
    
    public boolean registerMentor(User u) {
        String sql = "INSERT INTO mentor (name, email, password, noPhone, address, dateOfBirth, " +
                     "educationalLevel, masteredSubjects, yearsExperience, department, qualification, bio) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getNoPhone());
            ps.setString(5, u.getAddress());
            ps.setDate(6, u.getDateOfBirth());
            ps.setString(7, u.getEducationalLevel());
            ps.setString(8, ""); // masteredSubjects default empty
            
            if (u.getYearsExperience() != null) ps.setInt(9, u.getYearsExperience()); 
            else ps.setNull(9, Types.INTEGER);

            ps.setString(10, u.getDepartment());
            ps.setString(11, u.getQualification());
            ps.setString(12, u.getBio());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean registerMentee(User u) {
        String sql = "INSERT INTO mentee (name, email, password, noPhone, address, dateOfBirth, " +
                     "educationalLevel, subjectsToLearn, studentId, currentYear, program, learningGoals, availability) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getNoPhone());
            ps.setString(5, u.getAddress());
            ps.setDate(6, u.getDateOfBirth());
            ps.setString(7, u.getEducationalLevel());
            ps.setString(8, ""); // subjectsToLearn default empty
            ps.setString(9, u.getStudentId());
            ps.setString(10, ""); // currentYear default empty
            ps.setString(11, u.getProgram()); 
            ps.setString(12, ""); // learningGoals
            ps.setString(13, ""); // availability

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}