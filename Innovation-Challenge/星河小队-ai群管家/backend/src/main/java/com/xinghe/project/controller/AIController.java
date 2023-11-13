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
import com.xinghe.project.util.HttpClientUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.*;

@RestController
@RequestMapping("/ai")
public class AIController {
    static Set<String> BLOCK_KEYS = new HashSet<>();

    static {
        BLOCK_KEYS.add("傻逼");
        BLOCK_KEYS.add("打爆");
    }

    private static String DASHSCOPE_API_KEY = "sk-240dba3a3b1c430786deafa0f1ef4510";

    public String filterContent( String content) {
        for (String key : BLOCK_KEYS) {
            while (content.contains(key)) {
                int idx = content.indexOf(key);
                content = content.substring(0, idx)
                        + "x".repeat(key.length())
                        + content.substring(idx+key.length());
            }

        }
        return content;
    }

    @PostMapping("/get")
    public R<String> askForQuestion(String prompt, String content, Boolean b)
            throws NoApiKeyException, InputRequiredException {
        // String res = zhiPuAI_v2(prompt, content);
        String res = "";
        if (b == null ||b == false) {
            res = callWithMessage(prompt, content);
        } else {
            res = zhiPuAI_v2(prompt, content);
        }
        return RUtils.success(res);
    }

    public static String callWithMessage(String prompt, String content)
            throws NoApiKeyException, ApiException, InputRequiredException {
        Constants.apiKey = DASHSCOPE_API_KEY;
        Generation gen = new Generation();
        MessageManager msgManager = new MessageManager(10);
        Message systemMsg =
                Message.builder().role(Role.SYSTEM.getValue()).content(prompt).build();
        Message userMsg = Message.builder().role(Role.USER.getValue()).content(content).build();
        msgManager.add(systemMsg);
        msgManager.add(userMsg);
        QwenParam param =
                QwenParam.builder().model(Generation.Models.QWEN_MAX).messages(msgManager.get())
                        .resultFormat(QwenParam.ResultFormat.MESSAGE)
                        .topP(0.8)
                        .enableSearch(true)
                        .build();
        GenerationResult result = gen.call(param);
        System.out.println(result);
        return result.getOutput().toString();
    }


    public static final HashMap<String, Object> header = new HashMap<>();
    public static final HashMap<String, String> payload = new HashMap<>();
    private final static String API_KEY_ID = "f62e08a65553eb7b98548c5f4a9a447e";
    private final static String API_KEY_SECRET = "7VDzb32lmydt9Vcy";
    static {
        header.put("alg", "HS256");
        header.put("sign_type", "SIGN");
        payload.put("api_key", API_KEY_ID);
        payload.put("exp", System.currentTimeMillis() + 6 * 1000 * 10 + "");
        payload.put("timestamp", System.currentTimeMillis() + "");
    }

    public static String zhiPuAI_v2(String promptReq, String contentReq) {
        String token = null;
        try {
            token = sign();
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
        header.put("Authorization", token);
        String url = "https://open.bigmodel.cn/api/paas/v3/model-api/chatglm_turbo/invoke";
        Map<String, String> dataMap = new HashMap<>();
        Map<String, String> map = new HashMap<>();
        map.put("role", "user");
        map.put("content", promptReq + contentReq);
        dataMap.put("prompt", JsonUtils.toJson(map));
        System.out.println(JsonUtils.toJson(map));
        return HttpClientUtils.postRequest(url, header, dataMap);
    }

    public static String sign() throws UnsupportedEncodingException {

        return JWT.create()
                .withPayload(payload)
                .withHeader(header)
                .sign(Algorithm.HMAC256(API_KEY_SECRET.getBytes(StandardCharsets.UTF_8)));
    }
}
