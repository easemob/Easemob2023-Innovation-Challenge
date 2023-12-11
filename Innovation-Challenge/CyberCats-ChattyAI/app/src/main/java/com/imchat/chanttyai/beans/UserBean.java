package com.imchat.chanttyai.beans;

public class UserBean {
    private String account;

    private String content;

    private Integer gender;

    public Integer getGender() {
        return gender == null ? 0 : gender;
    }

    public void setGender(Integer gender) {
        this.gender = gender;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    private String name;
    private String desc;

    public UserBean() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }
}
