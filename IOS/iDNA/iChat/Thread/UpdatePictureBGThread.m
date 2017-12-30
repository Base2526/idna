//
//  UpdateBGThread.m
//  iDNA
//
//  Created by Somkid on 10/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "UpdatePictureBGThread.h"
#import "Configs.h"
#import "AppConstant.h"

@implementation UpdatePictureBGThread

-(void)start: (UIImage *)image
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].UPDATE_PICTURE_BG ]];
    
    //initialize a request from url
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:[Configs sharedInstance].timeOut];;//[NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    
    NSLog(@"%@", [request allHTTPHeaderFields]);
    
    //set http method
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *imgString =@"";
    if (image != nil) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        imgString = [[Utility base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    UIDevice *deviceInfo = [UIDevice currentDevice];
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"uid=%@&image=%@", [[Configs sharedInstance] getUIDU], imgString];
    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    /*
     //initialize a connection from request
     NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
     self.connection = connection;
     // [connection release];
     
     //start the connection
     [connection start];
     
     */
    
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

