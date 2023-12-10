//
//  AppDelegate.m
//  AILearn
//
//  Created by 岳腾飞 on 2023/11/23.
//

#import "AppDelegate.h"
#import <HyphenateChat/HyphenateChat.h>
#import "NETM.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerHy];
    return YES;
}
-(void)registerHy{
    // appkey 替换成你在环信即时通讯 IM 管理后台注册应用中的 App Key
        EMOptions *options = [EMOptions optionsWithAppkey:@"1111191229113028#aiyisheng"];
        // apnsCertName是证书名称，可以先传 nil，等后期配置 APNs 推送时在传入证书名称
        options.apnsCertName = nil;
        [[EMClient sharedClient] initializeSDKWithOptions:options];
    // 异步方法
    //创建用户
    [[EMClient sharedClient] registerWithUsername:@"learnAIUser"
                                             password:@"learnAIUser"
                                           completion:^(NSString *aUsername, EMError *aError) {
        [[EMClient sharedClient] loginWithUsername:@"learnAIUser"
                                             password:@"learnAIUser"
                                           completion:^(NSString *aUsername, EMError *aError) {

        }];
                                       }];
    [self registerSpak];
    
}
-(void)registerSpak{
    [NETM shareManger];
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
