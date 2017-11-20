//
//  FriendProfileRepo.m
//  iDNA
//
//  Created by Somkid on 13/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "FriendProfileRepo.h"

@implementation FriendProfileRepo

-(id) init{
    self = [super init];
    if(self){
        //do something
        // self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"db.sql"];
        self.dbManager = [[DBManager alloc] init];
    }
    return self;
}

- (BOOL)check:(NSString *)object_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from friend_profile where friend_id=%@", object_id];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return false;
    }
    return true;
}

-(NSArray *)get:(NSString *)friend_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from friend_profile where friend_id='%@';", friend_id];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return nil;
    }
    return [results objectAtIndex:0];
}

- (BOOL) insert:(FriendProfile *)friend{
    BOOL success = false;
    
    //  ยังไม่เคยมี ให้ insert
    NSString *query = [NSString stringWithFormat:@"INSERT INTO friend_profile ('friend_id', 'data', 'create', 'update') VALUES ('%@', '%@', '%@', '%@');", friend.friend_id, friend.data, friend.create, friend.update];
    
    //  Execute the query.
    [self.dbManager executeQuery:query];
    
    //  If the query was succesfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
        return true;
    }else{
        NSLog(@"Could not execute the query");
        return false;
    }
}

- (BOOL) update:(FriendProfile *)friend{
    //  แสดงว่ามีให้ทำการ udpate
    NSString *query = [NSString stringWithFormat:@"UPDATE friend_profile set 'data'='%@' WHERE friend_id='%@';", friend.data, friend.friend_id];
    
    //  Execute the query.
    [self.dbManager executeQuery:query];
    
    //  If the query was succesfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
        return true;
    }else{
        NSLog(@"Could not execute the query");
        return false;
    }
}

- (NSMutableArray *) getFriendProfileAll{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from friend_profile;"];
    
    //  Load the relevant data.
    return [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
}

- (BOOL) deleteFriendProfileAll{
    NSString *query = [NSString stringWithFormat:@"DELETE from friend_profile"];
    [self.dbManager executeQuery:query];
        
    //  If the query was succesfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
        return true;
    }else{
        NSLog(@"Could not execute the query");
        return false;
    }
}
@end
