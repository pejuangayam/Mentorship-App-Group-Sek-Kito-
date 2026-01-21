package model;


public class Profession {
    private int professionID;
    private String professionName;
    private String description;
     private String category;
    
//Getter and Setter
public int getProfessionID(){
    return professionID;
}

public String getProfessionName(){
    return professionName;
}

public String getDescription(){
    return description;
}

public String getCategory(){
    return category;
}

public void setProfessionID(int professionID){
    this.professionID = professionID;
}

public void setProfessionName(String professionName){
    this.professionName = professionName;
}
public void setDescription(String description){
    this.description = description;
}
public void setCategory(String category){
    this.category = category;
}
}
