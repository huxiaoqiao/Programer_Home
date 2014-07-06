//
//  SoftWareView.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-3.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "SoftWareView.h"
#import "MJRefresh.h"
#import "GDataXMLNode.h"
#import "SoftwareModel.h"
#import "SoftWareDetail.h"

@interface SoftWareView ()<UITableViewDataSource,UITableViewDelegate>
{
    int pageIndex;
    NSDictionary *initDict;
    NSMutableArray *_dataArr;
}
@end

@implementation SoftWareView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        label.text = @"软件列表";
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
    [self createBackButton];
        [self setupFresehObj];
    _dataArr = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //post 参数
    initDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.tag],@"searchTag",@"0",@"pageIndex",@"20",@"pageSize",nil];
    [self loadDataFromNetWorkWithParameters:initDict];
}

- (void)setupFresehObj
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

- (void)loadDataFromNetWorkWithParameters:(NSDictionary *)dict
{
    //这里使用了POST
    [[AFOSCClient sharedClient] postPath:api_softwaretag_list parameters: dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
         [self analyseXMLWithXMLData:operation.responseData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载软件列表失败");
    }];
    
}

- (void)analyseXMLWithXMLData:(NSData *)data
{
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSString *xpath = @"/oschina/softwares/software";
    NSArray *arr = [document nodesForXPath:xpath error:nil];
    for(GDataXMLElement *element in arr)
    {
        SoftwareModel *model = [[SoftwareModel alloc] init];
        model.name = [[element elementsForName:@"name"][0] stringValue];
        model.description = [[element elementsForName:@"description"][0] stringValue];
        model.url = [[element elementsForName:@"url"][0] stringValue];
        [_dataArr addObject:model];
    }
    [self.tableView reloadData];
}

- (void)footerRefreshing
{
    pageIndex ++;
    NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.tag],@"searchTag",[NSString stringWithFormat:@"%d",pageIndex],@"pageIndex",@"20",@"pageSize",nil];
    [self loadDataFromNetWorkWithParameters:newDict];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    SoftwareModel *model = _dataArr[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.detailTextLabel.text = model.description;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SoftwareModel *model = _dataArr[indexPath.row];
    NSArray *arr = [model.url componentsSeparatedByString:@"/"];
    NSString *prefix = [arr lastObject];
    SoftWareDetail *detailCrl = [[SoftWareDetail alloc] initWithNibName:@"SoftWareDetail" bundle:nil];
    detailCrl.softwareName = prefix;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailCrl];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (void)createBackButton
{
    UIButton *backBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    backBnt.frame = CGRectMake(0, 0, 30, 30);
    [backBnt setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBnt];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
