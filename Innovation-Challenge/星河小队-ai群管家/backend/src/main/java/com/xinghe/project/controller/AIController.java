package com.xinghe.project.controller;

import com.alibaba.dashscope.aigc.generation.Generation;
import com.alibaba.dashscope.aigc.generation.GenerationResult;
import com.alibaba.dashscope.aigc.generation.models.QwenParam;
import com.alibaba.dashscope.common.Message;
import com.alibaba.dashscope.common.MessageManager;
import com.alibaba.dashscope.common.Role;
import com.alibaba.dashscope.exception.ApiException;
import com.alibaba.dashscope.exception.InputRequiredException;
import com.alibaba.dashscope.exception.NoApiKeyException;
import com.alibaba.dashscope.utils.Constants;
import com.alibaba.dashscope.utils.JsonUtils;
import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.xinghe.project.common.R;
import com.xinghe.project.common.RUtils;
import com.xinghe.project.model.req.BotAddReq;
import com.xinghe.project.model.req.MessageReq;
import com.xinghe.project.service.MessageService;
import com.xinghe.project.util.AIUtils;
import com.xinghe.project.util.HttpClientUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.*;

@RestController
@RequestMapping("/bot")
public class AIController {

    @Resource
    private MessageService messageService;

    @PostMapping("/summary")
    public R<String> askForSummary(@RequestBody MessageReq req) {
        String s = messageService.doAIGC(req);
        // todo: 向群聊中发送消息
        messageService.sendMessage(req, s);
        return RUtils.success(s);
    }

    @PostMapping("/getAI")
    public R<String> askForQuestion(String prompt, String content, Boolean b)
            throws NoApiKeyException, InputRequiredException {
        String res = AIUtils.callAIGC(prompt, content, b);
        //
        return RUtils.success(res);
    }

    @PostMapping("/add")
    public R<Boolean> addBot(BotAddReq req){

        return RUtils.success(true);
    }


}
