//
//  FAQViewController.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "FAQViewController.h"
#import "PPRevealSideViewController.h"


@interface FAQViewController ()

@end

@implementation FAQViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        label.text = @"帖子";
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBarButtons];
    [self createScrollView];
}
- (void)createBarButtons
{
    UIButton *bnt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    bnt1.frame = CGRectMake(0, 0, 25, 25);
    [bnt1 setBackgroundImage:[UIImage imageNamed:@"nav_left"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:bnt1];
    self.navigationItem.leftBarButtonItem = leftItem;
    [bnt1 addTarget:self action:@selector(leftShow) forControlEvents:UIControlEventTouchUpInside];
    //编辑按钮
    
}
- (void)leftShow
{
     [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
}

- (void)createScrollView
{
    _topScrollView = [PostTopScrollView shareInstance];
    _rootScrollView = [PostRootScrollView shareInstance];
    _topScrollView.nameArray = @[@"问答",@"分享",@"IT杂烩",@"职业"];
    _rootScrollView.viewNameArray = @[@"问答",@"分享",@"IT杂烩",@"职业"];
    
    [self.view addSubview:_topScrollView];
    [self.view addSubview:_rootScrollView];
    [_topScrollView initWithNameButtons];
    [_rootScrollView initWithViews];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
