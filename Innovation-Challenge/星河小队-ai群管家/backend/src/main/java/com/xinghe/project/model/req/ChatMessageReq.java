package com.xinghe.project.model.req;

import lombok.Data;

@Data
public class ChatMessageReq {

    private String msg;

    private String promptId;

    private String chatId;

    private String toUserId;
}
