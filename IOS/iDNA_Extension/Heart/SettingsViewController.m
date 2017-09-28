//
//  SettingsViewController.m
//  Heart
//
//  Created by Somkid on 1/9/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "SettingsViewController.h"
#import "ChangePassword.h"
#import "ManageClass.h"

@interface SettingsViewController ()
{
    NSArray *data_all;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data_all = @[@"Change password", @"Manage Class"];
    
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
    return  [data_all count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //  cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    UILabel *labelName  = (UILabel *)[cell viewWithTag:10];
    
//    [labelName setText:[all_data objectAtIndex:indexPath.row]];
//    
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    
//    if ([self.friend_status integerValue] == indexPath.row) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
    
    [labelName setText:[data_all objectAtIndex:indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ChangePassword *v = [storybrd instantiateViewControllerWithIdentifier:@"ChangePassword"];
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
            
        case 1:
        {
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ManageClass *v = [storybrd instantiateViewControllerWithIdentifier:@"ManageClass"];
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
        default:
            break;
    }
    
    [self._table reloadData];
}

@end
