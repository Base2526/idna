//
//  PreLoginViewController.h
//  Heart
//
//  Created by Somkid on 12/17/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface PreLogin : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnAnnonymous;

- (IBAction)onAnnmousu:(id)sender;
- (IBAction)onLoginFB:(id)sender;
    
@end
