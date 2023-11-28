package com.xinghe.project.service.impl;

import cn.hutool.json.JSONUtil;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.project.controller.AIController;
import com.xinghe.project.model.entity.Message;
import com.xinghe.project.model.entity.MessageBody;
import com.xinghe.project.model.req.ChatMessageReq;
import com.xinghe.project.model.req.GroupMessageReq;
import com.xinghe.project.model.req.MessageReq;
import com.xinghe.project.service.MessageService;
import com.xinghe.project.mapper.MessageMapper;
import com.xinghe.project.util.AIUtils;
import com.xinghe.project.util.HXUtils;
import com.xinghe.project.util.HttpClientUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author 26258
 * @description 针对表【message(消息)】的数据库操作Service实现
 * @createDate 2023-11-14 14:32:33
 */
@Service
public class MessageServiceImpl extends ServiceImpl<MessageMapper, Message>
        implements MessageService {

    @Resource
    private MessageMapper messageMapper;

    // TODO inject
    private final String botName = "user_Bot";

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

    @Override
    public boolean sendGroupMessage(MessageReq req, String msg) {
        String userId = botName;
        // /{org_name}/{app_name}/messages/chatgroups
        String url = AIServiceImpl.URL_PREFIX + "messages/chatgroups";

        List<String> toList = new ArrayList<>();
        toList.add(req.getGroupId());
        Map<String, String> bodyMap = new HashMap<>();
        bodyMap.put("msg", msg);

        MessageBody messageBody = new MessageBody();
        messageBody.setFrom(userId);
        messageBody.setTo(toList);
        messageBody.setType("txt");
        messageBody.setBody(bodyMap);

        String res = HttpClientUtils.hxPostRequest(url, HXUtils.headerMap, JSONUtil.toJsonStr(messageBody));
        try {
            JSONObject jsonObject = JSONObject.parseObject(res);
            jsonObject = jsonObject.getJSONObject("data");
            String resId = jsonObject.getString(req.getGroupId());
            return resId != null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public boolean userSendGroupMessage(GroupMessageReq req) {
        String url = AIServiceImpl.URL_PREFIX + "messages/chatgroups";

        // 向groupIdList中发消息
        List<String> toList = new ArrayList<>();
        toList.add(req.getGroupId());

        Map<String, String> bodyMap = new HashMap<>();
        bodyMap.put("msg", req.getMsg());

        MessageBody messageBody = new MessageBody();
        messageBody.setFrom(req.getUserId());
        messageBody.setTo(toList);
        messageBody.setType("txt");
        messageBody.setBody(bodyMap);

        String res = HttpClientUtils.hxPostRequest(url, HXUtils.headerMap, JSONUtil.toJsonStr(messageBody));
        try {
            JSONObject jsonObject = JSONObject.parseObject(res);
            jsonObject = jsonObject.getJSONObject("data");
            String resId = jsonObject.getString(req.getGroupId());
            return resId != null;
        } catch (Exception e) {
            log.error("插入到数据库失败");
            return false;
        }
    }

    @Override
    public boolean sendChatMessage(ChatMessageReq req, String msg) {
        String userId = botName;
        // /{org_name}/{app_name}/messages/chatgroups
        String url = AIServiceImpl.URL_PREFIX + "messages/users";

        List<String> toList = new ArrayList<>();
        toList.add(req.getToUserId());
        Map<String, String> bodyMap = new HashMap<>();
        bodyMap.put("msg", msg);

        MessageBody messageBody = new MessageBody();
        messageBody.setFrom(userId);
        messageBody.setTo(toList);
        messageBody.setType("txt");
        messageBody.setBody(bodyMap);

        String res = HttpClientUtils.hxPostRequest(url, HXUtils.headerMap, JSONUtil.toJsonStr(messageBody));
        try {
            JSONObject jsonObject = JSONObject.parseObject(res);
            jsonObject = jsonObject.getJSONObject("data");
            String resId = jsonObject.getString(req.getToUserId());
            return resId != null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}




