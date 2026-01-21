package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    
    //connect db all 
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = null;
        try {
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentDB", "APP", "APP");
        } catch (SQLException e1) {
            try {
                conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentDB");
            } catch (SQLException e2) {
                conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentDB", "app", "app");
            }
        }
        return conn;
    }
}