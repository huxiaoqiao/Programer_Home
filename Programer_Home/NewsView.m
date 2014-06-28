//
//  NewsView.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-27.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "NewsView.h"
#import "MJRefresh.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "GDataXMLNode.h"

@interface NewsView()<ASIHTTPRequestDelegate>
{
    NSMutableArray *_dataArr;
    ASIHTTPRequest *_request1;
    ASIHTTPRequest *_request2;
    int pageIndex;
    BOOL isHeaderRefresh;
    BOOL isFooterRefresh;
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
    pageIndex = 1;
    _dataArr = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupRefresh];
    [self autoRefresh];
    isHeaderRefresh = NO;

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
    //网络加载数据
    _request1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?catalog=%d&pageIndex=%d&pageSize=%d", api_news_list, 1,1, 20]]];
    _request1.delegate = self;
    [_request1 startAsynchronous];
    isHeaderRefresh = YES;
    pageIndex = 0;
}
//上拉刷新
- (void)footerRefreshing
{
    isHeaderRefresh = NO;
    pageIndex ++;
    _request2 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?catalog=%d&pageIndex=%d&pageSize=%d", api_news_list, 1,pageIndex, 20]]];
    _request2.delegate = self;
    [_request2 startAsynchronous];
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(isHeaderRefresh)
    {
        if(_dataArr.count)
        {
            [_dataArr removeAllObjects];
        }
    }
        //XML数据解析
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:[request responseData] options:0 error:nil];
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
    if(request == _request1)
    {
        [self.tableView headerEndRefreshing];
    }else
    {
        [self.tableView footerEndRefreshing];
    }
   
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载失败");
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
            NewsModel *model = _dataArr[indexPath.row];
            cell.titleLabel.text = model.title;
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.pubDateLabel.text = [NSString stringWithFormat:@"%@ 发布于 %@ (%d评)",model.author,model.pubDate,model.commentCount];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}
@end
