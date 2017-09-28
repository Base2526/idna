//
//  Contactus2ViewController.h
//  Heart
//
//  Created by Somkid on 10/26/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGPlusButtonsView.h"
#import "SVProgressHUD.h"

#import "EditMyAppViewController.h"

@interface Contactus2ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


//@property (weak, nonatomic) IBOutlet UIImageView *imgGif;
- (IBAction)onClickFacebook:(id)sender;
- (IBAction)onClickGoogleplus:(id)sender;
- (IBAction)onClickWWW:(id)sender;
- (IBAction)onMyId:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmImgProfile;

@property (weak, nonatomic) IBOutlet UIImageView *img_phone;
@property (weak, nonatomic) IBOutlet UIImageView *img_location;
@property (weak, nonatomic) IBOutlet UIImageView *img_email;
@property (weak, nonatomic) IBOutlet UIImageView *img_google_plus;
@property (weak, nonatomic) IBOutlet UIImageView *img_facebook;


@end
