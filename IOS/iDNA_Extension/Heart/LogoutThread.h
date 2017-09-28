//
//  LogoutThread.h
//  D8
//
//  Created by System Administrator on 6/27/2559 BE.
//  Copyright © 2559 KLover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogoutThread : NSObject<NSURLConnectionDataDelegate>{
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

-(void)start;
-(void)cancel;

@end
