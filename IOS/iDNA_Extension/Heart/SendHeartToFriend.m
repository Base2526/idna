//
//  SendHeartToFriend.m
//  Heart
//
//  Created by Somkid on 11/28/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "SendHeartToFriend.h"

#import "SendHeartToFriendThread.h"
#import "SVProgressHUD.h"

#import "AppConstant.h"
#import "Configs.h"
#import "SendHeartHeader.h"

//FirebaseHandle

/*
 @import Firebase;
 @import FirebaseMessaging;
 @import FirebaseDatabase;
 */

@interface SendHeartToFriend ()

@end

@implementation SendHeartToFriend{
    NSArray *all_data;
    
    NSUserDefaults *preferences;
    FIRDatabaseReference *ref;
    
    NSString *heart_send, *heart_receive;
    
    FIRDatabaseHandle crv_handle;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    all_data = @[@"Cell-Heart", @"Cell-Sent", @"Cell-Recived"];
    

    ref = [[FIRDatabase database] reference];
    
    preferences = [NSUserDefaults standardUserDefaults];

    self.title =[self.data valueForKey:@"display_name"];
    
    heart_send = @"0";
    heart_receive = @"0";
    

    NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/friends/%@", [[Configs sharedInstance] getUIDU], [self.data valueForKey:@"uid"]];
    
    [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSLog(@"%@", snapshot.value);
        
        if([snapshot.key isEqualToString:@"send_heart"]){
            // [self.labelSend setText:[NSString stringWithFormat:@"Send : %@", snapshot.value]];
            
            heart_send = [NSString stringWithFormat:@"%d", [snapshot.value count]];
            
            NSLog(@"%d", [snapshot.value count]);
            
            [self._table reloadData];
        }
        
        if([snapshot.key isEqualToString:@"receive_heart"]){
            // [self.labelReceive setText:[NSString stringWithFormat:@"Receive : %@", snapshot.value]];
            
            heart_receive = [NSString stringWithFormat:@"%d", [snapshot.value count]];
            
            NSLog(@"%d", [snapshot.value count]);
            
            [self._table reloadData];
        }
    }];
    
    [[ref child:child] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSLog(@"%@", snapshot.value);
        
        if([snapshot.key isEqualToString:@"send_heart"]){
            // [self.labelSend setText:[NSString stringWithFormat:@"Send : %@", snapshot.value]];
            
            heart_send = [NSString stringWithFormat:@"%d", [snapshot.value count]];
            
            NSLog(@"%d", [snapshot.value count]);
            
            [self._table reloadData];
        }
        
        if([snapshot.key isEqualToString:@"receive_heart"]){
            // [self.labelReceive setText:[NSString stringWithFormat:@"Receive : %@", snapshot.value]];
            
            heart_receive = [NSString stringWithFormat:@"%d", [snapshot.value count]];
            
            NSLog(@"%d", [snapshot.value count]);
            
            [self._table reloadData];
        }
    }];
    
    NSString *child_user_heart = [NSString stringWithFormat:@"heart-id/user-login/%@/profile/", [[Configs sharedInstance] getUIDU]];
    [[ref child:child_user_heart] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSLog(@"%@", snapshot.key);
        
        if([snapshot.key isEqualToString:@"heart"]){
            [self._table reloadData];
        }
    }];
    
    
    // https://www.firebase.com/docs/ios/guide/retrieving-data.html
    NSString *child_receive = [NSString stringWithFormat:@"heart-id/user-login/%@/friends/%@/receive_heart", [[Configs sharedInstance] getUIDU], [self.data valueForKey:@"uid"]];
    crv_handle = [[ref child:child_receive] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (snapshot.value != [NSNull null]){
            
            
            if (self.view.window) {
                // viewController is visible
                for (NSString* key in snapshot.value) {
                    [[ref child:[NSString stringWithFormat:@"%@/%@", child_receive, key]] updateChildValues:@{@"is_read":@"1"} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                        if (error) {
                            NSLog(@"Error updating data: %@", error.debugDescription);
                        }
                    }];
                }
            }
        }
    }];
    
    // self.edgesForExtendedLayout = UIRectEdgeAll;
    // self._table.contentInset = UIEdgeInsetsMake(0., 0., -CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    // [ref removeObserverWithHandle:crv_handle];
    
    [ref removeAllObservers];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return 60;
    switch (indexPath.row) {
        case 0: return 300;
        case 1:
        case 2:
        case 3: return 80;
        default:
            break;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;//[all_data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerReuseIdentifier = @"TableViewSectionHeaderViewIdentifier";
    
    // ****** Do Step Two *********
    // SendHeartHeader *sectionHeaderView = [[NSBundle mainBundle] loadNibNamed:@"SendHeartHeader" owner:self options:nil];;//[self._table dequeueReusableHeaderFooterViewWithIdentifier:@"Cell-Sent"];
    // Display specific header title
    // sectionHeaderView.textLabel.text = @"specific title";
    // UILabel *btn = (UILabel *)[sectionHeaderView viewWithTag:10];
    // [btn setText:[NSString stringWithFormat:@"Sent : %@", heart_send]];
    
    NSArray * arr =[[NSBundle mainBundle] loadNibNamed:@"SendHeartHeader" owner:self options:nil];
    SendHeartHeader * customView = [arr firstObject];
    customView.label.text = [NSString stringWithFormat:@"Sent : %@", heart_send];
    
    // .backgroundColor = [UIColor redColor];
    customView.backgroundColor = [UIColor colorWithRed:0.98 green:0.17 blue:0.44 alpha:1.0];
    return customView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSArray * arr =[[NSBundle mainBundle] loadNibNamed:@"SendHeartHeader" owner:self options:nil];
    SendHeartHeader * customView = [arr firstObject];
    customView.label.text = [NSString stringWithFormat:@"Recived : %@", heart_receive];
    
    customView.backgroundColor = [UIColor colorWithRed:0.88 green:0.36 blue:0.54 alpha:1.0];
    return customView;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [all_data objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0: {
            
            UIButton *btn = (UIButton *)[cell viewWithTag:10];
            btn.tag = indexPath.row;
            [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapped:)]];
        
            break;
        }
            /*
        case 1:{
            UILabel *btn = (UILabel *)[cell viewWithTag:10];
            [btn setText:[NSString stringWithFormat:@"You can send  %@  today", [preferences objectForKey:_USER_HEART_CURRENT]]];
            
            // NSLog(@"%@", self.user_heart);
            NSLog(@"");
            break;
        }
            
        case 1:{
            UILabel *btn = (UILabel *)[cell viewWithTag:10];
            [btn setText:[NSString stringWithFormat:@"Sent : %@", heart_send]];
            break;
        }
        case 2:{
            UILabel *btn = (UILabel *)[cell viewWithTag:10];
            [btn setText:[NSString stringWithFormat:@"Recived : %@", heart_receive]];
            break;
        }
             */
        default:
            break;
    }
    return cell;
}


-(void)btnTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Send Heart"];
    
    SendHeartToFriendThread *sendHeartToFriendThread = [[SendHeartToFriendThread alloc] init];
    [sendHeartToFriendThread setCompletionHandler:^(NSString *data) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Send Heart success."];
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
        }
        
    }];
    
    [sendHeartToFriendThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [sendHeartToFriendThread start:[self.data valueForKey:@"uid"]];
}

@end
