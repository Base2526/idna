//
//  AddByIDViewController.h
//  Heart
//
//  Created by Somkid on 12/20/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddByIDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textfID;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

- (IBAction)onAdd:(id)sender;
@end
