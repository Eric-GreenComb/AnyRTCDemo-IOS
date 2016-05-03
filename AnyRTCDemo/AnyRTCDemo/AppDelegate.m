//
//  AppDelegate.m
//  AnyRTCDemo
//
//  Created by jianqiangzhang on 16/4/7.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+Category.h"
#import "AnyRTC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

#warning  Warning 用户需要去 www.anyrtc.io 注册开发者，并且创建App,你会得到：developerID，token，appKey; appId是你在开发平台上注册的应用名称
    NSLog(@"请到AppDelegate里面设置参数");
    assert(developerID.length>0 && token.length>0 && key.length>0 && appID.length>0);
    [AnyRTC InitAnyRTC:developerID withToken:token withAppKey:key withAppId:appID];
  
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithHexString:@"2fcf6f"]];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
  
     UIBarButtonItem *appearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    
     UIImage *navBackgroundImg =[[UIImage imageNamed:@"nav_back"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UINavigationBar appearance] setBackIndicatorImage:navBackgroundImg];
    //[[UINavigationBar appearance].backIndicatorImage:navBackgroundImg];
  //   [appearance setBackButtonBackgroundImage:navBackgroundImg  forState:UIControlStateNormal  barMetrics:UIBarMetricsDefault];
    [appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
