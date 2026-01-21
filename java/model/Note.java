package model;

import java.sql.Timestamp;

public class Note {
    private int id;
    private String name;      
    private String type;      
    private int filesCount;   
    private String createdBy; 
    private Timestamp dateUploaded;
    private String filePath;
    private String audienceName;

    public Note() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getFilesCount() { return filesCount; }
    public void setFilesCount(int filesCount) { this.filesCount = filesCount; }

    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }

    public Timestamp getDateUploaded() { return dateUploaded; }
    public void setDateUploaded(Timestamp dateUploaded) { this.dateUploaded = dateUploaded; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    
    public String getAudienceName() { return audienceName; }
    public void setAudienceName(String audienceName) { this.audienceName = audienceName; }
}