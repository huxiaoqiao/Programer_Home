//
//  SoftWareDetail.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-3.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoftWareDetail : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,copy) NSString *softwareName;
@property BOOL isFavoriteCtlPush;
@end
