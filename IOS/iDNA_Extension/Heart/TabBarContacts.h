//
//  TabBarChatWall.h
//  wireframe
//
//  Created by somkid simajarn on 5/5/2559 BE.
//  Copyright © 2559 somkid simajarn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGPlusButtonsView.h"

#import "GetMyProfileThread.h"
#import "HJManagedImageV.h"

@interface TabBarContacts : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;
@property (weak, nonatomic) IBOutlet UILabel *labelEmpty;

- (IBAction)onTest:(id)sender;
- (IBAction)onAddFriends:(id)sender;

- (void)NotificationCenterAddObserver;
@end
