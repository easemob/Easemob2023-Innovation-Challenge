package com.xinghe.project;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.xinghe.project.mapper")
public class XingHeApplication {

    public static void main(String[] args) {
        SpringApplication.run(XingHeApplication.class, args);
    }

}
