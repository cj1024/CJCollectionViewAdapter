//
//  CJAppDelegate.m
//  CJCollectionViewAdapter_Example
//
//  Created by cj1024 on 12/11/2020.
//  Copyright (c) 2020 cj1024. All rights reserved.
//

#import "CJAppDelegate.h"
#import <FLEX/FLEX.h>

@implementation CJApplication

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [[FLEXManager sharedManager] showExplorer];
    }
}

@end

@implementation CJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *navigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [navigationBarAppearance configureWithDefaultBackground];
        [[UINavigationBar appearance] setStandardAppearance:navigationBarAppearance];
        [[UINavigationBar appearance] setScrollEdgeAppearance:navigationBarAppearance];
        [[UINavigationBar appearance] setCompactAppearance:navigationBarAppearance];
        [[UINavigationBar appearance] setCompactScrollEdgeAppearance:navigationBarAppearance];
    }
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
