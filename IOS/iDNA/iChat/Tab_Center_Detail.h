//
//  Tab_Center_Detail.h
//  iDNA
//
//  Created by Somkid on 25/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface Tab_Center_Detail : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *_table;
//@property (strong, nonatomic) NSString *owner_id, *item_id, *category;
@property(strong, nonatomic) NSString *app_id;

@property (nonatomic)BOOL is_following;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

