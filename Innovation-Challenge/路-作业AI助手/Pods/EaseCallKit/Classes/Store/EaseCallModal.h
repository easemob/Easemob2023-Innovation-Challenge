//
//  EaseCallModal.h
//  EaseIM
//
//  Created by lixiaoming on 2021/1/8.
//  Copyright © 2021 lixiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseCallDefine.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

typedef NS_ENUM(NSInteger,EaseCallState) {
    EaseCallState_Idle,
    EaseCallState_Outgoing,
    EaseCallState_Alerting,
    EaseCallState_Answering
};

@protocol EaseCallModalDelegate <NSObject>

// 通话状态改变
- (void)callStateWillChangeTo:(EaseCallState)newState from:(EaseCallState)preState;

@end

NS_ASSUME_NONNULL_BEGIN

// 加入频道时，使用joinChannlewithAccount接口，account为自己的环信账户
@interface ECCall : NSObject
// 通话的callId，一次通话的唯一标识符
@property (nonatomic,strong) NSString* callId;
// 通话的对端账户环信Id
@property (nonatomic,strong) NSString* remoteUserAccount;
// 通话的对端账户设备ID
@property (nonatomic,strong) NSString* remoteCallDevId;
// 通话类型
@property (nonatomic) EaseCallType callType;
// 是否主叫方
@property (nonatomic) BOOL isCaller;
// 自己在频道中的声网ID
@property (nonatomic) NSInteger uid;
// 多人通话使用，会议中的人员使用的声网uid与环信id映射表<声网uid,环信ID>
@property (nonatomic,strong) NSMutableDictionary<NSNumber*,NSString*>* allUserAccounts;
// 频道名称
@property (nonatomic,strong) NSString* channelName;
// 扩展字段
@property (nonatomic,strong) NSDictionary* ext;
@end

@interface EaseCallModal : NSObject
// 当前正在进行的通话
@property (nonatomic,strong) ECCall* __nullable currentCall;
// 当前收到的通话请求
@property (nonatomic,strong) NSMutableDictionary* recvCalls;
// 本地设备ID
@property (nonatomic,strong) NSString* curDevId;
// 自己的环信ID
@property (nonatomic,strong) NSString* curUserAccount;
// 声网RTC的token
@property (nonatomic,strong) NSString* agoraRTCToken;
// 通话的呼叫状态
@property (nonatomic) EaseCallState state;
// 自己是否加入频道成功
@property (nonatomic) BOOL hasJoinedChannel;
// 使用的声网uid
@property (nonatomic) NSInteger agoraUid;

- (instancetype)initWithDelegate:(id<EaseCallModalDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
