package com.xinghe.project.controller;

import com.xinghe.project.common.ErrorCode;
import com.xinghe.project.common.R;
import com.xinghe.project.common.RUtils;
import com.xinghe.project.model.entity.AiPrompt;
import com.xinghe.project.model.req.BotAddReq;
import com.xinghe.project.model.req.MessageReq;
import com.xinghe.project.model.res.AIPromptRes;
import com.xinghe.project.service.AIService;
import com.xinghe.project.service.AiPromptService;
import com.xinghe.project.service.MessageService;
import com.xinghe.project.util.AIUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/ai_prompt")
public class AIPromptController {

    @Resource
    private AiPromptService aiPromptService;


    @GetMapping("/list")
    public R<List<AIPromptRes>> list() {
        List<AiPrompt> list = aiPromptService.list();
        List<AIPromptRes> res = list.stream()
                .map(AIPromptRes::toModel)
                .collect(Collectors.toList());
        return RUtils.success(res);
    }

    @PostMapping("/add")
    public R<Boolean> add(@RequestBody AiPrompt aiPrompt) {
        try {
            aiPromptService.save(aiPrompt);
        } catch (Exception e) {
            RUtils.error(ErrorCode.SYSTEM_ERROR, "请重新添加");
        }
        return RUtils.success(true);
    }

    @PostMapping("/update")
    public R<Boolean> update(@RequestBody AiPrompt aiPrompt) {
        try {
            aiPromptService.updateById(aiPrompt);
        } catch (Exception e) {
            RUtils.error(ErrorCode.SYSTEM_ERROR, "请重新修改");
        }
        return RUtils.success(true);
    }


}
