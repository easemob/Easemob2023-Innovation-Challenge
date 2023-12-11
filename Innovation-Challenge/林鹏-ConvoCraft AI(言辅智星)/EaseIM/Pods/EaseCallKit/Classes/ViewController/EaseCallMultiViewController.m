//
//  EaseCallMultiViewController.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallMultiViewController.h"
#import "EaseCallStreamView.h"
#import "EaseCallManager+Private.h"
#import "EaseCallPlaceholderView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "UIImage+Ext.h"
#import "EaseCallLocalizable.h"

@interface EaseCallMultiViewController ()<EaseCallStreamViewDelegate>
@property (nonatomic) UIButton* inviteButton;
@property (nonatomic) UILabel* statusLable;
@property (nonatomic) BOOL isJoined;
@property (nonatomic) EaseCallStreamView* bigView;
@property (nonatomic) NSMutableDictionary* placeHolderViewsDic;
@property (atomic) BOOL isNeedLayout;
@end

@implementation EaseCallMultiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubViews];
    [self updateViewPos];
}

- (void)setupSubViews
{
    self.bigView = nil;
    self.isNeedLayout = NO;
    self.contentView.backgroundColor = [UIColor grayColor];
    [self.timeLabel setHidden:YES];
    self.inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.inviteButton setImage:[UIImage imageNamedFromBundle:@"invite"] forState:UIControlStateNormal];
    [self.inviteButton addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.inviteButton];
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.height.equalTo(@50);
    }];
    [self.contentView bringSubviewToFront:self.inviteButton];
    [self.inviteButton setHidden:YES];
    [self setLocalVideoView:[UIView new] enableVideo:NO];
    {
        if([self.inviterId length] > 0) {
            NSURL* remoteUrl = [[EaseCallManager sharedManager] getHeadImageByUserName:self.inviterId];
            self.remoteHeadView = [[UIImageView alloc] init];
            [self.contentView addSubview:self.remoteHeadView];
            [self.remoteHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@80);
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(@100);
            }];
            [self.remoteHeadView sd_setImageWithURL:remoteUrl];
            self.remoteNameLable = [[UILabel alloc] init];
            self.remoteNameLable.backgroundColor = [UIColor clearColor];
            //self.remoteNameLable.font = [UIFont systemFontOfSize:19];
            self.remoteNameLable.textColor = [UIColor whiteColor];
            self.remoteNameLable.textAlignment = NSTextAlignmentRight;
            self.remoteNameLable.font = [UIFont systemFontOfSize:24];
            self.remoteNameLable.text = [[EaseCallManager sharedManager] getNicknameByUserName:self.inviterId];
            [self.timeLabel setHidden:YES];
            [self.contentView addSubview:self.remoteNameLable];
            [self.remoteNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.remoteHeadView.mas_bottom).offset(20);
                make.centerX.equalTo(self.contentView);
            }];
            self.statusLable = [[UILabel alloc] init];
            self.statusLable.backgroundColor = [UIColor clearColor];
            self.statusLable.font = [UIFont systemFontOfSize:15];
            self.statusLable.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            self.statusLable.textAlignment = NSTextAlignmentRight;
            self.statusLable.text = EaseCallLocalizableString(@"receiveCallInviteprompt",nil);
            self.answerButton.hidden = NO;
            self.acceptLabel.hidden = NO;
            [self.contentView addSubview:self.statusLable];
            [self.statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.remoteNameLable.mas_bottom).offset(20);
                make.centerX.equalTo(self.contentView);
            }];
        }else{
            self.answerButton.hidden = YES;
            self.acceptLabel.hidden = YES;
            [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.width.height.equalTo(@60);
                make.bottom.equalTo(self.contentView).with.offset(-40);
            }];
            self.isJoined = YES;
            self.localView.hidden = NO;
            [self enableVideoAction];
            self.inviteButton.hidden = NO;
        }
    }
//    for(int i = 0;i<5;i++) {
//        [self addRemoteView:[UIView new] member:[NSNumber numberWithInt:i] enableVideo:NO];
//    }
    [self updateViewPos];
}

- (NSMutableDictionary*)streamViewsDic
{
    if(!_streamViewsDic) {
        _streamViewsDic = [NSMutableDictionary dictionary];
    }
    return _streamViewsDic;
}

- (NSMutableDictionary*)placeHolderViewsDic
{
    if(!_placeHolderViewsDic) {
        _placeHolderViewsDic = [NSMutableDictionary dictionary];
    }
    return _placeHolderViewsDic;
}

