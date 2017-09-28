//
//  SendHeartByClass.m
//  Heart
//
//  Created by Somkid on 1/31/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "SendHeartByClass.h"
#import "SetClassFriendThread.h"
#import "Configs.h"
#import "AppConstant.h"
#import "ListUserSendHeart.h"

@interface SendHeartByClass ()
{
    NSMutableArray *all_data;
    NSMutableDictionary* dictUserFriends;
}
@end

@implementation SendHeartByClass

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    all_data = [[NSMutableArray alloc] initWithObjects:@"Family", @"Favorite", @"Friends", nil];
    
    dictUserFriends = [[Configs sharedInstance] loadData:_USER_CONTACTS];
    
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

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return  3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //  cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    UILabel *labelName  = (UILabel *)[cell viewWithTag:10];
    UILabel *labelCount  = (UILabel *)[cell viewWithTag:11];
    
    [labelName setText:[all_data objectAtIndex:indexPath.row]];
    
    [labelCount setText: [NSString stringWithFormat:@"%d User", [[dictUserFriends objectForKey:[all_data objectAtIndex:indexPath.row]] count]] ];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    /*
    if ([self.friend_status integerValue] == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
     */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row); // you can see selected row number in your console;
    
    if([[dictUserFriends objectForKey:[all_data objectAtIndex:indexPath.row]] count] > 0){
        
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ListUserSendHeart *v = [storybrd instantiateViewControllerWithIdentifier:@"ListUserSendHeart"];
        
        v._class = [all_data objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:v animated:YES];

    }else{
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Empty User."];
    }
    
    [self reloadData];
}

-(void)reloadData
{
    [self._table reloadData];
}

@end
