//
//  BCSEAppDelegate.m
//  Breadcrumbs
//
//  Created by Grey Lee on 2014/2/8.
//  Copyright (c) 2014年 Grey Lee. All rights reserved.
//

#import "BCSEAppDelegate.h"
#import "BCSEMainViewController.h"

@implementation BCSEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Add notification observer for settings changed
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    BCSEMainViewController *mainViewController = (BCSEMainViewController *)[navigationController.viewControllers firstObject];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:mainViewController
               selector:@selector(settingsChanged:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    BCSEMainViewController *mainViewController = (BCSEMainViewController *)[navigationController.viewControllers firstObject];
    [mainViewController switchToBackgroundMode:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    BCSEMainViewController *mainViewController = (BCSEMainViewController *)[navigationController.viewControllers firstObject];
    [mainViewController switchToBackgroundMode:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Notify user that we're about to be terminated.
    UILocalNotification *terminatingNotification = [[UILocalNotification alloc] init];
    terminatingNotification.alertBody = @"Breadcrumbs is teminated. Launch it again to continue logging.";
    terminatingNotification.alertAction = @"Launch";
    [application presentLocalNotificationNow:terminatingNotification];

    // Remove notification observer.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self.window.rootViewController];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [self applicationWillTerminate:application];
}

@end
