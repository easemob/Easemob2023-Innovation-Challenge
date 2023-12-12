//
//  EaseCallConfig.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/12/9.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 用户的昵称、头像信息
 */
@interface EaseCallUser : NSObject
/*
 * nickName    用户昵称
 */
@property (nonatomic,strong)  NSString* _Nullable  nickName;
/*
 * nickName    用户头像
 */
@property (nonatomic,strong)  NSURL* _Nullable  headImage;
+(instancetype)userWithNickName:(NSString*)aNickName image:(NSURL*)aUrl;
@end

// 增加铃声、标题文本、环信ID与昵称的映射
@interface EaseCallConfig : NSObject
/*
 * nickName    用户头像
 */
@property (nonatomic,strong)  NSURL*  defaultHeadImage;
/*
 * callTimeOut    呼叫超时时间
 */
@property (nonatomic) UInt32 callTimeOut;
/*
 * users    用户信息字典,key为环信ID，value为EaseCallUser
 */
@property (nonatomic,strong) NSMutableDictionary<NSString*,EaseCallUser*>* users;
/*
 * ringFileUrl    振铃文件
 */
@property (nonatomic,strong) NSURL* ringFileUrl;
/*
 * agoraAppId    声网appId
 */
@property (nonatomic,strong) NSString* agoraAppId;
/*
 * enableRTCTokenValidate 是否开启声网token验证，默认不开启，开启后必须实现callDidRequestRTCTokenForAppId回调，并在收到回调后调用setRTCToken才能进行通话
 */
@property (nonatomic) BOOL enableRTCTokenValidate;
/*
 * encoderConfiguration    声网RTC Video配置
 */
@property (nonatomic,strong) AgoraVideoEncoderConfiguration *encoderConfiguration;
@property (nonatomic) NSUInteger agoraUid;

- (void)setUser:(NSString*)aUser info:(EaseCallUser*)aInfo;
@end

NS_ASSUME_NONNULL_END
