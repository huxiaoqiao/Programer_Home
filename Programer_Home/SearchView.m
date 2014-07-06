//
//  SearchView.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-4.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "SearchView.h"
#import "PPRevealSideViewController.h"
#import "CCSegmentedControl.h"
#import "NYSegmentedControl.h"
#import "MJRefresh.h"
#import "GDataXMLNode.h"
#import "FavoriteModel.h"
#import "SoftWareDetail.h"
#import "PostDetail.h"
#import "BlogDetail.h"
#import "NewsDetail.h"

@interface SearchView ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NYSegmentedControl *_segmentCtl;
    NSInteger allCount;
    NSMutableArray *_dataArr;
    int pageIndex;
    BOOL isFootRefresh;
}
@end

@implementation SearchView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    allCount = 0;
    //self.searchBarView.backgroundColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
    //设置TableView代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self createSegmentCtl];
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    _dataArr = [NSMutableArray array];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    pageIndex = 0;
}
- (void)createSegmentCtl
{
    NSArray *arr = @[@"搜软件",@"搜帖子",@"搜博客",@"搜资讯"];
    _segmentCtl = [[NYSegmentedControl alloc] initWithItems:arr];
    _segmentCtl.frame = CGRectMake(0, 44, 320, 26);
    
    [self.searchBarView addSubview:_segmentCtl];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_dataArr removeAllObjects];
    if(_searchBar.text.length == 0)
    {
        return;
    }
    [self doSearch];
    [self.searchBar resignFirstResponder];
    pageIndex = 0;
    isFootRefresh = NO;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if(_dataArr.count)
    {
        [_dataArr removeAllObjects];
    }
    [self.tableView reloadData];
}


- (void)doSearch
{
    NSString *catalog;
    switch (_segmentCtl.selectedSegmentIndex) {
        case 0:
            catalog = @"software";
            break;
            case 1:
            catalog = @"post";
            break;
            case 2:
            catalog = @"blog";
            break;
            case 3:
            catalog = @"news";
            break;
        default:
            break;
    }
    if(isFootRefresh)
    {
        pageIndex ++;
    }
    [[AFOSCClient sharedClient] postPath:api_search_list parameters:[NSDictionary dictionaryWithObjectsAndKeys:self.searchBar.text,@"content",catalog,@"catalog",[NSString stringWithFormat:@"%d",pageIndex],@"pageIndex",@"20",@"pageSize", nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",operation.responseString);
        [self analyseXMLWithXMLData:operation.responseData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"搜索失败");
    }];
    
    
}

- (void)analyseXMLWithXMLData:(NSData *)data
{
    if(isFootRefresh == NO)
    {
        if(_dataArr.count)
        {
            [_dataArr removeAllObjects];
        }
    }
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSString *xpath = @"/oschina";
    GDataXMLElement *element = [document nodesForXPath:xpath error:nil][0];
        if([[[element elementsForName:@"pagesize"][0] stringValue] intValue] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"查无结果" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if([[[element elementsForName:@"pagesize"][0] stringValue] intValue] == 1&&_dataArr.count != 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"已加载完毕" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else
    {
        NSString *xpath2 = @"/oschina/results/result";
        NSArray *arr = [document nodesForXPath:xpath2 error:nil];
        for(GDataXMLElement *element in arr)
        {
            FavoriteModel *model = [[FavoriteModel alloc] init];
            model.objid = [[[element elementsForName:@"objid"][0] stringValue] intValue];
            model.searchType = [[element elementsForName:@"type"][0] stringValue];
            model.url = [[element elementsForName:@"url"][0] stringValue];
            model.pubDate = [[element elementsForName:@"pubDate"][0] stringValue];
            model.author = [[element elementsForName:@"author"][0] stringValue];
            model.title = [[element elementsForName:@"title"][0] stringValue];
            [_dataArr addObject:model];
        }
    }
    NSLog(@"%d",_dataArr.count);
    [self.tableView reloadData];
    if(isFootRefresh)
    {
        [self.tableView footerEndRefreshing];
    }
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
    if(_dataArr.count != 0)
    {
        FavoriteModel *model = _dataArr[indexPath.row];
        cell.textLabel.text = model.title;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataArr.count != 0)
    {
        FavoriteModel *model = _dataArr[indexPath.row];
        
        switch (_segmentCtl.selectedSegmentIndex) {
            case 0:
            {
                NSArray *arr = [model.url componentsSeparatedByString:@"/"];
                NSString *prefix = [arr lastObject];
                SoftWareDetail *softDetail = [[SoftWareDetail alloc] initWithNibName:@"SoftWareDetail" bundle:nil];
                softDetail.softwareName = prefix;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:softDetail];
                nav.navigationBar.translucent = NO;
                nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
                case 1:
            {
                PostDetail *postDetail = [[PostDetail alloc] initWithNibName:@"PostDetail" bundle:nil];
                postDetail.postID = model.objid;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:postDetail];
                nav.navigationBar.translucent = NO;
                nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
                case 2:
            {
                BlogDetail *blogDetail = [[BlogDetail alloc] initWithNibName:@"BlogDetail" bundle:nil];
                blogDetail.blogID = model.objid;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:blogDetail];
                nav.navigationBar.translucent = NO;
                nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
                case 3:
            {
                NewsDetail *newsDetail = [[NewsDetail alloc] initWithNibName:@"NewsDetail" bundle:nil];
                newsDetail.newsID = model.objid;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:newsDetail];
                nav.navigationBar.translucent = NO;
                nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}

- (void)footerRefreshing
{
    isFootRefresh = YES;
    [self doSearch];
    
}


- (IBAction)cancelPressed:(UIButton *)sender {
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
