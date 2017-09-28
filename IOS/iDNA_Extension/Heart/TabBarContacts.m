//
//  TabBarChatWall.m
//  wireframe
//
//  Created by somkid simajarn on 5/5/2559 BE.
//  Copyright © 2559 somkid simajarn. All rights reserved.

#import "TabBarContacts.h"
#import "AppDelegate.h"
#import "UIImage+animatedGIF.h"
#import "AppConstant.h"
#import "EditMyIDViewController.h"
#import "MyMapViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "UserFriendThread.h"
#import "SendHeartToFriend.h"
//#import "SVProgressHUD.h"
#import "AcceptFriendThread.h"
#import "NotAcceptFriendThread.h"
#import "TabBarFriendCell.h"
#import "HJManagedImageV.h"
#import "FriendID.h"
#import "AddFriend.h"
#import "PreLogin.h"
#import "InviteFriendForContactsViewController.h"
#import "TurnOffNotificationsThread.h"
#import "HideFriendThread.h"
#import "CancelWaitToAcceptThread.h"
#import "Configs.h"
#import "Utility.h"

/*
 0 = Family
 1 = Favority
 2 = Friends
 3 = Friend Requests, -3 = User cancel Friend Requests
 4 = Wait to Accept,  -4 = เป็นตัวบอกว่า เพือน cancel คำขอของเรา
 5 = Hide
 6 = Block
 */

@interface TabBarContacts ()<MFMailComposeViewControllerDelegate, SWTableViewCellDelegate>{
    NSMutableArray      *sectionTitleArray;
    NSMutableArray      *arrayForBool;
    NSString *user_heart;
    NSMutableDictionary *dictUserFriends;
    
    NSMutableArray *childObservers;
}

@property (strong, nonatomic) LGPlusButtonsView *floatingActionButton; // FloatingActionButton

@end

@implementation TabBarContacts{
    UIActivityIndicatorView *activityIndicator;
}
@synthesize floatingActionButton;
@synthesize labelEmpty;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", [NSTimeZone localTimeZone]);

    childObservers = [[NSMutableArray alloc] init];
    
    dictUserFriends = [[NSMutableDictionary alloc] init];

    [self._table registerNib:[UINib nibWithNibName:@"TabBarFriendCell" bundle:nil] forCellReuseIdentifier:@"TabBarFriendCell"];
    
    // ชื่อ Section
    if (!sectionTitleArray) {
        // sectionTitleArray = [NSMutableArray arrayWithObjects:@"Friend Requests", @"Family", @"Favority", @"Friends", @"Hide", @"Block" , @"Wait to Accept", nil];
        
        
        sectionTitleArray = [NSMutableArray arrayWithObjects: @"Family", @"Favorite", @"Friends", @"Friend Requests", @"Wait to Accept", @"Hide", @"Block" , nil];
    }
    
    // ค่า defualt expand | not expand
    if (!arrayForBool) {
        arrayForBool    = [NSMutableArray arrayWithObjects:
                           [NSNumber numberWithBool:YES],
                           [NSNumber numberWithBool:YES],
                           [NSNumber numberWithBool:YES],
                           [NSNumber numberWithBool:YES],
                           [NSNumber numberWithBool:YES],
                           [NSNumber numberWithBool:YES],
                           [NSNumber numberWithBool:YES],nil];
    }
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center=self.view.center;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    labelEmpty.hidden = YES;
    [self._table setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadData:)
                                                     name:@"reloadData"
                                                   object:nil];
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadData" object:nil];
}

- (void)viewDidLayoutSubviews {
    activityIndicator.center = self.view.center;
}

