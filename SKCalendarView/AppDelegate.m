//
//  AppDelegate.m
//  SKCalendarView
//
//  Created by shevchenko on 17/3/29.
//  Copyright © 2017年 shevchenko. All rights reserved.
//

#import "AppDelegate.h"
#import "SKCalendarView-Swift.h"
#import "TXSakuraKit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [RemindDataBase initDataBase];
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.tabBar.sakura.tintColor(@"accentColor");
    
    [TXSakuraManager registerLocalSakuraWithNames:@[@"yanzi"]];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"bilan"]];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"liuqin"]];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"meizi"]];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"moqin"]];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"tuofen"]];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"tailan"]];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"tianlan"]];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"xihong"]];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"zhuqin"]];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"zhusha"]];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"yanzi"]];
    
    NSString *name = [TXSakuraManager getSakuraCurrentName];
    NSInteger type = [TXSakuraManager getSakuraCurrentType];
    [TXSakuraManager shiftSakuraWithName:name type:type];
    
//    if let notifications = UIApplication.shared.scheduledLocalNotifications {
//        notifications.forEach({(notification) in
//            if let userInfo = notification.userInfo {
//                if let remindFilePath = userInfo["remindFilePath"] as? String {
//                    if remindFilePath == tempRemind?.filePath {
//                        UIApplication.shared.cancelLocalNotification(notification)
//                    }
//                }
//            }
//        })
//    }
    
    NSInteger launchCount = [NSUserDefaults.standardUserDefaults integerForKey:@"launchCount"];
    if (launchCount == 0) {
        NSArray<UILocalNotification *> *list = UIApplication.sharedApplication.scheduledLocalNotifications;
        [UIApplication.sharedApplication cancelAllLocalNotifications];
        list = UIApplication.sharedApplication.scheduledLocalNotifications;
    }
    [NSUserDefaults.standardUserDefaults setInteger:launchCount + 1 forKey:@"launchCount"];
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([NSUserDefaults.standardUserDefaults objectForKey:@"popup"] == NULL || [NSUserDefaults.standardUserDefaults boolForKey:@"popup"]) {
        if ([notification.userInfo objectForKey:@"remindFilePath"] != NULL) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:NULL];
            [alertController addAction:closeAction];
            [self.window.rootViewController presentViewController:alertController animated:true completion:nil];
        }
    }
}

@end
