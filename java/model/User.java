package model;

import java.sql.Date;

public class User {
    private int id;
    private String name;
    private String email;
    private String password;
    private String noPhone;
    private String role; // "mentor" or "mentee" or "admin"
    
    // Common fields
    private String address;
    private Date dateOfBirth;
    private String educationalLevel;
    
    // Mentor-specific fields
    private String masteredSubjects;
    private Integer yearsExperience;
    private String department;
    private String qualification;
    private String bio;
    
    // Mentee-specific fields
    private String subjectsToLearn;
    private String studentId;
    private String currentYear;
    private String program;
    private String learningGoals;
    private String availability;
    
    // Constructors
    public User() {}
    
    public User(String name, String email, String password, String noPhone, String role) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.noPhone = noPhone;
        this.role = role;
    }
    
    // Getters and Setters 
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getNoPhone() { return noPhone; }
    public void setNoPhone(String noPhone) { this.noPhone = noPhone; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    
    public String getEducationalLevel() { return educationalLevel; }
    public void setEducationalLevel(String educationLevel) { this.educationalLevel = educationLevel; }
    
    public String getMasteredSubjects() { return masteredSubjects; }
    public void setMasteredSubjects(String masteredSubjects) { this.masteredSubjects = masteredSubjects; }
    
    public Integer getYearsExperience() { return yearsExperience; }
    public void setYearsExperience(Integer yearsExperience) { this.yearsExperience = yearsExperience; }
    
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    
    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }
    
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    
    public String getSubjectsToLearn() { return subjectsToLearn; }
    public void setSubjectsToLearn(String subjectsToLearn) { this.subjectsToLearn = subjectsToLearn; }
    
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }
    
    public String getCurrentYear() { return currentYear; }
    public void setCurrentYear(String currentYear) { this.currentYear = currentYear; }
    
    public String getProgram() { return program; }
    public void setProgram(String program) { this.program = program; }
    
    public String getLearningGoals() { return learningGoals; }
    public void setLearningGoals(String learningGoals) { this.learningGoals = learningGoals; }
    
    public String getAvailability() { return availability; }
    public void setAvailability(String availability) { this.availability = availability; }
}