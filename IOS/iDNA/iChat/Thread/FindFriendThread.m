//
//  FindFriendByMyIDThread.m
//  iDNA
//
//  Created by Somkid on 7/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "FindFriendThread.h"
#import "Configs.h"
#import "AppConstant.h"

@implementation FindFriendThread

-(void)start: (NSString*)fction :(NSString *)code
{
    //if there is a connection going on just cancel it.
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].FIND_FRIEND]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *dataToSend = [NSMutableString string];
    
    [dataToSend appendFormat:@"uid=%@&fction=%@&code=%@", [[Configs sharedInstance] getUIDU], fction, code];
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
