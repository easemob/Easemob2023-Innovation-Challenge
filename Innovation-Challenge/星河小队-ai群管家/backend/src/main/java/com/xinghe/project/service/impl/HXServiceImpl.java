package com.xinghe.project.service.impl;

import com.alibaba.dashscope.utils.JsonUtils;
import com.easemob.im.server.EMService;
import com.easemob.im.server.api.message.MessageApi;
import com.easemob.im.server.model.EMKeyValue;
import com.easemob.im.server.model.EMMessage;
import com.easemob.im.shaded.reactor.core.publisher.Mono;
import com.xinghe.project.service.HXService;
import com.xinghe.project.util.HXUtils;
import com.xinghe.project.util.HttpClientUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@Service
public class HXServiceImpl implements HXService {

    @Resource
    private EMService emService;
/*
curl -X POST -H 'Accept: application/json' -H 'Authorization: Bearer YWMtcW9_gIKYEe6wVzPMNR5G0WzBsmE0oDgVlttEeaLWFqQPJTzaVHpJyKaou1axvyieAgMAAAGLy7v0EwAAAABht9tlYEWUuwNtPd5bBgZsF38bvkWBuSbcp8DJgoc21Q'\
 -i "https://a1.easemob.com/1181231114210730/demo/users" \
-d '{"username":"user2","password":"123","nickname":"testuser2"}'
-d '{"username":"user1","password":"123","nickname":"testuser"}'


curl -X GET -H 'Accept: application/json' -H 'Authorization: Bearer YWMtcW9_gIKYEe6wVzPMNR5G0WzBsmE0oDgVlttEeaLWFqQPJTzaVHpJyKaou1axvyieAgMAAAGLy7v0EwAAAABht9tlYEWUuwNtPd5bBgZsF38bvkWBuSbcp8DJgoc21Q'\
 'https://a1.easemob.com/1181231114210730/demo/users?limit=2'

    curl -X POST -i 'https://a1.easemob.com/1181231114210730/demo/messages/users' \
            -H 'Content-Type: application/json' \
            -H 'Accept: application/json' \
            -H 'Authorization: Bearer YWMtcW9_gIKYEe6wVzPMNR5G0WzBsmE0oDgVlttEeaLWFqQPJTzaVHpJyKaou1axvyieAgMAAAGLy7v0EwAAAABht9tlYEWUuwNtPd5bBgZsF38bvkWBuSbcp8DJgoc21Q'  \
            -d '{
            "from": "user1",
            "to": ["user2"],
            "type": "txt",
            "body": {
        "msg": "testmessages"
    },
            "ext": {
        "em_ignore_notification": true
    }
}'

    curl -X GET -H 'Accept: application/json' -H 'Authorization: Bearer YWMtcW9_gIKYEe6wVzPMNR5G0WzBsmE0oDgVlttEeaLWFqQPJTzaVHpJyKaou1axvyieAgMAAAGLy7v0EwAAAABht9tlYEWUuwNtPd5bBgZsF38bvkWBuSbcp8DJgoc21Q'\
            'https://a1.easemob.com/1181231114210730/demo/chatmessages/2023111410'
*/

    /**
     * 获取 [time, currentTime] 之间历史消息
     * @param time
     */
    private void getHistoryMessage(Long time) {
        String url = "https://a1.easemob.com/1181231114210730/demo/chatmessages/" + time;
        Map<String, Object> headerMap = new HashMap<>();
        headerMap.put("Accept", "application/json");
        headerMap.put("Content-Type", "application/json");
        headerMap.put("Authorization", "Bearer " + HXUtils.token);

        String s = HttpClientUtils.hxGetRequest(url, headerMap);
        System.out.println(s);
    }

    /**
     * 通过SDK获取历史消息
     * @param from
     * @param to
     * @param emMessage
     * @param extensions
     * @param isAckRead
     * @param msgTimestamp
     * @param needDownload
     */
    private void getHistoryMessageUsingSDK(String from, String to, EMMessage emMessage
            , Set<EMKeyValue> extensions, Boolean isAckRead, Long msgTimestamp
            , boolean needDownload) {
        MessageApi messageApi = emService.message();
        Mono<String> stringMono =
                messageApi.importChatGroupMessage(from, to, emMessage, extensions, isAckRead, msgTimestamp, needDownload);

    }


}
