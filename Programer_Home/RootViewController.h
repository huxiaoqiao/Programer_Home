//
//  RootViewController.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsRootScrollView.h"
#import "NewsTopScrollView.h"
@interface RootViewController : UIViewController
@property (nonatomic,strong) NewsTopScrollView *topScrollView;
@property (nonatomic,strong) NewsRootScrollView *rootScrollView;
@end
