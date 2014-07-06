//
//  FavoriteView.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-1.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "FavoriteView.h"
#import "CCSegmentedControl.h"
#import "GDataXMLNode.h"
#import "FavoriteModel.h"
#import "PostDetail.h"
#import "BlogDetail.h"
#import "NewsDetail.h"
#import "SoftWareDetail.h"

@interface FavoriteView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
}
@end

@implementation FavoriteView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        label.text = @"我的收藏夹";
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
    [self createBackBnt];
    NSArray *itemArr = @[@"软件",@"话题",@"博客",@"资讯",@"代码"];
    CCSegmentedControl *segmentControl = [[CCSegmentedControl alloc] initWithItems:itemArr];
    segmentControl.frame = CGRectMake(0, 0, 320, 40);
    //设置背景图片，或者设置颜色，或者使用默认白色外观
    segmentControl.backgroundImage = [UIImage imageNamed:@"segment_bg.png"];
    //segmentedControl.backgroundColor = [UIColor grayColor];
    
    //阴影部分图片，不设置使用默认椭圆外观的stain
    segmentControl.selectedStainView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stain.png"]];
    
    segmentControl.selectedSegmentTextColor = [UIColor whiteColor];
    segmentControl.segmentTextColor = [UIColor redColor];
    [segmentControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _dataArr = [NSMutableArray array];
    
    NSString *url = [NSString stringWithFormat:@"%@?uid=%@&type=%d&pageIndex=%d&pageSize=%d", api_favorite_list, self.uid,1,0,20];
    [self requestDataWithUrl:url];
}

- (void)valueChanged:(CCSegmentedControl *)sender
{
    int catalog = sender.selectedSegmentIndex + 1;
    NSString *url = [NSString stringWithFormat:@"%@?uid=%@&type=%d&pageIndex=%d&pageSize=%d", api_favorite_list, self.uid,catalog,0,20];
    [self requestDataWithUrl:url];
}

- (void)requestDataWithUrl:(NSString *)url
{
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",operation.responseString);
        [self analyseXMLWithXMLData:operation.responseData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载收藏失败");
    }];
}

- (void)analyseXMLWithXMLData:(NSData *)data
{
    if(_dataArr.count)
    {
        [_dataArr removeAllObjects];
    }
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSString *xpath = @"/oschina/favorites/favorite";
    NSArray *arr = [document nodesForXPath:xpath error:nil];
    for(GDataXMLElement *element in arr)
    {
        FavoriteModel *model = [[FavoriteModel alloc] init];
        model.objid = [[[element elementsForName:@"objid"][0] stringValue] intValue];
        model.type = [[[element elementsForName:@"type"][0] stringValue] intValue];
        model.title = [[element elementsForName:@"title"][0] stringValue];
        model.url = [[element elementsForName:@"url"][0] stringValue];
        [_dataArr addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    FavoriteModel *model = _dataArr[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteModel *model = _dataArr[indexPath.row];
    switch (model.type) {
        case 1:
        {
            NSArray *arr = [model.url componentsSeparatedByString:@"/"];
            NSString *prefix = [arr lastObject];
            SoftWareDetail *detailCtl = [[SoftWareDetail alloc] initWithNibName:@"SoftWareDetail" bundle:nil];
            detailCtl.softwareName = prefix;
            NSLog(@"%@",model.title);
            detailCtl.isFavoriteCtlPush = YES;
            [self.navigationController pushViewController:detailCtl animated:YES];
        }
            break;
            case 2:
        {
            PostDetail *detailCtl = [[PostDetail alloc] initWithNibName:@"PostDetail" bundle:nil];
            detailCtl.postID = model.objid;
            detailCtl.isFavoriteCtlPush = YES;
            [self.navigationController pushViewController:detailCtl animated:YES];
        }
            break;
            case 3:
        {
            BlogDetail *detailCtl = [[BlogDetail alloc] initWithNibName:@"BlogDetail" bundle:nil];
            detailCtl.blogID = model.objid;
            detailCtl.isFavoriteCtlPush = YES;
            [self.navigationController pushViewController:detailCtl animated:YES];
        }
            break;
            case 4:
        {
            NewsDetail *detailCtl = [[NewsDetail alloc] initWithNibName:@"NewsDetail" bundle:nil];
            detailCtl.newsID = model.objid;
            detailCtl.isFavoriteCtlPush = YES;
            [self.navigationController pushViewController:detailCtl animated:YES];
        }
            break;
            case 5:
            break;
        default:
            break;
    }
}

//UI
- (void)createBackBnt
{
    UIButton *backBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    backBnt.frame = CGRectMake(0, 0, 30, 30);
    [backBnt setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBnt addTarget:self action:@selector(backToFrontView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBnt];
}
- (void)backToFrontView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
