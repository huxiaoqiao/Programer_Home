//
//  LoginViewController.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "LoginViewController.h"
#import "ASIFormDataRequest.h"
#import "GDataXMLNode.h"
#import "LoginModel.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    CGRect loginViewRect;
    CGRect btnViewRect;
    BOOL isleft;
    NSTimer *timer;
    ASIFormDataRequest *_request;
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
    self.accoutTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
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
int i = 0;
//登录
- (IBAction)login:(UIButton *)sender {
    i = 0;
    NSString *username = self.accoutTF.text;
    NSString *password = self.passwordTF.text;
    
    
    if(username.length == 0 || password.length == 0)
    {
        timer =  [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(shakeView) userInfo:self repeats:YES];
    }else
    {
        _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:api_login_validate]];
        [_request setUseCookiePersistence:YES];
        [_request setPostValue:username forKey:@"username"];
        [_request setPostValue:password forKey:@"pwd"];
        [_request setPostValue:@"1" forKey:@"keep_login"];
        _request.delegate = self;
        [_request setDidFinishSelector:@selector(requestLogin:)];
        [_request setDidFailSelector:@selector(requestFailed:)];
        [_request startAsynchronous];
    }
}

- (void)requestLogin:(ASIHTTPRequest *)request
{
    [self analyseUserInfo:[request responseData]];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"登录失败");
}

- (void)analyseUserInfo:(NSData *) data
{
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSString *xpath1 = @"/oschina/result";
    NSString *xpath2 = @"/oschina/user";
    NSArray *arr1 = [document nodesForXPath:xpath1 error:nil];
    NSArray *arr2 = [document nodesForXPath:xpath2 error:nil];
    LoginModel *model = [[LoginModel alloc] init];
    for(GDataXMLElement *element in arr1)
    {
        model.errorCode = [[[element elementsForName:@"errorCode"][0] stringValue] intValue];
        model.errorMessage = [[element elementsForName:@"errorMessage"][0] stringValue];
    }
    for(GDataXMLElement *element in arr2)
    {
        model.uid = [[element elementsForName:@"uid"][0] stringValue];
        model.location = [[element elementsForName:@"location"][0] stringValue];
        model.name = [[element elementsForName:@"name"][0] stringValue];
        model.followers = [[[element elementsForName:@"followers"][0] stringValue] intValue];
        model.fans = [[[element elementsForName:@"fans"][0] stringValue] intValue];
        model.portraitUrl = [[element elementsForName:@"portrait"][0] stringValue];
    }
    if(model.errorCode == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:model.errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        if(_delegate && [_delegate respondsToSelector:@selector(getUserName:UserPortrait:Uid:)])
        {
            [_delegate getUserName:model.name UserPortrait:model.portraitUrl Uid:model.uid];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)shakeView
{
    i ++;
    CGAffineTransform left = CGAffineTransformMakeRotation(-5 * M_PI / 180);
    CGAffineTransform right = CGAffineTransformMakeRotation(5 * M_PI / 180);
    CGAffineTransform zero = CGAffineTransformMakeRotation(0);
    [UIView animateWithDuration:0.08 animations:^{
        if(isleft)
        {
            self.loginView.transform = right;
        }else
        {
            self.loginView.transform = left;
        }
        isleft = !isleft;
    }];
    if(i == 10)
    {
        self.loginView.transform = zero;
        [timer invalidate];
    }
}
//返回
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
