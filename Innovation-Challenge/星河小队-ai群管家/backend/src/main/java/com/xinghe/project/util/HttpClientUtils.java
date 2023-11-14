package com.xinghe.project.util;

import com.alibaba.dashscope.utils.JsonUtils;
import com.alibaba.fastjson.JSONObject;
import lombok.extern.slf4j.Slf4j;
import lombok.val;
import okhttp3.*;
import org.apache.commons.lang3.StringUtils;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Slf4j
public class HttpClientUtils {

    // 创建OkHttpClient对象, 并设置超时时间 添加拦截器LoginInterceptor
    private static final OkHttpClient client = new OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            // .addInterceptor(new LoginInterceptor())
            .build();

    public static void main(String[] args) throws IOException {
        String url = "http://www.baidu.com";

    }

    /**
     * 同步POST请求
     *
     * @param url 请求地址
     * @param headerMap 请求头
     * @param bodyMap 请求参数
     */
    public static String postRequest(String url, Map<String, Object> headerMap,
                                     Map<String, String> bodyMap) {

        try {
            // 3 构建Request.Builder对象
            Request.Builder requestBuilder = new Request.Builder().url(url);
            // 1 添加请求头
            headerMap.keySet().stream().forEach(it -> requestBuilder.addHeader(it, (String) headerMap.get(it)));

            // 2 构建请求体
            val body = RequestBody.create("{" + "\"prompt\":" + "[" + bodyMap.get("prompt") + "]" + "}", MediaType.get("application/json"));

            // 4 发起请求获取响应值
            Response response = client.newCall(requestBuilder
                    .post(body)
                    .build())
                    .execute();

            // 5 根据响应结果判断
            if (response.isSuccessful()) {
                return response.body().string();
            } else {
                throw new RuntimeException("请求异常,错误码为: " + response.code());
            }
        } catch (Exception e) {
            log.info("请求失败,错误信息为= {} ", e.getMessage());
        }
        return null;
    }

    public static String hxPostRequest(String url, Map<String, Object> headerMap,
                                     String bodyJSON) {
        try {
            // 3 构建Request.Builder对象
            Request.Builder requestBuilder = new Request.Builder().url(url);
            // 1 添加请求头
            headerMap.keySet().stream().forEach(it -> requestBuilder.addHeader(it, (String) headerMap.get(it)));

            // 2 构建请求体
            val body = RequestBody.create(bodyJSON, MediaType.get("application/json"));

            // 4 发起请求获取响应值
            Response response = client.newCall(requestBuilder
                            .post(body)
                            .build())
                    .execute();

            // 5 根据响应结果判断
            if (response.isSuccessful()) {
                System.out.println(response);
                return response.body().string();
            } else {
                throw new RuntimeException("请求异常,错误码为: " + response.code());
            }
        } catch (Exception e) {
            log.info("请求失败,错误信息为= {} ", e.getMessage());
        }
        return null;
    }

    public static String hxGetRequest(String url, Map<String, Object> headerMap) {
        try {
            // 3 构建Request.Builder对象
            Request.Builder requestBuilder = new Request.Builder().url(url);
            // 1 添加请求头
            headerMap.keySet().stream().forEach(it -> requestBuilder.addHeader(it, (String) headerMap.get(it)));

            // 4 发起请求获取响应值
            Response response = client.newCall(requestBuilder.build()).execute();

            // 5 根据响应结果判断
            if (response.isSuccessful()) {
                System.out.println(response);
                return response.body().string();
            } else {
                throw new RuntimeException("请求异常,错误码为: " + response.code());
            }
        } catch (Exception e) {
            log.info("请求失败,错误信息为= {} ", e.getMessage());
        }
        return null;
    }
}
