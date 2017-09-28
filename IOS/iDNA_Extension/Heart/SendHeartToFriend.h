//
//  SendHeartToFriend.h
//  Heart
//
//  Created by Somkid on 11/28/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface SendHeartToFriend : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

/*
@property (strong, nonatomic) NSString *user_heart;
@property (strong, nonatomic) NSString *name_friend;
@property (strong, nonatomic) NSString *uid_friend;
@property (strong, nonatomic) NSString *friend_status;
@property (strong, nonatomic) NSString *heart_send;
@property (strong, nonatomic) NSString *heart_receive;
*/

@property (weak, nonatomic) IBOutlet UILabel *labelSend;
@property (weak, nonatomic) IBOutlet UILabel *labelReceive;

/*
 "heart_receive" = 1;
 "heart_send" = 0;
 */

@property (strong, nonatomic)NSMutableDictionary *data;



@end
