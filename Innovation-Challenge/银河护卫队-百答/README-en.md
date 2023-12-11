[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/modood/Administrative-divisions-of-China/master/LICENSE)
[![Build Status](https://travis-ci.org/xialonghua/kotmvp.svg?branch=master)](https://github.com/supmaster/Easemob2023-Innovation-Challenge) 
![Github stars](https://img.shields.io/github/stars/supmaster/Easemob2023-Innovation-Challenge.svg)

<!-- PROJECT LOGO -->
<br />

<p align="center">
  <a href="https://github.com/supmaster/Easemob2023-Innovation-Challenge">
    <img src="Screenshots/bot.png" alt="Logo" width="80" height="80">
  </a>
  <h3 align="center">Baida</h3>
  <p align="center">
    Baida,an All-round Assistant,Your AI brain trust.
    <br />
    An all-round AI assistant developed based on the instant messaging solution of RingChat IM and combined with the capabilities of various large models.
    <br />
    The Internet+ plus EasemobIM plus LLM, strong power combination, multiple BUFF superposition, let ordinary people also have the power to move the earth!
    <br />
    <strong>Omnipotent & Intelligence</strong>
    <br />
    <a href="README.md" target="_blank"><strong>中文文档 »</strong></a>
    <br />
    <br />
    <a href="https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/wxamp.jpg" title="Wechat Demo">View Demo</a>
    ·
    <a href="https://github.com/supmaster/Easemob2023-Innovation-Challenge/issues">Report Bug</a>
    ·
    <a href="https://github.com/supmaster/Easemob2023-Innovation-Challenge/issues">Request Feature</a>
  </p>


</p>

<!-- TABLE OF CONTENTS -->

<details open="open">
  <summary><h2 style="display: inline-block">索引</h2></summary>
  <ol>
    <li>
      <a href="#1-项目背景">项目背景</a>
      <ul>
        <li><a href="#1.1-大赛背景">1.1 大赛背景</a></li>
        <li><a href="#1.2-赛道赛题">1.2 赛道赛题</a></li>
        <li><a href="#1.3-应用背景">1.3 适用对象</a></li>
        <li><a href="#1.4-应用领域">1.4 应用领域</a>
          <ul>
            <li><a href="#1.4.1-知识问答">1.4.1 知识问答</a></li>
            <li><a href="#1.4.2-代码能力">1.4.2 代码能力</a></li>
            <li><a href="#1.4.3-文本生成">1.4.3 文本生成</a></li>
            <li><a href="#1.4.4-角色扮演">1.4.4 角色扮演</a></li>
          </ul>
        </li>
      </ul>
    </li>
    <li><a href="#2-功能介绍</a></li>
      <ul>
        <li><a href="#2.1-系统功能">2.1 系统功能</a></li>
          <ul>
            <li><a href="#2.1.1-配置说明">2.1.1 配置说明</a></li>
            <li><a href="#2.1.2-用户登录">2.1.2 用户登录</a></li>
            <li><a href="#2.1.3-用户注册">2.1.3 用户注册</a></li>
            <li><a href="#2.1.4-服务配置">2.1.4 服务配置</a></li>
          </ul>
        <li><a href="#2.2-业务功能">2.2 业务功能</a></li>
          <ul>
            <li><a href="#2.2.1-好友列表">2.2.1 好友列表</a></li>
            <li><a href="#2.2.2-探索">2.2.2 探索</a></li>
            <li><a href="#2.2.3-聊天">2.2.3 聊天</a></li>
            <li><a href="#2.2.4-用户信息">2.2.4 用户信息</a></li>
            <li><a href="#2.2.5-退出登录">2.2.5 退出登录</a></li>
          </ul>
        <li><a href="#2.3 异常提示">2.3 异常提示</a></li>
          <ul>
            <li><a href="#2.3.1-登录失败">2.3.1 登录失败</a></li>
            <li><a href="#2.3.2-注册用户名已存在">2.3.2 注册用户名已存在</a></li>
            <li><a href="#2.3.3-消息发送频繁">2.3.3 消息发送频繁</a></li>
          </ul>
      </ul>
    <li><a href="#3-技术组件">技术组件</a></li>
    <li><a href="#4-快速上手">快速上手</a></li>
    <li><a href="#5-开源协议">开源协议</a></li>
    <li><a href="#6-联系作者">联系作者</a></li>
    <li><a href="#7-致谢">致谢</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## 1 项目背景

我有个朋友，他叫猪小明，爱情路上的夸父，有人说他深情，但大多数人说他傻，因为他把别人当女神，别人当他是舔狗。本来最近跟我说累了舔不动了，想放弃。结果女神鼓励说他是世界上最好的舔狗，舔的深情舔的认真，希望他能够坚持下去，永远做她的舔狗。于是他又充满了动力。

可是小明感觉这么多年能做的能说的都用过了，怕没有新意。所以想借助目前流行的人工智能技术帮他提升舔技，他说还能参加比赛还可能有奖金。

于是一款名为“舔狗教练“的小程序营运而生。正当我写好前后端服务，准备测一下效果的时候，发现进展不下去了，因为通义千问听到“舔狗”二字就愤然拒绝。我想也是啊，大模型都不愿做的事情肯定没前途，不得不更改策略，“舔狗教练“成为“恋爱导师”，于是受众就不再是猪小明一个人了，既然用户多了，那肯定要满足更多人的需求，一款全能型的智能助手转型成功。

百答，采用环信 RESTful API 快速实现用户管理、消息发送和系统推送。具有登录、注册、注销功能，好友列表，好友分类显示，机器人好友支持 恋爱导师、代码助手、周报生成、小红书文案、角色扮演、礼物攻略、翻译助手、法律咨询、简历润色等。更多功能后台正在加班接入。后期上线群聊功能。

<!-- event-background -->
### 1.1 大赛背景
*  即时通讯已成为现代生活中不可或缺的一部分，近年来人工智能的迅猛发展也为即时通讯带来了前所未有的智能化体验。高度拟人的陪伴型机器人，全能实用的服务型机器人，高效智能的对话机器人，AI 与即时通讯的结合创新，为用户提供了众多智慧化的沟通方式。借助 AI 模型的强大能力，即时通讯正迎来全新的场景和体验。
*  环信作为国内 IM 即时通讯领域的领导者，致力于为开发者和企业提供安全、可靠、高效的通讯体验及解决方案。在数字化时代，环信将继续推进即时通讯与 AI 的紧密结合，赋能智慧沟通新时代！
*  本次 未来已来·创新无限 - 环信 IM+AI编程挑战赛 由环信举办，旨在鼓励开发者、编程爱好者和创新者们发挥创意，融合即时通讯与人工智能技术，重新定义人们的沟通方式，创造出更智能、更便捷、更有趣的沟通体验。无论您是热衷于编程技术，还是对即时通讯与人工智能融合充满好奇，本次编程挑战赛都将是您展示才华和创新的绝佳机会。让我们一起开创未来，用编程点亮 IM+AI 的交融之美！

<!-- event-task -->
### 1.2 赛道赛题
* 参赛作品须基于环信即时通讯IM（SDK或Demo），自由调用业内领先的AI大模型能力，实现具有应用场景和创新功能的AI+IM的应用，鼓励大家在本次挑战赛中发挥奇思妙想的创意， 展现花样丰富、智能化的即时通讯体验及应用场景。

  以下场景及功能供参考：

  - ![img](https://www.easemob.com/event/aigc/images/handle-1.png)社交场景

    · AI 聊天机器人· AI 游戏陪玩· 虚拟人物

  - ![img](https://www.easemob.com/event/aigc/images/handle-2.png)电商场景

    · 智能客服· 精准营销· AI 模特换装· 虚拟主播

  - ![img](https://www.easemob.com/event/aigc/images/handle-3.png)医疗场景

    · 智慧导诊· 智能在线问诊· AI诊室听译机器人

  - ![img](https://www.easemob.com/event/aigc/images/handle-4.png)教育场景

    · AI 助教· 智能教学· 个性化教育

  - ![img](https://www.easemob.com/event/aigc/images/handle-5.png)银行保险

    · AI 虚拟代理或顾问

  - ![img](https://www.easemob.com/event/aigc/images/handle-6.png)软件/工具

    · 会议助手 AI 洞察· 群未读消息摘要· 群分享链接摘要

<!-- application-background -->

<!-- GETTING STARTED -->

### 1.3 适用对象
* !（不认识汉字的人||不会写字）

### 1.4 应用领域
#### 1.4.1 知识问答

- 生活常识
- 工作技能
- 医学知识
- 历史人文

#### 1.4.2 代码能力

- 代码生成
- 代码解释
- 代码纠错
- 单元测试

#### 1.4.3 文本生成

- 商业文案
- 营销方案
- 英文写作

#### 1.4.4 角色扮演

- 恋爱导师
- 虚拟人物
- 翻译助手
- 法律咨询
- 自助问诊

> **更多场景正在探索中……**

## 2 功能介绍
### 2.1 系统功能
#### 2.1.1 配置说明
* 配置文件utils/WebIM.js：配置自己的环信IM的host和appKey等信息
* 配置文件utils/Config.js：配置自己的默认后端服务端口
* 支持Android、IOS等APP，支持微信小程序，理论上支持阿里、百度和字节系小程序，时间问题未测试
* 推荐微信小程序访问，免安装方便快捷
#### 2.1.2 用户登录
* 首次启动应用显示登录页面，输入用户名密码即可登录
* 贴心的提供长按显示密码明文
* 登录失败显示失败原因
* 登录成功后存储用户信息，下次启动不必重新登录

![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/login.png "登录界面")![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/login2.png "登录界面")

#### 2.1.3 用户注册

* 新用户需注册才可使用，注册页面复用登录页面

* 由于注册采用环信IM接口，注册用户名规则和环信API文档一致，注册页面对用户名规则有说明

* 环信IM的用户注册API本来是不要求昵称必须，但是本程序昵称后续在群聊中有用，所以统一要求必须有，用户名作为用户id区别本应用内用户使用

* 用户名的作用：
  * 作为用户id区别本应用内用户
  * 用户登录、消息收发
  
* 用户昵称的作用：
  * 显示个人信息
  * 后期群聊显示昵称
  
* 注册成功后自动进入应用，不必重新登录

* 目前已有的机器人账号均是提前创建好的

  ![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/register.png "注册界面") ![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/register2.png "注册成功")
#### 2.1.4 服务配置

* 配置后台服务地址：用户可自定义后台服务。由于测试是白嫖的临时服务器只有几天使用期限，考虑到小程序上线审核周期问题，发布后不方便修改，通过配置该地址，可以实现用户端更换服务接口
* 服务appkey配置：用户可以自定义大模型appkey，目前限时白嫖的通义千问有使用频次限制，自定义后则优先使用自定义的key
* 以上接口留空则均使用默认配置，自己无设置导致不能使用也可以删掉后保存一下即可

### 2.2 业务功能
#### 2.2.1 好友列表
* 登录后进入应用的第一个页面，显示好友列表
* 显示分组和昵称等信息
* 添加好友和建群功能

![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/friends.png "好友分组列表")![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/friends2.png "快速定位好友")

#### 2.2.2 探索
* 用于展示更多创意玩法和教程
* 更多适用场景
* 该页面功能后期完善

![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/explore.png "探索页面")

#### 2.2.3 聊天
* 从通讯录点击机器人或好友，进入聊天界面
* 聊天界面显示对方昵称，发送消息后会显示自己和对方头像
* 确保用户合法性，聊天界面会验证用户accessToken有效性
* 根据机器人特性，发送相应的文字，获取智能答复
* 为防止混乱，每次发送完消息后，等收到回复才可继续提问
* 由于网络或AI服务原因，未得到答复时，自动恢复到发送前的状态，可一键再次发送请求
* 退出聊天界面时，会保存当前历史会话，下次进入可继续对话
* 可从悬浮按钮手动清理当前会话，开启新话题，建议清空历史会话，效果会更好

![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/chat1.png "聊天")![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/chat2.png "聊天")![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/chat3.png  "聊天")![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/chat4.png "聊天")![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/chat5.png "聊天")![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/chat6.png "聊天")![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/chat7.png "聊天")![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/chat8.png "清理聊天")

#### 2.2.4 用户信息
* 可查看用户头像、昵称、签名、用户名、以及环信IM中的uuid、用户类型、accessToken等信息
* accessToken默认隐藏，可显示查看
* 用户信息维护
* 可设置服务配置

![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/userInfo.png "用户信息")

#### 2.2.5 退出登录
* 用户再次确认退出后，退出当前用户登录状态
* 清除所有用户缓存信息
* 跳转到登录页面
### 2.3 异常提示

#### 2.3.1 登录失败

* 用户名或密码错误，导致登录失败

* 输入正确用户名或密码即可，也可以重新注册


  ![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/warning_no_username.png "登录失败")

#### 2.3.2 注册用户名已存在
* 环信IM中用户名在当前应用作为唯一标识，不能与其他人重复
* 遇到提示更换用户名即可，后续显示主要为用户昵称，昵称不要求唯一


  ![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/warning_id_not_unique.png "注册用户名已存在")
#### 2.3.2 消息发送频繁
* 由于大模型算力成本较高，目前很多都会限制用户请求频率，尤其是免费用户
* 如果自己有key，可以使用自己的key
* 如果没有key，稍等片刻再次请求即可
![](https://gitee.com/hbeu/easemob2023-innovation-challenge/raw/master/Screenshots/warning_msg_frequent.png "消息发送频繁-目前没复现出来，下次碰到再补图")

<!-- ROADMAP -->
## 3 技术组件
- [x] easemob-websdk
- [x] @dcloudio/uni-ui
- [x] fastapi
- [x] uvicorn
- [x] dashscope

<!-- GETTING STARTED -->
## 4 快速上手

1. 克隆代码 (`git clone https://github.com/supmaster/Easemob2023-Innovation-Challenge.git`)
2. 进入目录`Easemob2023-Innovation-Challenge/Innovation-Challenge/银河护卫队-百答/`
3. 安装依赖：`npm install`
4. 将该项目导入Hbuilder
5. 更改配置文件：`utils/Config.js`和`utils/WebIM.js`，替换自己的key和server
6. 可按需求发布原生APP，或小程序或H5页面
7. 服务端为了支持更多的业务场景，尚在继续开发中，暂未开源，可自己安装数据格式自行实现

<!-- LICENSE -->
## 5 开源协议

基于 MIT 开源协议. 点击 `LICENSE` 查看更多信息

<!-- CONTACT -->
## 6 联系作者

Supmaster - [@github_handle](https://github.com/supmaster) - email

Project Link: [https://github.com/supmaster/Easemob2023-Innovation-Challenge](https://github.com/supmaster/Easemob2023-Innovation-Challenge)

<!-- ACKNOWLEDGEMENTS -->

## 7 致谢

- [x] [环信](https://console.easemob.com)
- [x] [IM Geek]()
- [x] []()社群小姐姐 :girl:
- [x] uni-app

[回到顶部](#readme)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links

[contributors-shield]: https://img.shields.io/github/contributors/github_username/repo.svg?style=for-the-badge
[contributors-url]: https://github.com/github_username/repo_name/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/github_username/repo.svg?style=for-the-badge
[forks-url]: https://github.com/github_username/repo_name/network/members
[stars-shield]: https://img.shields.io/github/stars/github_username/repo.svg?style=for-the-badge
[stars-url]: https://github.com/github_username/repo_name/stargazers
[issues-shield]: https://img.shields.io/github/issues/github_username/repo.svg?style=for-the-badge
[issues-url]: https://github.com/github_username/repo_name/issues
[license-shield]: https://img.shields.io/github/license/github_username/repo.svg?style=for-the-badge
[license-url]: https://github.com/github_username/repo_name/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/github_username -->
