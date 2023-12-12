//
//  EaseCallSingleViewController.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallSingleViewController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Ext.h"
#import "EaseCallLocalizable.h"

@interface EaseCallSingleViewController ()<EaseCallStreamViewDelegate>
@property (nonatomic) NSString* remoteUid;
@property (nonatomic) UILabel* statusLable;
@property (nonatomic) EaseCallType type;
@property (nonatomic) UIView* viewRoundHead;
@property (nonatomic) UILabel * tipLabel;
@property (nonatomic,strong) UILabel* remoteNameLable;
@property (nonatomic,strong) UIImageView* remoteHeadView;
@end

@implementation EaseCallSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isConnected = NO;
    self.isMini = NO;
    if(self.type == EaseCallType1v1Video) {
        self.localView = [[EaseCallStreamView alloc] init];
        [self setLocalDisplayView:[UIView new] enableVideo:YES];
        self.remoteView = [[EaseCallStreamView alloc] init];
        [self setRemoteDisplayView:[UIView new] enableVideo:YES];
    }
    self.contentView.backgroundColor = [UIColor grayColor];
    NSURL* remoteUrl = [[EaseCallManager sharedManager] getHeadImageByUserName:self.remoteUid];
    self.remoteHeadView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.remoteHeadView];
    [self.remoteHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(@100);
    }];
    [self.remoteHeadView sd_setImageWithURL:remoteUrl];
    [self drawViewRoundHead];
    self.remoteNameLable = [[UILabel alloc] init];
    self.remoteNameLable.backgroundColor = [UIColor clearColor];
    self.remoteNameLable.font = [UIFont systemFontOfSize:24];
    self.remoteNameLable.textColor = [UIColor whiteColor];
    self.remoteNameLable.textAlignment = NSTextAlignmentRight;
    self.remoteNameLable.text = [[EaseCallManager sharedManager] getNicknameByUserName:self.remoteUid];
    [self.contentView addSubview:self.remoteNameLable];
    [self.remoteNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewRoundHead.mas_bottom).offset(40);
        make.centerX.equalTo(self.contentView);
    }];
    self.statusLable = [[UILabel alloc] init];
    self.statusLable.backgroundColor = [UIColor clearColor];
    self.statusLable.font = [UIFont systemFontOfSize:15];
    self.statusLable.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.statusLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.statusLable];
    [self.statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remoteNameLable.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.switchToVoiceLable = [[UILabel alloc] init];
    self.switchToVoiceLable.backgroundColor = [UIColor clearColor];
    self.switchToVoiceLable.font = [UIFont systemFontOfSize:11];
    self.switchToVoiceLable.textColor = [UIColor whiteColor];
    self.switchToVoiceLable.textAlignment = NSTextAlignmentCenter;
    self.switchToVoiceLable.text = EaseCallLocalizableString(@"switchvoice",nil);
    [self.contentView addSubview:self.switchToVoiceLable];
    if(self.isCaller) {
        [self.switchToVoiceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.hangupButton.mas_top).with.offset(-5);
            make.centerX.equalTo(self.hangupButton);
        }];
    }else{
        [self.switchToVoiceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.answerButton.mas_top).with.offset(-5);
            make.centerX.equalTo(self.answerButton);
        }];
    }


    self.switchToVoice = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.switchToVoice setTintColor:[UIColor whiteColor]];
    [self.switchToVoice setImage:[UIImage imageNamedFromBundle:@"Audio-mute"] forState:UIControlStateNormal];
    [self.switchToVoice addTarget:self action:@selector(switchToVoiceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.switchToVoice];
    [self.switchToVoice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.centerX.equalTo(self.switchToVoiceLable);
        make.bottom.equalTo(self.switchToVoiceLable.mas_top).with.offset(-5);
    }];
    
    if(self.isCaller) {
        self.statusLable.text = EaseCallLocalizableString(@"waitforanswer",nil);
        self.answerButton.hidden = YES;
        self.acceptLabel.hidden = YES;
    }else
    {
        self.statusLable.text = EaseCallLocalizableString(@"receiveCallInviteprompt",nil);
        self.localView.hidden = YES;
        self.remoteView.hidden = YES;
    }
    [self updatePos];
    
}

