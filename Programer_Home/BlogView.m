//
//  BlogView.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-27.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "BlogView.h"
#import "MJRefresh.h"
#import "BlogCell.h"
#import "GDataXMLNode.h"
#import "BlogModel.h"

@interface BlogView()
{
    NSMutableArray *_dataArr;
    int pageIndex;
}
@end
@implementation BlogView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    //网络上加载数据
    NSString *url = [NSString stringWithFormat:@"%@?type=latest&pageIndex=%d&pageSize=%d", api_blog_list, 1, 20];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(_dataArr.count)
            {
                [_dataArr removeAllObjects];
            }
        //XML数据解析
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:operation.responseData options:0 error:nil];
        NSString *xpath = @"/oschina/blogs/blog";
        NSArray *arr = [document nodesForXPath:xpath error:nil];
        
        for(GDataXMLElement *element in arr)
        {
            BlogModel *model = [[BlogModel alloc] init];
            model._id = [[[element elementsForName:@"id"][0] stringValue] intValue];
            model.title = [[element elementsForName:@"title"][0] stringValue];
            model.author = [[element elementsForName:@"authorname"][0] stringValue];
            model.authorId = [[[element elementsForName:@"authoruid"][0] stringValue] intValue];
            model.commentCount = [[[element elementsForName:@"commentCount"][0]stringValue] intValue];
            model.url = [[element elementsForName:@"url"][0] stringValue];
            model.pubDate = [[element elementsForName:@"pubDate"][0] stringValue];
            model.Type = [[[element elementsForName:@"documentType"][0] stringValue] intValue];
            [_dataArr addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载博客失败");
    }];
    pageIndex = 0;

}
- (void)footerRefreshing
{
   
    pageIndex ++;
    NSString *url = [NSString stringWithFormat:@"%@?type=latest&pageIndex=%d&pageSize=%d", api_blog_list,pageIndex, 20];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //XML数据解析
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:operation.responseData options:0 error:nil];
        NSString *xpath = @"/oschina/blogs/blog";
        NSArray *arr = [document nodesForXPath:xpath error:nil];
        
        for(GDataXMLElement *element in arr)
        {
            BlogModel *model = [[BlogModel alloc] init];
            model._id = [[[element elementsForName:@"id"][0] stringValue] intValue];
            model.title = [[element elementsForName:@"title"][0] stringValue];
            model.author = [[element elementsForName:@"authorname"][0] stringValue];
            model.authorId = [[[element elementsForName:@"authoruid"][0] stringValue] intValue];
            model.commentCount = [[[element elementsForName:@"commentCount"][0]stringValue] intValue];
            model.url = [[element elementsForName:@"url"][0] stringValue];
            model.pubDate = [[element elementsForName:@"pubDate"][0] stringValue];
            model.Type = [[[element elementsForName:@"documentType"][0] stringValue] intValue];
            [_dataArr addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载博客失败");
    }];
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlogCell"];
    if(_dataArr.count != 0)
    {
        if(cell == nil)
        {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"BlogCell" owner:self options:nil];
            cell = arr[0];
        }
        BlogModel *model = _dataArr[indexPath.row];
        cell.titleLabel.text = model.title;
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.authorLabel.text = [NSString stringWithFormat:@"%@ %@ %@ (%d评)",model.author,model.type==1?@"原创":@"转载",model.pubDate,model.commentCount];
    }
    return cell;
}

@end
