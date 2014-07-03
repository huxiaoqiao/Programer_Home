//
//  FavoriteView.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-1.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteView : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSString *uid;
@end
