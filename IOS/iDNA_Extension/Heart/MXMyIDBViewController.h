//
//  MXContactsBViewController.h
//  Heart
//
//  Created by Somkid on 8/29/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APLSectionHeaderView.h"    // for SectionHeaderViewDelegate

@interface MXMyIDBViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SectionHeaderViewDelegate>

@property (nonatomic) NSArray *plays;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
