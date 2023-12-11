//
//  EaseCallBaseViewController.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallBaseViewController.h"
#import "EaseCallManager+Private.h"
#import <Masonry/Masonry.h>
#import "UIImage+Ext.h"
#import "EaseCallLocalizable.h"

@interface EaseCallBaseViewController ()

@end

@implementation EaseCallBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setubSubViews];
    
    self.speakerButton.selected = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usersInfoUpdated) name:@"EaseCallUserUpdated" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)usersInfoUpdated
{
    
}

- (void)setubSubViews
{
    int size = 60;
    
    [self.view addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11,*)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else {
            make.edges.equalTo(self.view);
         }
       
    }];
    
    self.miniButton = [[UIButton alloc] init];
    self.miniButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.miniButton setImage:[UIImage imageNamedFromBundle:@"mini"] forState:UIControlStateNormal];
    [self.miniButton addTarget:self action:@selector(miniAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.miniButton];
    [self.miniButton setTintColor:[UIColor whiteColor]];
    [self.miniButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(@10);
        make.width.height.equalTo(@40);
    }];
    
    self.hangupButton = [[UIButton alloc] init];
    self.hangupButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.hangupButton setImage:[UIImage imageNamedFromBundle:@"hangup"] forState:UIControlStateNormal];
    [self.hangupButton addTarget:self action:@selector(hangupAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.hangupButton];
    [self.hangupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-60);
        make.left.equalTo(@30);
        make.width.height.equalTo(@60);
        //make.centerX.equalTo(@60);
    }];
    
    self.answerButton = [[UIButton alloc] init];
    self.answerButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.answerButton setImage:[UIImage imageNamedFromBundle:@"answer"] forState:UIControlStateNormal];
    [self.answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.answerButton];
    [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.hangupButton);
        make.right.equalTo(self.contentView).offset(-40);
        make.width.height.mas_equalTo(60);
    }];
    
    self.switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.switchCameraButton setImage:[UIImage imageNamedFromBundle:@"switchCamera"] forState:UIControlStateNormal];
    [self.switchCameraButton addTarget:self action:@selector(switchCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.switchCameraButton];
    [self.switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.hangupButton);
        make.width.height.mas_equalTo(60);
        make.centerX.equalTo(self.contentView).with.multipliedBy(1.5);
    }];
    
    self.microphoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.microphoneButton setImage:[UIImage imageNamedFromBundle:@"microphone_disable"] forState:UIControlStateNormal];
    [self.microphoneButton setImage:[UIImage imageNamedFromBundle:@"microphone_enable"] forState:UIControlStateSelected];
    [self.microphoneButton addTarget:self action:@selector(muteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.microphoneButton];
    [self.microphoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(self.speakerButton.mas_right).offset(40);
        make.centerX.equalTo(self.contentView).with.multipliedBy(0.5);
        make.bottom.equalTo(self.hangupButton.mas_top).with.offset(-40);
        make.width.height.equalTo(@(size));
    }];
    self.microphoneButton.selected = NO;
    
    self.speakerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.speakerButton setImage:[UIImage imageNamedFromBundle:@"speaker_disable"] forState:UIControlStateNormal];
    [self.speakerButton setImage:[UIImage imageNamedFromBundle:@"speaker_enable"] forState:UIControlStateSelected];
    [self.speakerButton addTarget:self action:@selector(speakerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.speakerButton];
    [self.speakerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.microphoneButton);
        //make.left.equalTo(self.switchCameraButton.mas_right).offset(40);
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@(size));
    }];

    self.enableCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.enableCameraButton setImage:[UIImage imageNamedFromBundle:@"video_disable"] forState:UIControlStateNormal];
    [self.enableCameraButton setImage:[UIImage imageNamedFromBundle:@"video_enable"] forState:UIControlStateSelected];
    [self.enableCameraButton addTarget:self action:@selector(enableVideoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.enableCameraButton];
    [self.enableCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(self.microphoneButton.mas_right).offset(40);
        make.centerX.equalTo(self.contentView).with.multipliedBy(1.5);
        make.bottom.equalTo(self.microphoneButton);
        make.width.height.equalTo(@(size));
    }];
    
    [self.enableCameraButton setEnabled:NO];
    [self.switchCameraButton setEnabled:NO];
    [self.microphoneButton setEnabled:NO];
    _timeLabel = nil;
    
    self.hangupLabel = [[UILabel alloc] init];
    self.hangupLabel.font = [UIFont systemFontOfSize:11];
    self.hangupLabel.textColor = [UIColor whiteColor];
    self.hangupLabel.textAlignment = NSTextAlignmentCenter;
    self.hangupLabel.text = EaseCallLocalizableString(@"Huangup",nil);
    [self.contentView addSubview:self.hangupLabel];
    [self.hangupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hangupButton.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.hangupButton);
    }];
    
    self.acceptLabel = [[UILabel alloc] init];
    self.acceptLabel.font = [UIFont systemFontOfSize:11];
    self.acceptLabel.textColor = [UIColor whiteColor];
    self.acceptLabel.textAlignment = NSTextAlignmentCenter;
    self.acceptLabel.text = EaseCallLocalizableString(@"Answer",nil);
    [self.contentView addSubview:self.acceptLabel];
    [self.acceptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.answerButton.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.answerButton);
    }];
    
    self.microphoneLabel = [[UILabel alloc] init];
    self.microphoneLabel.font = [UIFont systemFontOfSize:11];
    self.microphoneLabel.textColor = [UIColor whiteColor];
    self.microphoneLabel.textAlignment = NSTextAlignmentCenter;
    self.microphoneLabel.text = EaseCallLocalizableString(@"Mute",nil);
    [self.contentView addSubview:self.microphoneLabel];
    [self.microphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.microphoneButton.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.microphoneButton);
    }];
    
    self.speakerLabel = [[UILabel alloc] init];
    self.speakerLabel.font = [UIFont systemFontOfSize:11];
    self.speakerLabel.textColor = [UIColor whiteColor];
    self.speakerLabel.textAlignment = NSTextAlignmentCenter;
    self.speakerLabel.text = EaseCallLocalizableString(@"Hands-free",nil);
    [self.contentView addSubview:self.speakerLabel];
    [self.speakerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speakerButton.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.speakerButton);
    }];
    
    self.enableCameraLabel = [[UILabel alloc] init];
    self.enableCameraLabel.font = [UIFont systemFontOfSize:11];
    self.enableCameraLabel.textColor = [UIColor whiteColor];
    self.enableCameraLabel.textAlignment = NSTextAlignmentCenter;
    self.enableCameraLabel.text = EaseCallLocalizableString(@"Camera",nil);
    [self.contentView addSubview:self.enableCameraLabel];
    [self.enableCameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enableCameraButton.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.enableCameraButton);
    }];
    
    self.switchCameraLabel = [[UILabel alloc] init];
    self.switchCameraLabel.font = [UIFont systemFontOfSize:11];
    self.switchCameraLabel.textColor = [UIColor whiteColor];
    self.switchCameraLabel.textAlignment = NSTextAlignmentCenter;
    self.switchCameraLabel.text = EaseCallLocalizableString(@"SwitchCamera",nil);
    [self.contentView addSubview:self.switchCameraLabel];
    [self.switchCameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchCameraButton.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.switchCameraButton);
    }];
}

