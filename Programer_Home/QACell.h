//
//  QACell.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-29.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QACell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portriatView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCountLabel;


@end
