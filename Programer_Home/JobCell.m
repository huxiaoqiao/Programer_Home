//
//  JobCell.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-29.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "JobCell.h"

@implementation JobCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)addImageView
{
    _paImageView = [[PAImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) backgroundProgressColor:[UIColor lightTextColor] progressColor:[UIColor grayColor]];
    [self.portraitView addSubview:_paImageView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
