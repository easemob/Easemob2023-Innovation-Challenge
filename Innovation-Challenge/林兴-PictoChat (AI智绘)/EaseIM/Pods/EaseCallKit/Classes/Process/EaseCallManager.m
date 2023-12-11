//
//  EaseCallManager.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/18.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallManager.h"
#import "EaseCallSingleViewController.h"
#import "EaseCallMultiViewController.h"
#import "EaseCallManager+Private.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Masonry/Masonry.h>
#import "EaseCallModal.h"
#import <CommonCrypto/CommonDigest.h>
#import "EaseCallLocalizable.h"

static NSString* kAction = @"action";
static NSString* kChannelName = @"channelName";
static NSString* kCallType = @"type";
static NSString* kCallerDevId = @"callerDevId";
static NSString* kCallId = @"callId";
static NSString* kTs = @"ts";
static NSString* kMsgType = @"msgType";
static NSString* kCalleeDevId = @"calleeDevId";
static NSString* kCallStatus = @"status";
static NSString* kCallResult = @"result";
static NSString* kInviteAction = @"invite";
static NSString* kAlertAction = @"alert";
static NSString* kConfirmRingAction = @"confirmRing";
static NSString* kCancelCallAction = @"cancelCall";
static NSString* kAnswerCallAction = @"answerCall";
static NSString* kConfirmCalleeAction = @"confirmCallee";
static NSString* kVideoToVoice = @"videoToVoice";
static NSString* kBusyResult = @"busy";
static NSString* kAcceptResult = @"accept";
static NSString* kRefuseresult = @"refuse";
static NSString* kMsgTypeValue = @"rtcCallWithAgora";
static NSString* kExt = @"ext";
#define EMCOMMUNICATE_TYPE @"EMCommunicateType"
#define EMCOMMUNICATE_TYPE_VOICE @"EMCommunicateTypeVoice"
#define EMCOMMUNICATE_TYPE_VIDEO @"EMCommunicateTypeVideo"

@interface EaseCallManager ()<EMChatManagerDelegate,AgoraRtcEngineDelegate,EaseCallModalDelegate>
@property (nonatomic,strong) EaseCallConfig* config;
@property (nonatomic,weak) id<EaseCallDelegate> delegate;
@property (nonatomic) dispatch_queue_t workQueue;
@property (nonatomic,strong) AVAudioPlayer* audioPlayer;
@property (nonatomic,strong) EaseCallModal* modal;
// 定义 agoraKit 变量
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
// 呼叫方Timer
@property (nonatomic,strong) NSMutableDictionary* callTimerDic;
// 接听方Timer
@property (nonatomic,strong) NSMutableDictionary* alertTimerDic;
@property (nonatomic,weak) NSTimer* confirmTimer;
@property (nonatomic,weak) NSTimer* ringTimer;
@property (nonatomic,strong) EaseCallBaseViewController*callVC;
@property (nonatomic) BOOL bNeedSwitchToVoice;
@end

@implementation EaseCallManager
static EaseCallManager *easeCallManager = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //[[EMClient sharedClient] log:@"-------[EaseCallManager] init-------"];
        easeCallManager = [[EaseCallManager alloc] init];
        easeCallManager.delegate = nil;
        [[EMClient sharedClient].chatManager addDelegate:easeCallManager delegateQueue:nil];
        easeCallManager.modal = [[EaseCallModal alloc] initWithDelegate:easeCallManager];
        easeCallManager.agoraKit = nil;
    });
    return easeCallManager;
}

- (void)initWithConfig:(EaseCallConfig*)aConfig delegate:(id<EaseCallDelegate>)aDelegate
{
    self.delegate= aDelegate;
    _workQueue = dispatch_queue_create("EaseCallManager.WorkQ", DISPATCH_QUEUE_SERIAL);
    if(aConfig) {
        self.config = aConfig;
    }else{
        self.config = [[EaseCallConfig alloc] init];
    }
    if(!self.agoraKit) {
        self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:self.config.agoraAppId delegate:self];
        [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
        [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
        [self.agoraKit enableAudioVolumeIndication:1000 smooth:5 reportVad:NO];
    }
    
    self.modal.curUserAccount = [[EMClient sharedClient] currentUsername];
}

- (EaseCallConfig*)getEaseCallConfig
{
    return self.config;
}

- (void)setRTCToken:(NSString*_Nullable)aToken channelName:(NSString*)aChannelName uid:(NSUInteger)aUid
{
    if(self.modal.currentCall && [self.modal.currentCall.channelName isEqualToString:aChannelName]) {
        self.modal.agoraRTCToken = aToken;
        self.modal.agoraUid = aUid;
        [self joinChannel];
    }
}

- (void)setUsers:(NSDictionary<NSNumber*,NSString*>*_Nonnull)aUsers channelName:(NSString*)aChannel
{
    if(aUsers.count > 0 && self.modal.currentCall && [self.modal.currentCall.channelName isEqualToString:aChannel])
    {
        self.modal.currentCall.allUserAccounts = [aUsers mutableCopy];
        if(self.modal.currentCall.callType == EaseCallTypeMulti) {
            NSArray<NSString*>* array = aUsers.allValues;
            for(NSString* username in array) {
                [[self getMultiVC] removePlaceHolderForMember:username];
                [self _stopCallTimer:username];
            }
        }
    }
}

- (NSMutableDictionary*)callTimerDic
{
    if(!_callTimerDic)
        _callTimerDic = [NSMutableDictionary dictionary];
    return _callTimerDic;
}

- (NSMutableDictionary*)alertTimerDic
{
    if(!_alertTimerDic)
        _alertTimerDic = [NSMutableDictionary dictionary];
    return _alertTimerDic;
}

- (void)startInviteUsers:(NSArray<NSString*>*)aUsers ext:(NSDictionary*)aExt  completion:(void (^)(NSString* callId,EaseCallError*))aCompletionBlock{
    if([aUsers count] == 0){
        NSLog(@"InviteUsers faild!!remoteUid is empty");
        if(aCompletionBlock)
        {
            EaseCallError* error = [EaseCallError errorWithType:EaseCallErrorTypeProcess code:EaseCallProcessErrorCodeInvalidParams description:@"Require remoteUid"];
            aCompletionBlock(nil,error);
        }else{
            [self callBackError:EaseCallErrorTypeProcess code:EaseCallProcessErrorCodeInvalidParams description:@"Require remoteUid"];
        }
        return;
    }
    __weak typeof(self) weakself = self;
    dispatch_async(weakself.workQueue, ^{
        if(weakself.modal.currentCall && weakself.callVC) {
            NSLog(@"inviteUsers in group");
            for(NSString* uId in aUsers) {
                if([weakself.modal.currentCall.allUserAccounts.allValues containsObject:uId])
                    continue;
                [weakself sendInviteMsgToCallee:uId type:weakself.modal.currentCall.callType callId:weakself.modal.currentCall.callId channelName:weakself.modal.currentCall.channelName ext:aExt completion:nil];
                [weakself _startCallTimer:uId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[weakself getMultiVC] setPlaceHolderUrl:[weakself getHeadImageByUserName:uId] member:uId];
                });
                if(aCompletionBlock)
                    aCompletionBlock(weakself.modal.currentCall.callId,nil);
            }
        }else{
            weakself.modal.currentCall = [[ECCall alloc] init];
            weakself.modal.currentCall.channelName = [[NSUUID UUID] UUIDString];
            weakself.modal.currentCall.callType = EaseCallTypeMulti;
            weakself.modal.currentCall.callId = [[NSUUID UUID] UUIDString];
            weakself.modal.currentCall.isCaller = YES;
            weakself.modal.state = EaseCallState_Answering;
            weakself.modal.currentCall.ext = aExt;
            dispatch_async(dispatch_get_main_queue(), ^{
                for(NSString* uId in aUsers) {
                    [weakself sendInviteMsgToCallee:uId type:weakself.modal.currentCall.callType callId:weakself.modal.currentCall.callId channelName:weakself.modal.currentCall.channelName ext:aExt completion:nil];
                    [weakself _startCallTimer:uId];
                    [[weakself getMultiVC] setPlaceHolderUrl:[weakself getHeadImageByUserName:uId] member:uId];
                }
                if(aCompletionBlock)
                    aCompletionBlock(weakself.modal.currentCall.callId,nil);
            });
        }
    });
}

