//
//  Changefriendsname.m
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import "Changefriendsname.h"
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;
#import "Configs.h"
#import "FriendsRepo.h"

@interface Changefriendsname (){
    
    FriendsRepo *friendRepo;
    NSDictionary *friend;
}

@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation Changefriendsname
@synthesize friend_id, txtName, ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"Friend id > %@", friend_id];
    
    ref = [[FIRDatabase database] reference];
    
    NSLog(@"friend_id = %@", friend_id);
    
    friendRepo = [[FriendsRepo alloc] init];
    NSArray *val =  [friendRepo get:friend_id];
    
    NSData *data =  [[val objectAtIndex:[friendRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    /*
     [NSJSONSerialization JSONObjectWithData:[[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
     */
        
    friend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];//[[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"] objectForKey:friend_id];
    
    txtName.text = @"";
    if ([friend objectForKey:@"change_friends_name"] != nil) {
        txtName.text = [friend objectForKey:@"change_friends_name"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSave:(id)sender {
    __block NSString *text_name = [txtName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if (![text_name isEqualToString:@""] && [text_name length] > 0) {
        __block NSString *child = [NSString stringWithFormat:@"%@%@/friends/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU]];
 
        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@%@/change_friends_name/", child, friend_id]: text_name};
        [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (error == nil) {

                /*
                NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
                
                
                //  ดึงเพือนตาม friend_id แล้ว set change_friends_name
                NSMutableDictionary *friend  = [friends objectForKey:friend_id];
                [friend setValue:text_name forKey:@"change_friends_name"];
                
                // Update friends ของ DATA
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
                [newDict removeObjectForKey:@"friends"];
                [newDict setObject:friends forKey:@"friends"];
                
                [[Configs sharedInstance] saveData:_DATA :newDict];
                */
                
                Friends *fd  = [[Friends alloc] init];
                fd.friend_id = friend_id;
                
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                [newDict addEntriesFromDictionary:friend];
                
                if ([newDict objectForKey:@"change_friends_name"]) {
                    [newDict removeObjectForKey:@"change_friends_name"];
                }
                
                [newDict setObject:text_name forKey:@"change_friends_name"];
                
                NSError * err;
                NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newDict options:0 error:&err];
                fd.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
                fd.update    = [timeStampObj stringValue];
                
                BOOL rs= [friendRepo update:fd];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
@end
