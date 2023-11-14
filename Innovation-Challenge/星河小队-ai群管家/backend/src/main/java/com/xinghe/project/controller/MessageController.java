package com.xinghe.project.controller;

import com.alibaba.dashscope.exception.InputRequiredException;
import com.alibaba.dashscope.exception.NoApiKeyException;
import com.xinghe.project.common.R;
import com.xinghe.project.common.RUtils;
import com.xinghe.project.model.entity.Message;
import com.xinghe.project.model.req.MessageReq;
import com.xinghe.project.service.MessageService;
import com.xinghe.project.util.AIUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping("/message")
public class MessageController {

    @Resource
    private MessageService messageService;


    @PostMapping("sendMessage")
    public R<Boolean> sendMessage(@RequestBody Message message) {
        boolean save = messageService.save(message);
        return RUtils.success(save);
    }
}
