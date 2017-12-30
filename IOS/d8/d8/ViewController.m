//
//  ViewController.m
//  d8
//
//  Created by Somkid on 26/12/2560 BE.
//  Copyright © 2560 Somkid. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self curl];
//     [self login];
    // [self startHttpRequestWithCookie];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)curl{
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                               @"Content-Type": @"application/json",
                               @"Cache-Control": @"no-cache",
                               @"Postman-Token": @"b4f37f70-4330-20d1-f335-c2184c1de326" };
    NSArray *parameters = @[ @{ @"name": @"name", @"value": @"somkid" },
                             @{ @"name": @"pass", @"value": @"1234" },
                             @{ @"name": @"form_id", @"value": @"user_login_form" } ];
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    
    NSError *error;
    NSMutableString *body = [NSMutableString string];
    for (NSDictionary *param in parameters) {
        [body appendFormat:@"--%@\r\n", boundary];
        if (param[@"fileName"]) {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
            if (error) {
                NSLog(@"%@", error);
            }
        } else {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
            [body appendFormat:@"%@", param[@"value"]];
        }
    }
    [body appendFormat:@"\r\n--%@--\r\n", boundary];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/user/login?_format=json"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        
                                                        
                                                        NSString* myString;
                                                        myString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                                                        
                                                        NSLog(@"%@", myString);
                                                    }
                                                }];
    [dataTask resume];
}

- (void)login{
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.3/user/login?_format=json"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3000];
    
    // NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    
    NSLog(@"%@", [request allHTTPHeaderFields]);
    
    //set http method
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
//    NSDictionary *cookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      @"localhost", NSHTTPCookieDomain,
//                                      @"\\", NSHTTPCookiePath,
//                                      @"myCookie", NSHTTPCookieName,
//                                      @"1234", NSHTTPCookieValue,
//                                      nil];
//    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
//    NSArray* cookieArray = [NSArray arrayWithObject:cookie];
//    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
//   //  [request setAllHTTPHeaderFields:headers];
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"192.168.1.3", NSHTTPCookieOriginURL,
                                @"testCookies", NSHTTPCookieName,
                                @"1", NSHTTPCookieValue,
                                nil];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    
    [request setValue:cookie forHTTPHeaderField:@"Cookie"];
    
//    NSString *imgString =@"";
//    if (image != nil) {
//        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//        imgString = [[Utility base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//    }
    
   
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"name=somkid&pass=1234&form_id=user_login_form"];
    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            NSString* myString;
            myString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"");
        }else{
            NSLog(@"");
        }
    }];
    
    [postDataTask resume];
}

- (void)startHttpRequestWithCookie
{
    
    NSDictionary *cookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"localhost", NSHTTPCookieDomain,
                                      @"\\", NSHTTPCookiePath,
                                      @"myCookie", NSHTTPCookieName,
                                      @"1234", NSHTTPCookieValue,
                                      nil];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    NSArray* authCookies = [NSArray arrayWithObject:cookie];
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.3/user/login?_format=json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSData *requestData = [@"name=somkid&pass=1234" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:authCookies];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    [request setAllHTTPHeaderFields:headers];
    
    // [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            NSString* myString;
            myString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"");
        }else{
            NSLog(@"");
        }
    }];
    
    [postDataTask resume];
}


@end
