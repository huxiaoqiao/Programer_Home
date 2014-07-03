//
//  MyView.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-2.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "MyView.h"
#import "MJRefresh.h"
#import "TweetCell.h"
#import "GDataXMLNode.h"
#import "TweetModel.h"

@interface MyView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    int pageIndex;
}
@end
@implementation MyView

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
    NSString *url = [NSString stringWithFormat:@"%@?uid=%d&pageIndex=%d&pageSize=%d",api_tweet_list, -1,1, 20];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
        if(_dataArr.count)
        {
            [_dataArr removeAllObjects];
        }
        [self anylaseXMLWithData:operation.responseData];
        [self.tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载动弹失败");
    }];
    pageIndex = 1;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    if(_dataArr.count != 0)
    {
        if(cell == nil)
        {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil];
            cell = arr[0];
            [cell addImageView];
        }
        cell.model = _dataArr[indexPath.row];
    }
    return cell;
}
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
        height = 30 + model.tweentSize.height + 10 + 28;
    }else{
        height = 30 + model.tweentSize.height + 75 + 10 + 28;
    }
    return height;
}
@end
