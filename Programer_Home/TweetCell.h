//
//  TweetCell.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-2.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAImageView.h"
#import "TweetModel.h"

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (nonatomic,strong) PAImageView *paImageView;
- (void)addImageView;
@property (nonatomic,strong) TweetModel *model;
@end
