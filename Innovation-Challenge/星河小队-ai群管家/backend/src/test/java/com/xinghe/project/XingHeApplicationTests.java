package com.xinghe.project;

import com.xinghe.project.model.entity.Message;
import com.xinghe.project.model.req.GroupMessageReq;
import com.xinghe.project.service.AIService;
import com.xinghe.project.service.HXService;
import com.xinghe.project.service.MessageService;
import com.xinghe.project.util.HXUtils;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import javax.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;

@SpringBootTest
class XingHeApplicationTests {

    @Resource
    private HXService hxService;

    @Resource
    private MessageService messageService;

    @Resource
    private AIService aiService;

    private static final String GROUP_ID = "231249887166469";

    @Test
    public void sendMessageToGroup() {
        List<Message> list = messageService.list();
        // todo: 查看用户是否存在，不存在创建用户
        try {
            list.stream()
                    .peek(it -> {
                        // 判断群里是否有该员工，没有则创建
                        // boolean b = aiService.ensureBotExist(req);
                        it.setUserId("user1");
                        // 发送消息
                        messageService.userSendGroupMessage(GroupMessageReq.toModel(it));
                    }).collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    public void testSendMessage() {
        Message message = new Message();
        message.setUserId("user1");
        message.setContent("苹果手机便宜卖了");
        message.setGroupId(GROUP_ID);
        message.setContentType(0);
        messageService.save(message);
    }

    @Test
    void contextLoads() {
//        String token = HXUtils.getToken("https://a1.easemob.com/1181231114210730/demo/token");
//        System.out.println(token);
    }

}
