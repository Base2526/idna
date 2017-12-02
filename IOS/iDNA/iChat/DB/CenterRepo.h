//
//  CenterRepo.h
//  iDNA
//
//  Created by Somkid on 23/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "Center.h"

@interface CenterRepo : NSObject{
}

@property (nonatomic, strong) DBManager *dbManager;

- (BOOL)check:(NSString *)item_id;
- (NSArray *)get:(NSString *)item_id;
- (BOOL)insert:(Center *)data;
- (BOOL)update:(Center *)data;

- (NSMutableArray *) getCenterAll;

- (BOOL)deleteCenter:(NSString *)item_id;

- (BOOL) deleteCenterAll;
@end