- (void)startSingleCallWithUId:(NSString*)uId type:(EaseCallType)aType ext:(NSDictionary*)aExt completion:(void (^)(NSString* callId,EaseCallError*))aCompletionBlock {
    if([uId length] == 0) {
        NSLog(@"makeCall faild!!remoteUid is empty");
        if(aCompletionBlock)
        {
            EaseCallError* error = [EaseCallError errorWithType:EaseCallErrorTypeProcess code:EaseCallProcessErrorCodeInvalidParams description:@"Require remoteUid"];
            aCompletionBlock(nil,error);
        }else{
            [self callBackError:EaseCallErrorTypeProcess code:EaseCallProcessErrorCodeInvalidParams description:@"Require remoteUid"];
        }
        return;
    }
    __weak typeof(self) weakself = self;
    dispatch_async(weakself.workQueue, ^{
        EaseCallError * error = nil;
        if([self isBusy]) {
            NSLog(@"makeCall faild!!current is busy");
            if(aCompletionBlock) {
                error = [EaseCallError errorWithType:EaseCallErrorTypeProcess code:EaseCallProcessErrorCodeBusy description:@"current is busy "];
                aCompletionBlock(nil,error);
            }else{
                [self callBackError:EaseCallErrorTypeProcess code:EaseCallProcessErrorCodeBusy description:@"current is busy"];
            }
        }else{
            weakself.modal.currentCall = [[ECCall alloc] init];
            weakself.modal.currentCall.channelName = [[NSUUID UUID] UUIDString];
            weakself.modal.currentCall.remoteUserAccount = uId;
            weakself.modal.currentCall.callType = (EaseCallType)aType;
            weakself.modal.currentCall.callId = [[NSUUID UUID] UUIDString];
            weakself.modal.currentCall.isCaller = YES;
            weakself.modal.state = EaseCallState_Outgoing;
            weakself.modal.currentCall.ext = aExt;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself sendInviteMsgToCallee:uId type:weakself.modal.currentCall.callType callId:weakself.modal.currentCall.callId channelName:weakself.modal.currentCall.channelName ext:aExt completion:aCompletionBlock];
                [weakself _startCallTimer:uId];
//                if(aCompletionBlock)
//                    aCompletionBlock(weakself.modal.currentCall.callId,error);
            });
        }
    });
}

// 是否处于忙碌状态
- (BOOL)isBusy
{
    if(self.modal.currentCall && self.modal.state != EaseCallState_Idle)
        return YES;
    return NO;
}

- (void)clearRes
{
    if(self.modal.currentCall)
    {
        if(self.modal.currentCall.callType != EaseCallType1v1Audio)
        {
            [self.agoraKit stopPreview];
            [self.agoraKit disableVideo];
        }
        if(self.modal.hasJoinedChannel)
            dispatch_async(self.workQueue, ^{
                self.modal.hasJoinedChannel = NO;
                [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
                    [[EMClient sharedClient] log:@"leaveChannel"];
                }];
            });
            
        
    }
    if(self.callVC) {
        if(self.callVC.isMini) {
            [self.callVC.floatingView removeFromSuperview];
            self.callVC = nil;
        }else
        {
            [self.callVC dismissViewControllerAnimated:NO completion:^{
                self.callVC = nil;
            }];
        }
    }
    NSLog(@"invite timer count:%lu",(unsigned long)self.callTimerDic.count);
    NSArray* timers = [self.callTimerDic allValues];
    for (NSTimer* tm in timers) {
        if(tm) {
            [tm invalidate];
        }
    }
    [self.callTimerDic removeAllObjects];
    NSArray* alertTimers = [self.alertTimerDic allValues];
    for (NSTimer* tm in alertTimers) {
        if(tm) {
            [tm invalidate];
        }
    }
    if(self.confirmTimer) {
        [self.confirmTimer invalidate];
        self.confirmTimer = nil;
    }
    if(self.ringTimer) {
        [self.ringTimer invalidate];
        self.ringTimer = nil;
    }
    self.modal.currentCall = nil;
    [self.modal.recvCalls removeAllObjects];
    self.bNeedSwitchToVoice = NO;
}