- (UIView*)contentView
{
    if(!_contentView)
        _contentView = [[UIView alloc] init];
    return _contentView;
}

- (void)answerAction
{
    [[EaseCallManager sharedManager] acceptAction];
}

- (void)hangupAction
{
    if (_timeTimer) {
        [_timeTimer invalidate];
        _timeTimer = nil;
    }
    [[EaseCallManager sharedManager] hangupAction];
}

- (void)switchCameraAction
{
    self.switchCameraButton.selected = !self.switchCameraButton.isSelected;
    [[EaseCallManager sharedManager] switchCameraAction];
}

- (void)speakerAction
{
    self.speakerButton.selected = !self.speakerButton.isSelected;
    [[EaseCallManager sharedManager] speakeOut:self.speakerButton.selected];
}

- (void)muteAction
{
    self.microphoneButton.selected = !self.microphoneButton.isSelected;
    [[EaseCallManager sharedManager] muteAudio:self.microphoneButton.selected];
}

- (void)enableVideoAction
{
    self.enableCameraButton.selected = !self.enableCameraButton.isSelected;
    [[EaseCallManager sharedManager] enableVideo:self.enableCameraButton.selected];
}

- (void)miniAction
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.floatingView.frame = CGRectMake(self.contentView.bounds.size.width - 100, 80, 80, 100);
    [keyWindow addSubview:self.floatingView];
    [keyWindow bringSubviewToFront:self.floatingView];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (EaseCallStreamView*)floatingView
{
    if(!_floatingView)
    {
        _floatingView = [[EaseCallStreamView alloc] init];
        _floatingView.backgroundColor = [UIColor grayColor];
        _floatingView.bgView.image = [UIImage imageNamedFromBundle:@"floating_voice"];
        [_floatingView.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@55);
        }];
    }
    return _floatingView;
}


#pragma mark - timer

- (void)startTimer
{
    if(!_timeLabel) {
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:25];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.text = @"00:00";
        [self.contentView addSubview:self.timeLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.hangupButton.mas_top).with.offset(-20);
            make.centerX.equalTo(self.contentView);
        }];
        _timeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
    }
    
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int m = (_timeLength) / 60;
    int s = _timeLength - m * 60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", m, s];
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
