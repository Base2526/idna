//
//  ClasssListFriends.m
//  iDNA
//
//  Created by Somkid on 2/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "ClasssListFriends.h"
#import "Configs.h"
#import "FriendProfileRepo.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"

@interface ClasssListFriends (){
    NSMutableDictionary *blockFriends;
    FriendProfileRepo *friendPRepo;
    FIRDatabaseReference *ref;
    
    
    NSMutableArray *friends;
}
@end

@implementation ClasssListFriends
@synthesize item_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    
    friendPRepo = [[FriendProfileRepo alloc] init];
    
    friends = [[NSMutableArray alloc] init];
    
    [self reloadData:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)reloadData:(NSNotification *) notification{
    
    /*
    blockFriends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
    
    for (NSString* key in blockFriends) {
        NSDictionary* value = [blockFriends objectForKey:key];
        
        if ([value objectForKey:@"block"]) {
            if ([[value objectForKey:@"block"] isEqualToString:@"1"]) {
                continue;
            }
        }
        
        NSMutableDictionary *newFriends = [[NSMutableDictionary alloc] init];
        [newFriends addEntriesFromDictionary:blockFriends];
        
        [newFriends removeObjectForKey:key];
        
        blockFriends = newFriends;
    }
    */
    
    NSMutableDictionary *local_friends = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
    
    int count = 0;
    for (NSString* key in local_friends) {
        NSDictionary* value = [local_friends objectForKey:key];
        // do stuff
        
        if ([value objectForKey:@"classs"]) {
            NSString *classs = [value objectForKey:@"classs"];
            
            if ([classs isEqualToString:item_id]) {
                [friends addObject:key];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    HJManagedImageV *imageV = (HJManagedImageV *)[cell viewWithTag:9];
    UILabel *labelName = (UILabel *)[cell viewWithTag:10];
    
//    NSArray *keys = [blockFriends allKeys];
//    id aKey = [keys objectAtIndex:indexPath.row];
//    id anObject = [blockFriends objectForKey:aKey];
    
    
    NSArray *fprofile = [friendPRepo get:[friends objectAtIndex:indexPath.row]];
    
    NSData *data =  [[fprofile objectAtIndex:[friendPRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel]; // API_URL
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
    }else{
        [imageV clear];
    }
    [labelName setText:[NSString stringWithFormat:@"%@", [f objectForKey:@"name"]]];
    
    // cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}
@end