- (void)addRemoteView:(UIView*)remoteView member:(NSNumber*)uId enableVideo:(BOOL)aEnableVideo
{
    if([self.streamViewsDic objectForKey:uId])
        return;
    EaseCallStreamView* view = [[EaseCallStreamView alloc] init];
    view.displayView = remoteView;
    view.enableVideo = aEnableVideo;
    view.delegate = self;
    [view addSubview:remoteView];
    [self.contentView addSubview:view];
    [remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
    }];
    [view sendSubviewToBack:remoteView];
    [self.contentView sendSubviewToBack:view];
    [self.streamViewsDic setObject:view forKey:uId];
    [self startTimer];
    [self updateViewPos];
}

- (void)setRemoteViewNickname:(NSString*)aNickname headImage:(NSURL*)url uId:(NSNumber*)aUid
{
    EaseCallStreamView* view = [self.streamViewsDic objectForKey:aUid];
    if(view) {
        view.nameLabel.text = aNickname;
        [view.bgView sd_setImageWithURL:url];
    }
}

- (void)removeRemoteViewForUser:(NSNumber*)uId
{
    EaseCallStreamView* view = [self.streamViewsDic objectForKey:uId];
    if(view) {
        [view removeFromSuperview];
        [self.streamViewsDic removeObjectForKey:uId];
    }
    [self updateViewPos];
}
- (void)setRemoteMute:(BOOL)aMuted uid:(NSNumber*)uId
{
    EaseCallStreamView* view = [self.streamViewsDic objectForKey:uId];
    if(view) {
        view.enableVoice = !aMuted;
    }
}
- (void)setRemoteEnableVideo:(BOOL)aEnabled uId:(NSNumber*)uId
{
    EaseCallStreamView* view = [self.streamViewsDic objectForKey:uId];
    if(view) {
        view.enableVideo = aEnabled;
    }
    if(view == self.bigView && !aEnabled)
        self.bigView = nil;
    [self updateViewPos];
}

- (void)setLocalVideoView:(UIView*)aDisplayView  enableVideo:(BOOL)aEnableVideo
{
    self.localView = [[EaseCallStreamView alloc] init];
    self.localView.displayView = aDisplayView;
    self.localView.enableVideo = aEnableVideo;
    self.localView.delegate = self;
    [self.localView addSubview:aDisplayView];
    [aDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.localView);
    }];
    [self.localView sendSubviewToBack:aDisplayView];
    [self.contentView addSubview:self.localView];
    [self showNicknameAndAvartarForUsername:[EMClient sharedClient].currentUsername view:self.localView];
    [self.contentView sendSubviewToBack:self.localView];
    [self updateViewPos];
    self.answerButton.hidden = YES;
    self.acceptLabel.hidden = YES;
    
    [self.enableCameraButton setEnabled:YES];
    self.enableCameraButton.selected = YES;
    [self.switchCameraButton setEnabled:YES];
    [self.microphoneButton setEnabled:YES];
    if([self.inviterId length] > 0) {
        [self.remoteNameLable removeFromSuperview];
        [self.statusLable removeFromSuperview];
        [self.remoteHeadView removeFromSuperview];
    }
    self.localView.hidden = YES;
    [[EaseCallManager sharedManager] enableVideo:aEnableVideo];
}

- (UIView*) getViewByUid:(NSNumber*)uId
{
    EaseCallStreamView*view =  [self.streamViewsDic objectForKey:uId];
    if(view)
        return view.displayView;
    UIView *displayview = [UIView new];
    [self addRemoteView:displayview member:uId enableVideo:YES];
    return displayview;
}

