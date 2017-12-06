//
//  MenuTableViewController.m
//  SWTabBar
//
//  Created by Patrick BODET on 24/03/2016.
//  Copyright © 2016 Patrick BODET. All rights reserved.
//

#import "SWRevealViewController.h"
#import "MenuTableViewController.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UITabBarController *tabBarController = (UITabBarController *)self.revealViewController.frontViewController;
    UINavigationController *navController = tabBarController.viewControllers[tabBarController.selectedIndex];
    [navController popToRootViewControllerAnimated:YES];
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Item %ld", (long)indexPath.row + 1];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITabBarController *tabBarController = (UITabBarController *)self.revealViewController.frontViewController;
    UINavigationController *navController = tabBarController.viewControllers[indexPath.row];
    [navController popToRootViewControllerAnimated:NO];
    tabBarController.selectedIndex = indexPath.row;
    [self.revealViewController pushFrontViewController:tabBarController animated:YES];
}


@end