- (void)drawViewRoundHead
{
    self.viewRoundHead = [[UIView alloc] init];
    self.viewRoundHead.layer.backgroundColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0].CGColor;
    self.viewRoundHead.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02].CGColor;
    self.viewRoundHead.layer.shadowOffset = CGSizeMake(0,0);
    self.viewRoundHead.layer.shadowOpacity = 1;
    self.viewRoundHead.layer.shadowRadius = 15;
    self.viewRoundHead.layer.cornerRadius = 119;
    [self.contentView addSubview:self.viewRoundHead];
    [self.viewRoundHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.remoteHeadView);
            make.width.height.equalTo(@238);
    }];
    
    UIView* view2 = [[UIView alloc] init];
    view2.layer.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0].CGColor;
    view2.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    view2.layer.shadowOffset = CGSizeMake(0,0);
    view2.layer.shadowOpacity = 1;
    view2.layer.shadowRadius = 12;
    view2.layer.cornerRadius = 90;
    [self.viewRoundHead addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.viewRoundHead);
            make.width.height.equalTo(@179);
    }];
    
    UIView* view3 = [[UIView alloc] init];
    view3.layer.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
    view3.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    view3.layer.shadowOffset = CGSizeMake(0,0);
    view3.layer.shadowOpacity = 1;
    view3.layer.shadowRadius = 12;
    view3.layer.cornerRadius = 65;
    [view2 addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.viewRoundHead);
            make.width.height.equalTo(@129);
    }];
    
    [self.contentView sendSubviewToBack:self.viewRoundHead];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 325, 330, 30)];
    _tipLabel.backgroundColor = [UIColor blackColor];
    _tipLabel.layer.cornerRadius = 5;
    _tipLabel.layer.masksToBounds = YES;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.alpha = 0.0;
    [self.contentView addSubview:_tipLabel];
}

- (void)switchToVoiceAction
{
    [[EaseCallManager sharedManager] switchToVoice];
    if(!_isConnected && !_isCaller) {
        [self answerAction];
    }else
        [[EaseCallManager sharedManager] sendVideoToVoiceMsg];
}

- (void)updateToVoice
{
    if(self.type == EaseCallType1v1Audio)
        return;
    if(self.isMini) {
        self.floatingView.enableVideo = NO;
    }
    self.type = EaseCallType1v1Audio;
    [self updatePos];
}

- (nonnull instancetype)initWithisCaller:(BOOL)aIsCaller type:(EaseCallType)aType remoteName:(NSString*)aRemoteName {
    self = [super init];
    if(self) {
        self.isCaller = aIsCaller;
        self.remoteUid = aRemoteName;
        self.type = aType;
    }
    return  self;
}

