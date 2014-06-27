//
//  RightViewController.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "RightViewController.h"
#import "LoginViewController.h"

@interface RightViewController ()

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Login:(UIButton *)sender {
    LoginViewController *loginCtl = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:loginCtl animated:YES completion:nil];
}

- (IBAction)loginOut:(UIButton *)sender {
}

- (IBAction)btn1Pressed:(UIButton *)sender {
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
            }];
        }];
    }];
}

- (IBAction)btn2Pressed:(UIButton *)sender {
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

- (IBAction)btn3Pressed:(UIButton *)sender {
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

- (IBAction)btn4Pressed:(UIButton *)sender {
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
            }];
        }];
    }];

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
@end
