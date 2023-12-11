//
//  EaseCustomAIAlertView.m
//  EaseIMKit
//
//  Created by mac on 2023/12/9.
//

#import "EaseCustomAIAlertView.h"
#import "UIImage+EaseUI.h"
#import "UIColor+EaseUI.h"
#import "EMChatMessage+EaseUIExt.h"
#import <HyphenateChat/HyphenateChat.h>
#import "EMChatMessage+EaseUIExt.h"
#import "Easeonry.h"
#import "UIImageView+EaseWebCache.h"
#import "UIImage+EaseUI.h"
#import "EaseUserUtils.h"
#import "EaseEmoticonGroup.h"
#import "EaseEmojiHelper.h"
#import <EaseIMKit/EaseIMKit-Swift.h>
#import "EaseChatViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "EaseAlertController.h"

@implementation EaseCustomAIAlertView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.contentView = [EaseCustomAIAlertContentView new];
        [self addSubview:self.contentView];
        [self.contentView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.center.offset(0);
            make.left.offset(16);
            make.right.offset(-16);
            make.height.equalTo(@300);
        }];
    }
    return self;
}

-(void)setBlock:(void (^)(NSData * _Nonnull))block {
    _block = block;
    self.contentView.block = block;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

@implementation EaseCustomAIAlertContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 20;

        // 添加子视图
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    // 标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"请输入您的需求";
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self addSubview:self.titleLabel];

    // 输入框
    self.inputField = [[UITextField alloc] init];
    self.inputField.placeholder = @"AI智画、你说我画";
    self.inputField.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.inputField];
    self.inputField.text = @"";

    // 确定按钮
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"生成" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.confirmButton setTitleColor:[UIColor systemRedColor] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmButton];

    // 图像视图
    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];

    GLLOTAnimationView *loadingView = [[GLLOTAnimationView alloc] initWithFrame:CGRectMake(100, 200, 120, 120) name:@"ai_draw"];
    loadingView.loopAnimation  = YES;
    [loadingView play];
    
    [self.imageView addSubview:loadingView];
    [loadingView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.center.offset(0);
        make.width.height.equalTo(@120);
    }];
    loadingView.hidden = YES;
    self.loadingView = loadingView;
    
    // 发送按钮
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.sendButton];
    
    self.sendButton.backgroundColor = [UIColor systemBlueColor];
    self.sendButton.hidden = YES;
    self.imageView.userInteractionEnabled = YES;
    
    [self.sendButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@50);
        make.top.right.offset(0);
    }];
    
    // 布局
    [self.titleLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(16);
        make.right.offset(-16);
    }];

    [self.inputField Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.ease_bottom).offset(10);
        make.left.equalTo(self.ease_left).offset(16);
        make.right.equalTo(self.ease_right).offset(-56);
        make.height.Ease_equalTo(40);
    }];

    [self.confirmButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.inputField).offset(0);
        make.right.equalTo(self.ease_right).offset(-16);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];

    [self.imageView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.confirmButton.ease_bottom).offset(10);
        make.left.equalTo(self.ease_left).offset(16);
        make.right.equalTo(self.ease_right).offset(-16);
        make.bottom.equalTo(self.ease_bottom).offset(-16);
        make.height.Ease_equalTo(300);
    }];
}

- (void)send {
    if (self.block) {
        UIImage *image = self.imageView.image;
        NSData *data = UIImagePNGRepresentation(image);
        self.block(data);
    }
}

- (void)click {
    NSString *text = self.inputField.text;
    if (text.length == 0) {
        [EaseAlertController showErrorAlert:@"请先输入内容"];
        return;
    }
    
    self.inputField.text = @"";
    [self.inputField becomeFirstResponder];

    //loading
    self.loadingView.hidden = NO;
    self.sendButton.hidden = YES;
    
    // requst
    EaseOpenAISwiftHelper *shared = [EaseOpenAISwiftHelper shareHelper];
    //TODO: 必须自行配置 GPT4.0 的api key！！！
    shared.baseURL = @"https://api.openai.com";
    shared.authToken = @"sk-xxxxxx";
    [shared createImageWithQuery:text completion:^(NSString * url, NSError * _Nullable) {
        if (url.length > 0) {
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (data) {
                    self.imageView.image = image;
                }
                self.loadingView.hidden = YES;
                self.sendButton.hidden = NO;
            }];
        } else {
            self.loadingView.hidden = YES;
            self.sendButton.hidden = YES;
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.inputField becomeFirstResponder];
}

@end
