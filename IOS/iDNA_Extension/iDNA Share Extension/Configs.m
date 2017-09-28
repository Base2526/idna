//
//  Configs.m
//  Heart
//
//  Created by Somkid on 5/10/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "Configs.h"

@implementation Configs

+ (Configs *)sharedInstance
{
    static Configs *sharedInstance;
    
    @synchronized(self)
    {
        if (!sharedInstance)
            sharedInstance = [[Configs alloc] init];
        
        return sharedInstance;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        // sindex.php
        self.API_URL            = @"http://idna.center";
        self.END_POINT          = @"/api";
        self.AED_POST           = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/AED_post"];
    }
    return self;
}


/*
 ดึง UID User
 */
-(NSString *)getUIDU{
    NSUserDefaults *userDefaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.heart.idna"];
    NSDictionary* ur = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"user"]];
    return [ur objectForKey:@"user"][@"uid"];
}

@end
