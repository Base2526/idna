//
//  MainViewController.h
//  SidebarDemo
//
//  Created by Simon Ng on 10/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *_table;

@property (weak, nonatomic) IBOutlet UIImageView *imgGif;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
