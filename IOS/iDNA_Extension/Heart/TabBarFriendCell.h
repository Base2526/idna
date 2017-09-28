//
//  TabBarFriendCell.h
//  Heart
//
//  Created by Somkid on 11/29/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
// #import <SWTableViewCell.h>

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "HJManagedImageV.h"

@interface TabBarFriendCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet HJManagedImageV *img;
@property (weak, nonatomic) IBOutlet UIImageView *imgSpeakerMute;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelAccept;
@property (weak, nonatomic) IBOutlet UILabel *labelCencel;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UITextView *textViewSM;

@property (nonatomic)  NSString *_section;
@property (nonatomic)  NSString *_row;

@end
