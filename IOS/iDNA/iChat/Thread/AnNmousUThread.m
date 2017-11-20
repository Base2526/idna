//
//  AnNmousUThread.m
//  Heart
//
//  Created by Somkid on 1/1/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "AnNmousUThread.h"
#import "Configs.h"
#import "AppConstant.h"

#import "Configs.h"
@import FirebaseInstanceID;

@implementation AnNmousUThread

-(void)start
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // NSString *token = [[FIRInstanceID instanceID] token];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].ANNMOUSU]];
    
    //initialize a request from url
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];;//[NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    /*
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"udid=%@&platform=ios&bundleidentifier=%@&version=%@", [[Configs sharedInstance] getUniqueDeviceIdentifierAsString], [[Configs sharedInstance] getBundleIdentifier], [[Configs sharedInstance] getVersionApplication]];
    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    */
    
    /*
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    */
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                
                                                                   if (error == nil) {
                                                                       self.completionHandler(data);
                                                                   }else{
                                                                       self.errorHandler([error description]);
                                                                   }
                                                               }];
    
    // 5
    [uploadTask resume];
}
@end
