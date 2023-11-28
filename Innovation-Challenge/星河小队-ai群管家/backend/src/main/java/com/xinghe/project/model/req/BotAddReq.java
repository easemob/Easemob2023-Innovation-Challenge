package com.xinghe.project.model.req;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BotAddReq {

    /**
     * '群id'
     */
    private String groupId;

    /**
     * '用户name'
     */
    private String userId;

//    public static BotAddReq toModel() {
//
//    }
}
