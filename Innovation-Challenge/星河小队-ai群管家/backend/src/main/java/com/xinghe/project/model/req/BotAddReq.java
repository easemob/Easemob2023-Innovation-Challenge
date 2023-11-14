package com.xinghe.project.model.req;

import lombok.Data;

@Data
public class BotAddReq {

    /**
     * '群id'
     */
    private String groupId;

    /**
     * '用户name'
     */
    private String userId;
}
