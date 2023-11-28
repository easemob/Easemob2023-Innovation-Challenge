package com.xinghe.project.model.req;

import com.xinghe.project.model.entity.Message;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GroupMessageReq {

    private String groupId;

    private String userId;

    private String msg;

    private Integer groupOrOwn;

    private Integer contentType;

    public static GroupMessageReq toModel(Message message) {
        return GroupMessageReq.builder()
                .groupId(message.getGroupId())
                .userId(message.getUserId())
                .msg(message.getContent())
                .groupOrOwn(message.getGroupOrOwn())
                .contentType(message.getContentType())
                .build();
    }
}
