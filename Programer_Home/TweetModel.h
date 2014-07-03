//
//  TweetModel.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-2.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetModel : NSObject
@property int _id;
@property (nonatomic,copy) NSString * author;
@property int authorID;
@property (nonatomic,copy) NSString * tweet;
@property (nonatomic,readonly,assign) CGSize tweentSize;
@property (nonatomic,copy) NSString * fromNowOn;
@property (nonatomic,copy) NSString * img;
@property (nonatomic,retain) UIImage * imgData;
@property int commentCount;
@property (nonatomic,copy) NSString * imgTweet;
@property (nonatomic,retain) UIImage * imgTweetData;
@property (nonatomic,copy) NSString * imgBig;
@property (nonatomic,copy) NSString * attach;
@property int appClient;
@property int height;
@property (nonatomic,copy) NSString *portraitUrl;
@property (nonatomic,copy) NSString *pubDate;
@end
