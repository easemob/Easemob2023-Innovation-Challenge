package com.xinghe.project.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.xinghe.project.model.req.BotAddReq;
import com.xinghe.project.service.AIService;
import com.xinghe.project.util.AIUtils;
import com.xinghe.project.util.HXUtils;
import com.xinghe.project.util.HttpClientUtils;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.checkerframework.checker.index.qual.UpperBoundUnknown;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class AIServiceImpl implements AIService {

    public static final String URL_PREFIX = "https://a1.easemob.com/1181231114210730/demo/";

    // TODO inject
    private final String botName = "user_Bot";

    public static void main(String[] args) {
        AIServiceImpl aiService = new AIServiceImpl();
        BotAddReq req = new BotAddReq();
        req.setUserId("00000");
        req.setGroupId("1111");
        aiService.botHasOwn(req);
    }

    /**
     * 判断bot是否已在群groupId中
     *
     * @param req
     * @return
     */
    @Override
    public boolean botHasOwn(BotAddReq req) {
        // 查看指定的用户是否已加入群组。
        // GET https://{host}/{org_name}/{app_name}/chatgroups/{group_id}/user/{username}/is_joined
        String url = URL_PREFIX + "chatgroups/" + req.getGroupId()
                + "/user/" + req.getUserId() + "/is_joined";
        String json = HttpClientUtils.hxGetRequest(url, HXUtils.headerMap);
        try {
            return JSONObject.parseObject(json).getBoolean("data");
        } catch (Exception e) {
            log.warn("req2 " + url + ", result parse failed " + e + "\t" + json);
            throw e;
        }
    }

    @Override
    public boolean ensureBotExist(BotAddReq req) {
        // 判断群是否已存在机器人
        req.setUserId(botName);
        boolean b = botHasOwn(req);
        if (b) {
            return true;
        }

        // 添加bot
        // POST https://{host}/{org_name}/{app_name}/chatgroups/{group_id}/users/{username}
        String url = URL_PREFIX + "chatgroups/" + req.getGroupId() + "/users/" + req.getUserId();
        String json = HttpClientUtils.hxPostRequest(url, HXUtils.headerMap, "{}");
        try {
            JSONObject jsonObject = JSONObject.parseObject(json);
            return jsonObject.getJSONObject("data").getBoolean("result");
        } catch (Exception e) {
            log.warn("req2 " + url + ", result parse failed " + e + "\t" + json);
            throw e;
        }
    }
}
