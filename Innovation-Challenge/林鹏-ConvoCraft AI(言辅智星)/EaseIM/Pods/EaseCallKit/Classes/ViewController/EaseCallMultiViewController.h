//
//  EaseCallMultiViewController.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallBaseViewController.h"
#import "EaseCallStreamView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseCallMultiViewController : EaseCallBaseViewController
- (void)addRemoteView:(UIView*)remoteView member:(NSNumber*)uId enableVideo:(BOOL)aEnableVideo;
- (void)removeRemoteViewForUser:(NSNumber*)uId;
- (void)setRemoteMute:(BOOL)aMuted uid:(NSNumber*)uId;
- (void)setRemoteEnableVideo:(BOOL)aEnabled uId:(NSNumber*)uId;
- (void)setLocalVideoView:(UIView*)localView enableVideo:(BOOL)aEnableVideo;
- (void)setRemoteViewNickname:(NSString*)aNickname headImage:(NSURL*)url uId:(NSNumber*)aUid;
- (UIView*) getViewByUid:(NSNumber*)uId;
- (void)setPlaceHolderUrl:(NSURL*)url member:(NSString*)uId;
- (void)removePlaceHolderForMember:(NSString*)uId;
@property (nonatomic,strong) UILabel* remoteNameLable;
@property (nonatomic,strong) NSString* inviterId;
@property (nonatomic,strong) UIImageView* remoteHeadView;
@property (nonatomic) EaseCallStreamView* localView;
@property (nonatomic) NSMutableDictionary* streamViewsDic;
@end

NS_ASSUME_NONNULL_END
