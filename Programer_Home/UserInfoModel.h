//
//  UserInfoModel.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-30.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *portraitUrl;
@property (nonatomic,copy) NSString *joinTime;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *from;
@property (nonatomic,copy) NSString *dev;
@property (nonatomic,copy) NSString *expertise;
@property int favoriteCount;
@property int fansCount;
@property int followersCount;

@end
