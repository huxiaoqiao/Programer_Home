//
//  SoftwareModel.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-3.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoftwareModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *description;
@property (nonatomic,copy) NSString *url;
@property int tag;


@property int _id;
@property (copy,nonatomic) NSString * title;
@property (copy,nonatomic) NSString * extensionTitle;
@property (copy,nonatomic) NSString * license;
@property (copy,nonatomic) NSString * body;
@property (copy,nonatomic) NSString * homePage;
@property (copy,nonatomic) NSString * document;
@property (copy,nonatomic) NSString * download;
@property (copy,nonatomic) NSString * logo;
@property (copy,nonatomic) NSString * language;
@property (copy,nonatomic) NSString * os;
@property (copy,nonatomic) NSString * recordTime;
@property BOOL favorite;

@end
