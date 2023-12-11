//
//  EaseCallStreamView.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallStreamView.h"
#import <Masonry/Masonry.h>
#import "UIImage+Ext.h"

@interface EaseCallStreamView()

@property (nonatomic, strong) UIImageView *statusView;
@property (nonatomic) NSTimer *timeTimer;
@end

@implementation EaseCallStreamView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _enableVoice = YES;
        _isTalking = NO;
        
        self.bgView = [[UIImageView alloc] init];
        self.bgView.contentMode = UIViewContentModeScaleAspectFit;
        self.bgView.userInteractionEnabled = YES;
        UIImage *image = [UIImage imageNamedFromBundle:@"icon"];
        self.bgView.image = image;
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.edges.equalTo(self);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).with.offset(-5);
            make.width.lessThanOrEqualTo(@70);
            make.height.lessThanOrEqualTo(@70);
        }];
        
        self.backgroundColor = [UIColor blackColor];
        self.statusView = [[UIImageView alloc] init];
        self.statusView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.statusView];
        [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-5);
            make.right.equalTo(self).offset(-5);
            make.width.height.equalTo(@20);
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-5);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(@30);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
        [self addGestureRecognizer:tap];
        
        [self bringSubviewToFront:_nameLabel];
        
        _isLockedBgView = NO;
    }
    
    return self;
}

- (void)setEnableVoice:(BOOL)enableVoice
{
    _enableVoice = enableVoice;
    
    [self bringSubviewToFront:_statusView];
    if (enableVoice) {
        _statusView.image = nil;
    } else {
        self.isTalking = NO;
        _statusView.image = [UIImage imageNamedFromBundle:@"microphonenclose"];
    }
}

- (void)setEnableVideo:(BOOL)enableVideo
{
    _enableVideo = enableVideo;
    
    if (enableVideo) {
        _bgView.hidden = YES;
        [_displayView setHidden:NO];
        [self bringSubviewToFront:_nameLabel];
    } else {
        _bgView.hidden = NO;
        [_displayView setHidden:YES];
    }
}

- (void)setIsTalking:(BOOL)isTalking
{
    if(isTalking != _isTalking) {
        if(isTalking) {
            _statusView.image = [UIImage imageNamedFromBundle:@"talking_green"];
            if(!self.timeTimer)
                self.timeTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timeTalkingAction:) userInfo:nil repeats:NO];
            
        }else{
            if(self.timeTimer) {
                [self.timeTimer invalidate];
                self.timeTimer = nil;
            }
        }
    }
    _isTalking = isTalking;
}

- (void)timeTalkingAction:(id)sender
{
    _statusView.image = nil;
    self.isTalking = NO;
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapAction:(UITapGestureRecognizer *)aTap
{
    if (aTap.state == UIGestureRecognizerStateEnded) {

        if (_delegate && [_delegate respondsToSelector:@selector(streamViewDidTap:)]) {
            [_delegate streamViewDidTap:self];
        }
    }
}

@end