-(UIWindow*) getKeyWindow
{
    if(@available(iOS 13.0, *)) {
        for(UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if(scene.activationState == UISceneActivationStateForegroundActive) {
                if(@available(iOS 15.0, *)) {
                    return scene.keyWindow;
                }else{
                    for(UIWindow* window in scene.windows) {
                        if(window.isKeyWindow) {
                            return window;
                        }
                    }
                }
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

- (void)refreshUIOutgoing
{
    if(self.modal.currentCall) {
        
        if(!self.callVC)
            self.callVC = [[EaseCallSingleViewController alloc] initWithisCaller:self.modal.currentCall.isCaller type:self.modal.currentCall.callType remoteName:self.modal.currentCall.remoteUserAccount];
        self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
        __weak typeof(self) weakself = self;
        UIWindow* keyWindow = [self getKeyWindow];
        if(!keyWindow)
            return;
        UIViewController* rootVC = keyWindow.rootViewController;
        [rootVC presentViewController:self.callVC animated:NO completion:^{
            if(weakself.modal.currentCall.callType == EaseCallType1v1Video)
                [weakself setupLocalVideo];
            [weakself fetchToken];
        }];
    }
}

- (void)refreshUIAnswering
{
    if(self.modal.currentCall) {
        if(self.modal.currentCall.callType == EaseCallTypeMulti && self.modal.currentCall.isCaller) {
            self.callVC = [[EaseCallMultiViewController alloc] init];
            self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
            UIWindow* keyWindow = [self getKeyWindow];
            if(!keyWindow)
                return;
            UIViewController* rootVC = keyWindow.rootViewController;
            __weak typeof(self) weakself = self;
            [rootVC presentViewController:self.callVC animated:NO completion:^{
                [weakself setupLocalVideo];
                [weakself fetchToken];
            }];
        }
        [self _stopRingTimer];
        [self stopSound];
    }
}

- (void)refreshUIAlerting
{
    if(self.modal.currentCall) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(callDidReceive:inviter:ext:)]) {
            [self.delegate callDidReceive:self.modal.currentCall.callType inviter:self.modal.currentCall.remoteUserAccount ext:self.modal.currentCall.ext];
        }
        [self playSound];
        if(self.modal.currentCall.callType == EaseCallTypeMulti) {
            self.callVC = [[EaseCallMultiViewController alloc] init];
            [self getMultiVC].inviterId = self.modal.currentCall.remoteUserAccount;
            self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
            UIWindow* keyWindow = [self getKeyWindow];
            if(!keyWindow)
                return;
            UIViewController* rootVC = keyWindow.rootViewController;
            if(rootVC.presentationController && rootVC.presentationController.presentedViewController)
                [rootVC.presentationController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                
            [rootVC presentViewController:self.callVC animated:NO completion:^{
                
            }];
        }else{
            self.callVC = [[EaseCallSingleViewController alloc] initWithisCaller:NO type:self.modal.currentCall.callType remoteName:self.modal.currentCall.remoteUserAccount];
            self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
            UIWindow* keyWindow = [self getKeyWindow];
            if(!keyWindow)
                return;
            UIViewController* rootVC = keyWindow.rootViewController;
            if(rootVC.presentationController && rootVC.presentationController.presentedViewController)
                [rootVC.presentationController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            [rootVC presentViewController:self.callVC animated:NO completion:^{
                
            }];
        }
        [self _startRingTimer:self.modal.currentCall.callId];
    }
}

- (void)setupVideo {
    [self.agoraKit enableVideo];
    // Default mode is disableVideo
    
    // Set up the configuration such as dimension, frame rate, bit rate and orientation
    [self.agoraKit setVideoEncoderConfiguration:self.config.encoderConfiguration];
    
}

- (EaseCallSingleViewController*)getSingleVC
{
    return (EaseCallSingleViewController*)self.callVC;
}

- (EaseCallMultiViewController*)getMultiVC
{
    return (EaseCallMultiViewController*)self.callVC;
}

#pragma mark - EaseCallModalDelegate
- (void)callStateWillChangeTo:(EaseCallState)newState from:(EaseCallState)preState
{
    NSLog(@"callState will chageto:%ld from:%ld",newState,(long)preState);
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (newState) {
            case EaseCallState_Idle:
                [weakself clearRes];
                break;
            case EaseCallState_Outgoing:
                [weakself refreshUIOutgoing];
                break;
            case EaseCallState_Alerting:
                [weakself refreshUIAlerting];
                break;
            case EaseCallState_Answering:
                [weakself refreshUIAnswering];
                break;
            default:
                break;
        }
    });
    
}

#pragma mark - EMChatManagerDelegate
- (void)messagesDidReceive:(NSArray *)aMessages
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (EMChatMessage *msg in aMessages) {
            [weakself _parseMsg:msg];
        }
    });
}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (EMChatMessage *msg in aCmdMessages) {
            [weakself _parseMsg:msg];
        }
    });
}

#pragma mark - sendMessage

//发送呼叫邀请消息
- (void)sendInviteMsgToCallee:(NSString*)aUid type:(EaseCallType)aType callId:(NSString*)aCallId channelName:(NSString*)aChannelName ext:(NSDictionary*)aExt completion:(void (^)(NSString* callId,EaseCallError*))aCompletionBlock
{
    if([aUid length] == 0 || [aCallId length] == 0 || [aChannelName length] == 0)
        return;
    NSString* strType = EaseCallLocalizableString(@"voice", nil);
    if(aType == EaseCallTypeMulti)
        strType = EaseCallLocalizableString(@"conferenece", nil);
    if(aType == EaseCallType1v1Video)
        strType = EaseCallLocalizableString(@"video", nil);
    EMTextMessageBody* msgBody = [[EMTextMessageBody alloc] initWithText:[NSString stringWithFormat: EaseCallLocalizableString(@"inviteInfo", nil),strType]];
    NSMutableDictionary* ext = [@{kMsgType:kMsgTypeValue,kAction:kInviteAction,kCallId:aCallId,kCallType:[NSNumber numberWithInt:(int)aType],kCallerDevId:self.modal.curDevId,kChannelName:aChannelName,kTs:[self getTs]} mutableCopy];
    if(aExt && aExt.count > 0) {
        [ext setValue:aExt forKey:kExt];
    }
//    if(aType == EaseCallType1v1Audio) {
//        [ext setObject:EMCOMMUNICATE_TYPE_VOICE forKey:EMCOMMUNICATE_TYPE];
//    }
//    if(aType == EaseCallType1v1Video) {
//        [ext setObject:EMCOMMUNICATE_TYPE_VIDEO forKey:EMCOMMUNICATE_TYPE];
//    }
    EMChatMessage* msg = [[EMChatMessage alloc] initWithConversationID:aUid from:self.modal.curUserAccount to:aUid body:msgBody ext:ext];
    __weak typeof(self) weakself = self;
    [[[EMClient sharedClient] chatManager] sendMessage:msg progress:nil completion:^(EMChatMessage *message, EMError *error) {
        if(aCompletionBlock)
            aCompletionBlock(weakself.modal.currentCall.callId,nil);
        if(error) {
            [weakself callBackError:EaseCallErrorTypeIM code:error.code description:error.errorDescription];
        }
    }];
}

// 发送alert消息
- (void)sendAlertMsgToCaller:(NSString*)aCallerUid callId:(NSString*)aCallId devId:(NSString*)aDevId
{
    if([aCallerUid length] == 0 || [aCallId length] == 0 || [aDevId length] == 0)
        return;
    EMCmdMessageBody* msgBody = [[EMCmdMessageBody alloc] initWithAction:@"rtcCall"];
    msgBody.isDeliverOnlineOnly = YES;
    NSDictionary* ext = @{kMsgType:kMsgTypeValue,kAction:kAlertAction,kCallId:aCallId,kCalleeDevId:self.modal.curDevId,kCallerDevId:aDevId,kTs:[self getTs]};
    EMChatMessage* msg = [[EMChatMessage alloc] initWithConversationID:aCallerUid from:self.modal.curUserAccount to:aCallerUid body:msgBody ext:ext];
    __weak typeof(self) weakself = self;
    [[[EMClient sharedClient] chatManager] sendMessage:msg progress:nil completion:^(EMChatMessage *message, EMError *error) {
        if(error) {
            [weakself callBackError:EaseCallErrorTypeIM code:error.code description:error.errorDescription];
        }
    }];
}

