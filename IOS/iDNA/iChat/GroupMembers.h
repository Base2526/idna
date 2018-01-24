//
//  Members.h
//  iChat
//
//  Created by Somkid on 30/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface GroupMembers : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiInvite;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiEdit;

@property(nonatomic)NSString *group_id;
@property (strong, nonatomic) FIRDatabaseReference *ref;
- (IBAction)onEdit:(id)sender;
@end



