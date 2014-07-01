//
//  MyHomeViewController.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-30.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *updatePortraitBnt;
- (IBAction)updatePortraitImage:(UIButton *)sender;
- (IBAction)goToFavouriteView:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *View2;
@property (weak, nonatomic) IBOutlet UILabel *joinTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *View3;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UIView *View4;
@property (weak, nonatomic) IBOutlet UILabel *devLabel;
@property (weak, nonatomic) IBOutlet UIView *View5;
@property (weak, nonatomic) IBOutlet UILabel *expertiseLabel;
@property (weak, nonatomic) IBOutlet UIView *portraitView;

@property (nonatomic,copy) NSString *uid;
@end
