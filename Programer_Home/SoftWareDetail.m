//
//  SoftWareDetail.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-3.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "SoftWareDetail.h"
#import "SoftwareModel.h"
#import "GDataXMLNode.h"

@interface SoftWareDetail ()<UIWebViewDelegate>
{
    BOOL isFavoriteCliked;
}
@end

@implementation SoftWareDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        label.text = @"软件详情";
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
    [self createRightBnt];
    self.webView.delegate = self;
    [self loadDataFromNetwork];

}

- (void)loadDataFromNetwork
{
    NSString *url = [NSString stringWithFormat:@"%@?ident=%@",api_software_detail, _softwareName];
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
    NSString *xpath = @"/oschina/software";
    NSArray *arr = [document nodesForXPath:xpath error:nil];
     SoftwareModel *model = [[SoftwareModel alloc] init];
    for(GDataXMLElement *element in arr)
    {
        model._id = [[[element elementsForName:@"id"][0] stringValue] intValue];
        model.title = [[element elementsForName:@"title"][0] stringValue];
        model.url = [[element elementsForName:@"url"][0] stringValue];
        model.extensionTitle = [[element elementsForName:@"extensionTitle"][0] stringValue];
        model.license = [[element elementsForName:@"license"][0] stringValue];
        model.body = [[element elementsForName:@"body"][0] stringValue];
        model.homePage = [[element elementsForName:@"homepage"][0] stringValue];
        model.document = [[element elementsForName:@"document"][0] stringValue];
        model.download = [[element elementsForName:@"download"][0] stringValue];
        model.logo = [[element elementsForName:@"logo"][0] stringValue];
        model.language = [[element elementsForName:@"language"][0] stringValue];
        model.os = [[element elementsForName:@"os"][0] stringValue];
        model.recordTime = [[element elementsForName:@"recordtime"][0] stringValue];
        model.favorite = [[[element elementsForName:@"favorite"][0] stringValue] boolValue];
    }
    //刷新控件
    NSString *str_title = [NSString stringWithFormat:@"%@ %@", model.extensionTitle,model.title];
    NSString *tail = [NSString stringWithFormat:@"<div>授权协议: %@</div><div>开发语言: %@</div><div>操作系统: %@</div><div>收录时间: %@</div>",
                      model.license,model.language,model.os,model.recordTime];
    tail = [NSString stringWithFormat:@"<div><table><tr><td style='font-weight:bold'>授权协议:&nbsp;</td><td>%@</td></tr><tr><td style='font-weight:bold'>开发语言:</td><td>%@</td></tr><tr><td style='font-weight:bold'>操作系统:</td><td>%@</td></tr><tr><td style='font-weight:bold'>收录时间:</td><td>%@</td></tr></table></div>",model.license,model.language,model.os,model.recordTime];
    
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@<div id='oschina_title'><img src='%@' width='34' height='34'/>%@</div><hr/><div id='oschina_body'>%@</div><div>%@</div>%@%@</body>",HTML_Style,model.logo,str_title,model.body,tail, [self getButtonString:model.homePage andDocument:model.document andDownload:model.download],HTML_Bottom];
    
   
    [self.webView loadHTMLString:html baseURL:nil];
}

- (NSString *)getButtonString:(NSString *)homePage andDocument:(NSString *)document andDownload:(NSString *)download
{
    NSString *strHomePage = @"";
    NSString *strDocument = @"";
    NSString *strDownload = @"";
    if ([homePage isEqualToString:@""] == NO) {
        strHomePage = [NSString stringWithFormat:@"<a href=%@><input type='button' value='软件首页' style='font-size:14px;'/></a>", homePage];
    }
    if ([document isEqualToString:@""] == NO) {
        strDocument = [NSString stringWithFormat:@"<a href=%@><input type='button' value='软件文档' style='font-size:14px;'/></a>", document];
    }
    if ([download isEqualToString:@""] == NO) {
        strDownload = [NSString stringWithFormat:@"<a href=%@><input type='button' value='软件下载' style='font-size:14px;'/></a>", download];
    }
    return [NSString stringWithFormat:@"<p>%@&nbsp;&nbsp;%@&nbsp;&nbsp;%@</p>", strHomePage, strDocument, strDownload];
}
#pragma 浏览器链接处理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
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
- (void)createRightBnt
{
    UIButton *favoriteBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteBnt.frame = CGRectMake(0, 0, 30, 30);
    [favoriteBnt setImage:[UIImage imageNamed:@"account_1"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:favoriteBnt];
    [favoriteBnt addTarget:self action:@selector(clickFavoriteBnt:) forControlEvents:UIControlEventTouchUpInside];
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
