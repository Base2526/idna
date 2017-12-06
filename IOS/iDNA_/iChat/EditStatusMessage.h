//
//  EditStatusMessage.h
//  Heart
//
//  Created by Somkid on 12/27/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditStatusMessage : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMessage;
- (IBAction)onSave:(id)sender;

@property (strong, nonatomic) NSString *message;

@end
