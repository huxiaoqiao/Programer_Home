//
//  SearchView.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-4.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)cancelPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *searchBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
