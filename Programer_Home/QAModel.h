//
//  QAModel.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-29.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAModel : NSObject
@property int _id;
@property int answerCount;
@property int viewCount;
@property (copy,nonatomic) NSString * title;
@property (copy,nonatomic) NSString * author;
@property int authorid;
@property (copy,nonatomic) NSString * fromNowOn;
@property (copy,nonatomic) NSString * img;
@property (retain,nonatomic) UIImage * imgData;
@property (nonatomic,copy) NSString *portraitUrl;
@property (nonatomic,copy) NSString *pubDate;
@property BOOL favorite;
@end
