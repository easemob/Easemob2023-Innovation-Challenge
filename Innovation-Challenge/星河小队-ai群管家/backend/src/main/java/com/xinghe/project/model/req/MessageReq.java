package com.xinghe.project.model.req;

import lombok.Builder;
import lombok.Data;

@Data
public class MessageReq {

    private String groupId;

    private Integer offset = 100;
}
