//
//  ContactusViewController.h
//  SidebarDemo
//
//  Created by Somkid on 10/3/2559 BE.
//  Copyright © 2559 AppCoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactusViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@property (weak, nonatomic) IBOutlet UIImageView *imgGif;
- (IBAction)onClickFacebook:(id)sender;
- (IBAction)onClickGoogleplus:(id)sender;
- (IBAction)onClickWWW:(id)sender;


@end
