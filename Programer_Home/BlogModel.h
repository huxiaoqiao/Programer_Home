//
//  BlogModel.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-28.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogModel : NSObject
@property int _id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *author;
@property int authorId;
@property (nonatomic,copy) NSString *pubDate;
@property int commentCount;
@property int newsType;
@property (nonatomic,copy) NSString *attachment;
@property int authoruid2;
@property long type;

@end