- (void)_refreshViewPos
{
    unsigned long count = self.streamViewsDic.count + self.placeHolderViewsDic.count;
    if(self.localView.displayView)
        count++;
    int index = 0;
    int top = 40;
    int left = 0;
    int right = 0;
    int colSize = 1;
    int colomns = count>6?3:2;
    int bottom = 200;
    int cellwidth = (self.contentView.frame.size.width - left - right - (colomns - 1)*colSize)/colomns ;
    int cellHeight = (self.contentView.frame.size.height - top - bottom)/(count > 6?5:3);
    if(count < 5)
        cellHeight = cellwidth;
    //int cellwidth = (self.contentView.frame.size.width - left - right - (colomns - 1)*colSize)/colomns ;
    //int cellHeight = MIN(cellHeightH, cellWidthV);
    //int cellwidth = cellHeight
    if(self.isJoined) {
        
        self.microphoneButton.hidden = NO;
        self.microphoneLabel.hidden = NO;
        self.enableCameraButton.hidden = NO;
        self.enableCameraLabel.hidden = NO;
        self.speakerButton.hidden = NO;
        self.speakerLabel.hidden = NO;
        self.switchCameraButton.hidden = NO;
        self.switchCameraLabel.hidden = NO;
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.inviteButton);
            make.width.equalTo(@100);
        }];
        if(self.bigView) {
            [self.bigView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(top);
                make.width.equalTo(@(self.contentView.bounds.size.width));
                make.height.equalTo(@(self.contentView.bounds.size.height-top-bottom));
            }];
            if(self.bigView != self.localView) {
                [self.contentView sendSubviewToBack:self.localView];
            }
            NSArray* views = [self.streamViewsDic allValues];
            for(EaseCallStreamView* view in views) {
                if(self.bigView != view) {
                    [self.contentView sendSubviewToBack:view];
                }
            }
        }else{
            [self.localView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(left + index%colomns * (cellwidth + colSize));
                make.top.equalTo(self.contentView).offset(top + index/colomns * (cellHeight + colSize));
                make.width.equalTo(@(cellwidth));
                make.height.equalTo(@(cellHeight));
            }];
            index++;
            NSArray* views = [self.streamViewsDic allValues];
            for(EaseCallStreamView* view in views) {
                [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).offset(left + index%colomns * (cellwidth + colSize));
                    make.top.equalTo(self.contentView).offset(top + index/colomns * (cellHeight + colSize));
                    make.width.equalTo(@(cellwidth));
                    make.height.equalTo(@(cellHeight));
                }];
                index++;
            }
            NSArray* placeViews = [self.placeHolderViewsDic allValues];
            for(EaseCallStreamView* view in placeViews) {
                [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).offset(left + index%colomns * (cellwidth + colSize));
                    make.top.equalTo(self.contentView).offset(top + index/colomns * (cellHeight + colSize));
                    make.width.equalTo(@(cellwidth));
                    make.height.equalTo(@(cellHeight));
                }];
                index++;
            }
        }
        
    }else{
        self.microphoneButton.hidden = YES;
        self.microphoneLabel.hidden = YES;
        self.enableCameraButton.hidden = YES;
        self.enableCameraLabel.hidden = YES;
        self.speakerButton.hidden = YES;
        self.speakerLabel.hidden = YES;
        self.switchCameraButton.hidden = YES;
        self.switchCameraLabel.hidden = YES;
    }
}

- (void)updateViewPos
{
    self.isNeedLayout = YES;
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 200 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        if(weakself.isNeedLayout) {
            weakself.isNeedLayout = NO;
            [weakself _refreshViewPos];
        }
    });
}

- (void)inviteAction
{
    [[EaseCallManager sharedManager] inviteAction];
}

- (void)answerAction
{
    [super answerAction];
    self.answerButton.hidden = YES;
    self.acceptLabel.hidden = YES;
    self.statusLable.hidden = YES;
    self.remoteNameLable.hidden = YES;
    self.remoteHeadView.hidden = YES;
    [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@60);
        make.bottom.equalTo(self.contentView).with.offset(-40);
    }];
    self.isJoined = YES;
    self.localView.hidden = NO;
    self.inviteButton.hidden = NO;
    [self enableVideoAction];
}

- (void)hangupAction
{
    [super hangupAction];
}

- (void)muteAction
{
    [super muteAction];
    self.localView.enableVoice = !self.microphoneButton.isSelected;
}

- (void)enableVideoAction
{
    [super enableVideoAction];
    self.localView.enableVideo = self.enableCameraButton.isSelected;
    if(self.localView == self.bigView && !self.localView.enableVideo) {
        self.bigView = nil;
        [self updateViewPos];
    }
}

- (void)setPlaceHolderUrl:(NSURL*)url member:(NSString*)uId
{
    EaseCallPlaceholderView* view = [self.placeHolderViewsDic objectForKey:uId];
    if(view)
        return;
    EaseCallPlaceholderView* placeHolderView = [[EaseCallPlaceholderView alloc] init];
    [self.contentView addSubview:placeHolderView];
    [placeHolderView.nameLabel setText:[[EaseCallManager sharedManager] getNicknameByUserName:uId]];
//    NSData* data = [NSData dataWithContentsOfURL:url ];
//    [placeHolderView.placeHolder setImage:[UIImage imageWithData:data]];
    [placeHolderView.placeHolder sd_setImageWithURL:url];
    [self.placeHolderViewsDic setObject:placeHolderView forKey:uId];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateViewPos];
    });
    
}