// 发送消息有效确认消息
- (void)sendComfirmRingMsgToCallee:(NSString*)aUid callId:(NSString*)aCallId isValid:(BOOL)aIsCallValid calleeDevId:(NSString*)aCalleeDevId
{
    if([aUid length] == 0 || [aCallId length] == 0 )
        return;
    EMCmdMessageBody* msgBody = [[EMCmdMessageBody alloc] initWithAction:@"rtcCall"];
    msgBody.isDeliverOnlineOnly = YES;
    NSDictionary* ext = @{kMsgType:kMsgTypeValue,kAction:kConfirmRingAction,kCallId:aCallId,kCallerDevId:self.modal.curDevId,kCallStatus:[NSNumber numberWithBool:aIsCallValid],kTs:[self getTs],kCalleeDevId:aCalleeDevId};
    EMChatMessage* msg = [[EMChatMessage alloc] initWithConversationID:aUid from:self.modal.curUserAccount to:aUid body:msgBody ext:ext];
    __weak typeof(self) weakself = self;
    [[[EMClient sharedClient] chatManager] sendMessage:msg progress:nil completion:^(EMChatMessage *message, EMError *error) {
        if(error) {
            [weakself callBackError:EaseCallErrorTypeIM code:error.code description:error.errorDescription];
        }
    }];
}

// 发送取消呼叫消息
- (void)sendCancelCallMsgToCallee:(NSString*)aUid callId:(NSString*)aCallId
{
    if([aUid length] == 0 || [aCallId length] == 0 )
        return;
    EMCmdMessageBody* msgBody = [[EMCmdMessageBody alloc] initWithAction:@"rtcCall"];
    NSDictionary* ext = @{kMsgType:kMsgTypeValue,kAction:kCancelCallAction,kCallId:aCallId,kCallerDevId:self.modal.curDevId,kTs:[self getTs]};
    EMChatMessage* msg = [[EMChatMessage alloc] initWithConversationID:aUid from:self.modal.curUserAccount to:aUid body:msgBody ext:ext];
    __weak typeof(self) weakself = self;
    [[[EMClient sharedClient] chatManager] sendMessage:msg progress:nil completion:^(EMChatMessage *message, EMError *error) {
        if(error) {
            [weakself callBackError:EaseCallErrorTypeIM code:error.code description:error.errorDescription];
        }
    }];
}

// 发送Answer消息
- (void)sendAnswerMsg:(NSString*)aCallerUid callId:(NSString*)aCallId result:(NSString*)aResult devId:(NSString*)aDevId
{
    if([aCallerUid length] == 0 || [aCallId length] == 0 || [aResult length] == 0 || [aDevId length] == 0)
        return;
    EMCmdMessageBody* msgBody = [[EMCmdMessageBody alloc] initWithAction:@"rtcCall"];
    msgBody.isDeliverOnlineOnly = YES;
    NSMutableDictionary* ext = [@{kMsgType:kMsgTypeValue,kAction:kAnswerCallAction,kCallId:aCallId,kCalleeDevId:self.modal.curDevId,kCallerDevId:aDevId,kCallResult:aResult,kTs:[self getTs]} mutableCopy];
    if(self.modal.currentCall.callType == EaseCallType1v1Audio && self.bNeedSwitchToVoice)
        [ext setObject:[NSNumber numberWithBool:YES] forKey:kVideoToVoice];
    EMChatMessage* msg = [[EMChatMessage alloc] initWithConversationID:aCallerUid from:self.modal.curUserAccount to:aCallerUid body:msgBody ext:ext];
    __weak typeof(self) weakself = self;
    [[[EMClient sharedClient] chatManager] sendMessage:msg progress:nil completion:^(EMChatMessage *message, EMError *error) {
        if(error) {
            [weakself callBackError:EaseCallErrorTypeIM code:error.code description:error.errorDescription];
        }
    }];
    [self _startConfirmTimer:aCallId];
}

// 发送仲裁消息
- (void)sendConfirmAnswerMsgToCallee:(NSString*)aUid callId:(NSString*)aCallId result:(NSString*)aResult devId:(NSString*)aDevId
{
    if([aUid length] == 0 || [aCallId length] == 0 || [aResult length] == 0 || [aDevId length] == 0)
        return;
    EMCmdMessageBody* msgBody = [[EMCmdMessageBody alloc] initWithAction:@"rtcCall"];
    msgBody.isDeliverOnlineOnly = YES;
    NSMutableDictionary* ext = [@{kMsgType:kMsgTypeValue,kAction:kConfirmCalleeAction,kCallId:aCallId,kCallerDevId:self.modal.curDevId,kCalleeDevId:aDevId,kCallResult:aResult,kTs:[self getTs]} mutableCopy];
    EMChatMessage* msg = [[EMChatMessage alloc] initWithConversationID:aUid from:self.modal.curUserAccount to:aUid body:msgBody ext:ext];
    __weak typeof(self) weakself = self;
    [[[EMClient sharedClient] chatManager] sendMessage:msg progress:nil completion:^(EMChatMessage *message, EMError *error) {
        if(error) {
            [weakself callBackError:EaseCallErrorTypeIM code:error.code description:error.errorDescription];
        }
    }];
    if([aResult isEqualToString:kAcceptResult]) {
        self.modal.state = EaseCallState_Answering;
    }
}

// 发送视频转音频消息
- (void)sendVideoToVoiceMsg:(NSString*)aUid callId:(NSString*)aCallId
{
    if([aUid length] == 0 || [aCallId length] == 0)
        return;
    EMCmdMessageBody* msgBody = [[EMCmdMessageBody alloc] initWithAction:@"rtcCall"];
    NSDictionary* ext = @{kMsgType:kMsgTypeValue,kAction:kVideoToVoice,kCallId:aCallId,kTs:[self getTs]};
    EMChatMessage* msg = [[EMChatMessage alloc] initWithConversationID:aUid from:self.modal.curUserAccount to:aUid body:msgBody ext:ext];
    __weak typeof(self) weakself = self;
    [[[EMClient sharedClient] chatManager] sendMessage:msg progress:nil completion:^(EMChatMessage *message, EMError *error) {
        if(error) {
            [weakself callBackError:EaseCallErrorTypeIM code:error.code description:error.errorDescription];
        }
    }];
}

- (NSNumber*)getTs
{
    return [NSNumber numberWithLongLong:([[NSDate date] timeIntervalSince1970] * 1000)];
}

#pragma mark - 解析消息信令

