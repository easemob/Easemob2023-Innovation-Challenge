//
//  EMMsgFileBubbleView.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EMMsgFileBubbleView.h"
#import "EaseHeaders.h"
#import "UIImage+EaseUI.h"

@interface EMMsgFileBubbleView ()
{
    EaseChatViewModel *_viewModel;
}

@end
@implementation EMMsgFileBubbleView

- (instancetype)initWithDirection:(EMMessageDirection)aDirection
                             type:(EMMessageType)aType
                        viewModel:(EaseChatViewModel *)viewModel
{
    self = [super initWithDirection:aDirection type:aType viewModel:viewModel];
    if (self) {
        _viewModel = viewModel;
        [self _setupSubviews];
    }
    
    return self;
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    [self setupBubbleBackgroundImage];
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.clipsToBounds = YES;
    [self addSubview:self.iconView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = [UIFont systemFontOfSize:12];
    self.textLabel.textColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
    self.textLabel.numberOfLines = 2;
    [self addSubview:self.textLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont systemFontOfSize:10];
    self.detailLabel.numberOfLines = 0;
    [self addSubview:self.detailLabel];
    [self.detailLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.textLabel.ease_bottom).offset(16);
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self.textLabel);
        make.right.equalTo(self.ease_centerX);
    }];
    
    self.downloadStatusLabel = [[UILabel alloc] init];
    self.downloadStatusLabel.font = [UIFont systemFontOfSize:10];
    self.downloadStatusLabel.numberOfLines = 0;
    self.downloadStatusLabel.textAlignment = NSTextAlignmentRight;
    self.downloadStatusLabel.textColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0];
    [self addSubview:self.downloadStatusLabel];
    [self.downloadStatusLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.textLabel.ease_bottom).offset(16);
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self.ease_centerX);
        make.right.equalTo(self.textLabel);
    }];
    self.textLabel.textColor = [UIColor blackColor];
    if (self.direction == EMMessageDirectionSend) {
        self.iconView.image = [UIImage easeUIImageNamed:@"msg_file_white"];
        [self.iconView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(5);
            make.centerY.equalTo(self);
            make.width.equalTo(@40);
        }];
        [self.textLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self.iconView.ease_right).offset(5);
            make.right.equalTo(self).offset(-15);
        }];
        self.detailLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    } else {
        self.iconView.image = [UIImage easeUIImageNamed:@"msg_file"];
        [self.iconView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(8);
            make.centerY.equalTo(self);
            make.width.equalTo(@40);
        }];
        [self.textLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self.iconView.ease_right).offset(5);
            make.right.equalTo(self).offset(-10);
        }];
        
        self.detailLabel.textColor = [UIColor grayColor];
    }
}

#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model
{
    EMMessageType type = model.type;
    if (type == EMMessageTypeFile) {
        EMFileMessageBody *body = (EMFileMessageBody *)model.message.body;
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:body.displayName];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0; // 设置行间距
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
        [attributedStr addAttribute:NSKernAttributeName value:@0.34 range:NSMakeRange(0, attributedStr.length)];

        self.textLabel.attributedText = attributedStr;
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.detailLabel.text = [NSString stringWithFormat:@"%.2lf MB",(float)body.fileLength / (1024 * 1024)];
        
        if (self.direction == EMMessageDirectionReceive && body.downloadStatus == EMDownloadStatusSucceed) {
            self.downloadStatusLabel.text = EaseLocalizableString(@"downloaded", nil);
        } else {
            self.downloadStatusLabel.text = @"";
        }
    }
}

@end
