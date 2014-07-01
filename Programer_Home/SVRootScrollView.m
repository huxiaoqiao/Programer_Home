//
//  SVRootScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "SVRootScrollView.h"

#import "SVGloble.h"
#import "SVTopScrollView.h"
#import "NewsView.h"
#import "BlogView.h"
#import "RecommendView.h"

#define POSITIONID (int)(scrollView.contentOffset.x/320)

@implementation SVRootScrollView

@synthesize viewNameArray;

+ (SVRootScrollView *)shareInstance {
    static SVRootScrollView *_instance;
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
    //新闻页
    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"NewsView" owner:self options:nil];
    NewsView *news = arr1[0];
    [news loadTableView];
    news.tag = 200;
    //博客页
    NSArray *arr2 = [[NSBundle mainBundle] loadNibNamed:@"BlogView" owner:self options:nil];
    BlogView *blog = arr2[0];
    blog.tag = 201;
    [blog loadTableView];
    //推荐阅读页
    NSArray *arr3 = [[NSBundle mainBundle] loadNibNamed:@"RecommendView" owner:self options:nil];
    RecommendView *recommend = arr3[0];
    recommend.tag = 202;
    [recommend loadTableView];
    
    news.center = CGPointMake(160, [SVGloble shareInstance].globleHeight / 2);
    blog.center = CGPointMake(160 + 320, [SVGloble shareInstance].globleHeight / 2);
    recommend.center = CGPointMake(160 + 320 * 2, [SVGloble shareInstance].globleHeight / 2);
    
    [self addSubview:news];
    [self addSubview:blog];
    [self addSubview:recommend];
    
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
            NewsView *news = (NewsView *)[self viewWithTag:200 + page];
            //加载数据
            [news autoRefresh];
        }
        break;
        case 1:
        {
            BlogView *blog = (BlogView *)[self viewWithTag:200 + page];
            //加载数据
            [blog autoRefresh];
        }
            break;
            case 2:
        {
            RecommendView *recommend = (RecommendView *)[self viewWithTag:200 + page];
            //加载数据
            [recommend autoRefresh];
        }
            break;
        default:
            break;
    }
}

//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [[SVTopScrollView shareInstance] setButtonUnSelect];
    [SVTopScrollView shareInstance].scrollViewSelectedChannelID = POSITIONID+100;
    [[SVTopScrollView shareInstance] setButtonSelect];
    [[SVTopScrollView shareInstance] setScrollViewContentOffset];
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
