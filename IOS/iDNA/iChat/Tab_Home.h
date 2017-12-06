//
//  Tab_Home.h
//  iDNA
//
//  Created by Somkid on 4/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface Tab_Home : UIViewController

@property (weak, nonatomic) IBOutlet HJManagedImageV *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
- (IBAction)onAddFriend:(id)sender;
- (IBAction)onSettings:(id)sender;
@end
