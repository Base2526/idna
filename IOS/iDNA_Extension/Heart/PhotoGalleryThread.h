//
//  PhotoGalleryThread.h
//  SidebarDemo
//
//  Created by Somkid on 10/26/2559 BE.
//  Copyright © 2559 AppCoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoGalleryThread : NSObject<NSURLConnectionDataDelegate>{
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

-(void)start:(NSString *)nid;
-(void)cancel;
@end