-(void)observeEvent{
    /*
    ///--------------
    
    // observeEventType
    // [ref removeAllObservers]
    
    
    dictUserFriends = [[Configs sharedInstance] loadData:_USER_CONTACTS];
    
    if ([dictUserFriends count] == 0){
        NSMutableDictionary *sectionContentDict = [[NSMutableDictionary alloc] init];
        
        // Friend Requests
        [sectionContentDict setValue:[[NSMutableArray alloc] init] forKey:[sectionTitleArray objectAtIndex:0]];
        
        // Friend Requests
        [sectionContentDict setValue:[[NSMutableArray alloc] init] forKey:[sectionTitleArray objectAtIndex:1]];
        
        // Friend Requests
        [sectionContentDict setValue:[[NSMutableArray alloc] init] forKey:[sectionTitleArray objectAtIndex:2]];
        
        // Friends
        [sectionContentDict setValue:[[NSMutableArray alloc] init] forKey:[sectionTitleArray objectAtIndex:3]];
        
        // Hide Friend
        [sectionContentDict setValue:[[NSMutableArray alloc] init] forKey:[sectionTitleArray objectAtIndex:4]];
        
        // Block Friend
        [sectionContentDict setValue:[[NSMutableArray alloc] init] forKey:[sectionTitleArray objectAtIndex:5]];
        
        // Wait to Accept
        [sectionContentDict setValue:[[NSMutableArray alloc] init] forKey:[sectionTitleArray objectAtIndex:6]];
        
        dictUserFriends = sectionContentDict;
        
        [[Configs sharedInstance] saveData:_USER_CONTACTS :dictUserFriends];
    }
    
    [self reloadData];
    
    NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@", [preferences objectForKey:_UID]];
    
    [[ref child:child] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@", snapshot);
        for (NSString* key in dictUserFriends) {
            
            NSMutableArray *_items = [[dictUserFriends objectForKey:key] mutableCopy];
            if ([_items count] > 0) {
                for (int i = 0; i < [_items count]; i++) {
                    NSLog(@"");
                    if ([[[_items objectAtIndex:i] objectForKey:@"uid"] isEqualToString:snapshot.key]) {
                        // [_items replaceObjectAtIndex:i withObject:snapshot.value];
                        [_items removeObjectAtIndex:i];
                        
                        NSMutableDictionary *newHideDict = [[NSMutableDictionary alloc] init];
                        [newHideDict addEntriesFromDictionary:dictUserFriends];
                        [newHideDict removeObjectForKey:key];
                        
                        [newHideDict setObject:_items forKey:key];
                        
                        dictUserFriends = newHideDict;
                        
                        [[Configs sharedInstance] saveData:_USER_CONTACTS :dictUserFriends];
                        break;
                    }
                }
            }
        }
        
        [self reloadData];
    }];
    
    [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@", snapshot);
        if ([snapshot.key isEqualToString:@"friends"]) {
     
            NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
            
            NSMutableArray *Family = [[NSMutableArray alloc] init];
            NSMutableArray *Favority = [[NSMutableArray alloc] init];
            NSMutableArray *Friends = [[NSMutableArray alloc] init];
            NSMutableArray *FriendRequests = [[NSMutableArray alloc] init];
            NSMutableArray *WaittoAccept = [[NSMutableArray alloc] init];
            NSMutableArray *Hide = [[NSMutableArray alloc] init];
            NSMutableArray *Block = [[NSMutableArray alloc] init];
            
            for (NSString* key in snapshot.value) {
                
                NSString * friend_status =[[snapshot.value objectForKey:key] objectForKey:@"friend_status"];
                if ([friend_status isEqualToString:@"0"]) {
                    [Family addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"1"]){
                    [Favority addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"2"]){
                    [Friends addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"3"]){
                    [FriendRequests addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"4"]){
                    [WaittoAccept addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"5"]){
                    [Hide addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"6"]){
                    [Block addObject:[snapshot.value objectForKey:key]];
                }
            }
            
            // Family
            [tmp setValue:Family forKey:[sectionTitleArray objectAtIndex:0]];
            
            // Favority
            [tmp setValue:Favority forKey:[sectionTitleArray objectAtIndex:1]];
            
            // Friends
            [tmp setValue:Friends forKey:[sectionTitleArray objectAtIndex:2]];
            
            // FriendRequests
            [tmp setValue:FriendRequests forKey:[sectionTitleArray objectAtIndex:3]];
            
            // WaittoAccept
            [tmp setValue:WaittoAccept forKey:[sectionTitleArray objectAtIndex:4]];
            
            // Hide
            [tmp setValue:Hide forKey:[sectionTitleArray objectAtIndex:5]];
            
            // Block
            [tmp setValue:Block forKey:[sectionTitleArray objectAtIndex:6]];
            
            dictUserFriends = tmp;
            
            [[Configs sharedInstance] saveData:_USER_CONTACTS :dictUserFriends];
            
            [self setBadge];
            [self reloadData];
        }
    }];
    
    [[ref child:child] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@", snapshot);
        
        if ([snapshot.key isEqualToString:@"friends"]) {
            
            NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
            
            NSMutableArray *Family = [[NSMutableArray alloc] init];
            NSMutableArray *Favority = [[NSMutableArray alloc] init];
            NSMutableArray *Friends = [[NSMutableArray alloc] init];
            NSMutableArray *FriendRequests = [[NSMutableArray alloc] init];
            NSMutableArray *WaittoAccept = [[NSMutableArray alloc] init];
            NSMutableArray *Hide = [[NSMutableArray alloc] init];
            NSMutableArray *Block = [[NSMutableArray alloc] init];
            
            for (NSString* key in snapshot.value) {
                
                NSString * friend_status =[[snapshot.value objectForKey:key] objectForKey:@"friend_status"];
                if ([friend_status isEqualToString:@"0"]) {
                    [Family addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"1"]){
                    [Favority addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"2"]){
                    [Friends addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"3"]){
                    [FriendRequests addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"4"]){
                    [WaittoAccept addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"5"]){
                    [Hide addObject:[snapshot.value objectForKey:key]];
                }else if([friend_status isEqualToString:@"6"]){
                    [Block addObject:[snapshot.value objectForKey:key]];
                }
            }
            
            // Family
            [tmp setValue:Family forKey:[sectionTitleArray objectAtIndex:0]];
            
            // Favority
            [tmp setValue:Favority forKey:[sectionTitleArray objectAtIndex:1]];
            
            // Friends
            [tmp setValue:Friends forKey:[sectionTitleArray objectAtIndex:2]];
            
            // FriendRequests
            [tmp setValue:FriendRequests forKey:[sectionTitleArray objectAtIndex:3]];
            
            // WaittoAccept
            [tmp setValue:WaittoAccept forKey:[sectionTitleArray objectAtIndex:4]];
            
            // Hide
            [tmp setValue:Hide forKey:[sectionTitleArray objectAtIndex:5]];
            
            // Block
            [tmp setValue:Block forKey:[sectionTitleArray objectAtIndex:6]];
            
            dictUserFriends = tmp;
            
            [[Configs sharedInstance] saveData:_USER_CONTACTS :dictUserFriends];
     
            [self setBadge];
            [self reloadData];
        }
    }];
    
    [[ref child:[NSString stringWithFormat:@"heart-id/user-login/%@/profile/", [preferences objectForKey:_UID]]] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@", snapshot.key);
        
        if ([snapshot.key isEqualToString:@"display_name"]) {
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            
            [userDict addEntriesFromDictionary:[_dict objectForKey:@"user"]];
            
            [userDict removeObjectForKey:@"name"];
            
            [userDict setObject:snapshot.value forKey:@"name"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:_dict];
            [newDict removeObjectForKey:@"user"];
            
            [newDict setObject:userDict forKey:@"user"];
            
            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
            
            [preferences synchronize];
            
        }else if ([snapshot.key isEqualToString:@"heart"]) {
            
            NSLog(@"Add - heart > %@", snapshot.value);
            [preferences setObject:snapshot.value forKey:_USER_HEART_CURRENT];
            [preferences synchronize];
        }else if ([snapshot.key isEqualToString:@"phone"]) {
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            // NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
            
            NSMutableDictionary *profile2Dict = [[NSMutableDictionary alloc] init];
            
            [profile2Dict addEntriesFromDictionary:[_dict objectForKey:@"profile2"]];
            
            [profile2Dict removeObjectForKey:@"field_profile_phone"];
            
            // NSMutableDictionary *field_profile_image = [profile2Dict objectForKey:@"field_profile_image"];
            
            
            NSDictionary *value = @{@"value" : snapshot.value};
            
            NSMutableDictionary *new_field_profile_phone = [NSMutableDictionary
                                                            dictionaryWithDictionary:@{
                                                                                       @"und" :@[value]
                                                                                       }];
            
            [profile2Dict setObject:new_field_profile_phone forKey:@"field_profile_phone"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:_dict];
            [newDict removeObjectForKey:@"profile2"];
            
            [newDict setObject:profile2Dict forKey:@"profile2"];
            
            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
            
            [preferences synchronize];
            
        }else if ([snapshot.key isEqualToString:@"picture"]) {
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            // NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
            
            NSMutableDictionary *profile2Dict = [[NSMutableDictionary alloc] init];
            
            [profile2Dict addEntriesFromDictionary:[_dict objectForKey:@"profile2"]];
            
            [profile2Dict removeObjectForKey:@"field_profile_image"];
            
            // NSMutableDictionary *field_profile_image = [profile2Dict objectForKey:@"field_profile_image"];
            
            NSMutableDictionary *new_field_profile_image = [NSMutableDictionary
                                                            dictionaryWithDictionary:@{
                                                                                       @"und" :@[snapshot.value]
                                                                                       }];
            
            [profile2Dict setObject:new_field_profile_image forKey:@"field_profile_image"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:_dict];
            [newDict removeObjectForKey:@"profile2"];
            
            [newDict setObject:profile2Dict forKey:@"profile2"];
            
            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
            
            [preferences synchronize];
            
        }else if ([snapshot.key isEqualToString:@"status_message"]) {
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            // NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
            
            NSMutableDictionary *profile2Dict = [[NSMutableDictionary alloc] init];
            
            [profile2Dict addEntriesFromDictionary:[_dict objectForKey:@"profile2"]];
            
            [profile2Dict removeObjectForKey:@"field_profile_status_message"];
            
            // NSMutableDictionary *field_profile_image = [profile2Dict objectForKey:@"field_profile_image"];
            
            NSDictionary *value = @{@"value" : snapshot.value};
            
            NSMutableDictionary *new_field_profile_phone = [NSMutableDictionary
                                                            dictionaryWithDictionary:@{
                                                                                       @"und" :@[value]
                                                                                       }];
            
            [profile2Dict setObject:new_field_profile_phone forKey:@"field_profile_status_message"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:_dict];
            [newDict removeObjectForKey:@"profile2"];
            
            [newDict setObject:profile2Dict forKey:@"profile2"];
            
            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
            
            [preferences synchronize];
        }else if ([snapshot.key isEqualToString:@"my_id"]) {
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            // NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
            
            NSMutableDictionary *profile2Dict = [[NSMutableDictionary alloc] init];
            
            [profile2Dict addEntriesFromDictionary:[_dict objectForKey:@"profile2"]];
            
            [profile2Dict removeObjectForKey:@"field_profile_heart_id"];
            
            NSDictionary *value = @{@"value" : snapshot.value};
            
            NSMutableDictionary *new_field_profile_phone = [NSMutableDictionary
                                                            dictionaryWithDictionary:@{
                                                                                       @"und" :@[value]
                                                                                       }];
            
            [profile2Dict setObject:new_field_profile_phone forKey:@"field_profile_heart_id"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:_dict];
            [newDict removeObjectForKey:@"profile2"];
            
            [newDict setObject:profile2Dict forKey:@"profile2"];
            
            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
            
            [preferences synchronize];
        }else if ([snapshot.key isEqualToString:@"mail"]) {
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
            [user addEntriesFromDictionary:[_dict objectForKey:@"user"]];
            [user removeObjectForKey:@"mail"];
            
            [user setObject:snapshot.value forKey:@"mail"];
            
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:_dict];
            [newDict removeObjectForKey:@"user"];
            
            [newDict setObject:user forKey:@"user"];
            
            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
            
            [preferences synchronize];
        }
    }];
    
    [[ref child:[NSString stringWithFormat:@"heart-id/user-login/%@/profile/", [preferences objectForKey:_UID]]] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@", snapshot.key);
        
        NSMutableDictionary *change = snapshot.value;
        
        if ([snapshot.key isEqualToString:@"display_name"]) {
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            
            [userDict addEntriesFromDictionary:[_dict objectForKey:@"user"]];
            
            [userDict removeObjectForKey:@"name"];
            
            [userDict setObject:snapshot.value forKey:@"name"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:_dict];
            [newDict removeObjectForKey:@"user"];
            
            [newDict setObject:userDict forKey:@"user"];
            
            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
            
            [preferences synchronize];
            
        }else if ([snapshot.key isEqualToString:@"heart"]) {
            
            NSLog(@"Change - heart > %@", snapshot.value);
            
            [preferences setObject:snapshot.value forKey:_USER_HEART_CURRENT];
            [preferences synchronize];
            
        }else if ([snapshot.key isEqualToString:@"phone"]) {
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            NSMutableDictionary *profile2Dict = [[NSMutableDictionary alloc] init];
            
            [profile2Dict addEntriesFromDictionary:[_dict objectForKey:@"profile2"]];
            
            [profile2Dict removeObjectForKey:@"field_profile_phone"];
            
            // NSMutableDictionary *field_profile_image = [profile2Dict objectForKey:@"field_profile_image"];
            
            NSDictionary *value = @{@"value" : snapshot.value};
            
            NSMutableDictionary *new_field_profile_phone = [NSMutableDictionary
                                                            dictionaryWithDictionary:@{
                                                                                       @"und" :@[value]
                                                                                       }];
            
            [profile2Dict setObject:new_field_profile_phone forKey:@"field_profile_phone"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:_dict];
            [newDict removeObjectForKey:@"profile2"];
            
            [newDict setObject:profile2Dict forKey:@"profile2"];
            
            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
            
            [preferences synchronize];
            
        }else if ([snapshot.key isEqualToString:@"picture"]) {
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            // NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
            
            NSMutableDictionary *profile2Dict = [[NSMutableDictionary alloc] init];
            
            [profile2Dict addEntriesFromDictionary:[_dict objectForKey:@"profile2"]];
            
            [profile2Dict removeObjectForKey:@"field_profile_image"];
            
            // NSMutableDictionary *field_profile_image = [profile2Dict objectForKey:@"field_profile_image"];
            
            NSMutableDictionary *new_field_profile_image = [NSMutableDictionary
                                                            dictionaryWithDictionary:@{
                                                                                       @"und" :@[snapshot.value]
                                                                                       }];
            
            [profile2Dict setObject:new_field_profile_image forKey:@"field_profile_image"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:_dict];
            [newDict removeObjectForKey:@"profile2"];
            
            [newDict setObject:profile2Dict forKey:@"profile2"];
            
            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
            
            [preferences synchronize];
            
        }else if ([snapshot.key isEqualToString:@"status_message"]) {
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            NSMutableDictionary *profile2Dict = [[NSMutableDictionary alloc] init];
            
            [profile2Dict addEntriesFromDictionary:[_dict objectForKey:@"profile2"]];
            
            [profile2Dict removeObjectForKey:@"field_profile_status_message"];
            
            // NSMutableDictionary *field_profile_image = [profile2Dict objectForKey:@"field_profile_image"];
            
            
            NSDictionary *value = @{@"value" : snapshot.value};
            
            NSMutableDictionary *new_field_profile_phone = [NSMutableDictionary
                                                            dictionaryWithDictionary:@{
                                                                                       @"und" :@[value]
                                                                                       }];
            
            [profile2Dict setObject:new_field_profile_phone forKey:@"field_profile_status_message"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:_dict];
            [newDict removeObjectForKey:@"profile2"];
            
            [newDict setObject:profile2Dict forKey:@"profile2"];
            
            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
            
            [preferences synchronize];
        }else if ([snapshot.key isEqualToString:@"my_id"]) {
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            
            
            // NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
            
            NSMutableDictionary *profile2Dict = [[NSMutableDictionary alloc] init];
            
            [profile2Dict addEntriesFromDictionary:[_dict objectForKey:@"profile2"]];
            
            [profile2Dict removeObjectForKey:@"field_profile_heart_id"];
            
            // NSMutableDictionary *field_profile_image = [profile2Dict objectForKey:@"field_profile_image"];
            
            
            NSDictionary *value = @{@"value" : snapshot.value};
            
            NSMutableDictionary *new_field_profile_phone = [NSMutableDictionary
                                                            dictionaryWithDictionary:@{
                                                                                       @"und" :@[value]
                                                                                       }];
            
            [profile2Dict setObject:new_field_profile_phone forKey:@"field_profile_heart_id"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:_dict];
            [newDict removeObjectForKey:@"profile2"];
            
            [newDict setObject:profile2Dict forKey:@"profile2"];
            
            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
            
            [preferences synchronize];
        }
        
    }];
    
    ///--------------
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"observeEvent" object:nil];
    
    */
}

