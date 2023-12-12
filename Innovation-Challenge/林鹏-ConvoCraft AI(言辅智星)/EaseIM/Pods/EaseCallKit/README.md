# easecallkitui-ios

## 简介
EaseCallKitUI是一套可以让用户快速集成1v1语言、视频通话以及多人音视频通话的音视频UI库，使用声网音视频SDK为核心音视频模块，环信IM为信令通道，方便用户在最短的时间内完成音视频集成。

## 集成

### 准备条件
-
    集成EaseCallKitUI之前，用户应该已有独立的环信AppKey，在声网创建了应用，并基本完成了应用中的环信IM功能。
    
> 环信Console引导地址：[环信文档](http://docs-im.easemob.com/im/quickstart/guide/experience#注册并创建应用)
> 声网Console地址：[声网注册入口](https://console.agora.io)

### UI库编译生成

1.通过cocoapods安装依赖库
打开终端，运行命令

```
cd ./EaseCallKitUI

pod install

```
2.点击.xcworkspace运行即可

## 目录介绍

  - Assets :
    - EaseCall.bundle [存储UI库中用到的所有资源文件]
  - classes : 
    - Categories [用到的系统类扩展]
    - Store [通话信息]
    - Process [通话信令处理]
    - Utils [通用工具类、定义 ]
    - View [音视频视图]
    - ViewController [通话界面视图控制器]

## Pod集成

```
pod 'EaseCallKit'
```
引入头文件:  

```
#import <EaseCallKit/EaseCallUIKit.h>
```
