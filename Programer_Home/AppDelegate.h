//
//  AppDelegate.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability * hostReach;//网络状态
    NetworkStatus netstatus;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL isConnected;//判断网络是否已经连接
@property (nonatomic,strong) UINavigationController *nav;
@end
