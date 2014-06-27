//
//  AppDelegate.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "PPRevealSideViewController.h"
#import "SVGloble.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [SVGloble shareInstance].globleWidth = screenRect.size.width;//屏幕宽度
    [SVGloble shareInstance].globleHeight = screenRect.size.height - 20 - 64;//屏幕高度;
    [SVGloble shareInstance].globleAllHeight = screenRect.size.height;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
    [self performSelector:@selector(createViewController) withObject:nil afterDelay:0.1];
    return YES;
}
- (void)createViewController
{
    RootViewController *viewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    _nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    _nav.navigationBar.translucent = NO;
    _nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
    PPRevealSideViewController *revealCtl = [[PPRevealSideViewController alloc] initWithRootViewController:_nav];
    self.window.rootViewController = revealCtl;
}
//启用网络监视
-(void)reachabilityChanged:(NSNotification *)note{
    
    NSString * connectionKind = nil;
    
    Reachability * curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    netstatus = [curReach currentReachabilityStatus];
    switch (netstatus) {
        case NotReachable:
            connectionKind = @"当前没有网络链接\n请检查你的网络设置";
            _isConnected =NO;
            break;
            
        case ReachableViaWiFi:
            connectionKind = @"当前使用的网络类型是WIFI";
            _isConnected =YES;
            break;
            
        case ReachableViaWWAN:
            connectionKind = @"您现在使用的是2G/3G网络\n可能会产生流量费用";
            _isConnected =YES;
            break;
            
        default:
            break;
    }
    
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
