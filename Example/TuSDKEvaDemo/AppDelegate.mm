//
//  AppDelegate.m
//  TuSDKEvaDemo
//
//  Created by sprint on 2019/5/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "AppDelegate.h"
#import "TuSDKFramework.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [TuSDK initSdkWithAppKey:@"9573fb1a49c35b1c-04-ewdjn1"];
    // 可选: 设置日志输出级别 (默认不输出)
    [TuSDK setLogLevel:lsqLogLevelDEBUG];
    // 设置弹框时，背景按钮不可点击
    [TuSDKProgressHUD setDefaultMaskType:TuSDKProgressHUDMaskTypeClear];
    
    // 添加文件引入
    //#import <TuSDK/TuSDK.h>
    //#import <TuSDKVideo/TuSDKVideo.h>
    //#import <TuSDKEva/TuSDKEva.h>
    // 版本号输出
    //NSLog(@"TuSDK.framework 的版本号 : %@",lsqSDKVersion);
    //NSLog(@"TuSDKVideo.framework 的版本号 : %@",lsqVideoVersion);
    //NSLog(@"TuSDKEva.framework 的版本号 : %@",lsqEvaVersion);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // 接收到内存警告
    NSLog(@"=========================================");
    NSLog(@"++++++++++++++内存警告+++++++++++++++++++++");
    NSLog(@"=========================================");
}


@end
