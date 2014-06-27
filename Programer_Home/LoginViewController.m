//
//  LoginViewController.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    CGRect loginViewRect;
    CGRect btnViewRect;
}
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.accoutTF.delegate = self;
    self.passwordTF.delegate = self;
    loginViewRect = self.loginView.frame;
    btnViewRect = self.btnView.frame;
    self.loginView.layer.cornerRadius = 5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tap];
}
- (void)tapView
{
    [self.accoutTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.loginView.frame = loginViewRect;
        self.btnView.frame = btnViewRect;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect newRect1 = loginViewRect;
    CGRect newRect2 = btnViewRect;
    newRect1.origin.y -= 100;
    newRect2.origin.y -= 100;
    [UIView animateWithDuration:0.5 animations:^{
        self.loginView.frame = newRect1;
        self.btnView.frame = newRect2;
    }];
}
- (IBAction)login:(UIButton *)sender {
    
}

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
