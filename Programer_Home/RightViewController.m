//
//  RightViewController.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "RightViewController.h"
#import "LoginViewController.h"
#import "MyHomeViewController.h"
#import "FavoriteView.h"

@interface RightViewController ()<getTheUserInfo,UIAlertViewDelegate>
{
    LoginViewController * loginCtl;
}
@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     loginCtl = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginCtl.delegate = self;
    _paImageView = [[PAImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65) backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor grayColor]];
    [self.portraitView addSubview:_paImageView];
    _paImageView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Login:(UIButton *)sender {
    if(_isLogin)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else
    {
        [self presentViewController:loginCtl animated:YES completion:nil];
    }
}

- (IBAction)loginOut:(UIButton *)sender {
}

- (IBAction)btn1Pressed:(UIButton *)sender {
    if(!_isLogin)
    {
        [self presentViewController:loginCtl animated:YES completion:nil];
    }else{
        CGAffineTransform left = CGAffineTransformMakeRotation(-10*M_PI/180);
        CGAffineTransform right = CGAffineTransformMakeRotation(10*M_PI/180);
        CGAffineTransform zero = CGAffineTransformMakeRotation(0);
        
        [UIView animateWithDuration:0.1 animations:^{
            self.imageView1.transform = left;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.imageView1.transform = right;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.imageView1.transform = zero;
                    FavoriteView *favCtl = [[FavoriteView alloc] initWithNibName:@"FavoriteView" bundle:nil];
                    if(self.uid != nil)
                    {
                        favCtl.uid = self.uid;
                    }
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:favCtl];
                    nav.navigationBar.translucent = NO;
                    nav.navigationBar.barTintColor = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:250/255.0 alpha:1];
                    [self presentViewController:nav animated:YES completion:nil];
                }];
            }];
        }];
    }
}

- (IBAction)btn2Pressed:(UIButton *)sender {
   
    if(!_isLogin)
    {
        [self presentViewController:loginCtl animated:YES completion:nil];
    }else{
    CGAffineTransform left = CGAffineTransformMakeRotation(-10*M_PI/180);
    CGAffineTransform right = CGAffineTransformMakeRotation(10*M_PI/180);
    CGAffineTransform zero = CGAffineTransformMakeRotation(0);
    
    [UIView animateWithDuration:0.1 animations:^{
        self.imageView2.transform = left;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView2.transform = right;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.imageView2.transform = zero;
                
            }];
        }];
    }];
    }
}

- (IBAction)btn3Pressed:(UIButton *)sender {
    if(!_isLogin)
    {
        [self presentViewController:loginCtl animated:YES completion:nil];
    }else{
    CGAffineTransform left = CGAffineTransformMakeRotation(-10*M_PI/180);
    CGAffineTransform right = CGAffineTransformMakeRotation(10*M_PI/180);
    CGAffineTransform zero = CGAffineTransformMakeRotation(0);
    
    [UIView animateWithDuration:0.1 animations:^{
        self.imageView3.transform = left;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView3.transform = right;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.imageView3.transform = zero;
            }];
        }];
    }];
    }
}

- (IBAction)btn4Pressed:(UIButton *)sender {
    if(!_isLogin)
    {
        [self presentViewController:loginCtl animated:YES completion:nil];
    }else{
    CGAffineTransform left = CGAffineTransformMakeRotation(-10*M_PI/180);
    CGAffineTransform right = CGAffineTransformMakeRotation(10*M_PI/180);
    CGAffineTransform zero = CGAffineTransformMakeRotation(0);
    
    [UIView animateWithDuration:0.1 animations:^{
        self.imageView4.transform = left;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView4.transform = right;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.imageView4.transform = zero;
                MyHomeViewController *myHome = [[MyHomeViewController alloc] initWithNibName:@"MyHomeViewController" bundle:nil];
                if(self.uid != nil)
                {
                    myHome.uid = self.uid;
                }
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myHome];
                nav.navigationBar.barTintColor = [UIColor colorWithRed:41/255.0 green:42/255.0 blue:56/255.0 alpha:1];
                [self presentViewController:nav animated:YES completion:nil];
            }];
        }];
    }];
    }
}

- (IBAction)btn5Pressed:(UIButton *)sender {
    
    CGAffineTransform left = CGAffineTransformMakeRotation(-10*M_PI/180);
    CGAffineTransform right = CGAffineTransformMakeRotation(10*M_PI/180);
    CGAffineTransform zero = CGAffineTransformMakeRotation(0);
    
    [UIView animateWithDuration:0.1 animations:^{
        self.imageView5.transform = left;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView5.transform = right;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.imageView5.transform = zero;
            }];
        }];
    }];
    
}

- (IBAction)btn6Pressed:(UIButton *)sender {
    
    CGAffineTransform left = CGAffineTransformMakeRotation(-10*M_PI/180);
    CGAffineTransform right = CGAffineTransformMakeRotation(10*M_PI/180);
    CGAffineTransform zero = CGAffineTransformMakeRotation(0);
    
    [UIView animateWithDuration:0.1 animations:^{
        self.imageView6.transform = left;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView6.transform = right;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.imageView6.transform = zero;
            }];
        }];
    }];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            return ;
            break;
            case 1:
        {
            [ASIHTTPRequest setSessionCookies:nil];
            [ASIHTTPRequest clearSession];
            _isLogin = NO;
            self.nameLabel.text = @"";
            [self.loginBnt setTitle:@"点击登录" forState:UIControlStateNormal];
            //重置头像
            self.portraitImageView.hidden = NO;
            self.paImageView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

- (void)getUserName:(NSString *)name UserPortrait:(NSString *) portrait
                Uid:(NSString *)uid
{
    self.nameLabel.text = name;
    [self.loginBnt setTitle:@"注销" forState:UIControlStateNormal];
    _isLogin = YES;
    self.portraitImageView.hidden = YES;
    [self.paImageView setImageURL:portrait];
    self.paImageView.hidden = NO;
    self.uid = uid;
}


@end
