//
//  LogoutThread.m
//  iDNA
//
//  Created by Somkid on 18/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "LogoutThread.h"
#import "Configs.h"
#import "AppConstant.h"
#import "MessageRepo.h"
#import "FriendProfileRepo.h"
#import "GroupChatRepo.h"
#import "MyApplicationsRepo.h"
#import "ProfilesRepo.h"
#import "FriendsRepo.h"
#import "ClasssRepo.h"
#import "FollowingRepo.h"
#import "CenterRepo.h"
@import FirebaseInstanceID;

@implementation LogoutThread

-(void)start
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // NSString *token = [[FIRInstanceID instanceID] token];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].USER_LOGOUT]];
        
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    NSMutableString *dataToSend = [NSMutableString string];//[[NSString alloc] initWithFormat:@"uid=%@&image=%@", [preferences objectForKey:_UID],imgString];
    
//    [dataToSend appendFormat:@"uid=%@", [[Configs sharedInstance] getUIDU]];
//    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];

    NSDictionary *jsonBodyDict = @{@"uid":[[Configs sharedInstance] getUIDU]};
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
    
    /*
     เราต้อง เครียส์หลังจาก getUIDU เพราะว่าจะมีการเริ่มใช้งาน getUIDU อีกจะทำให้ error
     */
    [[Configs sharedInstance] saveData:_USER :nil];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            
            // Delete User ออกจาก
            [[Configs sharedInstance] saveData:_USER :nil];
            
            [[[ProfilesRepo alloc] init] delete];
            [[[FriendsRepo alloc] init] deleteFriendAll];
            [[[MessageRepo alloc] init] deleteMessagesAll];
            [[[FriendProfileRepo alloc] init] deleteFriendProfileAll];
            [[[GroupChatRepo alloc] init] deleteGroupAll];
            [[[MyApplicationsRepo alloc] init] deleteMyApplicationAll];
            [[[ClasssRepo alloc] init] deleteClasssAll];
            [[[FollowingRepo alloc] init] deleteFollowingAll];
            [[[CenterRepo alloc] init] deleteCenterAll];
            
            self.completionHandler(data);
        }else{
            self.errorHandler([error description]);
        }
    }];
    
    [postDataTask resume];
}
@end

