//
//  ItemViewController.h
//  Heart
//
//  Created by Somkid on 4/22/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HJObjManager.h"

@class ItemViewController;
@protocol ItemViewDelegate <NSObject>
-(void)sendingViewController:(ItemViewController *) controller sentItem:(NSString *) retItem;
@end

@interface ItemViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource>
{

}

@property (nonatomic, weak) id <ItemViewDelegate> delegate;

//@property (strong,nonatomic) UITableView *table;
//@property (strong,nonatomic) NSArray     *content;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic) NSString* text, *selected;

@property (strong, nonatomic) HJObjManager *obj_Manager;

@end
