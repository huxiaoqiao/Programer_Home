//
//  RootViewController.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "RootViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "PPRevealSideViewController.h"


@interface RootViewController ()<leftViewDelegate>

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSideViewCtls];
    [self createScrollViews];
}
- (void)createSideViewCtls
{
    LeftViewController *left = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    left.delegate = self;
    RightViewController *right = [[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil];
    
    [self.revealSideViewController preloadViewController:left forSide:PPRevealSideDirectionLeft];
    [self.revealSideViewController preloadViewController:right forSide:PPRevealSideDirectionRight];
    
    UIButton *bnt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    bnt1.frame = CGRectMake(0, 0, 25, 25);
    [bnt1 setBackgroundImage:[UIImage imageNamed:@"nav_left"] forState:UIControlStateNormal];
    
    UIButton *bnt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    bnt2.frame = CGRectMake(0, 0, 25, 25);
    [bnt2 setBackgroundImage:[UIImage imageNamed:@"nav_right"] forState:UIControlStateNormal];
   
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:bnt1];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:bnt2];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [bnt1 addTarget:self action:@selector(leftShow:) forControlEvents:UIControlEventTouchUpInside];
    [bnt2 addTarget:self action:@selector(rightShow) forControlEvents:UIControlEventTouchUpInside];
}
- (void)createScrollViews
{
    _topScrollView = [SVTopScrollView shareInstance];
    _rootScrollView = [SVRootScrollView shareInstance];
    _topScrollView.nameArray = @[@"资讯",@"博客",@"推荐阅读"];
    _rootScrollView.viewNameArray = @[@"资讯",@"博客",@"推荐阅读"];
    
    [self.view addSubview:_topScrollView];
    [self.view addSubview:_rootScrollView];
    [_topScrollView initWithNameButtons];
    [_rootScrollView initWithViews];
}
- (void)leftShow:(UIButton *)sender;
{
//    CGAffineTransform  transform = CGAffineTransformMakeRotation(M_PI_2);
//    [UIView animateWithDuration:0.2 animations:^{
//        sender.transform = transform;
//    }];
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
}
- (void)rightShow
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionRight animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testMethod
{
    NSLog(@"I am delegate!");
}

@end
