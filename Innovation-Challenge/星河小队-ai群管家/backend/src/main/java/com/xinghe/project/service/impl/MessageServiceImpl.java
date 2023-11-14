package com.xinghe.project.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.project.controller.AIController;
import com.xinghe.project.model.entity.Message;
import com.xinghe.project.model.req.MessageReq;
import com.xinghe.project.service.MessageService;
import com.xinghe.project.mapper.MessageMapper;
import com.xinghe.project.util.AIUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
* @author 26258
* @description 针对表【message(消息)】的数据库操作Service实现
* @createDate 2023-11-14 14:32:33
*/
@Service
public class MessageServiceImpl extends ServiceImpl<MessageMapper, Message>
    implements MessageService{

    @Resource
    private MessageMapper messageMapper;

    private static final String PROMPT = "你是ai群管家，下面几条对话的内容，可能有多个讨论的主体，请按每个讨论主体给出讨论简短的摘要，要包含讨论的上下文，不需要针对单个内容总结：\n" +
            "输出格式为 \n" +
            "各点摘要:\n" +
            "1. xxxx\n" +
            "2. xxxx";

    @Override
    public String doAIGC(MessageReq req) {
        List<Message> messages = messageMapper.selectLatest(req);
        StringBuilder res = new StringBuilder();
        messages.forEach(res::append);
        return AIUtils.callAIGC(PROMPT, res.toString(), false);
    }
}




