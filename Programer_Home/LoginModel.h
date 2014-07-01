//
//  LoginModel.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-30.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
@property int errorCode;
@property (nonatomic,copy) NSString *errorMessage;

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *name;
@property int followers;
@property int fans;
@property int score;
@property (nonatomic,copy) NSString *portraitUrl;

@property (nonatomic,copy) NSString *atmeCount;
@property (nonatomic,copy) NSString *msgCount;
@property (nonatomic,copy) NSString *reviewCount;
//@property (nonatomic,copy) NSString *newFansCount;

@end
