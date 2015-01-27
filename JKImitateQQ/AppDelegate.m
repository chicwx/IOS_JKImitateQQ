//
//  AppDelegate.m
//  QQFrame
//
//  Created by dg11185_zal on 14/11/24.
//  Copyright (c) 2014年 dg11185. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MessageViewController.h"
#import "ContactsViewController.h"
#import "InterspaceViewController.h"
#import "LeftSideViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *rootVC = [[ViewController alloc] init];
    //添加左侧视图控制器
    rootVC.leftVC = [[LeftSideViewController alloc] init];
    //添加主视图控制器
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    messageVC.title = @"消息";
    UINavigationController *messageController = [[UINavigationController alloc] initWithRootViewController:messageVC];
    ContactsViewController *contactsVC = [[ContactsViewController alloc] init];
    contactsVC.title = @"联系人";
    UINavigationController *contactsController = [[UINavigationController alloc] initWithRootViewController:contactsVC];
    InterspaceViewController *interspaceVC = [[InterspaceViewController alloc] init];
    interspaceVC.title = @"动态";
    UINavigationController *interspaceController = [[UINavigationController alloc] initWithRootViewController:interspaceVC];
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    tabVC.viewControllers = [NSArray arrayWithObjects:messageController,contactsController,interspaceController, nil];
    rootVC.mainVC = tabVC;
    
    //设置低栏图标与标题
    messageController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageWithCGImage:[UIImage imageNamed:@"tab_message.png"].CGImage scale:2 orientation:UIImageOrientationUp] selectedImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"tab_message_on.png"].CGImage scale:2 orientation:UIImageOrientationUp]];
    contactsController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人" image:[UIImage imageWithCGImage:[UIImage imageNamed:@"tab_contacts.png"].CGImage scale:2 orientation:UIImageOrientationUp] selectedImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"tab_contacts_on.png"].CGImage scale:2 orientation:UIImageOrientationUp]];
    interspaceController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"动态" image:[UIImage imageWithCGImage:[UIImage imageNamed:@"tab_interspace.png"].CGImage scale:2 orientation:UIImageOrientationUp] selectedImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"tab_interspace_on.png"].CGImage scale:2 orientation:UIImageOrientationUp]];
    
    //设置navigationBar颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:40/255.0 green:179/255.0 blue:234/255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
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
