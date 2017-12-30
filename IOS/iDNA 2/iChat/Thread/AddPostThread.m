//
//  AddPostThread.m
//  Heart
//
//  Created by Somkid on 1/18/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "AddPostThread.h"
#import "Configs.h"
#import "AppConstant.h"

@implementation AddPostThread

/*
  is_add : เป้นสถานะบอกว่าจะเพิ่ม(1) หรือ แก้ไข(0)
  key    : เป็น key ของ my-app
  nid    : node id ของ Pages My Application (Machine name: pages_my_app)
  key_edit : key ของ post ที่เราต้องแก้ไข
  edit_item_id  : item id ของ post เพราะเราจะได้ แก้ใขได้ถูก
  photo  : รูป
  title  : ชื่อ post
  detail : รายละเอียด
 */
-(void)start:(NSString *)is_add :(NSString *)item_id: (NSString*)post_nid :(UIImage*)photo: (NSString *)title :(NSString *)detail
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].AED_POST ]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];;//[NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *imgString =@"";
    if (photo != nil) {
        NSData *imageData = UIImageJPEGRepresentation(photo, 0.5);
        imgString = [[self base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    UIDevice *deviceInfo = [UIDevice currentDevice];
    NSMutableString *dataToSend = [NSMutableString string];//[[NSString alloc] initWithFormat:@"uid=%@&image=%@", [preferences objectForKey:_UID],imgString];
    
    [dataToSend appendFormat:@"uid=%@&is_add=%@&item_id=%@&post_nid=%@&title=%@&detail=%@&image=%@", [[Configs sharedInstance] getUIDU], is_add,item_id, post_nid, title, detail, imgString];
    
    /*
    // http://stackoverflow.com/questions/13676893/passing-array-to-php-using-post-from-ios
    // NSMutableString *bodyStr = [NSMutableString string];
    for (NSIndexPath *restID in email) {
        // [dataToSend appendFormat:@"field[]=%d&",[restID.row]];
        
        NSLog(@"%d", restID.row);
        [dataToSend appendFormat:@"email[]=%d&", restID.row];
    }
    */
    // http://stackoverflow.com/questions/13676893/passing-array-to-php-using-post-from-ios
    // NSMutableString *bodyStr = [NSMutableString string];
    /*
    for (NSIndexPath *restID in phone) {
        // [dataToSend appendFormat:@"field[]=%d&",[restID.row]];
        
        NSLog(@"%d", restID.row);
        [dataToSend appendFormat:@"phone[]=%d&", restID.row];
    }
     */
    
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
    
    if (self.completionHandler) {
        self.completionHandler(self.receivedData);
    }
}

- (NSString*)base64forData:(NSData*) theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
@end

