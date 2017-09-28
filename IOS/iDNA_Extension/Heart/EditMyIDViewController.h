//
//  EditMyIDViewController.h
//  Heart
//
//  Created by Somkid on 11/6/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextfieldScrollViewController.h"
#import "HJManagedImageV.h"

@interface EditMyIDViewController : UITextfieldScrollViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmImgVProfile;
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmImgVBG;

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *phone;
@property(nonatomic) NSString *location;
@property(nonatomic) NSString *googlePlus;
@property(nonatomic) NSString *facebook;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtGooglePlus;
@property (weak, nonatomic) IBOutlet UITextField *txtFacebook;

- (IBAction)onEditPicProfile:(id)sender;
- (IBAction)onSave:(id)sender;

@end
