//
//  PostDetail.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-1.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "PostDetail.h"
#import "GDataXMLNode.h"
#import "SinglePostModel.h"

@interface PostDetail ()<UIWebViewDelegate>
{
    BOOL isFavoriteCliked;
}
@end

@implementation PostDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        label.text = @"帖子详情";
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
    NSString *url = [NSString stringWithFormat:@"%@?id=%d",api_post_detail, _postID];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",operation.responseString);
        [self loadDataWithXMLData:operation.responseData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载详情失败");
    }];
}
- (void)loadDataWithXMLData:(NSData *)data
{
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSString *xpath = @"/oschina/post";
    NSArray *arr = [document nodesForXPath:xpath error:nil];
    SinglePostModel *model = [[SinglePostModel alloc] init];
    for(GDataXMLElement *element in arr)
    {
        model._id = [[[element elementsForName:@"id"][0] stringValue] intValue];
        model.title = [[element elementsForName:@"title"][0] stringValue];
        model.url = [[element elementsForName:@"url"][0] stringValue];
        model.portrait = [[element elementsForName:@"portrait"][0] stringValue];
        model.body = [[element elementsForName:@"body"][0] stringValue];
        model.author = [[element elementsForName:@"author"][0] stringValue];
        model.authorid = [[[element elementsForName:@"authorid"][0] stringValue] intValue];
        model.answerCount = [[[element elementsForName:@"answerCount"][0] stringValue] intValue];
        model.viewCount = [[[element elementsForName:@"viewCount"][0] stringValue] intValue];
        model.pubDate = [[element elementsForName:@"pubDate"][0] stringValue];
        model.favorite = [[[element elementsForName:@"favorite"][0] stringValue] boolValue];
    }
    //刷新控件
    NSString *author_str = [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%d'>%@</a> 发布于 %@",model.authorid, model.author, model.pubDate];
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3;'>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div></body>",HTML_Style, model.title,author_str,model.body];
    [self.webView loadHTMLString:html baseURL:nil];
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
