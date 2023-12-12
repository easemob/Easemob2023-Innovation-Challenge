//
//  AppDelegate.m
//  HomeworkHelper
//
//  Created by Mac on 2023/12/2.
//

#import "AppDelegate.h"
#import <HyphenateChat/HyphenateChat.h>
#import <IQKeyboardManager.h>
@import GoogleMobileAds;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    EMOptions *options = [EMOptions optionsWithAppkey:@"1149221111120747#homeworkhelper"];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
        [IQKeyboardManager sharedManager].enable = YES;
    [GADMobileAds.sharedInstance startWithCompletionHandler:nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application;{
    
    [EMClient.sharedClient logout:YES completion:^(EMError * _Nullable aError) {
        if(aError){
            NSLog(@"退出登陆失败:%@",aError.errorDescription);
        }
    }];
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
