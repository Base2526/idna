//
//  ChangePasswordViewController.h
//  Heart
//
//  Created by Somkid on 1/9/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassword : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textFieldOldpassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewpassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmpassword;

- (IBAction)onSave:(id)sender;
@end