- (void)_parseMsg:(EMChatMessage*)aMsg
{
    if(![aMsg.to isEqualToString:[EMClient sharedClient].currentUsername])
        return;
    NSDictionary* ext = aMsg.ext;
    NSString* from = aMsg.from;
    NSString* msgType = [ext objectForKey:kMsgType];
    if([msgType length] == 0)
        return;
    NSString* callId = [ext objectForKey:kCallId];
    NSString* result = [ext objectForKey:kCallResult];
    NSString* callerDevId = [ext objectForKey:kCallerDevId];
    NSString* calleeDevId = [ext objectForKey:kCalleeDevId];
    NSString* channelname = [ext objectForKey:kChannelName];
    NSNumber* isValid = [ext objectForKey:kCallStatus];
    NSNumber* callType = [ext objectForKey:kCallType];
    NSNumber* isVideoToVoice = [ext objectForKey:kVideoToVoice];
    NSDictionary* callExt = nil;
    id ret = [ext objectForKey:kExt];
    if([ret isKindOfClass:[NSDictionary class]])
        callExt = ret;
    __weak typeof(self) weakself = self;
    
    void (^parseInviteMsgExt)(NSDictionary*) = ^void (NSDictionary* ext) {
        //[[EMClient sharedClient] log:@"parseInviteMsgExt"];
        if(weakself.modal.currentCall && [weakself.modal.currentCall.callId isEqualToString:callId])
        {
            return;
        }
        if([weakself.alertTimerDic objectForKey:callId])
            return;
        if([weakself isBusy])
            [weakself sendAnswerMsg:from callId:callId result:kBusyResult devId:callerDevId];
        else
        {
            ECCall* call = [[ECCall alloc] init];
            call.callId = callId;
            call.isCaller = NO;
            call.callType = (EaseCallType)[callType intValue];
            call.remoteCallDevId = callerDevId;
            call.channelName = channelname;
            call.remoteUserAccount = from;
            call.ext = callExt;
            [weakself.modal.recvCalls setObject:call forKey:callId];
            [weakself sendAlertMsgToCaller:call.remoteUserAccount callId:callId devId:call.remoteCallDevId];
            [weakself _startAlertTimer:callId];
        }
    };
    void (^parseAlertMsgExt)(NSDictionary*) = ^void (NSDictionary* ext) {
        //[[EMClient sharedClient] log:[NSString stringWithFormat:@"parseAlertMsgExt currentCallId:%@,state:%ld",weakself.modal.currentCall.callId,(long)weakself.modal.state]];
        // 判断devId
        if([weakself.modal.curDevId isEqualToString:callerDevId]) {
            // 判断有效
            if(weakself.modal.currentCall && [weakself.modal.currentCall.callId isEqualToString:callId] && [weakself.callTimerDic objectForKey:from]) {
                [weakself sendComfirmRingMsgToCallee:from callId:callId isValid:YES calleeDevId:calleeDevId];
            }else{
                [weakself sendComfirmRingMsgToCallee:from callId:callId isValid:NO calleeDevId:calleeDevId];
            }
        }
    };
    void (^parseCancelCallMsgExt)(NSDictionary*) = ^void (NSDictionary* ext) {
        //[[EMClient sharedClient] log:[NSString stringWithFormat:@"parseCancelCallMsgExt currentCallId:%@,state:%ld",weakself.modal.currentCall.callId,(long)weakself.modal.state]];
        if(weakself.modal.currentCall && [weakself.modal.currentCall.callId isEqualToString:callId] && !weakself.modal.hasJoinedChannel) {
            [weakself _stopConfirmTimer:callId];
            [weakself _stopAlertTimer:callId];
            [weakself callBackCallEnd:EaseCallEndReasonRemoteCancel];
            weakself.modal.state = EaseCallState_Idle;
            [weakself stopSound];
        }else{
            [weakself.modal.recvCalls removeObjectForKey:callId];
            [weakself _stopAlertTimer:callId];
        }
    };
    void (^parseAnswerMsgExt)(NSDictionary*) = ^void (NSDictionary* ext) {
        //[[EMClient sharedClient] log:[NSString stringWithFormat:@"parseAnswerMsgExt currentCallId:%@,state:%ld",weakself.modal.currentCall.callId,weakself.modal.state]];
        if(weakself.modal.currentCall && [weakself.modal.currentCall.callId isEqualToString:callId] && [weakself.modal.curDevId isEqualToString:callerDevId]) {
            if(weakself.modal.currentCall.callType == EaseCallTypeMulti) {
                if(![result isEqualToString:kAcceptResult])
                    [[weakself getMultiVC] removePlaceHolderForMember:from];
                
                NSTimer* timer = [self.callTimerDic objectForKey:from];
                if(timer) {
                    [self sendConfirmAnswerMsgToCallee:from callId:callId result:result devId:calleeDevId];
                    [timer invalidate];
                    timer = nil;
                    [self.callTimerDic removeObjectForKey:from];
                }
            }else{
                if(weakself.modal.state == EaseCallState_Outgoing) {
                    if([result isEqualToString:kAcceptResult]) {
                        
                            if(isVideoToVoice && isVideoToVoice.boolValue) {
                                [weakself switchToVoice];
                            }
                            weakself.modal.state = EaseCallState_Answering;
                    }else
                    {
                        if([result isEqualToString:kRefuseresult])
                            [weakself callBackCallEnd:EaseCallEndReasonRefuse];
                        if([result isEqualToString:kBusyResult]){
                            [weakself callBackCallEnd:EaseCallEndReasonBusy];
                        }
                        weakself.modal.state = EaseCallState_Idle;
                    }
                    [weakself sendConfirmAnswerMsgToCallee:from callId:callId result:result devId:calleeDevId];
                }
            }
        }
    };
    void (^parseConfirmRingMsgExt)(NSDictionary*) = ^void (NSDictionary* ext) {
        //[[EMClient sharedClient] log:[NSString stringWithFormat:@"parseConfirmRingMsgExt currentCallId:%@,state:%ld",weakself.modal.currentCall.callId,weakself.modal.state]];
        if([weakself.alertTimerDic objectForKey:callId] && [calleeDevId isEqualToString:weakself.modal.curDevId]) {
            [weakself _stopAlertTimer:callId];
            if([weakself isBusy])
            {
                [weakself sendAnswerMsg:from callId:callId result:kBusyResult devId:callerDevId];
                return;
            }
            ECCall* call = [weakself.modal.recvCalls objectForKey:callId];
            if(call) {
                if([isValid boolValue])
                {
                    weakself.modal.currentCall = call;
                    [weakself.modal.recvCalls removeAllObjects];
                    [weakself _stopAllAlertTimer];
                    weakself.modal.state = EaseCallState_Alerting;
                }
                [weakself.modal.recvCalls removeObjectForKey:callId];
            }
            
        }
    };
    void (^parseConfirmCalleeMsgExt)(NSDictionary*) = ^void (NSDictionary* ext) {
        //[[EMClient sharedClient] log:[NSString stringWithFormat:@"parseConfirmCalleeMsgExt currentCallId:%@,state:%ld",weakself.modal.currentCall.callId,weakself.modal.state]];
        if (weakself.modal.state == EaseCallState_Alerting && [weakself.modal.currentCall.callId isEqualToString:callId]) {
            [weakself _stopConfirmTimer:callId];
            if([weakself.modal.curDevId isEqualToString:calleeDevId])
            {
                // 仲裁为自己
                if([result isEqualToString:kAcceptResult]) {
                    weakself.modal.state = EaseCallState_Answering;
                    if(weakself.modal.currentCall.callType != EaseCallType1v1Audio)
                        [weakself setupLocalVideo];
                    [weakself fetchToken];
                }
            }else{
                // 已在其他端处理
                [weakself callBackCallEnd:EaseCallEndReasonHandleOnOtherDevice];
                weakself.modal.state = EaseCallState_Idle;
                [weakself stopSound];
            }
        }else{
            if([self.modal.recvCalls objectForKey:callId]) {
                [weakself.modal.recvCalls removeObjectForKey:callId];
                [weakself _stopAlertTimer:callId];
            }
        }
    };
    void (^parseVideoToVoiceMsg)(NSDictionary*) = ^void (NSDictionary* ext){
        if(weakself.modal.currentCall && [weakself.modal.currentCall.callId isEqualToString:callId]) {
            [weakself switchToVoice];
        }
    };
    if([msgType isEqualToString:kMsgTypeValue]) {
        NSString* action = [ext objectForKey:kAction];
        if([action isEqualToString:kInviteAction]) {
            parseInviteMsgExt(ext);
        }
        if([action isEqualToString:kAlertAction]) {
            parseAlertMsgExt(ext);
        }
        if([action isEqualToString:kConfirmRingAction]) {
            parseConfirmRingMsgExt(ext);
        }
        if([action isEqualToString:kCancelCallAction]) {
            parseCancelCallMsgExt(ext);
        }
        if([action isEqualToString:kConfirmCalleeAction]) {
            parseConfirmCalleeMsgExt(ext);
        }
        if([action isEqualToString:kAnswerCallAction]) {
            parseAnswerMsgExt(ext);
        }
        if([action isEqualToString:kVideoToVoice]) {
            parseVideoToVoiceMsg(ext);
        }
    }
}

