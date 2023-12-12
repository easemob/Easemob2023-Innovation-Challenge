//
//  EaseCallDefine.h
//  EaseIM
//
//  Created by lixiaoming on 2021/1/8.
//  Copyright © 2021 lixiaoming. All rights reserved.
//

#ifndef EaseCallDefine_h
#define EaseCallDefine_h
// 通话类型
typedef NS_ENUM(NSInteger,EaseCallType) {
    EaseCallType1v1Audio,// 1v1语音
    EaseCallType1v1Video,// 1v1视频
    EaseCallTypeMulti// 多人通话
};

//通话结束原因
typedef NS_ENUM(NSInteger,EaseCallEndReason) {
    EaseCallEndReasonHangup,// 挂断通话
    EaseCallEndReasonCancel,// 取消呼叫
    EaseCallEndReasonRemoteCancel,// 对方取消呼叫
    EaseCallEndReasonRefuse,// 对方拒绝呼叫
    EaseCallEndReasonBusy,// 忙碌
    EaseCallEndReasonNoResponse,// 无响应
    EaseCallEndReasonRemoteNoResponse,// 对方无响应
    EaseCallEndReasonHandleOnOtherDevice// 已在其他设备处理
};

// 错误类型
typedef NS_ENUM(NSInteger,EaseCallErrorType) {
    EaseCallErrorTypeProcess,// 业务处理异常
    EaseCallErrorTypeRTC, // RTC异常，声网接口返回
    EaseCallErrorTypeIM // IM异常，环信SDK接口返回
};

// 业务逻辑异常代码
typedef NS_ENUM(NSInteger,EaseCallProcessErrorCode) {
    EaseCallProcessErrorCodeInvalidParams = 100, // 参数错误
    EaseCallProcessErrorCodeBusy, //当前处于忙碌状态
    EaseCallProcessErrorCodeFetchTokenFail, //token错误

};

#endif /* EaseCallDefine_h */
