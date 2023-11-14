package com.xinghe.project.util;

import com.alibaba.dashscope.utils.JsonUtils;
import lombok.extern.slf4j.Slf4j;

import java.awt.*;
import java.util.HashMap;
import java.util.Map;

@Slf4j
public class HXUtils {

    public static void main() {
        String url = "https://a1.easemob.com/1181231114210730/demo/token";
        String token = getToken(url);
        System.out.println(token);
    }

    public static String token =
            "YWMtcW9_gIKYEe6wVzPMNR5G0WzBsmE0oDgVlttEeaLWFqQPJTzaVHpJyKaou1axvyieAgMAAAGLy7v0EwAAAABht9tlYEWUuwNtPd5bBgZsF38bvkWBuSbcp8DJgoc21Q";
    /**
     * 获取token
     */
    public static String getToken(String url) {
        Map<String, Object> headerMap = new HashMap<>();
        headerMap.put("Content-Type", "application/json");
        headerMap.put("Accept","application/json");

        Map<String, String> bodyMap = new HashMap<>();
        bodyMap.put("grant_type", "client_credentials");
        bodyMap.put("client_id", "YXA6DyU82lR6ScimqLtWsb8ong");
        bodyMap.put("client_secret", "YXA6cfkXcddKU-JR3OnhddRrDxtBRvo");
        bodyMap.put("ttl", 0 + "");
        return HttpClientUtils.hxPostRequest(url, headerMap, JsonUtils.toJson(bodyMap));
    }
}
