//
//  AppDelegate.swift
//  ChatAi
//
//  Created by wangfeng on 2023/11/16.
//

import UIKit
import HyphenateChat
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let options = EMOptions(appkey: "1177231129162090#demo")
        options.isAutoLogin = true
        options.logLevel = .debug
        options.enableConsoleLog = true
        EMClient.shared().initializeSDK(with: options)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        if EMClient.shared().isLoggedIn {
            window?.rootViewController = MainTabBarC()
        }else{
            window?.rootViewController = LoginVC()
        }
        window?.makeKeyAndVisible()

        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}

