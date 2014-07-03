//
//  TweetDetail.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-2.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "TweetDetail.h"
#import "GDataXMLNode.h"
#import "TweetModel.h"

@interface TweetDetail ()<UIWebViewDelegate>

@end

@implementation TweetDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        label.text = @"动弹详情";
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
    [self loadDataFromNetwork];
    self.webView.delegate = self;
}

- (void)loadDataFromNetwork
{
    NSString *url = [NSString stringWithFormat:@"%@?id=%d", api_tweet_detail, _tweetID];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
        [self loadDataWithXMLData:operation.responseData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载详情失败");
    }];
}

- (void)loadDataWithXMLData:(NSData *)data
{
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSString *xpath = @"/oschina/tweet";
    NSArray *arr = [document nodesForXPath:xpath error:nil];
    TweetModel *model = [[TweetModel alloc] init];
    for(GDataXMLElement *element in arr)
    {
        model._id = [[[element elementsForName:@"id"][0] stringValue] intValue];
        model.tweet = [[element elementsForName:@"body"][0] stringValue];
        model.author = [[element elementsForName:@"author"][0] stringValue];
        model.authorID = [[[element elementsForName:@"authorid"][0] stringValue] intValue];
        model.commentCount = [[[element elementsForName:@"commentCount"][0] stringValue] intValue];
        model.portraitUrl = [[element elementsForName:@"portrait"][0] stringValue];
        model.appClient = [[[element elementsForName:@"appclient"][0] stringValue] intValue];
        model.pubDate = [[element elementsForName:@"pubDate"][0] stringValue];
        model.img = [[element elementsForName:@"imgSmall"][0] stringValue];
        model.imgBig = [[element elementsForName:@"imgBig"][0] stringValue];
        model.attach = [[element elementsForName:@"attach"][0] stringValue];
    }
    //刷新控件
    NSString *imgHtml = @"";
    if ([model.imgBig isEqualToString:@""] == NO) {
        imgHtml = [NSString stringWithFormat:@"<br/><a href='http://wangjuntom'><img style='max-width:300px;' src=' '/></a>"];
    }
    NSString *html = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><script type='text/javascript'></script></head>%@<body style='background-color:#EBEBF3'><div id='oschina_title'><a href='http://my.oschina.net/u/%d'>%@</a></div><div id='oschina_outline'>%@</div><br/><div id='oschina_body' style='font-weight:bold;font-size:14px;line-height:21px;'>%@</div>%@%@</body></html>",HTML_Style, model.authorID, model.author,model.pubDate,model.tweet,imgHtml,HTML_Bottom];
    [self.webView loadHTMLString:html baseURL:nil];
}

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
