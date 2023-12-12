//
//  EaseCallManager+Private.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/12/3.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallManager.h"

@interface EaseCallManager (Private)
-(void) switchCameraAction;
-(void) hangupAction;
-(void) acceptAction;
-(void) inviteAction;
-(void) enableVideo:(BOOL)aEnable;
-(void) muteAudio:(BOOL)aMuted;
-(void) speakeOut:(BOOL)aEnable;
-(NSString*) getNicknameByUserName:(NSString*)aUserName;
-(NSURL*) getHeadImageByUserName:(NSString*)aUserName;
-(NSString*) getUserNameByUid:(NSNumber*)uId;
- (void)setupLocalVideo;
- (void)setupRemoteVideoView:(NSUInteger)uid;
- (void)joinChannel;
-(void) switchToVoice;
- (void)sendVideoToVoiceMsg;
@end /* EaseCallManager_Private_h */