-(void)setBadge{
    /**
     // badge value
     
     NSDictionary *dict =  @{
        @"function" : @"badge",
        @"tabN" : @"1",
        @"value" : @"100",
     };
     
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
    */
    
    int count = 0;
    for (NSString* key in dictUserFriends) {
        NSArray* value = [dictUserFriends objectForKey:key];
        
        if ([value count] > 0) {
            for (id object in value) {
                // do something with object
                
                if ([object objectForKey:@"receive_heart"] != nil) {
                    for (NSString* ikey in [object objectForKey:@"receive_heart"]) {
                        if ([[[[object objectForKey:@"receive_heart"] objectForKey:ikey] objectForKey:@"is_read"] isEqualToString:@"0"]) {
                            count++;
                        }
                    }
                }
            }
        }
    }
    
    NSDictionary *dict =  @{
                            @"function" : @"badge",
                            @"tabN" : @"1",
                            @"value" : [NSString stringWithFormat:@"%i", count],
                            };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
}

- (IBAction)onHeartATAll:(id)sender {
    UINavigationController *navChatView = [self.storyboard instantiateViewControllerWithIdentifier:@"NavHeartATAll"];
    // [self.navigationController pushViewController:chatView animated:YES];
    [self presentViewController:navChatView animated:YES completion:nil];
}

