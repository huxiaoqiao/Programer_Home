//
//  TweetCell.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-2.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+WebCache.h"

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)addImageView
{
    _paImageView = [[PAImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor grayColor]];
    [self.portraitView addSubview:_paImageView];
}

- (void)setModel:(TweetModel *)model
{
    if([model.portraitUrl isEqualToString:@""])
    {
        [_paImageView setDefaultImage];
    }else
    {
        [_paImageView setImageURL:model.portraitUrl];
    }
    _nameLabel.text = model.author;
    _commentCountLabel.text = [NSString stringWithFormat:@"%d",model.commentCount];
    
    _contentLabel.text = model.tweet;
    _contentLabel.frame = CGRectMake(68, 30, model.tweentSize.width, model.tweentSize.height);
    
    if([model.img isEqualToString:@""])
    {
        _tweetImageView.frame = CGRectMake(100, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 5, 0, 0);
    }else{
        [_tweetImageView setImageWithURL:[NSURL URLWithString:model.img]];
        _tweetImageView.frame = CGRectMake(100,_contentLabel.frame.origin.y + _contentLabel.frame.size.height + 5 , 70, 70);
    }
    _pubDateLabel.text = model.pubDate;
    _pubDateLabel.frame = CGRectMake(68, _tweetImageView.frame.origin.y + _tweetImageView.frame.size.height + 5, 226, 18);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
