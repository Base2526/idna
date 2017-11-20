//
//  HideFriends.m
//  iDNA
//
//  Created by Somkid on 14/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "HideFriends.h"

#import "Configs.h"
#import "FriendProfileRepo.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"

@interface HideFriends (){
    NSMutableDictionary *hideFriends;
    FriendProfileRepo *friendPRepo;
    FIRDatabaseReference *ref;
}

@end

@implementation HideFriends

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    
    friendPRepo = [[FriendProfileRepo alloc] init];
    
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
    
    hideFriends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
    
    for (NSString* key in hideFriends) {
        NSDictionary* value = [hideFriends objectForKey:key];

        if ([value objectForKey:@"hide"]) {
            if ([[value objectForKey:@"hide"] isEqualToString:@"1"]) {
                continue;
            }
        }
        
        NSMutableDictionary *newFriends = [[NSMutableDictionary alloc] init];
        [newFriends addEntriesFromDictionary:hideFriends];
        
        [newFriends removeObjectForKey:key];
        
        hideFriends = newFriends;
    }

    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [hideFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    HJManagedImageV *imageV = (HJManagedImageV *)[cell viewWithTag:9];
    UILabel *labelName = (UILabel *)[cell viewWithTag:10];
    
    NSArray *keys = [hideFriends allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [hideFriends objectForKey:aKey];
    
    
    NSArray *fprofile = [friendPRepo get:aKey];
    
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
    [labelName setText:[NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], aKey]];

    // cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *btnUnhide = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Unhide" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Unhide");
        
        NSArray *keys = [hideFriends allKeys];
        id aKey = [keys objectAtIndex:indexPath.row];
        
        NSString *child = [NSString stringWithFormat:@"%@%@/friends/%@/hide/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU], aKey];
        
        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@", child]: @"0"};
        [ref updateChildValues:childUpdates];
        
        [self updateUnhideFriend:aKey];
    }];
    btnUnhide.backgroundColor = [UIColor redColor];

    return @[btnUnhide];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


/*
 Unhide
 */
-(void)updateUnhideFriend:(NSString*)friend_id{
    
    NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
    
    /*
     ดึงเพือนตาม friend_id แล้ว set change_friends_name
     */
    NSMutableDictionary *friend  = [friends objectForKey:friend_id];
    [friend setValue:@"0" forKey:@"hide"];
    
    // Update friends ของ DATA
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
    [newDict removeObjectForKey:@"friends"];
    [newDict setObject:friends forKey:@"friends"];
    
    [[Configs sharedInstance] saveData:_DATA :newDict];
    
    [self reloadData:nil];
}


@end
