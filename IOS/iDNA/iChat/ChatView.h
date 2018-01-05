//
//  ChatView.h
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import <UIKit/UIKit.h>

// #import <JSQMessagesViewController/JSQMessages.h>

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ChatView : UIViewController

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property(nonatomic)NSDictionary *friend;
- (IBAction)onInvite:(id)sender;

@end