#pragma mark - Timer Manager
- (void)_startCallTimer:(NSString*)aRemoteUser
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if([weakself.callTimerDic objectForKey:aRemoteUser])
            return;
        NSLog(@"_startCallTimer,user:%@",aRemoteUser);
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:self.config.callTimeOut target:weakself selector:@selector(_timeoutCall:) userInfo:aRemoteUser repeats:NO];
        if(!timer)
            NSLog(@"create callout Timer failed");
        [weakself.callTimerDic setObject:timer forKey:aRemoteUser];
    });
}

- (void)_stopCallTimer:(NSString*)aRemoteUser
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimer* tm = [weakself.callTimerDic objectForKey:aRemoteUser];
        if(tm) {
            NSLog(@"stopCallTimer:%@",aRemoteUser);
            [tm invalidate];
            tm = nil;
            [weakself.callTimerDic removeObjectForKey:aRemoteUser];
        }
    });
}

- (void)_timeoutCall:(NSTimer*)timer
{
    NSString* aRemoteUser = (NSString*)[timer userInfo];
    NSLog(@"_timeoutCall,user:%@",aRemoteUser);
    [self.callTimerDic removeObjectForKey:aRemoteUser];
    [self sendCancelCallMsgToCallee:aRemoteUser callId:self.modal.currentCall.callId];
    if(self.modal.currentCall.callType != EaseCallTypeMulti) {
        [self callBackCallEnd:EaseCallEndReasonRemoteNoResponse];
        self.modal.state = EaseCallState_Idle;
    }else{
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[weakself getMultiVC] removePlaceHolderForMember:aRemoteUser];
        });
    }
}

- (void)_startAlertTimer:(NSString*)callId
{
    NSLog(@"_startAlertTimer,callId:%@",callId);
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimer* tm = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(_timeoutAlert:) userInfo:callId repeats:NO];
        [weakself.alertTimerDic setObject:tm forKey:callId];
    });
}

- (void)_stopAlertTimer:(NSString*)callId
{
    NSLog(@"_stopAlertTimer,callId:%@",callId);
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimer* tm = [weakself.alertTimerDic objectForKey:callId];
        if(tm) {
            [tm invalidate];
            tm = nil;
            [weakself.alertTimerDic removeObjectForKey:callId];
        }
    });
}

- (void)_stopAllAlertTimer
{
    NSLog(@"_stopAllAlertTimer");
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray*tms = [weakself.alertTimerDic allValues];
        for (NSTimer* tm in tms) {
            if(tm) {
                [tm invalidate];
            }
        }
        [weakself.alertTimerDic removeAllObjects];
    });
}

- (void)_timeoutAlert:(NSTimer*)tm
{
    NSString* callId = (NSString*)[tm userInfo];
    NSLog(@"_timeoutAlert,callId:%@",callId);
    [self.alertTimerDic removeObjectForKey:callId];
}

- (void)_startConfirmTimer:(NSString*)callId
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakself.confirmTimer) {
            [weakself.confirmTimer invalidate];
        }
        weakself.confirmTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(_timeoutConfirm:) userInfo:callId repeats:NO];
    });
}

- (void)_stopConfirmTimer:(NSString*)callId
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakself.confirmTimer) {
            [weakself.confirmTimer invalidate];
            weakself.confirmTimer = nil;
        }
    });
    
}

- (void)_timeoutConfirm:(NSTimer*)tm
{
    NSString* callId = (NSString*)[tm userInfo];
    NSLog(@"_timeoutConfirm,callId:%@",callId);
    if(self.modal.currentCall && [self.modal.currentCall.callId isEqualToString:callId]) {
        [self callBackCallEnd:EaseCallEndReasonRemoteNoResponse];
        self.modal.state = EaseCallState_Idle;
    }
}

- (void)_startRingTimer:(NSString*)callId
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakself.ringTimer) {
            [weakself.ringTimer invalidate];
        }
        weakself.ringTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(_timeoutRing:) userInfo:callId repeats:NO];
    });
}

- (void)_stopRingTimer
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakself.ringTimer) {
            [weakself.ringTimer invalidate];
            weakself.ringTimer = nil;
        }
    });
    
}

- (void)_timeoutRing:(NSTimer*)tm
{
    NSString* callId = (NSString*)[tm userInfo];
    NSLog(@"_timeoutConfirm,callId:%@",callId);
    [self stopSound];
    if(self.modal.currentCall && [self.modal.currentCall.callId isEqualToString:callId]) {
        [self callBackCallEnd:EaseCallEndReasonNoResponse];
        self.modal.state = EaseCallState_Idle;
    }
}

#pragma mark - 铃声控制

- (AVAudioPlayer*)audioPlayer
{
    if(!_audioPlayer && _config.ringFileUrl) {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_config.ringFileUrl error:nil];
        _audioPlayer.numberOfLoops = -1;
        [_audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}

// 播放铃声
- (void)playSound
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    AVAudioSession*session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [session setActive:YES error:nil];
    
    [self.audioPlayer play];
}

// 停止播放铃声
- (void)stopSound
{
    if(self.audioPlayer.isPlaying)
        [self.audioPlayer stop];
}

#pragma mark - AgoraRtcEngineKitDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode
{
    NSLog(@"rtcEngine didOccurError:%ld",(long)errorCode);
    if(errorCode == AgoraErrorCodeTokenExpired || errorCode == AgoraErrorCodeInvalidToken) {
        self.modal.state = EaseCallState_Idle;
        [self callBackError:EaseCallErrorTypeRTC code:errorCode description:@"RTC Error"];
    }else{
        if(errorCode != AgoraErrorCodeNoError && errorCode != AgoraErrorCodeLeaveChannelRejected) {
            [self callBackError:EaseCallErrorTypeRTC code:errorCode description:@"RTC Error"];
        }
    }
}

// 远程音频质量数据
- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteAudioStats:(AgoraRtcRemoteAudioStats *)stats
{
    
}

// 加入频道成功
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"join channel success!!! channel:%@,uid:%lu",channel,(unsigned long)uid);
}

// 注册账户成功
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRegisteredLocalUser:(NSString *)userAccount withUid:(NSUInteger)uid
{
    
}

//token即将过期
- (void)rtcEngine:(AgoraRtcEngineKit *)engine tokenPrivilegeWillExpire:(NSString *)token
{
    // token即将过期，需要重新获取
}

// token 已过期
- (void)rtcEngineRequestToken:(AgoraRtcEngineKit * _Nonnull)engine
{
    
}

// 对方退出频道
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason
{
    [[EMClient sharedClient] log:[NSString stringWithFormat:@"didOfflineOfUid uid:%lu,reason:%lu",(unsigned long)uid,reason]];
    {
        if(self.modal.currentCall.callType == EaseCallTypeMulti) {
            [[self getMultiVC] removeRemoteViewForUser:[NSNumber numberWithUnsignedInteger:uid]];
            [self.modal.currentCall.allUserAccounts removeObjectForKey:[NSNumber numberWithUnsignedInteger:uid]];
        }else{
            [self callBackCallEnd:EaseCallEndReasonHangup];
            self.modal.state = EaseCallState_Idle;
        }
    }
}

// 对方加入频道
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    [[EMClient sharedClient] log:[NSString stringWithFormat:@"didJoinedOfUid:%lu",(unsigned long)uid]];
    if(self.modal.currentCall.callType == EaseCallTypeMulti) {
        UIView *view = [UIView new];
        [[self getMultiVC] addRemoteView:view member:[NSNumber numberWithUnsignedInteger:uid] enableVideo:YES];
        NSString*username = [self.modal.currentCall.allUserAccounts objectForKey:[NSNumber numberWithUnsignedInteger:uid]];
        if(username.length > 0) {
            if([self.callTimerDic objectForKey:username])
            {
                [self _stopCallTimer:username];
            }
            [[self getMultiVC] removePlaceHolderForMember:username];
            [[self getMultiVC] setRemoteViewNickname:[self getNicknameByUserName:username] headImage:[self getHeadImageByUserName:username] uId:[NSNumber numberWithUnsignedInteger:uid]];
        }
    }else{
        [self getSingleVC].isConnected = YES;
        [self _stopCallTimer:self.modal.currentCall.remoteUserAccount];
        [self.modal.currentCall.allUserAccounts setObject:self.modal.currentCall.remoteUserAccount forKey:[NSNumber numberWithUnsignedInteger:uid]];
    }
    if([self.delegate respondsToSelector:@selector(remoteUserDidJoinChannel:uid:username:)]){
        NSString* username = [self.modal.currentCall.allUserAccounts objectForKey:[NSNumber numberWithUnsignedInteger:uid]];
        [self.delegate remoteUserDidJoinChannel:self.modal.currentCall.channelName uid:uid username:username];
    }
}

// 对方关闭/打开视频
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    if(self.modal.currentCall.callType == EaseCallTypeMulti) {
        [[self getMultiVC] setRemoteEnableVideo:!muted uId:[NSNumber numberWithUnsignedInteger:uid]];
    }
}

// 对方打开/关闭音频
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    if(self.modal.currentCall.callType == EaseCallTypeMulti) {
        [[self getMultiVC] setRemoteMute:muted uid:[NSNumber numberWithUnsignedInteger:uid]];
    }else{
        [[self getSingleVC] setRemoteMute:muted];
    }
}

// 对方发视频流
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    [self setupRemoteVideoView:uid];
    //[[EMClient sharedClient] log:[NSString stringWithFormat:@"firstRemoteVideoDecodedOfUid:%lu",uid]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteAudioFrameOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"firstRemoteAudioFrameOfUid:%lu",(unsigned long)uid);
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine
     remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteReason)reason elapsed:(NSInteger)elapsed
{
    if(reason == AgoraVideoRemoteReasonRemoteMuted && self.modal.currentCall.callType == EaseCallType1v1Video) {
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself switchToVoice];
        });
    }
}

// 谁在说话的回调
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo *> * _Nonnull)speakers totalVolume:(NSInteger)totalVolume
{
    if(self.agoraKit != engine)
        return;
    if(self.modal.currentCall && self.modal.currentCall.callType == EaseCallTypeMulti) {
        for (AgoraRtcAudioVolumeInfo *speakerInfo in speakers) {
            if(speakerInfo.volume > 5) {
                if(speakerInfo.uid == 0) {
                    [self getMultiVC].localView.isTalking = YES;
                }else{
                    EaseCallStreamView* view = [[self getMultiVC].streamViewsDic objectForKey:[NSNumber numberWithUnsignedInteger:speakerInfo.uid]];
                    if(view) {
                        view.isTalking = YES;
                    }
                }
            }
            
        }
    }
}

#pragma mark - 提供delegate

- (void)callBackCallEnd:(EaseCallEndReason)reason
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakself.delegate && [weakself.delegate respondsToSelector:@selector(callDidEnd:reason:time:type:)]) {
            [weakself.delegate callDidEnd:weakself.modal.currentCall.channelName reason:reason time:weakself.callVC.timeLength type:weakself.modal.currentCall.callType];
        }
    });
}

- (void)callBackError:(EaseCallErrorType)aErrorType code:(NSInteger)aCode description:(NSString*)aDescription
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakself.delegate && [weakself.delegate respondsToSelector:@selector(callDidOccurError:)]) {
            EaseCallError* error = [EaseCallError errorWithType:aErrorType code:aCode description:aDescription];
            [weakself.delegate callDidOccurError:error];
        }
    });
}


#pragma mark - 获取token
- (void)fetchToken {
    if(self.config.enableRTCTokenValidate) {
        if([self.delegate respondsToSelector:@selector(callDidRequestRTCTokenForAppId:channelName:account:uid:)]) {
            self.modal.agoraUid = arc4random();
            [self.delegate callDidRequestRTCTokenForAppId:self.config.agoraAppId channelName:self.modal.currentCall.channelName account:[EMClient sharedClient].currentUsername uid:self.config.agoraUid];
        }else{
            NSLog(@"Warning: You have not implement interface callDidRequestRTCTokenForAppId:channelName:account:!!!!");
        }
    }else{
        [self setRTCToken:nil channelName:self.modal.currentCall.channelName uid:arc4random()];
    }
}

@end


@implementation EaseCallManager (Private)