- (void)removePlaceHolderForMember:(NSString*)aUserName
{
    EaseCallPlaceholderView* view = [self.placeHolderViewsDic objectForKey:aUserName];
    if(view)
    {
        [view removeFromSuperview];
        [self.placeHolderViewsDic removeObjectForKey:aUserName];
        [self updateViewPos];
    }
}

- (void)streamViewDidTap:(EaseCallStreamView *)aVideoView
{
    if(aVideoView == self.floatingView) {
        self.isMini = NO;
        [self.floatingView removeFromSuperview];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIViewController *rootViewController = window.rootViewController;
        self.modalPresentationStyle = 0;
        [rootViewController presentViewController:self animated:YES completion:nil];
        return;
    }
    if(aVideoView == self.bigView) {
        self.bigView = nil;
        [self updateViewPos];
    }else{
        if(aVideoView.enableVideo)
        {
            self.bigView = aVideoView;
            [self updateViewPos];
        }
    }
}

- (void)miniAction
{
    self.isMini = YES;
    [super miniAction];
    self.floatingView.enableVideo = NO;
    self.floatingView.delegate = self;
    if(self.isJoined) {
        self.floatingView.nameLabel.text = EaseCallLocalizableString(@"Call in progress",nil);
    }else{
        self.floatingView.nameLabel.text = EaseCallLocalizableString(@"waitforanswer",nil);
    }
}

- (void)showNicknameAndAvartarForUsername:(NSString*)aUserName view:(UIView*)aView
{
    if([aView isKindOfClass:[EaseCallStreamView class]]) {
        EaseCallStreamView* streamView = (EaseCallStreamView*)aView;
        if(streamView && aUserName.length > 0) {
            streamView.nameLabel.text = [[EaseCallManager sharedManager] getNicknameByUserName:aUserName];
            NSURL* url = [[EaseCallManager sharedManager] getHeadImageByUserName:aUserName];
            NSURL* curUrl = [streamView.bgView sd_imageURL];
            if(!curUrl || (url && ![self isEquivalent:url with:curUrl])) {
                [streamView.bgView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                }];
            }
        }
    }
    if([aView isKindOfClass:[EaseCallPlaceholderView class]]) {
        EaseCallPlaceholderView* placeHolderView = (EaseCallPlaceholderView*)aView;
        if(placeHolderView && aUserName.length > 0) {
            placeHolderView.nameLabel.text = [[EaseCallManager sharedManager] getNicknameByUserName:aUserName];
            NSURL* url = [[EaseCallManager sharedManager] getHeadImageByUserName:aUserName];
            if(url) {
                [placeHolderView.placeHolder sd_setImageWithURL:url completed:nil];
            }
        }
    }
    
}

- (void)usersInfoUpdated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super usersInfoUpdated];
        [self showNicknameAndAvartarForUsername:[EMClient sharedClient].currentUsername view:self.localView];
        for(NSNumber* uid in self.streamViewsDic) {
            NSString * username = [[EaseCallManager sharedManager] getUserNameByUid:uid];
            if(username.length > 0) {
                EaseCallStreamView* view = [self.streamViewsDic objectForKey:uid];
                [self showNicknameAndAvartarForUsername:username view:view];
            }
        }
        for(NSString* username in self.placeHolderViewsDic) {
            EaseCallPlaceholderView* view = [self.placeHolderViewsDic objectForKey:username];
            [self showNicknameAndAvartarForUsername:username view:view];
        }
    });
    
}

- (BOOL)isEquivalent:(NSURL *)aURL1 with:(NSURL *)aURL2 {

    if ([aURL1 isEqual:aURL2]) return YES;
    if ([[aURL1 scheme] caseInsensitiveCompare:[aURL2 scheme]] != NSOrderedSame) return NO;
    if ([[aURL1 host] caseInsensitiveCompare:[aURL2 host]] != NSOrderedSame) return NO;

    // NSURL path is smart about trimming trailing slashes
    // note case-sensitivty here
    if ([[aURL1 path] compare:[aURL2 path]] != NSOrderedSame) return NO;

    // at this point, we've established that the urls are equivalent according to the rfc
    // insofar as scheme, host, and paths match

    // according to rfc2616, port's can weakly match if one is missing and the
    // other is default for the scheme, but for now, let's insist on an explicit match
    if ([aURL1 port] || [aURL2 port]) {
        if (![[aURL1 port] isEqual:[aURL2 port]]) return NO;
        if (![[aURL1 query] isEqual:[aURL2 query]]) return NO;
    }

    // for things like user/pw, fragment, etc., seems sensible to be
    // permissive about these.
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
