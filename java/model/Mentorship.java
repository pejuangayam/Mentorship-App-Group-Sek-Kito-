package model;

import java.sql.Timestamp;

public class Mentorship {
    private int mentorshipID;
    private int menteeID;
    private int mentorID;
    private String message;     
    private String status;      
    private Timestamp startDate;
    
    // Join Fields
    private String menteeName;
    private String menteeProgram;
    private String menteeEmail;
    
    private String mentorName;
    private String mentorDepartment;
    
    public Mentorship(){}
    
    // getter
    public int getMentorshipID() { return mentorshipID; }
    public int getMenteeID() { return menteeID; }
    public int getMentorID() { return mentorID; }
    public String getMessage() { return message; }
    public String getStatus() { return status; }
    public Timestamp getStartDate() { return startDate; }

    public String getMenteeName() { return menteeName; }
    public String getMenteeProgram() { return menteeProgram; } 
    public String getMenteeEmail() { return menteeEmail; }     

    public String getMentorName() { return mentorName; }       
    public String getMentorDepartment() { return mentorDepartment; }
    
    // setter
    public void setMentorshipID(int mentorshipID) { this.mentorshipID = mentorshipID; }
    public void setMenteeID(int menteeID) { this.menteeID = menteeID; }
    public void setMentorID(int mentorID) { this.mentorID = mentorID; }
    public void setMessage(String message) { this.message = message; }
    public void setStatus(String status) { this.status = status; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }

    public void setMenteeName(String menteeName) { this.menteeName = menteeName; }
    public void setMenteeProgram(String menteeProgram) { this.menteeProgram = menteeProgram; }
    public void setMenteEmail(String menteeEmail) { this.menteeEmail = menteeEmail; }

    public void setMentorName(String mentorName) { 
        this.mentorName = mentorName; 
    }
    
    public void setMentorDepartment(String mentorDepartment) { this.mentorDepartment = mentorDepartment; }
}