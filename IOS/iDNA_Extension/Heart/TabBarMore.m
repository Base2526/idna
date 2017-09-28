//
//  TabBarRider.m
//  wireframe
//
//  Created by somkid simajarn on 5/5/2559 BE.
//  Copyright © 2559 somkid simajarn. All rights reserved.
//

#import "TabBarMore.h"
//#import "PrivateApp_Temp.h"
//#import "NavLogin.h"
#import "LogoutThread.h"
#import "SVProgressHUD.h"
#import "AppConstant.h"
#import "PreLogin.h"

#import "Configs.h"
#import "SettingsViewController.h"
#import "SendHeartByClass.h"
#import "MyWebViewViewController.h"

@interface TabBarMore (){
    NSArray *data;
}

@end

@implementation TabBarMore

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data = @[@"Privacy" , @"Send heart by class" , @"Settings" /*, @"News", @"How to use", @"Agreement"*/ , @"Acknowledgement", /*@"Contact us",*/ @"Logout"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (headerView == nil) {
//        [[NSBundle mainBundle] loadNibNamed:@"RiderHeaderView" owner:self options:nil];
//        // headerView.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [contact objectForKey:@"name"], [contact objectForKey:@"familyname"]];
//        //        if ([[contact allKeys] containsObject:@"pictureurl"]) {
//        //            headerView.avatarView.image = [UIImage imageNamed:[contact objectForKey:@"pictureurl"]];
//        //        }
//    }
//    
//    [self._table setTableHeaderView: headerView];
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:@"Rider"]) {
        
        NSIndexPath *indexPath = [self._table indexPathForSelectedRow];
        PrivateApp_Temp* profile_Temp = segue.destinationViewController;
        switch (indexPath.row) {
            case 0:
            {
                profile_Temp.title =@"Privacy";
            }
                break;
                
            case 1:
            {
                profile_Temp.title =@"Info";
            }
                break;
                
            case 2:
            {
                profile_Temp.title =@"Settings";
            }
                break;
                
            case 3:
            {
                profile_Temp.title =@"News";
            }
                break;
                
            case 4:
            {
                profile_Temp.title =@"How to use";
            }
                break;
                
            case 5:
            {
                profile_Temp.title =@"Agreement";
            }
                break;
                
            case 6:
            {
                profile_Temp.title =@"Acknowledgement";
            }
                break;
                
            case 7:
            {
                profile_Temp.title =@"Contact us";
            }
                break;
                
            default:
                break;
        }
    }
    
    [self._table reloadData];
}
*/

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];//[[contact allKeys] count]-3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    // id key = [self.possibleFields objectAtIndex:indexPath.row];
    //    cell.textLabel.text = [NSString stringWithFormat:@"%@", key];
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [contact objectForKey:key]];
    
    //	cell.backgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    //	cell.backgroundView.backgroundColor = [UIColor whiteColor];
    //	for (UIView* view in cell.contentView.subviews)
    //	{
    //		view.backgroundColor = [UIColor clearColor];
    //	}
    //	cell.selectedBackgroundView = [[[UIImageView alloc] initWithFrame:cell.frame] autorelease];
    //	UIImage *img = [UIImage imageNamed:@"bg.png"];
    //	[(UIImageView*)[cell selectedBackgroundView] setImage:img];
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == [data count] - 1) {
        //
        
        static NSString *CellIdentifier = @"CellLogout";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }

    }else{
        
        static NSString *CellIdentifier = @"Cell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        
        switch (indexPath.row) {
            case 2:
            {
                [cell setUserInteractionEnabled:YES];
                [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingsTapped:)]];
            }
                break;
                
            default:
                break;
        }
        
        
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
        
        nameLabel.text = [data objectAtIndex:indexPath.row];
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    switch (indexPath.row) {
        case 0:
        {
            UIViewController *rider_tmp = [self.storyboard instantiateViewControllerWithIdentifier:@"Rider_tmp"];
            rider_tmp.title =@"Privacy";
            [self.navigationController pushViewController:rider_tmp animated:YES];
        }
            break;
            
        case 1:
        {
            UIViewController *rider_tmp = [self.storyboard instantiateViewControllerWithIdentifier:@"Rider_tmp"];
            rider_tmp.title =@"Info";
            [self.navigationController pushViewController:rider_tmp animated:YES];
        }
            break;
            
        case 2:
        {
            Settings *settings = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
            settings.title =@"Settings";
            [self.navigationController pushViewController:settings animated:YES];
        }
            break;
            
        case 3:
        {
            UIViewController *rider_tmp = [self.storyboard instantiateViewControllerWithIdentifier:@"Rider_tmp"];
            rider_tmp.title =@"News";
            [self.navigationController pushViewController:rider_tmp animated:YES];
        }
            break;
            
        case 4:
        {
            UIViewController *rider_tmp = [self.storyboard instantiateViewControllerWithIdentifier:@"Rider_tmp"];
            rider_tmp.title =@"How to use";
            [self.navigationController pushViewController:rider_tmp animated:YES];
        }
            break;
            
        case 5:
        {
            UIViewController *rider_tmp = [self.storyboard instantiateViewControllerWithIdentifier:@"Rider_tmp"];
            rider_tmp.title =@"Agreement";
            [self.navigationController pushViewController:rider_tmp animated:YES];
        }
            break;
            
        case 6:
        {
            UIViewController *rider_tmp = [self.storyboard instantiateViewControllerWithIdentifier:@"Rider_tmp"];
            rider_tmp.title =@"Acknowledgement";
            [self.navigationController pushViewController:rider_tmp animated:YES];
        }
            break;
            
        case 7:
        {
            UIViewController *rider_tmp = [self.storyboard instantiateViewControllerWithIdentifier:@"Rider_tmp"];
            rider_tmp.title =@"Contact us";
            [self.navigationController pushViewController:rider_tmp animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    */
    
    switch (indexPath.row) {
        case 0: // Privacy
        {
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyWebViewViewController *v = [storybrd instantiateViewControllerWithIdentifier:@"MyWebViewViewController"];
            v.urlString = @"http://128.199.247.179/node/2";
            [self.navigationController pushViewController:v animated:YES];
            
        }
            break;
        case 1: // Send Heart By Class
        {
            
            //
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SendHeartByClass *v = [storybrd instantiateViewControllerWithIdentifier:@"SendHeartByClass"];
            
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
            
        case 3: // Privacy
        {
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyWebViewViewController *v = [storybrd instantiateViewControllerWithIdentifier:@"MyWebViewViewController"];
            v.urlString = @"http://128.199.247.179/node/116";
            [self.navigationController pushViewController:v animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    if (indexPath.row == [data count] - 1) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Confirm Logout." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        
            alertView.tag = -999;
        [alertView show];
        
    }
    
    [self._table reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case -999:
            if (buttonIndex == 0)
            {
                NSLog(@"ยกเลิก");
            }
            else
            {
                NSLog(@"ตกลง");
                
                [SVProgressHUD showWithStatus:@"Logout"];
                
                LogoutThread *logoutThread = [[LogoutThread alloc] init];
                [logoutThread setCompletionHandler:^(NSString * data) {
                    
                    // Clear All Data
                    
                    
                    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:_UID];
                    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:_SESSION_ID];
                    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:_SESSION_NAME];
                    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:_USER];
                    //  [[NSUserDefaults standardUserDefaults] removeObjectForKey:_USER_CONTACTS];
                    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:_USER_HEART_CURRENT];
                    // [[NSUserDefaults standardUserDefaults] synchronize];
                    // Clear All Data
                    
                    
                    // [[Configs sharedInstance] removeData:_USER_CONTACTS]; // removeData
                    // [[Configs sharedInstance] removeData:_USER_HEART];
                    
                    [[Configs sharedInstance] removeData:_USER];
                    [[Configs sharedInstance] removeData:_DATA];
                    
                    [[Configs sharedInstance] synchronizeLogout];
                    
                    
                    // Clear badge tab 1, icon app  ให้เท่ากับ 0
                    NSDictionary *dict =  @{
                                            @"function" : @"badge",
                                            @"tabN" : @"1",
                                            @"value" : [NSString stringWithFormat:@"%i", 0],
                                            };
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
                    
                    
                    [SVProgressHUD dismiss];
                    
//                    NavLogin *mtc = [self.storyboard instantiateViewControllerWithIdentifier:@"NavLogin"];
//                    [self presentViewController:mtc animated:YES completion:nil];
                    
                    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    PreLogin *preLogin = [storybrd instantiateViewControllerWithIdentifier:@"PreLogin"];
                    
                    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:preLogin];
                    
                    [self presentViewController:nav animated:YES completion:nil];
                }];
                
                [logoutThread setErrorHandler:^(NSString *data) {
                    NSLog(@"Error data=%@", data);
                    
                    [SVProgressHUD dismiss];
                    
                    [SVProgressHUD showErrorWithStatus:data];
                }];
                [logoutThread start];
                
                
            }
            
            break;
            
        default:
            break;
    }
}

-(void)settingsTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm delete friend " message:@"Delete friend." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
//    
//        alertView.tag = -999;
//    [alertView show];
    
    SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsViewController animated:YES];
    
}

@end
