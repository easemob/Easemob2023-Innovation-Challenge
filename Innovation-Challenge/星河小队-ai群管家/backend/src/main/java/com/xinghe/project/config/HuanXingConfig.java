package com.xinghe.project.config;

import com.easemob.im.server.EMProperties;
import com.easemob.im.server.EMService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class HuanXingConfig {

    @Bean
    public EMService service() {

        EMProperties properties = EMProperties.builder()
                .setBaseUri("https://a1.easemob.com/1181231114210730/demo/token")
                .setAppkey("1181231114210730#demo")
                .setClientId("YXA6DyU82lR6ScimqLtWsb8ong")
                .setClientSecret("YXA6cfkXcddKU-JR3OnhddRrDxtBRvo")
                .build();

        return new EMService(properties);
    }
}