- (void)hangupAction
{
    NSLog(@"hangupAction,curState:%ld",(long)self.modal.state);
    if(self.modal.state == EaseCallState_Answering) {
        // 正常挂断
        if(self.modal.currentCall.callType == EaseCallTypeMulti)
        {
            if(self.callTimerDic.count > 0) {
                NSArray* tmArray = [self.callTimerDic allValues];
                for(NSTimer * tm in tmArray) {
                    if(tm) {
                        [tm fire];
                    }
                 }
                [self.callTimerDic removeAllObjects];
            }
        }
        
        [self callBackCallEnd:EaseCallEndReasonHangup];
        self.modal.state = EaseCallState_Idle;
    }else{
        if(self.modal.state == EaseCallState_Outgoing) {
            // 取消呼叫
            [self _stopCallTimer:self.modal.currentCall.remoteUserAccount];
            [self sendCancelCallMsgToCallee:self.modal.currentCall.remoteUserAccount callId:self.modal.currentCall.callId];
            [self callBackCallEnd:EaseCallEndReasonCancel];
            self.modal.state = EaseCallState_Idle;
        }else if(self.modal.state == EaseCallState_Alerting){
            // 拒绝
            [self stopSound];
            [self sendAnswerMsg:self.modal.currentCall.remoteUserAccount callId:self.modal.currentCall.callId result:kRefuseresult devId:self.modal.currentCall.remoteCallDevId];
            [self callBackCallEnd:EaseCallEndReasonRefuse];
            self.modal.state = EaseCallState_Idle;
        }
    }
}

-(void) acceptAction
{
    [self stopSound];
    [self sendAnswerMsg:self.modal.currentCall.remoteUserAccount callId:self.modal.currentCall.callId result:kAcceptResult devId:self.modal.currentCall.remoteCallDevId];
}
-(void) switchCameraAction
{
    [self.agoraKit switchCamera];
}

-(void) inviteAction
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(multiCallDidInvitingWithCurVC:excludeUsers:ext:)]){
        NSMutableArray* array = [NSMutableArray array];
        NSArray<NSNumber*>* uids = [[self getMultiVC].streamViewsDic allKeys];
        for (NSNumber* uid in uids) {
            NSString* username = [self.modal.currentCall.allUserAccounts objectForKey:uid];
            if(username.length > 0)
               [array addObject:username];
        }
        NSArray* invitingMems = [self.callTimerDic allKeys];
        [array addObjectsFromArray:invitingMems];
        [self.delegate multiCallDidInvitingWithCurVC:self.callVC excludeUsers:array ext:self.modal.currentCall.ext];
    }
}

-(void) enableVideo:(BOOL)aEnable
{
    [self.agoraKit muteLocalVideoStream:!aEnable];
}
-(void) muteAudio:(BOOL)aMuted
{
    [self.agoraKit muteLocalAudioStream:aMuted];
}
-(void) speakeOut:(BOOL)aEnable
{
    [self.agoraKit setEnableSpeakerphone:aEnable];
}
-(NSString*) getNicknameByUserName:(NSString*)aUserName
{
    if([aUserName length] > 0){
        EaseCallUser*user = [self.config.users objectForKey:aUserName];
        if(user && user.nickName.length > 0) {
            return user.nickName;
        }
    }
    return aUserName;
}
-(NSURL*) getHeadImageByUserName:(NSString *)aUserName
{
    if([aUserName length] > 0){
        EaseCallUser*user = [self.config.users objectForKey:aUserName];
        if(user && user.headImage.absoluteString.length > 0) {
            return user.headImage;
        }
    }
    return self.config.defaultHeadImage;
}

-(NSString*)getUserNameByUid:(NSNumber *)uId
{
    if(self.modal.currentCall && self.modal.currentCall.allUserAccounts.count > 0) {
        NSString* username = [self.modal.currentCall.allUserAccounts objectForKey:uId];
        if(username.length > 0)
            return username;
    }
    return nil;
}

- (void)setupRemoteVideoView:(NSUInteger)uid
{
    AgoraRtcVideoCanvas* canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = uid;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    if(self.modal.currentCall.callType == EaseCallTypeMulti) {
        canvas.view = [[self getMultiVC] getViewByUid:[NSNumber numberWithUnsignedInteger:uid]];
    }else{
        canvas.view = [self getSingleVC].remoteView.displayView;
    }
    [self.agoraKit setupRemoteVideo:canvas];
}

- (void)setupLocalVideo
{
    AgoraCameraCapturerConfiguration* cameraConfig = [[AgoraCameraCapturerConfiguration alloc] init];
    cameraConfig.cameraDirection = AgoraCameraDirectionFront;
    [self.agoraKit setCameraCapturerConfiguration:cameraConfig];
    [self setupVideo];
    AgoraRtcVideoCanvas*canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = 0;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    if(self.modal.currentCall.callType == EaseCallTypeMulti) {
        canvas.view = [self getMultiVC].localView.displayView;
    }else{
        canvas.view = [self getSingleVC].localView.displayView;
    }
    [self.agoraKit setupLocalVideo:canvas];
    [self.agoraKit startPreview];
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
}

- (void)joinChannel
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakself.modal.hasJoinedChannel)
            [weakself.agoraKit leaveChannel:nil];
        [weakself.agoraKit joinChannelByToken:weakself.modal.agoraRTCToken channelId:weakself.modal.currentCall.channelName info:@"" uid:self.modal.agoraUid joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
            [EMClient.sharedClient log:[NSString stringWithFormat:@"joinChannel:%@ success",channel]];
            if([self.delegate respondsToSelector:@selector(callDidJoinChannel:uid:)]) {
                [self.delegate callDidJoinChannel:channel uid:uid];
            }
            weakself.modal.hasJoinedChannel = YES;
            [weakself.modal.currentCall.allUserAccounts setObject:[EMClient sharedClient].currentUsername forKey:[NSNumber numberWithUnsignedInteger:uid]];
            if(self.modal.currentCall.callType == EaseCallTypeMulti) {
                [self enableVideo:NO];
            }
        }];
        
        [weakself speakeOut:YES];
    });
}

-(void) switchToVoice
{
    if(self.modal.currentCall && self.modal.currentCall.callType == EaseCallType1v1Video) {
        self.bNeedSwitchToVoice = YES;
        self.modal.currentCall.callType = EaseCallType1v1Audio;
        [[self getSingleVC] updateToVoice];
        [self.agoraKit stopPreview];
        [self.agoraKit disableVideo];
        [self.agoraKit muteLocalVideoStream:YES];
        
    }
    if(self.modal.currentCall.isCaller || self.modal.state == EaseCallState_Answering) {
        [self.agoraKit stopPreview];
        [self.agoraKit disableVideo];
        [self.agoraKit muteLocalVideoStream:YES];
    }
}

- (void)sendVideoToVoiceMsg
{
    [self sendVideoToVoiceMsg:self.modal.currentCall.remoteUserAccount callId:self.modal.currentCall.callId];
}

@end
