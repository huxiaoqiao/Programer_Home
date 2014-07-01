//
//  RecommendView.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-27.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)loadTableView;
- (void)setupRefresh;
- (void)headerRefreshing;
- (void)autoRefresh;
@end
