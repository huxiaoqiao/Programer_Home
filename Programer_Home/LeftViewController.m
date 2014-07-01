//
//  LeftViewController.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "LeftViewController.h"
#import "CellModel.h"
#import "LeftMenuCell.h"
#import "PPRevealSideViewController.h"
#import "AppDelegate.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArr;
}
@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataArr = [NSMutableArray array];
        NSArray *titleArr = @[@"资讯",@"问答",@"动弹",@"软件",@"设置"];
        NSArray *imageArr = @[@"menu_news",@"menu_help",@"menu_forum",@"menu_app",@"menu_setting"];
        for(int i = 0;i < titleArr.count;i ++)
        {
            CellModel *model = [[CellModel alloc] init];
            model.menuImage = [UIImage imageNamed:imageArr[i]];
            model.menuTitle = titleArr[i];
            [dataArr addObject:model];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.searchBar;
    //注册Cell
    UINib *customeCell = [UINib nibWithNibName:@"LeftMenuCell" bundle:nil];
    [self.tableView registerNib:customeCell forCellReuseIdentifier:@"LeftMenuCell"];
    //设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftMenuCell"];
    CellModel *model = dataArr[indexPath.row];
    cell.menuImageView.image = model.menuImage;
    cell.menuTitle.text = model.menuTitle;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            AppDelegate *appDele = [[UIApplication sharedApplication] delegate];
            
            [self.revealSideViewController popViewControllerWithNewCenterController:appDele.nav animated:YES];
        }
            break;
            case 1:
        {
            _faqCtl = [[FAQViewController alloc] initWithNibName:@"FAQViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_faqCtl];
            nav.navigationBar.translucent = NO;
            nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
            [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
        }
            break;
            case 2:
        {
            _tweetCtl = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_tweetCtl];
            nav.navigationBar.translucent = NO;
            nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
            [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
        }
            break;
            case 3:
        {
            _softCtl = [[SoftWareViewController alloc] initWithNibName:@"SoftWareViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_softCtl];
            nav.navigationBar.translucent = NO;
            nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
            [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
        }
            break;
            case 4:
        {
            _settingCtl = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_settingCtl];
            nav.navigationBar.translucent = NO;
            nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
            [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
