//
//  QAView.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-29.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "QAView.h"
#import "MJRefresh.h"
#import "QACell.h"
#import "GDataXMLNode.h"
#import "QAModel.h"
#import "UIImageView+WebCache.h"
#import "PAImageView.h"
#import "PostDetail.h"
#import "AppDelegate.h"

@interface QAView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    int pageIndex;
    
}
@end
@implementation QAView
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
    NSString *url = [NSString stringWithFormat:@"%@?catalog=1&pageIndex=%d&pageSize=%d", api_post_list, 1, 20];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(_dataArr.count)
        {
            [_dataArr removeAllObjects];
        }
        //XML数据解析
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:operation.responseData options:0 error:nil];
        NSString *xpath = @"/oschina/posts/post";
        NSArray *arr = [document nodesForXPath:xpath error:nil];
        
        for(GDataXMLElement *element in arr)
        {
            QAModel *model = [[QAModel alloc] init];
            model._id = [[[element elementsForName:@"id"][0] stringValue] intValue];
            model.title = [[element elementsForName:@"title"][0] stringValue];
            model.author = [[element elementsForName:@"author"][0] stringValue];
            model.authorid = [[[element elementsForName:@"authoruid"][0] stringValue] intValue];
            model.answerCount = [[[element elementsForName:@"answerCount"][0]stringValue] intValue];
            model.portraitUrl = [[element elementsForName:@"portrait"][0] stringValue];
            model.pubDate = [[element elementsForName:@"pubDate"][0] stringValue];
            [_dataArr addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载问答失败");
    }];
    pageIndex = 1;
    
}
- (void)footerRefreshing
{
    
    pageIndex ++;
    NSString *url = [NSString stringWithFormat:@"%@?catalog=1&pageIndex=%d&pageSize=%d", api_post_list,pageIndex, 20];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //XML数据解析
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:operation.responseData options:0 error:nil];
        NSString *xpath = @"/oschina/posts/post";
        NSArray *arr = [document nodesForXPath:xpath error:nil];
        
        for(GDataXMLElement *element in arr)
        {
            QAModel *model = [[QAModel alloc] init];
            model._id = [[[element elementsForName:@"id"][0] stringValue] intValue];
            model.title = [[element elementsForName:@"title"][0] stringValue];
            model.author = [[element elementsForName:@"author"][0] stringValue];
            model.authorid = [[[element elementsForName:@"authoruid"][0] stringValue] intValue];
            model.answerCount = [[[element elementsForName:@"answerCount"][0]stringValue] intValue];
            model.portraitUrl = [[element elementsForName:@"portrait"][0] stringValue];
            model.pubDate = [[element elementsForName:@"pubDate"][0] stringValue];
            [_dataArr addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载问答失败");
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QACell *cell = [tableView dequeueReusableCellWithIdentifier:@"QACell"];
    if(_dataArr.count != 0)
    {
        if(cell == nil)
        {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"QACell" owner:self options:nil];
            cell = arr[0];
            [cell addImageView];
        }
        QAModel *model = _dataArr[indexPath.row];
        if([model.portraitUrl isEqualToString:@""])
        {
            [cell.paImageView setDefaultImage];
        }else{
            [cell.paImageView setImageURL:model.portraitUrl];
        }
        cell.titleLabel.text = model.title;
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.authorLabel.text = [NSString stringWithFormat:@"%@ 发布于 %@",model.author,model.pubDate];
        cell.answerCountLabel.text = [NSString stringWithFormat:@"%d",model.answerCount];
    }
    return cell;
}
//点击进入详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QAModel *model = _dataArr[indexPath.row];
    PostDetail *detailCtl = [[PostDetail alloc] initWithNibName:@"PostDetail" bundle:nil];
    NSLog(@"%d",model._id);
    detailCtl.postID = model._id;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailCtl];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
    AppDelegate *appDele = [UIApplication sharedApplication].delegate;
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [appDele.window.rootViewController presentViewController:nav animated:YES completion:nil];
}
@end
