//
//  UpdateMyAppThread.h
//  Heart
//
//  Created by Somkid on 11/9/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface UpdateMyAppThread : NSObject
//
//@end

#import <UIKit/UIKit.h>

@interface UpdateMyAppThread  : NSObject<NSURLConnectionDataDelegate>{
    id <NSObject /*, Soap_LottoDateDelegate */> delegate;
    
    // parse xml
    NSXMLParser *parser;
    NSString *currentElement;
    NSMutableString *lottodate;
    // parse xml
}
@property (nonatomic, strong) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

@property (nonatomic, copy) void (^completionHandler)(NSString *);
@property (nonatomic, copy) void (^errorHandler)(NSString *);

-(void)start: (UIImage *)img :(NSString *)strName: (NSString *)strPhoneNumber :(NSString *) strLocation :(NSString *)strGooglePlus :(NSString *)strFacebook;
-(void)cancel;

/*
 1. imageProfile
 2. Heart URL
 3. Phone
 4. Location
 5. Email
 6. Google+
 7. Facebook
 */
@end
