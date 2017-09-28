//
//  ManageClass.h
//  Heart
//
//  Created by Somkid on 1/31/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageClass : UIViewController<UITableViewDelegate, UITableViewDataSource>
/*{
    NSMutableArray *_list;
}
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (retain, nonatomic) IBOutlet UITableView *_table;

- (IBAction) editButtonAction:(id)sender;
@end