- (IBAction)onAddFriends:(id)sender {
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddFriend *mtc = [storybrd instantiateViewControllerWithIdentifier:@"AddFriend"];
    // [self presentViewController:mtc animated:YES completion:nil];
    
    [self.navigationController pushViewController:mtc animated:YES];
}

- (void)NotificationCenterAddObserver{
    NSLog(@"");
}

- (void) reloadData:(NSNotification *) notification{
    
    NSMutableDictionary*data =  [[Configs sharedInstance] loadData:_DATA];

    if ([data objectForKey:@"contacts"]) {
        NSDictionary *contacts = [data objectForKey:@"contacts"];
        
        NSMutableArray *family = [[NSMutableArray alloc] init];
        NSMutableArray *favority = [[NSMutableArray alloc] init];
        NSMutableArray *friends = [[NSMutableArray alloc] init];
        NSMutableArray *friend_requests = [[NSMutableArray alloc] init];
        NSMutableArray *wait_to_accept = [[NSMutableArray alloc] init];
        NSMutableArray *hide = [[NSMutableArray alloc] init];
        NSMutableArray *block = [[NSMutableArray alloc] init];
        
        for (NSString* key in contacts) {
            NSDictionary* items = [contacts objectForKey:key];
            
            NSString* friend_status = [items objectForKey:@"friend_status"];
            /*
             0 = Family
             1 = Favority
             2 = Friends
             3 = Friend Requests, -3 = กด Reject คำบอกเป็นเพือน
             4 = Wait to Accept,  -4 = ยกเลิกการขอเป็นเพือน (เราจำเป็นไปลบ เราออกจากเพือนที่เราขอเป็นเพือนด้วย)
             5 = Hide
             6 = Block             
             */
            
            if([friend_status isEqualToString:@"0"]){
                [family addObject:items];
            }else if([friend_status isEqualToString:@"1"]){
                [favority addObject:items];
            }else if([friend_status isEqualToString:@"2"]){
                [friends addObject:items];
            }else if([friend_status isEqualToString:@"3"]){
                [friend_requests addObject:items];
            }else if([friend_status isEqualToString:@"4"]){
                [wait_to_accept addObject:items];
            }else if([friend_status isEqualToString:@"5"]){
                [hide addObject:items];
            }else if([friend_status isEqualToString:@"6"]){
                [block addObject:items];
            }
        }
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        
        // Family
        [tmp setValue:family forKey:[sectionTitleArray objectAtIndex:0]];
        
        // Favority
        [tmp setValue:favority forKey:[sectionTitleArray objectAtIndex:1]];
        
        // Friends
        [tmp setValue:friends forKey:[sectionTitleArray objectAtIndex:2]];
        
        // Friends Requests
        [tmp setValue:friend_requests forKey:[sectionTitleArray objectAtIndex:3]];
        
        // Wait to accept
        [tmp setValue:wait_to_accept forKey:[sectionTitleArray objectAtIndex:4]];
        
        // Hide
        [tmp setValue:hide forKey:[sectionTitleArray objectAtIndex:5]];
        
        // Block
        [tmp setValue:block forKey:[sectionTitleArray objectAtIndex:6]];
        
        dictUserFriends = tmp;
        
        [self._table setHidden:NO];
       
        labelEmpty.hidden = YES;
        [self._table reloadData];
    }else{
        
        [self._table setHidden:YES];
        labelEmpty.hidden = NO;
    }
    
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if ([dictUserFriends count] > 0){
        return [sectionTitleArray count];
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        if ([dictUserFriends count] > 0){
            NSArray * arr_section = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:section]];
            return [arr_section count];
        }
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0];;//[UIColor brownColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-30, 30)];
    BOOL manyCells                  = [[arrayForBool objectAtIndex:section] boolValue];
    
    if ([dictUserFriends count] > 0){
    
        NSArray * arr_section = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:section]];
        // เช็ดกรณี ไม่มี user ในกลุ่มนั้น
        if ([arr_section count] < 1) {
            headerView.hidden = YES;
        }else{
            headerView.hidden = NO;
    
            headerString.text = [NSString stringWithFormat:@"%@ (%d)", [sectionTitleArray objectAtIndex:section], [arr_section count]];
    
            headerString.textAlignment      = NSTextAlignmentLeft;
            headerString.textColor          = [UIColor blackColor];
            [headerView addSubview:headerString];
    
            UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
            [headerView addGestureRecognizer:headerTapped];
    
            //up or down arrow depending on the bool
            UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"ic-arrow-up.png"] : [UIImage imageNamed:@"ic-arrow-down.png"]];
            upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
            upDownArrow.frame               = CGRectMake(self.view.frame.size.width-30, 3, 25, 25); //CGRe
            [headerView addSubview:upDownArrow];
        }
    }
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([dictUserFriends count] > 0){
        NSArray * arr_section = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:section]];
        
        // เช็ดกรณี ไม่มี user ในกลุ่มนั้น
        if ([arr_section count] < 1) {
            return 0;
        }
        
        return 30;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([dictUserFriends count] > 0){
        
        NSArray * arr_section = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:section]];
        // เช็ดกรณี ไม่มี user ในกลุ่มนั้น
        if ([arr_section count] < 1) {
            return 0;
        }
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 80;
    }
    return 0;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TabBarFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TabBarFriendCell" forIndexPath:indexPath];
    
    // cell.tag = indexPath.row;
    // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HJManagedImageV *img = (HJManagedImageV *)cell.img;
    UILabel *labelName = (UILabel *)cell.labelName;
    UILabel *labelStatus = (UILabel *)cell.labelStatus;
    UILabel *btnAccept = (UILabel *)cell.labelAccept;
    UILabel *btnNotaccept = (UILabel *)cell.labelCencel;
    UIImageView *imgSpeakerMute = (UIImageView *)cell.imgSpeakerMute;
    
    UITextView *textViewSM = (UITextView *)cell.textViewSM;
    
    textViewSM.textContainer.lineFragmentPadding = 0; // pading 0
    textViewSM.userInteractionEnabled = NO;
    [textViewSM addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    imgSpeakerMute.hidden = YES;
    
    NSArray * arr_section = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
    
    if ([arr_section count] >0) {
        
        @try {
            
            if ([[arr_section objectAtIndex:indexPath.row] valueForKey:@"friend_name"]) {
                [labelName setText:[[arr_section objectAtIndex:indexPath.row] valueForKey:@"friend_name"]];
            }else{
                [labelName setText:[[arr_section objectAtIndex:indexPath.row] valueForKey:@"default_name"]];
            }
        
            if ([[arr_section objectAtIndex:indexPath.row] valueForKey:@"status_message"]) {
                [textViewSM setText:[[arr_section objectAtIndex:indexPath.row] valueForKey:@"status_message"]];
            }else{
                [textViewSM setText:@""];
            }
        
            [img clear];
            if ([[arr_section objectAtIndex:indexPath.row] valueForKey:@"picture"]) {
            
                NSMutableDictionary *picture = [[arr_section objectAtIndex:indexPath.row] valueForKey:@"picture"];
            
                if ([picture count] > 0 ) {
                    [img showLoadingWheel];
                
                    NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                    [img setUrl:[NSURL URLWithString:url]];
                    // [img setImage:[UIImage imageWithData:fileData]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:img ];
                }else{
                    [img setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
                }
            
            }else{
                [img setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
            }
            
            /*
            // ทำกรอบรูปหัวใจ
            [img setBackgroundColor:[UIColor colorWithRed:1.00 green:0.61 blue:0.87 alpha:1.0]];
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            
            UIBezierPath * bezirePath = [Utility heartShape:CGRectMake(0, 0, img.bounds.size.width, img.bounds.size.height)];
            maskLayer.path =bezirePath.CGPath;
            img.layer.mask = maskLayer;
            */
            // ทำกรอบรูปหัวใจ
        }@catch (NSException *exception) {
            NSLog(@"%@", exception.reason);
        }@finally {
            NSLog(@"");
        }
        
        NSString *friends_status = [[arr_section objectAtIndex:indexPath.row] valueForKey:@"friend_status"];
        
        switch ([friends_status integerValue]) {
            // Family
            case 0:
            {
                [btnAccept setHidden:YES];
                [btnNotaccept setHidden:YES];
                [labelStatus setHidden:YES];
                
                img.tag = indexPath.row;
                img.userInteractionEnabled = YES;
                [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(familyTapped:)]];
                
                
                cell._section = [NSString stringWithFormat:@"%d", indexPath.section];
                cell._row     = [NSString stringWithFormat:@"%d", indexPath.row];
                
                if ([[[arr_section objectAtIndex:indexPath.row] valueForKey:@"notifications_status"] isEqualToString:@"1"]) {
                    imgSpeakerMute.hidden = NO;
                    
                    cell.leftUtilityButtons  = [self leftButtonsFriend:@"1"];
                }else{
                    cell.leftUtilityButtons  = [self leftButtonsFriend:@"0"];
                }
                
                cell.rightUtilityButtons = [self rightButtonsFriend];
                cell.delegate = self;
            
            }
                break;
               
            // Favorite
            case 1:
            {
                [btnAccept setHidden:YES];
                [btnNotaccept setHidden:YES];
                [labelStatus setHidden:YES];
                
                //            labelName.tag = indexPath.row;
                //            labelName.userInteractionEnabled = YES;
                //            [labelName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)]];
                
                img.tag = indexPath.row;
                img.userInteractionEnabled = YES;
                [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteTapped:)]];
                
                // cell.leftUtilityButtons = [self leftButtons];
                // cell.tag = indexPath.section;
                
                cell._section = [NSString stringWithFormat:@"%d", indexPath.section];
                cell._row     = [NSString stringWithFormat:@"%d", indexPath.row];
                
                if ([[[arr_section objectAtIndex:indexPath.row] valueForKey:@"notifications_status"] isEqualToString:@"1"]) {
                    imgSpeakerMute.hidden = NO;
                    
                    cell.leftUtilityButtons  = [self leftButtonsFriend:@"1"];
                }else{
                    cell.leftUtilityButtons  = [self leftButtonsFriend:@"0"];
                }
                
                cell.rightUtilityButtons = [self rightButtonsFriend];
                cell.delegate = self;
            }
                break;
                
            // Friends
            case 2:
            {
                [btnAccept setHidden:YES];
                [btnNotaccept setHidden:YES];
                [labelStatus setHidden:YES];
                
                //            labelName.tag = indexPath.row;
                //            labelName.userInteractionEnabled = YES;
                //            [labelName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)]];
                
                img.tag = indexPath.row;
                img.userInteractionEnabled = YES;
                [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friendTapped:)]];
                
                // cell.leftUtilityButtons = [self leftButtons];
                // cell.tag = indexPath.section;
                
                cell._section = [NSString stringWithFormat:@"%d", indexPath.section];
                cell._row     = [NSString stringWithFormat:@"%d", indexPath.row];
                
                if ([[[arr_section objectAtIndex:indexPath.row] valueForKey:@"notifications_status"] isEqualToString:@"1"]) {
                    imgSpeakerMute.hidden = NO;
                    
                    cell.leftUtilityButtons  = [self leftButtonsFriend:@"1"];
                }else{
                    cell.leftUtilityButtons  = [self leftButtonsFriend:@"0"];
                }
                
                cell.rightUtilityButtons = [self rightButtonsFriend];
                cell.delegate = self;
            }
                break;
                
            // Friend Requests
            case 3:
            {
                [labelStatus setText:@""];
                
                [labelStatus setHidden:NO];
                [btnAccept setHidden:NO];
                [btnNotaccept setHidden:NO];
                
                
                btnAccept.layer.cornerRadius = 5;
                btnAccept.layer.borderWidth = 1;
                btnAccept.layer.borderColor = [UIColor greenColor].CGColor;
                
                btnNotaccept.layer.cornerRadius = 5;
                btnNotaccept.layer.borderWidth = 1;
                btnNotaccept.layer.borderColor = [UIColor redColor].CGColor;

                
                btnAccept.tag = indexPath.row;
                btnAccept.userInteractionEnabled = YES;
                [btnAccept addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnAcceptTapped:)]];
                
                btnNotaccept.tag = indexPath.row;
                btnNotaccept.userInteractionEnabled = YES;
                [btnNotaccept addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnNotacceptTapped:)]];
            }
                break;
                
            // Wait to Accept
            case 4:
            {
                [labelStatus setText:@""]; // wait to accept friend request
                
                [btnAccept setHidden:YES];
                [btnNotaccept setHidden:YES];
                [labelStatus setHidden:NO];
                
                // [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteTapped:)]];
                
                [img setUserInteractionEnabled:NO];
                
                cell._section = [NSString stringWithFormat:@"%d", indexPath.section];
                cell._row     = [NSString stringWithFormat:@"%d", indexPath.row];
                
                cell.tag = indexPath.section;
                cell.leftUtilityButtons = nil;
                cell.rightUtilityButtons = [self rightButtonsWaitFriendRequest];
                cell.delegate = self;
            }
                break;

            // Hide
            case 5:
            {
                [labelStatus setText:@""];
                
                [labelStatus setHidden:YES];
                [btnAccept setHidden:YES];
                [btnNotaccept setHidden:YES];
                
                [img setUserInteractionEnabled:NO];
                
                cell._section = [NSString stringWithFormat:@"%d", indexPath.section];
                cell._row     = [NSString stringWithFormat:@"%d", indexPath.row];
                
                cell.leftUtilityButtons = nil;
                cell.rightUtilityButtons = [self rightButtonsHideFriend];
                cell.delegate = self;
            }
                break;

            // Block
            case 6:
            {
                [labelStatus setText:@""];
                
                [labelStatus setHidden:YES];
                [btnAccept setHidden:YES];
                [btnNotaccept setHidden:YES];
                
                [img setUserInteractionEnabled:NO];
                
                cell._section = [NSString stringWithFormat:@"%d", indexPath.section];
                cell._row     = [NSString stringWithFormat:@"%d", indexPath.row];
                
                cell.leftUtilityButtons = nil;
                cell.rightUtilityButtons = [self rightButtonsBlockFriend];
                cell.delegate = self;
            }
                break;

            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    switch (indexPath.section) {
        case 0:
        case 1:
        case 2:{
            NSArray *arr_section = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
            if ([arr_section count] >0) {
                SendHeartToFriend *sendHeartToFriend = [self.storyboard instantiateViewControllerWithIdentifier:@"SendHeartToFriend"];
                sendHeartToFriend.data = [arr_section objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:sendHeartToFriend animated:YES];
            }
        }
            break;
            
            
           //  4 = Wait to Accept,  -4 = เป็นตัวบอกว่า เพือน cancel คำขอของเรา
           //  5 = Hide
           //  6 = Block
        
        // Wait to Accept
        case 4:
        // Hide
        case 5:
        // Block
        case 6:
        {
            
            NSMutableArray *_items = [[dictUserFriends objectForKey:[sectionTitleArray objectAtIndex:indexPath.section]] mutableCopy];
            NSLog(@"%@", [_items objectAtIndex:indexPath.row]);
            
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            FriendID *friend = [storybrd instantiateViewControllerWithIdentifier:@"FriendID"];
            friend.data = [_items objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:friend animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    */
    
    [self._table reloadData];
}

#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        collapsed       = !collapsed;
        [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
        
        //reload specific section animated
        NSRange range   = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self._table reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSArray *)rightButtonsFriend{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    // Hide
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Hide"];
    
    // Block
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.02 green:0.00 blue:1.00 alpha:1.0]
                                                title:@"Block"];

    return rightUtilityButtons;
}

