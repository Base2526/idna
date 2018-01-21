//
//  LoginThread.m
//  ParseStarterProject
//
//  Created by somkid simajarn on 6/9/2559 BE.
//
//

#import "LoginThread.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Configs.h"
@import FirebaseInstanceID;

@implementation LoginThread

-(void)start:(NSString *)username:(NSString *)password /*:(NSString *)parse_id*/
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    // self.receivedData = nil;
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    
    //initialize url that is going to be fetched.
    // NSURL *url = [NSURL URLWithString:@"http://www.snee.com/xml/crud/posttest.cgi"];
    // NSString *token = [[FIRInstanceID instanceID] token];
    // NSLog(@"InstanceID token: %@", token);
    
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    /*
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?udid=%@&platform=ios&bundleidentifier=%@&version=%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].USER_LOGIN, [[Configs sharedInstance] getUniqueDeviceIdentifierAsString], [[Configs sharedInstance] getBundleIdentifier], [[Configs sharedInstance] getVersionApplication] ]];
     */
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].USER_LOGIN]];
    
    // NSLog(@">%@", [[Configs sharedInstance] getUniqueDeviceIdentifierAsString]);
    
    //initialize a request from url
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    //set http method
    // [request setHTTPMethod:@"POST"];
    /*
     postData.put("token", token);
     postData.put("client", clientId);
     postData.put("apikey", Constants.API_KEY);
     postData.put("model", DeviceUtil.getDeviceModel());
     */
    
    //initialize a post data
    // NSString *postData = [[NSString alloc] initWithString:@"fname=example&lname=example"];  username, password, parse_id
    
    // NSString *postData = [NSString stringWithFormat:@"username=%@&password=%@&parse_id=%@", username, password, parse_id];
    // NSString *postData = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    
    //set request content type we MUST set this value.
    // [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
     // [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     // [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    // [request setValue:@"aAs9B_vHJ86yf5gjvXbFRfrPPBHV9ENHFIu8riaI7wM" forHTTPHeaderField:@"X-CSRF-Token"];
    
    //set post data of request
    // [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    /*
     v1.0
    NSDictionary* dict = @{ @"username": username,
                            @"password": password};
     */
    
    /* v1.1
    NSDictionary* dict = @{ @"username_email": username,
                            @"password": password};
    
    NSError* error;
    NSData* _data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    [request setHTTPBody:_data];

    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    // [connection release];
    
    //start the connection
    [connection start];
    */
    
    NSMutableString *dataToSend = [NSMutableString string];//[[NSString alloc] initWithFormat:@"uid=%@&image=%@", [preferences objectForKey:_UID],imgString];
    
//    [dataToSend appendFormat:@"name=%@&pass=%@", username, password];
//    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSDictionary *jsonBodyDict = @{@"name":username, @"pass":password};
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
    
    /*
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
    */
    
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

