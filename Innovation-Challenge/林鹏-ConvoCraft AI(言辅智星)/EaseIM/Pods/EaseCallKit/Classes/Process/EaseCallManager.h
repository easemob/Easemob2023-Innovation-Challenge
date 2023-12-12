//
//  EaseCallManager.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/18.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseCallConfig.h"
#import "EaseCallDefine.h"
#import "EaseCallError.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

@protocol EaseCallDelegate <NSObject>
/**
 * 通话结束时触发该回调
 * @param aChannelName         通话的通道名称，用于在声网水晶球查询通话质量
 * @param aReason                    通话结束原因
 * @param aTm                             通话时长
 * @param aType    通话类型，EaseCallTypeAudio为语音通话，EaseCallTypeVideo为视频通话，EaseCallTypeMulti为多人通话
 */
- (void)callDidEnd:(NSString*_Nonnull)aChannelName reason:(EaseCallEndReason)aReason time:(int)aTm type:(EaseCallType)aType;
/**
 * 多人通话中，点击邀请按钮触发该回调
 * @param vc                          当前通话页面的视图控制器
 * @param users                    当前会议中已存在的成员及已邀请的成员
 * @param aExt                      邀请中的扩展信息
 */
- (void)multiCallDidInvitingWithCurVC:(UIViewController*_Nonnull)vc excludeUsers:(NSArray<NSString*> *_Nullable)users ext:(NSDictionary*_Nullable)aExt;
/**
 * 被叫开始振铃时，触发该回调
 * @param aType         通话类型
 * @param user            主叫的环信Id
 * @param aExt            邀请中的扩展信息
 */
- (void)callDidReceive:(EaseCallType)aType inviter:(NSString*_Nonnull)user ext:(NSDictionary*_Nullable)aExt;
/**
 * 通话过程发生异常时，触发该回调
 * @param aError         错误信息
 */
- (void)callDidOccurError:(EaseCallError*_Nonnull)aError;
/**
 * 加入音视频通话频道前触发该回调，用户需要在触发该回调后，主动从AppServer获取声网token，然后调用setRTCToken:channelName:方法将token设置进来
 * @param aAppId 声网通话使用的appId
 * @param aChannelName 呼叫使用的频道名称
 * @param aUserAccount 用户使用的环信账户
 */
- (void)callDidRequestRTCTokenForAppId:(NSString*_Nonnull)aAppId channelName:(NSString*_Nonnull)aChannelName account:(NSString*_Nonnull)aUserAccount uid:(NSInteger)aAgoraUid;
/**
 * 通话中对方加入会议时触发该回调
 */
-(void)remoteUserDidJoinChannel:( NSString*_Nonnull)aChannelName uid:(NSInteger)aUid username:(NSString*_Nullable)aUserName;

/**
 * 通话中自己加入会议成功时触发该回调
 */
- (void)callDidJoinChannel:(NSString*_Nonnull)aChannelName uid:(NSUInteger)aUid;
@end

@interface EaseCallManager : NSObject
+(instancetype _Nonnull ) alloc __attribute__((unavailable("call sharedManager instead")));
+(instancetype _Nonnull ) new __attribute__((unavailable("call sharedManager instead")));
-(instancetype _Nonnull ) copy __attribute__((unavailable("call sharedManager instead")));
-(instancetype _Nonnull ) mutableCopy __attribute__((unavailable("call sharedManager instead")));
+ (instancetype _Nonnull )sharedManager;
/**
 * EaseCall模块初始化
 * @param aConfig         EaseCall的配置，包括用户昵称、头像、呼叫超时时间等
 * @param aDelegate    回调监听
 */
- (void)initWithConfig:(EaseCallConfig*_Nullable)aConfig delegate:(id<EaseCallDelegate>_Nullable)aDelegate;
/**
 * 邀请成员进行单人通话
 * @param uId         被邀请人的环信ID
 * @param aType    通话类型，EaseCallTypeAudio为语音通话，EaseCallTypeVideo为视频通话
 * @param aExt      扩展信息
 * @param aCompletionBlock 完成回调
 */
- (void)startSingleCallWithUId:(NSString*_Nonnull)uId type:(EaseCallType)aType ext:(NSDictionary* _Nullable)aExt completion:(void (^_Nullable)(NSString* _Nullable callId,EaseCallError* _Nullable aError))aCompletionBlock;
/**
 * 邀请成员进行多人会议
 * @param aUsers         被邀请人的环信ID数组
 * @param aExt              扩展信息，可添加如群组ID等信息
 * @param aCompletionBlock 完成回调
 */

- (void)startInviteUsers:(NSArray<NSString*>*_Nonnull)aUsers ext:(NSDictionary*_Nullable)aExt  completion:(void (^_Nullable)(NSString*_Nullable callId,EaseCallError*_Nullable aError))aCompletionBlock;

/**
 * 获取EaseCallKit的配置
 * @return  EaseCallKit的配置
 */
- (EaseCallConfig*_Nonnull)getEaseCallConfig;
/**
 * 设置声网频道及token
 * @param aToken         声网token
 * @param aChannelName              token对应的频道名称
 * @param aUid 声网账户
 */
- (void)setRTCToken:(NSString*_Nullable)aToken channelName:(NSString*_Nonnull)aChannelName uid:(NSUInteger)aUid;
/**
 * 设置用户环信ID与声网账户的映射表
 * @param aUsers         用户环信ID与声网账户的映射表
 * @param aChannel              对应的频道名称
 */
- (void)setUsers:(NSDictionary<NSNumber*,NSString*>*_Nonnull)aUsers channelName:(NSString*_Nonnull)aChannel;
@end
