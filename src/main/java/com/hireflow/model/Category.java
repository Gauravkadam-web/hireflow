package com.hireflow.model;

public class Category {

    private int    categoryId;
    private String name;
    private String icon;
    private int    jobCount;

    public Category() {}

    public int    getCategoryId()            { return categoryId; }
    public void   setCategoryId(int id)      { this.categoryId = id; }

    public String getName()                  { return name; }
    public void   setName(String name)       { this.name = name; }

    public String getIcon()                  { return icon; }
    public void   setIcon(String icon)       { this.icon = icon; }

    public int    getJobCount()              { return jobCount; }
    public void   setJobCount(int c)         { this.jobCount = c; }
}
