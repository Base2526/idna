//
//  GroupChatRepo.m
//  iDNA
//
//  Created by Somkid on 16/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "GroupChatRepo.h"

@implementation GroupChatRepo

-(id) init{
    self = [super init];
    if(self){
        //do something
        // self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"db.sql"];
        self.dbManager = [[DBManager alloc] init];
    }
    return self;
}

- (BOOL)check:(NSString *)group_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from group_chat where group_id=%@", group_id];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return false;
    }
    return true;
}

-(NSArray *)get:(NSString *)group_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from group_chat where group_id='%@';", group_id];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return nil;
    }
    return [results objectAtIndex:0];
}

- (BOOL) insert:(GroupChat *)group{
    BOOL success = false;
    
    //  ยังไม่เคยมี ให้ insert
    NSString *query = [NSString stringWithFormat:@"INSERT INTO group_chat ('group_id', 'data', 'create', 'update') VALUES ('%@', '%@', '%@', '%@');", group.group_id, group.data, group.create, group.update];
    
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

- (BOOL) update:(GroupChat *)group{
    //  แสดงว่ามีให้ทำการ udpate
    NSString *query = [NSString stringWithFormat:@"UPDATE group_chat set 'data'='%@' WHERE group_id='%@';", group.data, group.group_id];
    
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

- (NSMutableArray *) getGroupChatAll{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from group_chat;"];
    
    //  Load the relevant data.
    return [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
}

- (BOOL)deleteGroup:(NSString *)group_id{
    NSString *query = [NSString stringWithFormat:@"DELETE from group_chat WHERE group_id = %@", group_id];
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

- (BOOL) deleteGroupAll{
    NSString *query = [NSString stringWithFormat:@"DELETE from group_chat"];
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

