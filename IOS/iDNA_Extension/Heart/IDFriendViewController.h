//
//  IDFriendViewController.h
//  Heart
//
//  Created by Somkid on 11/9/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
//
//@interface IDFriendViewController : UIViewController
//
//@end

#import "LGPlusButtonsView.h"

#import "GetMyProfileThread.h"
#import "HJManagedImageV.h"

@interface IDFriendViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


//@property (weak, nonatomic) IBOutlet UIImageView *imgGif;
@property (weak, nonatomic) IBOutlet UIView *main_content;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressLoading;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmImgProfile;
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmImgQRCode;
@property (weak, nonatomic) IBOutlet UIImageView *img_phone;
@property (weak, nonatomic) IBOutlet UIImageView *img_location;
@property (weak, nonatomic) IBOutlet UIImageView *img_email;
@property (weak, nonatomic) IBOutlet UIImageView *img_google_plus;
@property (weak, nonatomic) IBOutlet UIImageView *img_facebook;

- (IBAction)onHeartATAll:(id)sender;
- (void)NotificationCenterAddObserver;
@end
