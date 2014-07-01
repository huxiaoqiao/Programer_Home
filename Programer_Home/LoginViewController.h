//
//  LoginViewController.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getTheUserInfo <NSObject>

- (void)getUserName:(NSString *)name UserPortrait:(NSString *) portrait
                Uid:(NSString *)uid;

@end

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *accoutTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *btnView;

@property (nonatomic,weak) id<getTheUserInfo>delegate;
- (IBAction)login:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@end
