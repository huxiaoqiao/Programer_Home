//
//  LatestView.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-2.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "LatestView.h"
#import "MJRefresh.h"
#import "TweetCell.h"
#import "GDataXMLNode.h"
#import "TweetModel.h"
#import "TweetDetail.h"
#import "AppDelegate.h"

@interface LatestView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    int pageIndex;
}
@end
@implementation LatestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)loadTableView
{
    _dataArr = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupRefresh];
    [self autoRefresh];
    //注册TableViewCell
    UINib *customCell  = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:customCell forCellReuseIdentifier:@"TweetCell"];
}
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}
- (void)autoRefresh
{
    [self.tableView headerBeginRefreshing];
}
- (void)headerRefreshing
{
    NSString *url = [NSString stringWithFormat:@"%@?uid=%d&pageIndex=%d&pageSize=%d",api_tweet_list, 0,0, 20];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(_dataArr.count)
        {
            [_dataArr removeAllObjects];
        }
        [self anylaseXMLWithData:operation.responseData];
        [self.tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载动弹失败");
    }];
    pageIndex = 0;
}

- (void)footerRefreshing
{
    pageIndex ++;
    
    NSString *url = [NSString stringWithFormat:@"%@?uid=%d&pageIndex=%d&pageSize=%d",api_tweet_list, 0,pageIndex, 20];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self anylaseXMLWithData:operation.responseData];
        [self.tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载动弹失败!");
    }];
}

- (void)anylaseXMLWithData:(NSData *)data
{
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSString *xpath = @"/oschina/tweets/tweet";
    NSArray *arr = [document nodesForXPath:xpath error:nil];
    for(GDataXMLElement *element in arr)
    {
        TweetModel *model = [[TweetModel alloc] init];
        model._id = [[[element elementsForName:@"id"][0] stringValue] intValue];
        model.portraitUrl = [[element elementsForName:@"portrait"][0] stringValue];
        model.author = [[element elementsForName:@"author"][0] stringValue];
        model.authorID = [[[element elementsForName:@"authorid"][0] stringValue] intValue];
        model.appClient = [[[element elementsForName:@"appclient"][0] stringValue] intValue];;
        model.commentCount = [[[element elementsForName:@"commentCount"][0] stringValue] intValue];
        model.pubDate = [[element elementsForName:@"pubDate"][0] stringValue];
        model.img = [[element elementsForName:@"imgSmall"][0] stringValue];
        model.imgBig = [[element elementsForName:@"imgBig"][0] stringValue];
        model.tweet = [[element elementsForName:@"body"][0] stringValue];
        [_dataArr addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetModel *model = _dataArr[indexPath.row];
    CGFloat height;
    if([model.img isEqualToString:@""])
    {
        height = model.tweentSize.height + 68;
    }else{
        height = model.tweentSize.height + 148;
    }
    return (int)height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    if(_dataArr.count != 0)
    {
        
        [cell addImageView];
        cell.model = _dataArr[indexPath.row];
    }
    return cell;
}



//点击某行进入动弹详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetModel *model = _dataArr[indexPath.row];
    TweetDetail *detailCtl = [[TweetDetail alloc] initWithNibName:@"TweetDetail" bundle:nil];
    detailCtl.tweetID = model._id;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailCtl];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    AppDelegate *appDele = [UIApplication sharedApplication].delegate;
    [appDele.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

@end
