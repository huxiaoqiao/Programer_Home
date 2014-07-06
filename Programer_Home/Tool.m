//
//  Tool.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-4.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "Tool.h"

@implementation Tool
//+ (BOOL)analysis:(NSString *)url andNavController:(UINavigationController *)navController
//{
//    NSString *search = @"oschina.net";
//    //判断是否包含 oschina.net 来确定是不是站内链接
//    NSRange rng = [url rangeOfString:search];
//    if(rng.length == 0)
//    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//        return NO;
//    }
//    //站内链接
//    else
//    {
//        url = [url substringFromIndex:7];
//        NSString *prefix = [url substringToIndex:3];
//        
////        //此情况为 博客,动弹,个人专页
////        if([prefix isEqualToString:@"my."])
////        {
////            NSArray *array = [url componentsSeparatedByString:@"/"];
////            if(array.count <= 2){
////               //个人专页 用户名形式
////                return YES;
////            }
////        }
//        
//        //------2014.7.4--现只考虑软件/新闻/问答，其他以后再添加
//        if([prefix isEqualToString:@"www"])
//        {
//            NSArray *arr = [url componentsSeparatedByString:@"/"];
//            int count = [arr count];
//            if(count >= 3)
//             
//        }
//        
//    }
//}
@end
