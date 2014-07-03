//
//  TweetViewController.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetRootScrollView.h"
#import "TweetTopScrollView.h"

@interface TweetViewController : UIViewController
@property (nonatomic,strong) TweetRootScrollView *rootScrollView;
@property (nonatomic,strong) TweetTopScrollView *topScrollView;
@end
