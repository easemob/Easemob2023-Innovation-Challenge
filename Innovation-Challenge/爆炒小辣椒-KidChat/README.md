# KidChat

儿童绘本故事创作分享社区

## Features

- 通过语音输入故事梗概然后由 LLM 生成绘本故事
- 自动将绘本故事分享到群内，让小朋友们一起欣赏通通过 reaction 互动
- 自动为每一个故事生成子区，可在子区内对故事进一步讨论

## Requirements

- 创建一个[环信](https://www.easemob.com)应用并获取到 AppKey
- 此应用使用星火大模型，你需要在[星火](https://www.xfyun.cn)上创建一个项目并获取到项目 ID

## Build & Run

此项目为 Flutter 项目，目前只适配了 android 端，你可以通过一下命令来编译出一个 apk

```bash
flutter build apk --release --dart-define EM_APP_KEY=1187221121120259#demo --dart-define IFLYTEK_APP_ID=5f9f8c6a --dart-define IFLYTEK_APP_SECRET=5f9f8c6a --dart-define IFLYTEK_API_KEY=5f9f8c6a
```

> 请务必编译 release 版本， debug 版本对 llm 输出 tokens 有限制
> EM_APP_KEY 为环信应用的 AppKey，请为此应用开通 reaction 和 群聊子区服务
> IFLY_APP_ID 为星火项目的 ID
> IFLY_APP_SECRET 为星火项目的 Secret
> IFLY_API_KEY 为星火 3.0 web api 的 key

## 预编译版本下载

你也可以通过下面的地址直接下载预编译版本， 预编译版本每次可以使用 5 次生成服务， 到达上线后卸载重新即可。

[下载地址]()

## License
