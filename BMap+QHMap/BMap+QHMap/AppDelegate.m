//
//  AppDelegate.m
//  BMap+QHMap
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

//每个应用的key都是不一样的 请到百度地图官网申请
#define BMAPKEY @"o89oDuYEHp2Wde3RwhpLyjhk"
@interface AppDelegate ()<BMKGeneralDelegate>
@property(strong,nonatomic)BMKMapManager *bmkMapManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UINavigationController*nav=[[UINavigationController alloc] initWithRootViewController:[HomeViewController new]];
    self.window.rootViewController=nav;
    [self.window makeKeyAndVisible];
    

     NSString*bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];//申请key的时候会用到这个string
    self.bmkMapManager=[[BMKMapManager alloc] init];
    [self.bmkMapManager start:BMAPKEY generalDelegate:self];

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
