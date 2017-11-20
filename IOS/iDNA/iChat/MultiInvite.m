//
//  MutiInvite.m
//  iChat
//
//  Created by Somkid on 5/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "MultiInvite.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "HJManagedImageV.h"
#import "CreateMutiChatThread.h"
#import "MultiChatInviteNewMembersThread.h"

@interface MultiInvite ()

@property(nonatomic, strong)NSMutableDictionary *friends;

@property (nonatomic, strong) NSMutableDictionary *selectedIndex;
@end

@implementation MultiInvite
// @synthesize ref;
@synthesize friends, selectedIndex, barBtnInvite;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // ref = [[FIRDatabase database] reference];
    
    selectedIndex = [NSMutableDictionary dictionary];
    
    friends = [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"] mutableCopy];
    

    
    /*
    NSDictionary * members = [self.group objectForKey:@"members"];
    for (NSString *item_id in members) {
        NSDictionary *val = [members objectForKey:item_id];
        [friends removeObjectForKey:[val objectForKey:@"friend_id"]];
    }
    */
    
    
    if ([self.typeChat isEqualToString:@"1"] || [self.typeChat isEqualToString:@"2"]) {
       [friends removeObjectForKey:self.friend_id];
    }else if([self.typeChat isEqualToString:@"4"]){
        // Multi Chat
        NSDictionary * members = [self.multi_members objectForKey:@"members"];
        for (NSString *item_id in members) {
            NSDictionary *val = [members objectForKey:item_id];
            [friends removeObjectForKey:[val objectForKey:@"friend_id"]];
        }
    }
    
    barBtnInvite.enabled = NO;
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
    
    NSArray *keys = [friends allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    id item = [friends objectForKey:key];
    
    NSMutableDictionary *f = [[Configs sharedInstance] loadData:key];//[[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:key];
    
    // cell.lblName.text = ;
    
    HJManagedImageV *imageV = (HJManagedImageV *)[cell viewWithTag:100];
    UILabel *lblName = (UILabel *)[cell viewWithTag:101];
    
    // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        [imageV setUrl:[NSURL URLWithString:[f objectForKey:@"image_url"]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{
        [imageV clear];
    }
    
    lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], key] ;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    // cell.textLabel.text = _dataArray[indexPath.row][@"text"];
    if (selectedIndex[indexPath] != nil) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (selectedIndex[indexPath] == nil) {
        // NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
        NSArray *keys = [friends allKeys];
        
        [selectedIndex setObject:[keys objectAtIndex:indexPath.row] forKey:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [selectedIndex removeObjectForKey:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    self.title =[NSString stringWithFormat:@"Choose friends (%d)", [selectedIndex count]];
    
    
    barBtnInvite.enabled = NO;
    if ([selectedIndex count] > 0) {
        barBtnInvite.enabled = YES;
    }
}

- (IBAction)onOK:(id)sender {
    
    NSMutableDictionary* members =[NSMutableDictionary dictionary];
    
    for (NSString* key in selectedIndex) {
        id value = [selectedIndex objectForKey:key];
        // do stuff
        [members setObject:@"" forKey:value];
    }
    
    /*
     ที่เราไม่วิ่งผ่าน firebase เพราะว่า member จะมีการ เอา node id มาใช้งานด้วย
     */
    
   
    
    if ([self.typeChat isEqualToString:@"1"] || [self.typeChat isEqualToString:@"2"]) {
        /*
         เป้นการสร้าง multi chat ใหม่
         */
        
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
        CreateMutiChatThread *groupINMT = [[CreateMutiChatThread alloc] init];
        [groupINMT setCompletionHandler:^(NSString *data) {
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Success."];
        }];
        
        [groupINMT setErrorHandler:^(NSString *error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        [groupINMT start:members];
    }else if([self.typeChat isEqualToString:@"4"]){
        // Multi Chat
        
        /*
         เป้นการเพิ่มสมาชิก ใหม่
         */
        
 
        
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
        MultiChatInviteNewMembersThread *groupINMT = [[MultiChatInviteNewMembersThread alloc] init];
        [groupINMT setCompletionHandler:^(NSString *data) {
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Success."];
        }];
        
        [groupINMT setErrorHandler:^(NSString *error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];

        [groupINMT start:[self.multi_members objectForKey:@"multi_chat_id"] :members];
    }
    
}
@end
