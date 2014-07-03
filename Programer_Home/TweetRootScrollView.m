//
//  SVRootScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "TweetRootScrollView.h"

#import "SVGloble.h"
#import "TweetTopScrollView.h"
#import "LatestView.h"
#import "HotView.h"
#import "MyView.h"

#define POSITIONID (int)(scrollView.contentOffset.x/320)

@implementation TweetRootScrollView

@synthesize viewNameArray;

+ (TweetRootScrollView *)shareInstance {
    static TweetRootScrollView *_instance;
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
    //最新动弹
    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"LatestView" owner:self options:nil];
    LatestView *latest = arr1[0];
    [latest loadTableView];
    latest.tag = 200;
    //热门动弹
    NSArray *arr2 = [[NSBundle mainBundle] loadNibNamed:@"HotView" owner:self options:nil];
    HotView *hot = arr2[0];
    hot.tag = 201;
    [hot loadTableView];
    //我的动弹
    NSArray *arr3 = [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:self options:nil];
    MyView *my = arr3[0];
    my.tag = 202;
    [my loadTableView];
    
    latest.center = CGPointMake(160, [SVGloble shareInstance].globleHeight / 2);
    hot.center = CGPointMake(160 + 320, [SVGloble shareInstance].globleHeight / 2);
    my.center = CGPointMake(160 + 320 * 2, [SVGloble shareInstance].globleHeight / 2);
    
    [self addSubview:latest];
    [self addSubview:hot];
    [self addSubview:my];
    
    self.contentSize = CGSizeMake(320*3, [SVGloble shareInstance].globleHeight);
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
            LatestView *latest = (LatestView *)[self viewWithTag:200 + page];
            //加载数据
            [latest autoRefresh];
        }
        break;
        case 1:
        {
            HotView *hot = (HotView *)[self viewWithTag:200 + page];
            //加载数据
            [hot autoRefresh];
        }
            break;
            case 2:
        {
            MyView *my = (MyView *)[self viewWithTag:200 + page];
            //加载数据
            [my autoRefresh];
        }
            break;
        default:
            break;
    }
}

//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [[TweetTopScrollView shareInstance] setButtonUnSelect];
    [TweetTopScrollView shareInstance].scrollViewSelectedChannelID = POSITIONID+100;
    [[TweetTopScrollView shareInstance] setButtonSelect];
    [[TweetTopScrollView shareInstance] setScrollViewContentOffset];
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
