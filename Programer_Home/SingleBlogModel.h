//
//  SingleBlogModel.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-1.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleBlogModel : NSObject
@property int _id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *where;
@property (nonatomic,copy) NSString *body;
@property (nonatomic,copy) NSString *author;
@property int authorid;
@property int documentType;
@property (nonatomic,copy) NSString *pubDate;
@property (nonatomic,copy) NSString *url;
@property int commentCount;
@property BOOL favorite;

@end
