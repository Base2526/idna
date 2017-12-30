//
//  LoginThread.h
//  ParseStarterProject
//
//  Created by somkid simajarn on 6/9/2559 BE.
//
//

//#import <Foundation/Foundation.h>
//
//@interface LoginThread : NSObject
//
//@end

#import <Foundation/Foundation.h>

@interface LoginThread : NSObject<NSURLConnectionDataDelegate>{
    id <NSObject /*, Soap_LottoDateDelegate */> delegate;
    
    // parse xml
    NSXMLParser *parser;
    NSString *currentElement;
    NSMutableString *lottodate;
    // parse xml
}
@property (nonatomic, strong) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

@property (nonatomic, copy) void (^completionHandler)(NSData *);
@property (nonatomic, copy) void (^errorHandler)(NSString *);

-(void)start:(NSString *)username:(NSString *)password /*:(NSString *)parse_id*/;
-(void)cancel;

@end
