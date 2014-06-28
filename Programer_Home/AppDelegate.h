//
//  AppDelegate.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "ASIHTTPRequest.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate>
{
    Reachability * hostReach;//网络状态
    NetworkStatus netstatus;
    ASIHTTPRequest *request1;
    ASIHTTPRequest *request2;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL isConnected;//判断网络是否已经连接
@property (nonatomic,strong) UINavigationController *nav;

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *access_token;
- (void)getTheCode;
- (void)getTheAccess_tokenWithCode:(NSString *)code;
@end
