//
//  TweetModel.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-2.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "TweetModel.h"

@implementation TweetModel
- (void)setTweet:(NSString *)tweet
{
    if(_tweet != tweet)
    {
        _tweet = nil;
        _tweet = tweet;
    }
    _tweentSize = [_tweet sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 2000)];
}
@end
