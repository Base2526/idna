//
//  GroupsFriends.m
//  Heart
//
//  Created by Somkid on 12/26/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "ClassFriends.h"
#import "SetClassFriendThread.h"
#import "SVProgressHUD.h"

@interface ClassFriends ()
{
    NSMutableArray *all_data;
}
@end

@implementation ClassFriends

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    all_data = [[NSMutableArray alloc] initWithObjects:@"Family", @"Favorite", @"Friends", nil];
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
    return 60;
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
    
    [labelName setText:[all_data objectAtIndex:indexPath.row]];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([self.friend_status integerValue] == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row); // you can see selected row number in your console;
    
    /*
    self.friend_status = [NSString stringWithFormat:@"%d", indexPath.row];
    
    // [self._table reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //raise notification about dismiss
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"CLASS_RESULT"
     object:[NSString stringWithFormat:@"%d", indexPath.row]];
     */
    
    
    // NSArray * contentArray = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:[section integerValue]]];
    
    [SVProgressHUD showWithStatus:@"Wait."];
    SetClassFriendThread *setClassFriendThread = [[SetClassFriendThread alloc] init];
    [setClassFriendThread setCompletionHandler:^(NSString *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            /*
             // ลบเพือนออกจาก Group Hide
             NSMutableArray * _contentArray = [dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:5]];
             
             NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
             
             [userDict addEntriesFromDictionary:[_contentArray objectAtIndex:[row integerValue]]];
             
             [userDict removeObjectForKey:@"friend_status"];
             [userDict setObject:@"1" forKey:@"friend_status"];
             
             // [_contentArray replaceObjectAtIndex:[row integerValue] withObject:userDict];
             
             // ลบเพือนออกจาก groud
             [_contentArray removeObjectAtIndex:[row integerValue]];
             
             NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
             [newDict addEntriesFromDictionary:dictUserFriends];
             [newDict removeObjectForKey:[sectionTitleArray objectAtIndex:[section integerValue]]];
             
             [newDict setObject:_contentArray forKey:[sectionTitleArray objectAtIndex:[section integerValue]]];
             
             dictUserFriends = newDict;
             
             // ลบเพือนออกจาก Group Hide
             
             
             // เพิ่มเพือนจาก Group Friend
             NSMutableArray * _contentHideArray = [[dictUserFriends valueForKey:[sectionTitleArray objectAtIndex:3]] mutableCopy];
             [_contentHideArray addObject:userDict];
             
             NSMutableDictionary *newHideDict = [[NSMutableDictionary alloc] init];
             [newHideDict addEntriesFromDictionary:dictUserFriends];
             // [newHideDict removeObjectForKey:[sectionTitleArray objectAtIndex:[section integerValue]]];
             
             [newHideDict setObject:_contentHideArray forKey:[sectionTitleArray objectAtIndex:3]];
             
             dictUserFriends = newHideDict;
             
             // เพิ่มเพือนจาก Group Friend
             
             
             [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: dictUserFriends] forKey:_USER_FRIENDS];
             //  Save to disk
             [preferences synchronize];
             
             [self._table reloadData];
             
             */
            
            [SVProgressHUD dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:jsonDict[@"output"]];
        }
    }];
    
    [setClassFriendThread setErrorHandler:^(NSString *data) {
        [SVProgressHUD showErrorWithStatus:data];
    }];
    [setClassFriendThread start:self.friend_uid :[NSString stringWithFormat:@"%d", indexPath.row]];
}


@end
