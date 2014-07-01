//
//  SVRootScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "PostRootScrollView.h"

#import "SVGloble.h"
#import "PostTopScrollView.h"
#import "QAView.h"
#import "ShareView.h"
#import "MixView.h"
#import "JobView.h"


#define POSITIONID (int)(scrollView.contentOffset.x/320)

@implementation PostRootScrollView

@synthesize viewNameArray;

+ (PostRootScrollView *)shareInstance {
    static PostRootScrollView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc] initWithFrame:CGRectMake(0,30, 320, [SVGloble shareInstance].globleHeight)];
    });
    return _instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userContentOffsetX = 0;
    }
    return self;
}

- (void)initWithViews
{
    //问答页
    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"QAView" owner:self options:nil];
    QAView *qa = arr1[0];
    [qa loadTableView];
    qa.tag = 200;
    //分享页
    NSArray *arr2 = [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil];
    ShareView *share = arr2[0];
    share.tag = 201;
    [share loadTableView];
    //综合页
    NSArray *arr3 = [[NSBundle mainBundle] loadNibNamed:@"MixView" owner:self options:nil];
    MixView *mix = arr3[0];
    mix.tag = 202;
    [mix loadTableView];
    //职业页
    NSArray *arr4 = [[NSBundle mainBundle] loadNibNamed:@"JobView" owner:self options:nil];
    JobView *job = arr4[0];
    job.tag = 203;
    [job loadTableView];
    
    qa.center = CGPointMake(160, [SVGloble shareInstance].globleHeight / 2);
    share.center = CGPointMake(160 + 320, [SVGloble shareInstance].globleHeight / 2);
    mix.center = CGPointMake(160 + 320 * 2, [SVGloble shareInstance].globleHeight / 2);
    job.center = CGPointMake(160 + 320 * 3, [SVGloble shareInstance].globleHeight / 2);
    
    [self addSubview:qa];
    [self addSubview:share];
    [self addSubview:mix];
    [self addSubview:job];
    
    self.contentSize = CGSizeMake(320*4, [SVGloble shareInstance].globleHeight);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
    }
    else {
        isLeftScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    
    [self loadData];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self loadData];
}

-(void)loadData
{
    CGFloat pagewidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pagewidth/3)/pagewidth)+1;
    NSLog(@"%d",page);
    switch (page) {
        case 0:
        {
            QAView *qa = (QAView *)[self viewWithTag:200 + page];
            //加载数据
            [qa autoRefresh];
        }
        break;
        case 1:
        {
            ShareView *share = (ShareView *)[self viewWithTag:200 + page];
            //加载数据
            [share autoRefresh];
        }
            break;
            case 2:
        {
            MixView *mix = (MixView *)[self viewWithTag:200 + page];
            //加载数据
            [mix autoRefresh];
        }
            break;
            case 3:
        {
            JobView *job = (JobView *)[self viewWithTag:200 + page];
            [job autoRefresh];
        }
        default:
            break;
    }
}

//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [[PostTopScrollView shareInstance] setButtonUnSelect];
    [PostTopScrollView shareInstance].scrollViewSelectedChannelID = POSITIONID+100;
    [[PostTopScrollView shareInstance] setButtonSelect];
    [[PostTopScrollView shareInstance] setScrollViewContentOffset];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