- (NSArray *)rightButtonsWaitFriendRequest{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    // Cancel
    [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                    title:@"Cancel"];
    return rightUtilityButtons;
}

- (NSArray *)rightButtonsHideFriend{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    // Cancel
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Unhide"];
    return rightUtilityButtons;
}

-(NSArray *)rightButtonsBlockFriend{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    // Cancel
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Unblock"];
    return rightUtilityButtons;
}

- (NSArray *)leftButtonsFriend:(NSString *)status{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    if([status isEqualToString:@"1"]){
        [leftUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                    icon:[UIImage imageNamed:@"ic-speaker.png"]];

    
    }else{
        [leftUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"ic-speaker-mute.png"]];
    }
    
    return leftUtilityButtons;
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    TabBarFriendCell *_cell = ((TabBarFriendCell *)cell);
    
    __block NSString *section = (NSString *)_cell._section;
    NSString *row = (NSString *)_cell._row;
    
    NSArray * contentArray = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:[section integerValue]]];
    
    __block NSString *status = @"0";
    if ([[[contentArray objectAtIndex:[row integerValue]] valueForKey:@"notifications_status"] isEqualToString:@"0"]) {
        status = @"1";
    }
    
    __block NSString *uid_friend = [[contentArray objectAtIndex:[row integerValue]] valueForKey:@"uid"];
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    TurnOffNotificationsThread *turnOffThread = [[TurnOffNotificationsThread alloc] init];
    [turnOffThread setCompletionHandler:^(NSString *data) {
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
           
            [self reloadData:nil];
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
        }
    }];
    
    [turnOffThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [turnOffThread start:uid_friend :status];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    TabBarFriendCell *_cell = ((TabBarFriendCell *)cell);
    
    NSString *section = (NSString *)_cell._section;
    NSString *row = (NSString *)_cell._row;
    
    /*
      index
      0 = Hide
      1 = Block
     */
    
    NSLog(@"%@-%@-%d", section, row, index);
    NSLog(@"");
    
    switch ([section integerValue]) {
        // Section Family, Favority Friends
        case 0:
        case 1:
        case 2:{
            switch (index) {
                // เลือก Hide
                case 0:
                {
                    
                    NSArray * contentArray = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:[section integerValue]]];
                    
                    __block NSString* uid_friend = [[contentArray objectAtIndex:[row integerValue]] valueForKey:@"uid"];
                    __block NSString* status = @"5";
                    
                    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
                    HideFriendThread *hideFriendThread = [[HideFriendThread alloc] init];
                    [hideFriendThread setCompletionHandler:^(NSString *data) {
                        [[Configs sharedInstance] SVProgressHUD_Dismiss];
                        
                        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                        
                        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                            [self reloadData:nil];
                        }else{
                            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
                        }
                    }];
                    
                    [hideFriendThread setErrorHandler:^(NSString *error) {
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                    }];
                    [hideFriendThread start:uid_friend :status];
                
                }
                    break;
                    
                //  เลือก Block
                case 1:
                {
                    NSArray * contentArray = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:[section integerValue]]];
                    
                    __block NSString* uid_friend = [[contentArray objectAtIndex:[row integerValue]] valueForKey:@"uid"];
                    __block NSString* status = @"6";
                    
                    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
                    HideFriendThread *hideFriendThread = [[HideFriendThread alloc] init];
                    [hideFriendThread setCompletionHandler:^(NSString *data) {
                        [[Configs sharedInstance] SVProgressHUD_Dismiss];
                        
                        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                        
                        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                            [self reloadData:nil];
                        }else{
                            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
                        }
                    }];
                    
                    [hideFriendThread setErrorHandler:^(NSString *error) {
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                    }];
                    [hideFriendThread start:uid_friend :status];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
 
        // Section Hide
        case 5:{
        
            switch (index) {
                    // เลือก Unhide
                case 0:
                {
                    NSLog(@"");
                    
                    // __block NSMutableDictionary *dictUserFriends = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER_FRIENDS]];
                    
                    NSArray * contentArray = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:[section integerValue]]];
                    
                    __block NSString* uid_friend = [[contentArray objectAtIndex:[row integerValue]] valueForKey:@"uid"];
                    __block NSString* status = @"2";
                    
                    
                    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
                    HideFriendThread *hThread = [[HideFriendThread alloc] init];
                    [hThread setCompletionHandler:^(NSString *data) {
                        
                        [[Configs sharedInstance] SVProgressHUD_Dismiss];
                        
                        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                        
                        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                            
                            [self reloadData:nil];
                        }else{
                            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
                        }
                    }];
                    
                    [hThread setErrorHandler:^(NSString *error) {
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                    }];
                    [hThread start:uid_friend :status];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
            // Section Block
        case 6:{
            switch (index) {
                    // เลือก  Unblock
                case 0:
                {
                    // __block NSMutableDictionary *dictUserFriends = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER_FRIENDS]];
                    
                    NSArray * contentArray = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:[section integerValue]]];
                    
                    __block NSString* uid_friend = [[contentArray objectAtIndex:[row integerValue]] valueForKey:@"uid"];
                    __block NSString* status = @"2";
                    
                    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
                    HideFriendThread *hThread = [[HideFriendThread alloc] init];
                    [hThread setCompletionHandler:^(NSString *data) {
                        
                        [[Configs sharedInstance] SVProgressHUD_Dismiss];
                        
                        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                        
                        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                            [self reloadData:nil];
                        }else{
                            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
                        }
                    }];
                    
                    [hThread setErrorHandler:^(NSString *error) {
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                    }];
                    [hThread start:uid_friend :status];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        
        // Cancel Wait to Accept
        case 4:{
            
            switch (index) {
                case 0:{
                    
                    NSLog(@"%@-%@-%d", section, row, index);
                    
                    NSArray * contentArray = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:[section integerValue]]];
                    
                    __block NSString* uid_friend = [[contentArray objectAtIndex:[row integerValue]] valueForKey:@"uid"];
                    
                    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
                    CancelWaitToAcceptThread *cwThread = [[CancelWaitToAcceptThread alloc] init];
                    [cwThread setCompletionHandler:^(NSString *data) {
                        [[Configs sharedInstance] SVProgressHUD_Dismiss];
                        
                        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                        
                        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                            [self reloadData:nil];
                        }else{
                            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
                        }
                    }];
                    
                    [cwThread setErrorHandler:^(NSString *error) {
                         [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                    }];
                   [cwThread start:uid_friend :@"-4"];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

-(void)familyTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    NSArray * arr_section = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:0]];
    
    if([arr_section count] > 0){
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
        FriendID *friend = [storybrd instantiateViewControllerWithIdentifier:@"FriendID"];
        friend.uid = [[arr_section objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag] objectForKey:@"uid"];
       
        [self.navigationController pushViewController:friend animated:YES];
    }
}

