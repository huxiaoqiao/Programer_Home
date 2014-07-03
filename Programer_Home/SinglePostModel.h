//
//  SinglePostModel.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-1.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinglePostModel : NSObject
@property int _id;
@property (copy,nonatomic) NSString * title;
@property (copy,nonatomic) NSString * url;
@property (copy,nonatomic) NSString * portrait;
@property (copy,nonatomic) NSString * body;
@property (copy,nonatomic) NSString * author;
@property int authorid;
@property (copy,nonatomic) NSString * pubDate;
@property int answerCount;
@property int viewCount;
@property BOOL favorite;
@property (nonatomic) NSMutableArray * tags;
@end
