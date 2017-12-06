//
//  Invite.m
//  iChat
//
//  Created by Somkid on 30/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "GroupInvite.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "HJManagedImageV.h"
#import "GroupInviteNewMembersThread.h"

#import "GroupChatRepo.h"
#import "FriendProfileRepo.h"

@interface GroupInvite (){
    NSMutableDictionary *group;
    
    GroupChatRepo *groupChatRepo;
    FriendProfileRepo *friendPRepo;
}

@property(nonatomic, strong)NSMutableDictionary *friends;

@property (nonatomic, strong) NSMutableDictionary *selectedIndex;
@end

@implementation GroupInvite
@synthesize group_id, ref;
@synthesize friends, selectedIndex, barBtnInvite;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    
    groupChatRepo = [[GroupChatRepo alloc] init];
    friendPRepo   = [[FriendProfileRepo alloc] init];
    
    selectedIndex = [NSMutableDictionary dictionary];

    friends = [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"] mutableCopy];
    
    barBtnInvite.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData{
    NSArray *_group = [groupChatRepo get:group_id];
    NSString *data = [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]];
    NSMutableDictionary *items = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    group = [NSJSONSerialization JSONObjectWithData:items options:0 error:nil];
    
    NSDictionary * members = [group objectForKey:@"members"];
    for (NSString *item_id in members) {
        NSDictionary *val = [members objectForKey:item_id];
        [friends removeObjectForKey:[val objectForKey:@"friend_id"]];
    }
    
    // เราต้องกรอบ user hid, block ออกด้วย
    for (NSString* key in friends) {
        NSDictionary* value = [friends objectForKey:key];
        
        if ([value objectForKey:@"hide"]) {
            if ([[value objectForKey:@"hide"] isEqualToString:@"1"]) {
                
                NSMutableDictionary *newFriends = [[NSMutableDictionary alloc] init];
                [newFriends addEntriesFromDictionary:friends];
                
                [newFriends removeObjectForKey:key];
                
                friends = newFriends;
            }
        }
        if ([value objectForKey:@"block"]) {
            if ([[value objectForKey:@"block"] isEqualToString:@"1"]) {
                // [friends removeObjectForKey:key];
                
                NSMutableDictionary *newFriends = [[NSMutableDictionary alloc] init];
                [newFriends addEntriesFromDictionary:friends];
                
                [newFriends removeObjectForKey:key];
                
                friends = newFriends;
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
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
    
    // cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    // @"Friends";
    // NSMutableDictionary *friends = [data objectForKey:@"friends"];
    
    /*
    NSArray *keys = [friends allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    id item = [friends objectForKey:key];
    
    NSMutableDictionary *f = [[Configs sharedInstance] loadData:key];
    */
    
    // NSMutableDictionary *favorite = [all_data objectForKey:@"favorite"];
    
    ////---sort เราต้องการเรียงก่อนแสดงผล
    NSArray *myKeys = [friends allKeys];
    NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
    for(id key in sortedKeys) {
        id object = [friends objectForKey:key];
        [sortedValues addObject:object];
    }
    NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
    ////---sort
    
    NSArray *fprofile = [friendPRepo get:[sortedKeys objectAtIndex:indexPath.row]];
    NSData *data =  [[fprofile objectAtIndex:[friendPRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data == nil) {
        return  cell;
    }
    
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    HJManagedImageV *imageV = (HJManagedImageV *)[cell viewWithTag:100];
    UILabel *lblName = (UILabel *)[cell viewWithTag:101];
    
    // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        // [imageV setUrl:[NSURL URLWithString:[f objectForKey:@"image_url"]]];
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[f objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{
        [imageV clear];
    }
    
    lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], [sortedKeys objectAtIndex:indexPath.row]] ;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    // cell.textLabel.text = _dataArray[indexPath.row][@"text"];
    if (selectedIndex[indexPath] != nil) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (selectedIndex[indexPath] == nil) {
        NSArray *keys = [friends allKeys];
        [selectedIndex setObject:[keys objectAtIndex:indexPath.row] forKey:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [selectedIndex removeObjectForKey:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    self.title =[NSString stringWithFormat:@"Invite new members(%d)", [selectedIndex count]];
    
    barBtnInvite.enabled = NO;
    if ([selectedIndex count] > 0) {
        barBtnInvite.enabled = YES;
    }
}

- (IBAction)onInvite:(id)sender {
    
    NSMutableDictionary* newMembers =[NSMutableDictionary dictionary];
    
    for (NSString* key in selectedIndex) {
        id value = [selectedIndex objectForKey:key];
        [newMembers setObject:@"" forKey:value];
    }
    
    /*
     ที่เราไม่วิ่งผ่าน firebase เพราะว่า member จะมีการ เอา node id มาใช้งานด้วย
     */
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    GroupInviteNewMembersThread *groupINMT = [[GroupInviteNewMembersThread alloc] init];
    [groupINMT setCompletionHandler:^(NSData *data) {
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        // [self.navigationController popViewControllerAnimated:YES];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            NSMutableDictionary *members = [group objectForKey:@"members"];
            
            NSMutableDictionary *resultMembers = jsonDict[@"members"];
            for (NSString* key in resultMembers) {
                NSDictionary* value = [resultMembers objectForKey:key];

                NSMutableDictionary *tempFriend = [[NSMutableDictionary alloc] init];
                [tempFriend addEntriesFromDictionary:members];
                [tempFriend removeObjectForKey:key];
                [tempFriend setObject:value forKey:key];
                
                members = tempFriend;
            }
            
            GroupChatRepo *groupChatRepo = [[GroupChatRepo alloc] init];
             
            NSArray *_group = [groupChatRepo get:group_id];
            NSString *data = [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]];
             
            NSMutableDictionary *items = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
             
            NSMutableDictionary *tgroup = [[NSMutableDictionary alloc] init];
            [tgroup addEntriesFromDictionary:items];
            [tgroup removeObjectForKey:@"members"];
            [tgroup setObject:members forKey:@"members"];
             
            GroupChat *groupChat = [[GroupChat alloc] init];
            groupChat.group_id =  [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"group_id"]];
            groupChat.create   =  [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"create"]];
             
            // แปลกข้อมูลก่อนบันทึก local
            NSError * err;
            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:tgroup options:0 error:&err];
            groupChat.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            groupChat.update    = [timeStampObj stringValue];
             
             // Update local database
            [groupChatRepo update:groupChat];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Success."];
    }];
    
    [groupINMT setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [groupINMT start:group_id : newMembers];
}
@end
