package com.xinghe.project;

import com.xinghe.project.service.HXService;
import com.xinghe.project.util.HXUtils;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import javax.annotation.Resource;

@SpringBootTest
class XingHeApplicationTests {

    @Resource
    private HXService hxService;
    @Test
    void contextLoads() {
//        String token = HXUtils.getToken("https://a1.easemob.com/1181231114210730/demo/token");
//        System.out.println(token);
    }

}