- (void)updatePos
{
    if(self.type == EaseCallType1v1Audio) {
        // 音频
        [self.remoteHeadView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@80);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(@230);
        }];
        self.switchToVoice.hidden = YES;
        self.switchToVoiceLable.hidden = YES;
        self.enableCameraButton.hidden = YES;
        self.enableCameraLabel.hidden = YES;
        self.switchCameraButton.hidden = YES;
        self.switchCameraLabel.hidden = YES;
        self.localView.hidden = YES;
        self.remoteView.hidden = YES;
        self.remoteNameLable.hidden = NO;
        self.viewRoundHead.hidden = NO;
        [self.answerButton setImage:[UIImage imageNamedFromBundle:@"answer"] forState:UIControlStateNormal];
        [self.remoteNameLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewRoundHead.mas_bottom).with.offset(30);
            make.centerX.equalTo(self.contentView);
        }];
        if(_isConnected) {
            // 接通
            self.microphoneButton.hidden = NO;
            self.microphoneLabel.hidden = NO;
            self.speakerButton.hidden = NO;
            self.speakerLabel.hidden = NO;
            self.microphoneButton.enabled = YES;
            self.speakerButton.enabled = YES;
            self.answerButton.hidden = YES;
            self.acceptLabel.hidden = YES;
            self.remoteHeadView.hidden = NO;
            self.statusLable.hidden = YES;
            [self.hangupButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.width.height.equalTo(@60);
                make.bottom.equalTo(self.contentView).with.offset(-40);
            }];
            [self.microphoneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.bottom.equalTo(self.hangupButton);
//                    make.width.height.equalTo(self.hangupButton);
                make.bottom.equalTo(self.contentView).with.offset(-40);
                make.left.equalTo(@40);
            }];
            [self.speakerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.bottom.equalTo(self.hangupButton);
//                    make.width.height.equalTo(self.hangupButton);
                make.bottom.equalTo(self.contentView).with.offset(-40);
                make.right.equalTo(self.contentView).with.offset(-40);
            }];
        }else{
            self.statusLable.hidden = NO;
            // 未接通
            if(_isCaller) {
                // 发起方
                self.microphoneButton.hidden = NO;
                self.microphoneLabel.hidden = NO;
                self.speakerButton.hidden = NO;
                self.speakerLabel.hidden = NO;
                self.microphoneButton.enabled = NO;
                self.speakerButton.enabled = NO;
                self.answerButton.hidden = YES;
                self.acceptLabel.hidden = YES;
                [self.hangupButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.contentView);
                    make.width.height.equalTo(@60);
                    make.bottom.equalTo(self.contentView).with.offset(-40);
                }];
                [self.microphoneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.bottom.equalTo(self.hangupButton);
//                    make.width.height.equalTo(self.hangupButton);
                    make.bottom.equalTo(self.contentView).with.offset(-40);
                    make.left.equalTo(@40);
                }];
                [self.speakerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.bottom.equalTo(self.hangupButton);
//                    make.width.height.equalTo(self.hangupButton);
                    make.bottom.equalTo(self.contentView).with.offset(-40);
                    make.right.equalTo(self.contentView).with.offset(-40);
                }];
                
            }else{
                self.microphoneButton.hidden = YES;
                self.microphoneLabel.hidden = YES;
                self.speakerButton.hidden = YES;
                self.speakerLabel.hidden = YES;
                self.answerButton.hidden = NO;
                self.acceptLabel.hidden = NO;
                [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@40);
                }];
            }
        }
    }else{
        //视频
        self.enableCameraButton.hidden = YES;
        self.enableCameraLabel.hidden = YES;
        self.microphoneButton.hidden = YES;
        self.microphoneLabel.hidden = YES;
        self.speakerButton.hidden = YES;
        self.speakerLabel.hidden = YES;
        self.localView.hidden = NO;
        self.viewRoundHead.hidden = YES;
        [self.remoteHeadView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@80);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(@100);
        }];
        [self.remoteNameLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.remoteHeadView.mas_bottom).offset(40);
        }];
        [self.answerButton setImage:[UIImage imageNamedFromBundle:@"camera_answer"] forState:UIControlStateNormal];
        if(_isConnected) {
            // 接通
            self.remoteView.hidden = NO;
            self.remoteHeadView.hidden = YES;
            self.remoteNameLable.hidden = YES;
            self.switchCameraButton.hidden = NO;
            self.switchCameraLabel.hidden = NO;
            self.answerButton.hidden = YES;
            self.acceptLabel.hidden = YES;
            self.statusLable.hidden = YES;
            self.switchToVoice.hidden = NO;
            self.switchToVoiceLable.hidden = NO;
            [self.hangupButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.width.height.equalTo(@60);
                make.bottom.equalTo(self.contentView).with.offset(-40);
            }];
            [self.switchToVoiceLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@60);
                make.bottom.equalTo(self.hangupLabel.mas_bottom);
            }];
            [self.switchToVoice mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.switchToVoiceLable);
                make.bottom.equalTo(self.switchToVoiceLable.mas_top).with.offset(-5);
                make.width.height.equalTo(@60);
            }];
            [self.switchCameraButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.contentView).with.offset(-40);
                            make.right.equalTo(self.contentView).with.offset(-40);
            }];
        }else{
            // 未接通
            self.remoteView.hidden = YES;
            self.statusLable.hidden = NO;
            if(_isCaller) {
                // 发起方
                self.switchCameraButton.hidden = YES;
                self.switchCameraLabel.hidden = YES;
                self.answerButton.hidden = YES;
                self.acceptLabel.hidden = YES;
                self.switchToVoice.hidden = NO;
                self.switchToVoiceLable.hidden = NO;
                [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.contentView);
                }];
                self.localView.hidden = NO;
            }else{
                // 接听方
                self.localView.hidden = YES;
                self.switchCameraButton.hidden = YES;
                self.switchCameraLabel.hidden = YES;
                self.answerButton.hidden = NO;
                self.acceptLabel.hidden = NO;
                [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@40);
                }];
            }
        }
    }
}

- (void)setRemoteEnableVideo:(BOOL)aEnabled
{
    self.remoteView.enableVideo = aEnabled;
}

- (void)setLocalView:(EaseCallStreamView *)localView
{
    _localView = localView;
    [self.contentView addSubview:_localView];
    [self.contentView sendSubviewToBack:_localView];
    [self.localView.bgView sd_setImageWithURL:[[EaseCallManager sharedManager] getHeadImageByUserName:[EMClient sharedClient].currentUsername]];
    //self.localView.nameLabel.text = [[EaseCallManager sharedManager] getNickNameFromUID:[EMClient sharedClient].currentUsername];
    localView.delegate = self;
    [_localView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.enableCameraButton setEnabled:YES];
    [self.switchCameraButton setEnabled:YES];
    [self.microphoneButton setEnabled:YES];
    if(self.type == EaseCallType1v1Video)
    {
        self.enableCameraButton.selected = YES;
        self.localView.enableVideo = YES;
    }else
    {
        self.localView.enableVideo = NO;
        self.localView.hidden = YES;
    }
}

- (void)setRemoteView:(EaseCallStreamView *)remoteView
{
    _remoteView = remoteView;
    remoteView.delegate = self;
    [self.contentView addSubview:_remoteView];
    [_remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@100);
        make.right.equalTo(self.contentView).with.offset(-40);
        make.top.equalTo(self.contentView).with.offset(70);
    }];
    [self updatePos];
}

