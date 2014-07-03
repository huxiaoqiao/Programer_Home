//
//  NewsView.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-27.
//  Copyright (c) 2014年 Apple.Inc All rights reserved.
//

#import "NewsView.h"
#import "MJRefresh.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "GDataXMLNode.h"
#import "NewsDetail.h"
#import "AppDelegate.h"


@interface NewsView()
{
    NSMutableArray *_dataArr;
    int pageIndex;
}
@end

@implementation NewsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)loadTableView
{
    pageIndex = 0;
    _dataArr = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupRefresh];
    [self autoRefresh];

}

- (void)autoRefresh
{
    [self.tableView headerBeginRefreshing];
}
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}
//下拉刷新
- (void)headerRefreshing
{
    //网络上加载数据
    NSString *url = [NSString stringWithFormat:@"%@?catalog=%d&pageIndex=%d&pageSize=%d", api_news_list, 1,1, 20];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(_dataArr.count)
        {
            [_dataArr removeAllObjects];
        }
        //XML数据解析
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:operation.responseData options:0 error:nil];
        NSString *xpath = @"/oschina/newslist/news";
        NSArray *arr = [document nodesForXPath:xpath error:nil];
        
        for(GDataXMLElement *element in arr)
        {
            NewsModel *model = [[NewsModel alloc] init];
            model._id = [[[element elementsForName:@"id"][0] stringValue] intValue];
            model.title = [[element elementsForName:@"title"][0] stringValue];
            model.author = [[element elementsForName:@"author"][0] stringValue];
            model.authorId = [[[element elementsForName:@"authorid"][0] stringValue] intValue];
            model.commentCount = [[[element elementsForName:@"commentCount"][0]stringValue] intValue];
            model.pubDate = [[element elementsForName:@"pubDate"][0] stringValue];
            model.newsType = [[[element elementsForName:@"newstype"][0] stringValue] intValue];
            //model.authoruid2 = [[[element elementsForName:@"newstype"][1] stringValue] intValue];
            [_dataArr addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载新闻失败");
    }];
    pageIndex = 0;
}
//上拉刷新
- (void)footerRefreshing
{
    pageIndex ++;
    NSLog(@"%d",pageIndex);
    NSString *url = [NSString stringWithFormat:@"%@?catalog=%d&pageIndex=%d&pageSize=%d", api_news_list, 1,pageIndex, 20];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //XML数据解析
        //NSLog(@"%@",operation.responseString);
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:operation.responseData options:0 error:nil];
        NSString *xpath = @"/oschina/newslist/news";
        NSArray *arr = [document nodesForXPath:xpath error:nil];
        
        for(GDataXMLElement *element in arr)
        {
            NewsModel *model = [[NewsModel alloc] init];
            model._id = [[[element elementsForName:@"id"][0] stringValue] intValue];
            model.title = [[element elementsForName:@"title"][0] stringValue];
            model.author = [[element elementsForName:@"author"][0] stringValue];
            model.authorId = [[[element elementsForName:@"authorid"][0] stringValue] intValue];
            model.commentCount = [[[element elementsForName:@"commentCount"][0]stringValue] intValue];
            model.pubDate = [[element elementsForName:@"pubDate"][0] stringValue];
            model.newsType = [[[element elementsForName:@"newstype"][0] stringValue] intValue];
            //model.authoruid2 = [[[element elementsForName:@"newstype"][1] stringValue] intValue];
            [_dataArr addObject:model];
        }
        NSLog(@"_dataArr.count is %d",_dataArr.count);
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载新闻失败");
    }];

}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    if(_dataArr.count != 0)
    {
        if(cell == nil)
        {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
            cell = arr[0];
        }
        NewsModel *model = _dataArr[indexPath.row];
        cell.titleLabel.text = model.title;
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.pubDateLabel.text = [NSString stringWithFormat:@"%@ 发布于 %@ (%d评)",model.author,model.pubDate,model.commentCount];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

//选中某项
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *model = _dataArr[indexPath.row];
    AppDelegate *appDele = [UIApplication sharedApplication].delegate;
    NewsDetail *detailCtl = [[NewsDetail alloc] initWithNibName:@"NewsDetail" bundle:nil];
    detailCtl.newsID = model._id;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailCtl];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.barTintColor = [UIColor colorWithRed:41/255.0 green:42/255.0 blue:56/255.0 alpha:1];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [appDele.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
}

@end
