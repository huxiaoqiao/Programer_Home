//
//  RootViewController.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVRootScrollView.h"
#import "SVTopScrollView.h"
@interface RootViewController : UIViewController
@property (nonatomic,strong) SVTopScrollView *topScrollView;
@property (nonatomic,strong) SVRootScrollView *rootScrollView;
@end
