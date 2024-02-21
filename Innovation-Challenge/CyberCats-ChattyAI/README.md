# ChattyAI
----

开发环境：
- Tools : Android Studio
- os : MacOS
- code : JAVA

运行环境：

- os : Android 6.0 +

项目包含内容：

- Android Project
- 安装包

第三方：

- 环信IM sdk
    - 单聊消息
    - 发送前回调
- minmax AI接口

## 项目背景

该项目的背景是为了提供一个有趣和互动性强的聊天应用。
通过与虚拟角色的聊天，用户可以体验到与人工智能进行对话的乐趣，并获得智能化的回答。
这种交互方式可以增加用户的参与感和娱乐性，同时也展示了环信 IM 和 minimax AI 接口的强大功能。

## 功能列表

- 多达八种不同性格的倾诉对象
- 早安和晚安

## 运行说明

使用AndroidStudio运行项目


## 运行相关配置

## 环信console后台配置
- 第一：需要设置用户注册的模式为开放注册和好友关系检查关闭
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/4b0262991fa3493f80af8bbe744127a9.png#pic_center)
- 第二：创建8个机器人的账号
在应用概览下，用户认证创建8个机器人的账号
![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/eaf628e989eb4a90989a82c1fe559b17.png#pic_center)
🤖 注意，这八个基础账号不可以更改用户ID，否则需要调整代码中BotSettingUtil中八个对应机器人的Account
- 第三：需要配置发送前回调
![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/9ceb5eb7e51049f2b38db1c44d86ba75.png#pic_center)
🤖 回调地址请确保环信可以通过外网访问到
## minimax配置信息
- 如果需要修改minimax的配置信息，修改该文件的第十一到十三行
    自己的minimax的配置信息获取方式如下
    > 参考minimax给出的快速开始获取这三个参数的值，其中url变化不大，因为minimax是通过http请求来获取对应响应的
    > 请确保MiniMax有余额，否则可能导致调用MiniMax的调用失败
    [MiniMax的快速开始](https://api.minimax.chat/v1/text/chatcompletion_pro?GroupId=)

## 前端修改Appkey：

前往com.imchat.chanttyai/base/Constants.java，修改APP_KEY值为自己在环信的Appkey

## 后端地址修改

前往com.imchat.chanttyai/base/Constants.java，修改HTTP_HOST值为部署域名或IP