-(void)favoriteTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    NSArray * arr_section = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:1]];
    if([arr_section count] > 0){

        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
        FriendID *friend = [storybrd instantiateViewControllerWithIdentifier:@"FriendID"];
        friend.uid = [[arr_section objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag] objectForKey:@"uid"];
        [self.navigationController pushViewController:friend animated:YES];
    }
}

-(void)friendTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    NSArray * arr_section = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:2]];
    if([arr_section count] > 0){
    
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FriendID *friend = [storybrd instantiateViewControllerWithIdentifier:@"FriendID"];
        friend.uid = [[arr_section objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag] objectForKey:@"uid"];
        
        [self.navigationController pushViewController:friend animated:YES];
    }
}

-(void)btnHJManagedImageVTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);

    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *mtc = [storybrd instantiateViewControllerWithIdentifier:@"MyID"];
    // [self presentViewController:mtc animated:YES completion:nil];
    
    [self.navigationController pushViewController:mtc animated:YES];
}

-(void)btnAcceptTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    __block NSString *section = @"3";
    __block NSString *row = [NSString stringWithFormat:@"%d", [(UIGestureRecognizer *)gestureRecognizer view].tag];
    __block NSString *status = @"2";  // friend
    
    NSString* uid_friend = [[dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:[section integerValue]]] valueForKey:@"uid"][0];
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    AcceptFriendThread *aThread = [[AcceptFriendThread alloc] init];
    [aThread setCompletionHandler:^(NSString *data) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [self reloadData:nil];
            // เพิ่มเพือนจาก Group Friend
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
        }
    }];
    
    [aThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    
    [aThread start:uid_friend];
}

-(void)btnNotacceptTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    __block NSString *section = @"3";
    NSString *row = [NSString stringWithFormat:@"%d", [(UIGestureRecognizer *)gestureRecognizer view].tag];
    
    __block NSString* uid_friend = [[dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:[section integerValue]]] valueForKey:@"uid"][0];
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    NotAcceptFriendThread *naThread = [[NotAcceptFriendThread alloc] init];
    [naThread setCompletionHandler:^(NSString *data) {
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [self reloadData:nil];
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
        }
    }];
    
    [naThread setErrorHandler:^(NSString *error) {
        NSLog(@"%@", error);
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    
    [naThread start:uid_friend];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv     contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    [tv setContentInset:UIEdgeInsetsMake(topCorrect,0,0,0)];
}

-(BOOL)isEmptyUserFriends{
    
    for (NSString* key in dictUserFriends) {
        NSArray* value = [dictUserFriends objectForKey:key];

        if ([value count] > 0) {
            return NO;
        }
    }
    return YES;
}

- (IBAction)onTest:(id)sender {
    
    // set your message properties
    NSDictionary *dict =  @{
      @"function" : @"badge",
      @"tabN" : @"1",
      @"value" : @"100",
      };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
}
@end
