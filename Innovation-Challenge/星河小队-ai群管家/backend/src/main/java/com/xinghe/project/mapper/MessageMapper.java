package com.xinghe.project.mapper;

import com.xinghe.project.model.entity.Message;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xinghe.project.model.req.MessageReq;

import java.util.List;

/**
* @author 26258
* @description 针对表【message(消息)】的数据库操作Mapper
* @createDate 2023-11-14 14:32:33
* @Entity com.xinghe.project.model.entity.Message
*/
public interface MessageMapper extends BaseMapper<Message> {
    public List<Message> selectLatest(MessageReq req);
}




