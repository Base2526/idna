//
//  GroupsFriends.h
//  Heart
//
//  Created by Somkid on 12/26/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassFriends : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;

@property (strong, nonatomic) NSString *friend_uid, *friend_status;

@end
