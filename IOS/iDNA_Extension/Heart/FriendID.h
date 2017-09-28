//
//  FriendID.h
//  Heart
//
//  Created by Somkid on 12/1/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface FriendID : UITableViewController
@property (strong, nonatomic) NSMutableDictionary*data;
@property (strong, nonatomic) NSString *uid;

- (IBAction)showMenuSetting:(id)sender;
@end
