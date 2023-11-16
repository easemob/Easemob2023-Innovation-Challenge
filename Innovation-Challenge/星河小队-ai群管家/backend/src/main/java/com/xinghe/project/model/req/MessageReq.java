package com.xinghe.project.model.req;

import lombok.Builder;
import lombok.Data;

@Data
public class MessageReq {

    private String groupId;

    /**
     * 接口允许字符范围 [1, 6000]
     */
    private Integer offset = 20;
}
