//
//  SubMainViewController.h
//  SidebarDemo
//
//  Created by Somkid on 10/3/2559 BE.
//  Copyright © 2559 AppCoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoGalleryThread.h"

@interface SubMainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *_table;

@property (strong, nonatomic) NSString *_category;

@end
