//
//  SHByClassThread.m
//  Heart
//
//  Created by Somkid on 1/31/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "SHByClassThread.h"

#import "Configs.h"
#import "AppConstant.h"
#import "Configs.h"

@import FirebaseInstanceID;

@implementation SHByClassThread
-(void)start: (NSArray*) arrUid
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    
    /*
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?udid=%@&platform=ios&token=%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].USER_LOGIN, [[Configs sharedInstance] getUniqueDeviceIdentifierAsString], token ]];
     */
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].SHBY_CLASS]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];;//[NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    NSMutableString *dataToSend = [NSMutableString string];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    [dataToSend appendString:[NSString stringWithFormat:@"uid=%@&",  [[Configs sharedInstance] getUIDU]]];
    for (NSString *restID in arrUid) {
        [dataToSend appendFormat:@"uids[]=%@&",[restID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    // NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    // [request setHTTPBody: body];
    
    
    
    
    // NSString *dataToSend = [[NSString alloc] initWithFormat:@"UDID=%@",  [[Configs sharedInstance] getUniqueDeviceIdentifierAsString]];
    
    
    
    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    // [connection release];
    
    //start the connection
    [connection start];
    
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}

/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@" , error);
    
    if (self.errorHandler) {
        self.errorHandler([error description]);
    }
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@" , htmlSTR);
    
    //    NSError *error = nil;
    //    id object = [NSJSONSerialization
    //                 JSONObjectWithData:self.receivedData
    //                 options:0
    //                 error:&error];
    //
    //    if(error) { /* JSON was malformed, act appropriately here */ }
    //    if([object isKindOfClass:[NSDictionary class]]){
    //        NSDictionary *results = object;
    //        NSLog(@"%@",[results objectForKey:@"status"]);
    //        NSLog(@"%@",[results objectForKey:@"output"]);
    //    }else{
    //        NSLog(@"there is not an JSON object");
    //    }
    
    if (self.completionHandler) {
        self.completionHandler(self.receivedData);
    }
}
@end

