package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;
import utils.DBConnection;

public class AdminDAO {

    //  DASHBOARD STATS 
    public int getCount(String tableName) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM " + tableName; 
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public List<User> getAllUsersCombined() {
        List<User> userList = new ArrayList<>();
        
        // 1. Get Mentors
        String sqlMentor = "SELECT MENTORID, NAME, EMAIL FROM MENTOR";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sqlMentor)) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("MENTORID"));
                u.setName(rs.getString("NAME"));
                u.setEmail(rs.getString("EMAIL"));
                u.setRole("Mentor");
                userList.add(u);
            }
        } catch (Exception e) { e.printStackTrace(); }

        // 2. Get Mentees
        String sqlMentee = "SELECT MENTEEID, NAME, EMAIL FROM MENTEE";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sqlMentee)) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("MENTEEID"));
                u.setName(rs.getString("NAME"));
                u.setEmail(rs.getString("EMAIL"));
                u.setRole("Mentee");
                userList.add(u);
            }
        } catch (Exception e) { e.printStackTrace(); }

        return userList;
    }

    //  PROFESSIONS & DEPARTMENTS 
    public void addProfession(String name, String description, String category) {
        String sql = "INSERT INTO PROFESSION (PROFESSIONNAME, DESCRIPTION, CATEGORY) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setString(3, category);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public boolean addDepartment(String deptName) {
        String checkSql = "SELECT * FROM DEPARTMENT WHERE DEPT_NAME = ?";
        String insertSql = "INSERT INTO DEPARTMENT (DEPT_NAME) VALUES (?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
            
            psCheck.setString(1, deptName);
            ResultSet rs = psCheck.executeQuery();
            
            if (!rs.next()) { // Only insert if not found
                try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                    psInsert.setString(1, deptName);
                    psInsert.executeUpdate();
                    return true;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public List<String[]> getAllProfessions() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT * FROM PROFESSION";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                String[] p = new String[3];
                p[0] = rs.getString("PROFESSIONNAME");
                p[1] = rs.getString("CATEGORY");
                p[2] = rs.getString("DESCRIPTION");
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<String> getProfessionCategories() {
        List<String> list = new ArrayList<>();
        list.add("Technology");
        list.add("Business"); 
        
        String sql = "SELECT DISTINCT CATEGORY FROM PROFESSION ORDER BY CATEGORY";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                String c = rs.getString("CATEGORY");
                if (c != null && !list.contains(c)) list.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<String> getAllDepartments() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DEPT_NAME FROM DEPARTMENT ORDER BY DEPT_NAME ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(rs.getString("DEPT_NAME"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    //  DELETE METHODS 
    public void deleteDepartment(String deptName) {
        String sql = "DELETE FROM DEPARTMENT WHERE DEPT_NAME = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, deptName);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void deleteProfession(String profName) {
        String sql = "DELETE FROM PROFESSION WHERE PROFESSIONNAME = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, profName);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    //  USER MANAGEMENT 
    public User getUserById(int id, String role) {
        User u = null;
        String sql = "Mentor".equalsIgnoreCase(role) ? 
                     "SELECT * FROM MENTOR WHERE MENTORID = ?" : 
                     "SELECT * FROM MENTEE WHERE MENTEEID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                u = new User();
                u.setId(id);
                u.setName(rs.getString("NAME"));
                u.setEmail(rs.getString("EMAIL"));
                u.setRole(role);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return u;
    }

    public void deleteUser(int id, String role) {
        String sql = "Mentor".equalsIgnoreCase(role) ? 
                     "DELETE FROM MENTOR WHERE MENTORID=?" : 
                     "DELETE FROM MENTEE WHERE MENTEEID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    //  ADMIN PROFILE 
    public void updateAdminProfile(int id, String name, String email) {
        String sql = "UPDATE ADMIN SET NAME=?, EMAIL=? WHERE ADMINID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}