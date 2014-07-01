//
//  LeftViewController.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAQViewController.h"
#import "TweetViewController.h"
#import "SoftWareViewController.h"
#import "SettingViewController.h"

@interface LeftViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) FAQViewController *faqCtl;
@property (strong,nonatomic) TweetViewController *tweetCtl;
@property (strong,nonatomic) SoftWareViewController *softCtl;
@property (strong,nonatomic) SettingViewController *settingCtl;
@end
