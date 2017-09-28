//
//  Configs.h
//  Heart
//
//  Created by Somkid on 5/10/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configs : NSObject

+ (Configs *)sharedInstance;

@property(nonatomic) NSString* API_URL, *END_POINT;
@property(nonatomic)NSString* AED_POST;


/*
 ดึง UID User
 */
-(NSString *)getUIDU;
@end
