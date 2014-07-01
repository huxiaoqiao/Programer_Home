//
//  FAQViewController.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostTopScrollView.h"
#import "PostRootScrollView.h"

@interface FAQViewController : UIViewController
@property (nonatomic,strong) PostTopScrollView *topScrollView;
@property (nonatomic,strong) PostRootScrollView *rootScrollView;

@end
