//
//  NewsDetail.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-1.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "NewsDetail.h"
#import "GDataXMLNode.h"
#import "SingleNewsModel.h"
#import "RelativeNewsModel.h"


@interface NewsDetail ()<UIWebViewDelegate>
{
    BOOL isFavoriteCliked;
    UIButton *_favoriteBtn;
}
@end

@implementation NewsDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        label.text = @"新闻详情页";
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
    self.webView.delegate = self;
    [self createBackBnt];
    [self createRightBnt];
    [self loadDataFromNetwork];
}

- (void)loadDataFromNetwork
{
    NSString *url = [NSString stringWithFormat:@"%@?id=%d",api_news_detail, _newsID];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self loadDataWithXMLData:operation.responseData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载详情失败");
    }];
}

- (void)loadDataWithXMLData:(NSData *)data
{
    //XML解析
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSString *xpath = @"/oschina/news";
    NSArray *arr = [document nodesForXPath:xpath error:nil];
    SingleNewsModel *model = [[SingleNewsModel alloc] init];
    for(GDataXMLElement *element in arr)
    {
        model._id = [[[element elementsForName:@"id"][0] stringValue] intValue];
        model.title = [[element elementsForName:@"title"][0] stringValue];
        model.url = [[element elementsForName:@"url"][0] stringValue];
        model.body = [[element elementsForName:@"body"][0] stringValue];
        model.commentCount = [[[element elementsForName:@"commentCount"][0] stringValue] intValue];
        model.author = [[element elementsForName:@"author"][0] stringValue];
        model.authorid = [[[element elementsForName:@"authorid"][0] stringValue] intValue];
        model.pubDate = [[element elementsForName:@"pubDate"][0] stringValue];
        model.softwarelink = [[element elementsForName:@"softwarelink"][0] stringValue];
        model.softwarename = [[element elementsForName:@"softwarename"][0] stringValue];
        model.favorite = [[[element elementsForName:@"favorite"][0] stringValue] boolValue];
    }
    if(model.favorite == 1)
    {
        [_favoriteBtn setImage:[UIImage imageNamed:@"account_1_s"] forState:UIControlStateNormal];
    }else
    {
        [_favoriteBtn setImage:[UIImage imageNamed:@"account_1"] forState:UIControlStateNormal];
    }
    NSString *xpath2 = @"/oschina/news/relativies/relative";
    NSArray *arr2 = [document nodesForXPath:xpath2 error:nil];
    model.relativies = [NSMutableArray array];
    for(GDataXMLElement *element in arr2)
    {
        RelativeNewsModel *model2 = [[RelativeNewsModel alloc] init];
        model2.title = [[element elementsForName:@"rtitle"][0] stringValue];
        model2.url = [[element elementsForName:@"rurl"][0] stringValue];
        NSLog(@"%@",model2.title);
        [model.relativies addObject:model2];
    }
    //控件更新
    NSString *author_str = [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%d'>%@</a> 发布于 %@",model.authorid,model.author,model.pubDate];
    
    NSString *software = @"";
    if ([model.softwarename isEqualToString:@""] == NO) {
        software = [NSString stringWithFormat:@"<div id='oschina_software' style='margin-top:8px;color:#FF0000;font-size:14px;font-weight:bold'>更多关于:&nbsp;<a href='%@'>%@</a>&nbsp;的详细信息</div>",model.softwarelink, model.softwarename];
    }
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@%@%@</body>",HTML_Style, model.title,author_str, model.body,software,[self generateRelativeNewsString:model.relativies],HTML_Bottom];
    [self.webView loadHTMLString:html baseURL:nil];
    
}

- (NSString *)generateRelativeNewsString:(NSArray *)array
{
    NSLog(@"%d",array.count);
    if (array == nil || [array count] == 0) {
        return @"";
    }
    NSString *middle = @"";
    for (RelativeNewsModel *r in array) {
        middle = [NSString stringWithFormat:@"%@<a href=%@ style='text-decoration:none'>%@</a><p/>",middle, r.url, r.title];
    }
    return [NSString stringWithFormat:@"<hr/>相关文章<div style='font-size:14px'><p/>%@</div>", middle];
}
#pragma mark - UIWebViewDelegate
//浏览器链接处理--------------2014.7.1-未处理-------------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
//-------------------------------------------------------------------

- (void)createBackBnt
{
    UIButton *backBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    backBnt.frame = CGRectMake(0, 0, 30, 30);
    [backBnt setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBnt addTarget:self action:@selector(backToFrontView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBnt];
}
- (void)createRightBnt
{
    _favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _favoriteBtn.frame = CGRectMake(0, 0, 30, 30);
    [_favoriteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_favoriteBtn];
    [_favoriteBtn addTarget:self action:@selector(clickFavoriteBnt:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)backToFrontView
{
    if(_isFavoriteCtlPush)
    {
        [self.navigationController popViewControllerAnimated:YES];
        _isFavoriteCtlPush = NO;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//收藏键被点击
- (void)clickFavoriteBnt:(UIButton *)sender;
{
    if(!isFavoriteCliked)
    {
        [sender setImage:[UIImage imageNamed:@"account_1_s"] forState:UIControlStateNormal];
        isFavoriteCliked = YES;
        //收藏---------------------------
        
    }else{
        [sender setImage:[UIImage imageNamed:@"account_1"] forState:UIControlStateNormal];
        isFavoriteCliked = NO;
        //取消收藏-------------------------
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
