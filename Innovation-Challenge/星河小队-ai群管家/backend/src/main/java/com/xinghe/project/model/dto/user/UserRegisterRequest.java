package com.xinghe.project.model.dto.user;

import lombok.Data;

/**
 * 用户注册请求
 */
@Data
public class UserRegisterRequest {
    private static final long serialVersionUID = 3191241716373120793L;

    private String userAccount;

    private String userPassword;

    private String checkPassword;
}
