//
//  ViewController.m
//  HomeworkHelper
//
//  Created by Mac on 2023/12/2.
//

#import "ViewController.h"
#import <HyphenateChat/HyphenateChat.h>
#import <EaseIMKit/EaseChatViewController.h>
#import "EMChatViewController.h"
#import <AFNetworking.h>
#import <ZLPhotoBrowser-objc/ZLPhotoBrowser.h>
#import "ConfirmImageViewController.h"
#import <SVProgressHUD.h>
#import "AboutUsViewController.h"
#import <StoreKit/StoreKit.h>
@import GoogleMobileAds;
@interface ViewController ()<GADBannerViewDelegate>{
    NSString *access_token;
    ConfirmImageViewController *c;
    EMChatViewController *chat;
}
@property(nonatomic, strong) GADBannerView *bannerView;
@end

@implementation ViewController

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidReceiveAd");
    [self addBannerViewToView:self.bannerView];
    bannerView.alpha = 0;
      [UIView animateWithDuration:1.0 animations:^{
        bannerView.alpha = 1;
      }];
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
  NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidRecordImpression");
}

- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillPresentScreen");
}

- (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillDismissScreen");
}

- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidDismissScreen");
}

- (void)addBannerViewToView:(UIView *)bannerView {
  bannerView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:bannerView];
  [self.view addConstraints:@[
    [NSLayoutConstraint constraintWithItem:bannerView
                               attribute:NSLayoutAttributeBottom
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self.view.safeAreaLayoutGuide
                               attribute:NSLayoutAttributeBottom
                              multiplier:1
                                constant:0],
    [NSLayoutConstraint constraintWithItem:bannerView
                               attribute:NSLayoutAttributeCenterX
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                               attribute:NSLayoutAttributeCenterX
                              multiplier:1
                                constant:0]
                                ]];
}

- (void)viewWillAppear:(BOOL)animated{
    [chat loadRewardedAd];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    chat = [[EMChatViewController alloc] initWithConversationId:@"AIMain" conversationType:EMConversationTypeChat];
    
    
    
    self.bannerView = [[GADBannerView alloc]
          initWithAdSize:GADAdSizeBanner];
    
//      [self addBannerViewToView:self.bannerView];
    
    // Do any additional setup after loading the view.
    //注册AI账户
//    [[EMClient sharedClient] registerWithUsername:@"userAI002"
//                                             password:@"userAI2023"
//                                           completion:^(NSString *aUsername, EMError *aError) {
//        if(aError){
//            NSLog(@"注册失败:%@",aError.description);
//
    
//        }else{
//            NSLog(@"userName = %@",aUsername);
//        }
//
//                                       }];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=BaiDu_Client_ID&client_secret=Baidu_Client_Secret" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求BaiduTOKEN成功：%@",responseObject);
        
        NSDictionary *dic = responseObject;
        self->access_token = [dic objectForKey:@"access_token"];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求Baidu Token失败：%@",error.description);
    }];
    
    ///登陆AI账户
    ///
    [[EMClient sharedClient] loginWithUsername:@"User001"
                                         password:@"Aa123456"
                                       completion:^(NSString *aUsername, EMError *aError) {
        if(aError){
            NSLog(@"登录失败 : %@",aError.errorDescription);
//            [SVProgressHUD showAlertWithMessage:[NSString stringWithFormat:@"登录失败 : %@",aError.errorDescription]];
        }else{
            NSLog(@"登录成功 : %@",aUsername);
//            [SVProgressHUD showAlertWithMessage:[NSString stringWithFormat:@"登录成功"]];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    
    if(c){
        [self.navigationController pushViewController:c animated:true];
        c = nil;
    }
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前为参赛版本，正常使用前需先填入百度的client_id和client_secret以及百度千帆的client_id和client_id" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSUserDefaults *s = [NSUserDefaults standardUserDefaults];
            [s setObject:@"y" forKey:@"isFirst"];
            [s synchronize];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:true completion:nil];
    }
    
    
}
- (IBAction)sacnToAskAction:(id)sender {
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"请选择" message:@"打开照片方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 直接调用相机
        ZLCustomCamera *camera = [[ZLCustomCamera alloc] init];
        
        
        camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
            // 自己需要在这个地方进行图片或者视频的保存
            self->c = [[ConfirmImageViewController alloc] initWithNibName:@"ConfirmImageViewController" bundle:nil];
            self->c.astkn = self->access_token;
            self->c.scanImg = image;
//            [self.navigationController pushViewController:c animated:true];
        };

        [self showDetailViewController:camera sender:nil];
    }];
    
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 选择回调
        [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            //your codes
            self->c = [[ConfirmImageViewController alloc] initWithNibName:@"ConfirmImageViewController" bundle:nil];
            self->c.astkn = self->access_token;
            self->c.scanImg = images[0];
            
        }];
        ac.sender = self;
        // 调用相册
        [ac showPreviewAnimated:YES];
        
    }];
    
    [a addAction:a1];
    [a addAction:a2];
    
    [self presentViewController:a animated:true completion:nil];
    
}
- (IBAction)startAskAction:(id)sender {
    
    [self.navigationController pushViewController:chat animated:true];
}

- (IBAction)aboutAction:(id)sender {
    AboutUsViewController *a = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    [self.navigationController pushViewController:a animated:true];
}
- (IBAction)rateUsAction:(id)sender {
    [SKStoreReviewController requestReview];
}

@end
