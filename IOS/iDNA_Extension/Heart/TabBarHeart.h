//
//  TabBarWallet.h
//  wireframe
//
//  Created by somkid simajarn on 5/5/2559 BE.
//  Copyright © 2559 somkid simajarn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactusViewController.h"

#import "LGPlusButtonsView.h"
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface TabBarHeart : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;

//@property (retain) NSDictionary *jsonDict;
//@property (retain) NSMutableArray *all_data;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSUserDefaults *preferences;

@end
