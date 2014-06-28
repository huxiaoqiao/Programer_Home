//
//  BlogView.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-27.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "BlogView.h"

@implementation BlogView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            }
    return self;
}

- (void)AFNetworkTest
{
    NSString *url = [NSString stringWithFormat:@"%@?type=latest&pageIndex=%d&pageSize=%d", api_blog_list, 2, 20];
    
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"博客列表读取出错！");
    }];
}

@end
