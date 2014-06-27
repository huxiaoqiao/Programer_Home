//
//  RightViewController.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UIImageView *imageView6;

- (IBAction)Login:(UIButton *)sender;
- (IBAction)loginOut:(UIButton *)sender;

- (IBAction)btn1Pressed:(UIButton *)sender;
- (IBAction)btn2Pressed:(UIButton *)sender;
- (IBAction)btn3Pressed:(UIButton *)sender;
- (IBAction)btn4Pressed:(UIButton *)sender;
- (IBAction)btn5Pressed:(UIButton *)sender;
- (IBAction)btn6Pressed:(UIButton *)sender;

@end
