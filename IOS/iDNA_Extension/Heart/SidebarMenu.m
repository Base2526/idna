//
//  SidebarTableViewController.m
//  SidebarDemo
//
//  Created by Simon Ng on 10/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "SidebarMenu.h"
#import "SWRevealViewController.h"
//#import "NavLogin.h"

//#import <Quickblox/Quickblox.h>

#import "SVProgressHUD.h"

#import "LogoutThread.h"
#import "AppConstant.h"

#import <Firebase/Firebase.h>
#import "Configs.h"

@interface SidebarMenu ()

@end

@implementation SidebarMenu {
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // menuItems = @[@"home", @"my_profile", @"logout"];
    
        menuItems = @[@"title", @"calendar", @"news", @"comments", @"map", @"wishlist", @"policy", @"privacy", @"acknowledge"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%d", indexPath.row); // you can see selected row number in your console;
//    
//    if ([indexPath row] == 2) {
//        NSLog(@"->");
//        
//    }
//}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case -999:
            /*
            if (buttonIndex == 0)
            {
                NSLog(@"ยกเลิก");
            }
            else
            {
                NSLog(@"ตกลง");
//                // [self dismissModalViewControllerAnimated:YES];
//                LoginViewController *login = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
//                login.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//                [self.presentingViewController presentModalViewController:login animated:YES];
                
                [SVProgressHUD showWithStatus:@"Logout"];
                
             
                
                LogoutThread *logoutThread = [[LogoutThread alloc] init];
                [logoutThread setCompletionHandler:^(NSString * str) {
                    
                    //        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", user[PF_USER_FULLNAME]]];
                    //        [self dismissViewControllerAnimated:YES completion:nil];
                    
                    NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:str  options:kNilOptions error:nil];
                    
             
                    
                    NSLog(@"%@", jsonDict);
                    
                    
                    // http://stackoverflow.com/questions/19206762/equivalent-to-shared-preferences-in-ios
                    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                    
                    
                    Firebase *ref = [[Firebase alloc] initWithUrl:[Configs sharedInstance].API_URL_FIREBASE];
                    
                    Firebase *loginRef = [ref childByAppendingPath: [NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL_FIREBASE_USER_LOGIN, [preferences objectForKey:_UID]  ]];
                    
                    NSDictionary *user = @{
                                            @"online" : @"0"
                                           };
                    
                    [loginRef updateChildValues: user];
                    
                    
                    
                    // const NSInteger currentLevel = ...;
                    // [preferences setInteger:currentLevel forKey:currentLevelKey];
                    [preferences setObject:nil forKey:_UID];
                    [preferences setObject:nil forKey:_SESSION_ID];
                    [preferences setObject:nil forKey:_SESSION_NAME];
                    [preferences setObject:nil forKey:_USER];
                    
                    
                    //  Save to disk
                    const BOOL didSave = [preferences synchronize];
                    
                    if (didSave)
                    {
                        //  Couldn't save (I've never seen this happen in real world testing)
                        
//                        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                        
//                        LoginViewController *_loginViewC =[storybrd instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                        // UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];settingsViewController.title = @"Settings";
//                        
//                        UINavigationController* _navViewC = [[UINavigationController alloc] initWithRootViewController:_loginViewC];
//                        
//                        [self presentViewController:_navViewC animated:YES completion:nil];
                        
                        
                        
                        
                        NavLogin *mtc = [self.storyboard instantiateViewControllerWithIdentifier:@"NavLogin"];
                        [self presentViewController:mtc animated:YES completion:nil];
                        
//                        [self.hud hide:YES];
//                        [self.hud removeFromSuperview];
                        
                        [SVProgressHUD  dismiss];
                    }
                    
                    
                    NSLog(@"%@", str);
                }];
                [logoutThread setErrorHandler:^(NSString * str) {
                    NSLog(@"%@", str);
//                    
//                    [self.hud hide:YES];
//                    [self.hud removeFromSuperview];
                    
                    [SVProgressHUD  dismiss];
                }];
                
                [logoutThread start];
            }
            */
            
            break;
            
        default:
            break;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
//    if ([segue.identifier isEqualToString:@"showPhoto"]) {
//        UINavigationController *navController = segue.destinationViewController;
//        PhotoViewController *photoController = [navController childViewControllers].firstObject;
//        NSString *photoFilename = [NSString stringWithFormat:@"%@_photo", [menuItems objectAtIndex:indexPath.row]];
//        photoController.photoFilename = photoFilename;
//    }
}


@end
