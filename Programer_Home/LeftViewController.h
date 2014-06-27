//
//  LeftViewController.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-26.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol leftViewDelegate <NSObject>
- (void)testMethod;
@end

@interface LeftViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,weak) id<leftViewDelegate>delegate;

@end
