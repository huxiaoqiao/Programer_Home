//
//  SoftWareViewController.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "SoftWareViewController.h"
#import "PPRevealSideViewController.h"
#import "GDataXMLNode.h"
#import "SoftwareModel.h"
#import "SoftWareView.h"

@interface SoftWareViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    NSMutableArray *_dataArr2;
    NSMutableArray *_dataArr3;
    int tag;
    BOOL isSelectedFirstRow;
}
@end

@implementation SoftWareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        label.text = @"软件";
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
     tag = 0;
    _dataArr = [NSMutableArray array];
    _dataArr2 = [NSMutableArray array];
    self.tableView3.hidden = YES;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [self loadDataFromNetworkWithTableView:self.tableView1];
    tag = 1;
    [self loadDataFromNetworkWithTableView:self.tableView2];
    
}
- (void)loadDataFromNetworkWithTableView:(UITableView *)tableview
{
    NSString *url = [NSString stringWithFormat:@"%@?tag=%d",api_softwarecatalog_list,tag];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",operation.responseString);
        [self analyseXMLWithXMLData:operation.responseData AndTableView:tableview];
        [tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载软件列表失败！");
    }];
}
- (void)analyseXMLWithXMLData:(NSData *)data AndTableView:(UITableView *)tableview
{
    if(_dataArr2.count)
    {
        [_dataArr2 removeAllObjects];
    }
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSString *xpath = @"/oschina/softwareTypes/softwareType";
    NSArray *arr = [document nodesForXPath:xpath error:nil];
    for(GDataXMLElement *element in arr)
    {
        SoftwareModel *model = [[SoftwareModel alloc] init];
        model.name = [[element elementsForName:@"name"][0] stringValue];
        model.tag = [[[element elementsForName:@"tag"][0] stringValue] intValue];
        if(tableview == _tableView1)
        {
            [_dataArr addObject:model];
        }else if(tableview == _tableView2)
        {
            [_dataArr2 addObject:model];
        }
    }
    [tableview reloadData];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _tableView1)
    {
        return _dataArr.count;
    }else{
        return _dataArr2.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tableView1)
    {
        return 30.0f;
    }else if (tableView == _tableView2)
    {
        return 25.0f;
    }else
    {
        return 40.0f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if(tableView == _tableView1)
    {
        SoftwareModel *model = _dataArr[indexPath.row];
        cell.textLabel.text = model.name;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categorySelectBg"]];
    }else
    {
        SoftwareModel *model = _dataArr2[indexPath.row];
        cell.textLabel.text = model.name;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tableView1)
    {
        SoftwareModel *model = _dataArr[indexPath.row];
        tag = model.tag;
        [self loadDataFromNetworkWithTableView:_tableView2];
    }else if(tableView == _tableView2){
        SoftwareModel *model = _dataArr2[indexPath.row];
        //NSLog(@"%@----%d",model.name,model.tag);
        SoftWareView *softCtl = [[SoftWareView alloc] initWithNibName:@"SoftWareView" bundle:nil];
        softCtl.tag = model.tag;
        [self.navigationController pushViewController:softCtl animated:YES];
    }
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
