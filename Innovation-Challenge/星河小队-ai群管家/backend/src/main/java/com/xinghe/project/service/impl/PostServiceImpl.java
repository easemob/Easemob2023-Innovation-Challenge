package com.xinghe.project.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.project.service.PostService;
import com.xinghe.project.model.entity.Post;
import com.xinghe.project.mapper.PostMapper;
import org.springframework.stereotype.Service;

/**
* @author SoftPro
* @description 针对表【post(帖子)】的数据库操作Service实现
* @createDate 2023-05-13 08:27:40
*/
@Service
public class PostServiceImpl extends ServiceImpl<PostMapper, Post>
    implements PostService {

}




