//
//  SingleNewsModel.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-1.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleNewsModel : NSObject
@property int _id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *body;
@property (nonatomic,copy) NSString *author;
@property int authorid;
@property (nonatomic,copy) NSString *pubDate;
@property int commentCount;
@property (nonatomic) NSMutableArray *relativies;
@property (nonatomic,copy) NSString *softwarelink;
@property (nonatomic,copy) NSString *softwarename;
@property BOOL favorite;
@end
