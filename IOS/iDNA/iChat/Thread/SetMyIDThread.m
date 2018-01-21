//
//  SetMyIDThread.m
//  Heart
//
//  Created by Somkid on 12/29/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "SetMyIDThread.h"

//@implementation SetMyIDThread
//
//@end

#import "Configs.h"
#import "AppConstant.h"

@implementation SetMyIDThread

-(void)start: (NSString *)my_id
{
    //if there is a connection going on just cancel it.
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].SET_MY_ID]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    NSMutableString *dataToSend = [NSMutableString string];
    
    [dataToSend appendFormat:@"uid=%@&my_id=%@", [[Configs sharedInstance] getUIDU], my_id];
    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            self.completionHandler(data);
        }else{
            self.errorHandler([error description]);
        }
    }];
    
    [postDataTask resume];
}
@end

