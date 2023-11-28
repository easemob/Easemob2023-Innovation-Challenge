package com.xinghe.project.controller;

import com.xinghe.project.model.entity.Message;
import com.xinghe.project.service.MessageService;
import org.junit.jupiter.api.Test;

import javax.annotation.Resource;

public class MessageControllerTest {

    @Resource
    private MessageService messageService;

    private static final String GROUP_ID = "231249887166469";

    @Test
    public void sendMessageToGroup() {

    }

    @Test
    public void testSendMessage() {
        Message message = new Message();
        message.setUserId("user1");
        message.setContent("苹果手机便宜卖了");
        message.setGroupId(GROUP_ID);
        message.setContentType(0);
        messageService.save(message);
    }
}
