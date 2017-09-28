//
//  TabBarRider.h
//  wireframe
//
//  Created by somkid simajarn on 5/5/2559 BE.
//  Copyright © 2559 somkid simajarn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiderHeaderView.h"

@interface TabBarMore : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet RiderHeaderView *headerView;
}
@property (weak, nonatomic) IBOutlet UITableView *_table;



@end
