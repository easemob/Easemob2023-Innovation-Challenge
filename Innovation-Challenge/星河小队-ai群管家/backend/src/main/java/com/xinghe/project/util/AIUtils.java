package com.xinghe.project.util;

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
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringEscapeUtils;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

@Slf4j
public class AIUtils {

    private static String DASHSCOPE_API_KEY = "sk-240dba3a3b1c430786deafa0f1ef4510";

    public static String callAIGC(String prompt, String content, Boolean b) {
        String res = "";
        try {
            if (b == null || b == false) {
                res = callWithMessage(prompt, content);
            } else {
                res = zhiPuAI_v2(prompt, content);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return res;
    }

    public static final HashMap<String, Object> header = new HashMap<>();
    public static final HashMap<String, String> payload = new HashMap<>();
    private final static String API_KEY_ID = "475451f1ca2c967bdb451508982a56d6";
    private final static String API_KEY_SECRET = "YqPuCfIhXJaDpYUD";

    static {
        header.put("alg", "HS256");
        header.put("sign_type", "SIGN");
        payload.put("api_key", API_KEY_ID);
        payload.put("exp", System.currentTimeMillis() + 6 * 1000 * 10 + "");
        payload.put("timestamp", System.currentTimeMillis() + "");
    }

    public static String zhiPuAI_v2(String prompt, String content) {
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
        map.put("content", prompt + content);
        dataMap.put("prompt", JsonUtils.toJson(map));
        System.out.println(JsonUtils.toJson(map));
        String res = HttpClientUtils.postRequest(url, header, dataMap);

        JSONObject root = JSONObject.parseObject(res);

        try {

            int code = root.getInteger("code");
            boolean success = root.getBoolean("success");
            String msg = root.getString("msg");
            log.info("zhiPu call: prompt {}, content {}, result {}", prompt, content, root);
            if (!success) {
                log.warn("request failed {} {}", code, msg);
                return root.getString("msg");
            }
            //获得字符串型数据
            root = root.getJSONObject("data");
            JSONArray choices = root.getJSONArray("choices");
            return StringEscapeUtils.unescapeJson(choices.getJSONObject(0).getString("content"));
        } catch (Exception e) {
            log.warn("zhiPu call error");
            throw e;
        }
    }

    public static String sign() throws UnsupportedEncodingException {

        return JWT.create()
                .withPayload(payload)
                .withHeader(header)
                .sign(Algorithm.HMAC256(API_KEY_SECRET.getBytes(StandardCharsets.UTF_8)));
    }


    /**
     * 调用阿里接口
     *
     * @param prompt
     * @param content
     * @return
     * @throws NoApiKeyException
     * @throws ApiException
     * @throws InputRequiredException
     */
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
        log.info("ali call: prompt {}, content {}, result usage {} output {}", prompt, content, result.getUsage(), result.getOutput());
        try {
            return result.getOutput().getChoices().get(0).getMessage().getContent();
        } catch (Exception e) {
            log.warn("get result failed");
            throw e;
        }
    }


    static Set<String> BLOCK_KEYS = new HashSet<>();

    static {
        BLOCK_KEYS.add("傻逼");
        BLOCK_KEYS.add("打爆");
    }

    public String filterContent(String content) {
        for (String key : BLOCK_KEYS) {
            while (content.contains(key)) {
                int idx = content.indexOf(key);
                content = content.substring(0, idx)
                        + "x".repeat(key.length())
                        + content.substring(idx + key.length());
            }

        }
        return content;
    }
}
