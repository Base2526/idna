//
//  ListUserSendHeart.h
//  Heart
//
//  Created by Somkid on 1/31/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListUserSendHeart : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSend;


@property (strong, nonatomic) NSString *_class;

- (IBAction)onSend:(id)sender;
@end