- (void)answerAction
{
    [super answerAction];
    self.answerButton.hidden = YES;
    self.acceptLabel.hidden = YES;
    [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
    }];
}

- (void)hangupAction
{
    [super hangupAction];
}

- (void)muteAction
{
    [super muteAction];
    self.localView.enableVoice = self.microphoneButton.isSelected;
}

- (void)miniAction
{
    self.isMini = YES;
    [super miniAction];
    self.floatingView.enableVideo = self.type == EaseCallType1v1Video ? YES : NO;
    self.floatingView.delegate = self;
    if(self.type == EaseCallType1v1Video) {
        self.floatingView.displayView = self.remoteView.displayView;
        [self.floatingView addSubview:self.remoteView.displayView];
        self.floatingView.enableVideo = self.remoteView.enableVideo;
        [self.floatingView.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.floatingView);
        }];
    }
    if(self.isConnected) {
        self.floatingView.nameLabel.text = EaseCallLocalizableString(@"Call in progress",nil);
    }else{
        self.floatingView.nameLabel.text = EaseCallLocalizableString(@"waitforanswer",nil);
        self.floatingView.enableVideo = NO;
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
        if(self.type == EaseCallType1v1Video) {
            [self.floatingView.displayView removeFromSuperview];
                [self setRemoteDisplayView:self.floatingView.displayView enableVideo:YES];
        }
        return;
    }
    if(aVideoView.frame.size.width == 80) {
        [self.contentView sendSubviewToBack:aVideoView];
        EaseCallStreamView *otherView = aVideoView == self.localView?self.remoteView:self.localView;
        [otherView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.height.equalTo(@100);
            make.right.equalTo(self.contentView).with.offset(-40);
            make.top.equalTo(self.contentView).with.offset(70);
        }];
        [aVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
}

- (void)setLocalDisplayView:(UIView*)aDisplayView enableVideo:(BOOL)aEnableVideo
{
    if(self.localView)
    {
        self.localView.displayView = aDisplayView;
        self.localView.delegate = self;
        [self.localView addSubview:aDisplayView];
        self.localView.enableVideo = aEnableVideo;
        [aDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.localView);
        }];
        if(!aEnableVideo) {
            self.enableCameraButton.selected = NO;
        }
    }
}
- (void)setRemoteDisplayView:(UIView*)aDisplayView enableVideo:(BOOL)aEnableVideo
{
    __weak typeof(self) weakself = self;
    void (^setDisplayView)(EaseCallStreamView*) = ^void (EaseCallStreamView*view) {
        if(view)
        {
            view.displayView = aDisplayView;
            view.delegate = self;
            [view addSubview:aDisplayView];
            view.enableVideo = aEnableVideo;
            [view.bgView sd_setImageWithURL:[[EaseCallManager sharedManager] getHeadImageByUserName:weakself.remoteUid]];
            [aDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
        }
    };
    if(self.isMini) {
        setDisplayView(self.floatingView);
        self.floatingView.nameLabel.text = EaseCallLocalizableString(@"Call in progress",nil);
        return;
    }else{
        setDisplayView(self.remoteView);
        if(!aEnableVideo && self.type == EaseCallType1v1Video) {
            [weakself switchToVoiceAction];
        }
        if(self.type == EaseCallType1v1Video && self.isConnected) {
            [weakself streamViewDidTap:self.remoteView];
        }
        [self updatePos];
    }
}

- (void)enableVideoAction
{
    [super enableVideoAction];
    self.localView.enableVideo = self.enableCameraButton.isSelected;
}

- (void)showTip:(BOOL)aEnableVoice
{
    NSString* msg = @"";
    if(aEnableVoice)
        msg = EaseCallLocalizableString(@"remoteUnmute",nil);
    else
        msg = EaseCallLocalizableString(@"remoteMute",nil);
    _tipLabel.alpha = 1.0;
    self.tipLabel.text = msg;
    [UIView animateWithDuration:3 animations:^{
            self.tipLabel.alpha = 0.0;
        }];
}

-(void) setRemoteMute:(BOOL)aMuted
{
    if(self.remoteView) {
        self.remoteView.enableVoice = !aMuted;
    }
}

- (void)setIsConnected:(BOOL)isConnected
{
    _isConnected = isConnected;
    if(isConnected)
    {
        [self startTimer];
        if(self.isMini && self.type == EaseCallType1v1Video) {
            self.floatingView.enableVideo = YES;
            self.floatingView.nameLabel.text = EaseCallLocalizableString(@"Call in progress",nil);
        }
    }
    if(self.type == EaseCallType1v1Video && isConnected)
        [self streamViewDidTap:self.remoteView];
    [self updatePos];
}

- (void)usersInfoUpdated
{
    [super usersInfoUpdated];
    self.remoteNameLable.text = [[EaseCallManager sharedManager] getNicknameByUserName:self.remoteUid];
}
@end
