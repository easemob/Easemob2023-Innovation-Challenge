package com.xinghe.project.controller;

import cn.hutool.core.io.FileUtil;
import com.alibaba.dashscope.exception.InputRequiredException;
import com.alibaba.dashscope.exception.NoApiKeyException;
import com.xinghe.project.common.ErrorCode;
import com.xinghe.project.common.R;
import com.xinghe.project.common.RUtils;
import com.xinghe.project.exception.BusinessException;
import com.xinghe.project.model.entity.Message;
import com.xinghe.project.model.req.MessageReq;
import com.xinghe.project.service.MessageService;
import com.xinghe.project.util.AIUtils;
import com.xinghe.project.util.FileUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/message")
public class MessageController {

    @Resource
    private MessageService messageService;


    @PostMapping("/sendMessage")
    public R<Boolean> sendMessage(@RequestBody Message message) {
        boolean save = messageService.save(message);
        return RUtils.success(save);
    }

    @PostMapping("/addMessageByFile")
    public R<String> addMessageByFile(@RequestPart("file") MultipartFile file) {
        // 校验文件
        long size = file.getSize();
        String originalFilename = file.getOriginalFilename();
        // 校验文件大小
        final long ONE_MB = 1024 * 1024L;
        if (size > ONE_MB) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "文件超过 1M");
        }
        // 校验文件后缀   aaa.png
        String suffix = FileUtil.getSuffix(originalFilename);
        final List<String> validFileSuffixList = Arrays.asList("xlsx", "xls");
        if (!validFileSuffixList.contains(suffix)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "文件后缀非法");
        }

        List<Message> userQuestionMapList = FileUtils.excelToMessageList(file);
        boolean saveBatch = messageService.saveBatch(userQuestionMapList);
        if (!saveBatch) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "数据库错误");
        }
        return RUtils.success("添加完成");
    }
}
