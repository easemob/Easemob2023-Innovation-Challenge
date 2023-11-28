package com.xinghe.project.service;

import com.xinghe.project.model.entity.Message;
import com.baomidou.mybatisplus.extension.service.IService;
import com.xinghe.project.model.req.ChatMessageReq;
import com.xinghe.project.model.req.GroupMessageReq;
import com.xinghe.project.model.req.MessageReq;

/**
* @author 26258
* @description 针对表【message(消息)】的数据库操作Service
* @createDate 2023-11-14 14:32:33
*/
public interface MessageService extends IService<Message> {
    String doAIGC(MessageReq res);

    /**
     * ai向群聊中发送消息
     * @param req
     * @return
     */
    boolean sendGroupMessage(MessageReq req, String msg);

    boolean userSendGroupMessage(GroupMessageReq req);

    boolean sendChatMessage(ChatMessageReq req, String msg);
}
