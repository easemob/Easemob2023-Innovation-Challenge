package com.xinghe.project.service;

import com.xinghe.project.model.req.BotAddReq;

public interface AIService {

    boolean botHasOwn(BotAddReq req);

    boolean ensureBotExist(BotAddReq req);
}
