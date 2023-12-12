//
//  EaseCustomAIAlertView.h
//  EaseIMKit
//
//  Created by mac on 2023/12/9.
//

#import <UIKit/UIKit.h>
#import <HyphenateChat/HyphenateChat.h>
#import <EaseIMKit/EaseIMKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface EaseCustomAIAlertContentView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GLLOTAnimationView *loadingView;
@property (nonatomic, copy) void(^block)(NSData *imagedata);


@end

@interface EaseCustomAIAlertView : UIView

@property (nonatomic, strong) EaseCustomAIAlertContentView *contentView;

@property (nonatomic, copy) void(^block)(NSData *imagedata);

@end

NS_ASSUME_NONNULL_END
