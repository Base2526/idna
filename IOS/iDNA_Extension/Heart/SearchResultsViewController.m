//
//  SearchResultsViewController.m
//  Table Search
//
//  Created by Jay Versluis on 03/11/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "ShowResultsViewController.h"

@interface SearchResultsViewController ()
@property (nonatomic, strong) NSArray *searchResults;
@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchResults = [NSArray arrayWithObjects: @"Jill Valentine", @"Peter Griffin", @"Meg Griffin", @"Jack Lolwut",
                        @"Mike Roflcoptor", @"Cindy Woods", @"Jessica Windmill", @"Alexander The Great",
                        @"Sarah Peterson", @"Scott Scottland", @"Geoff Fanta", @"Amanda Pope", @"Michael Meyers",
                        @"Richard Biggus", @"Montey Python", @"Mike Wut", @"Fake Person", @"Chair",
                        nil];
    
    NSLog(@"====> %@", self.tabsName);
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    // cell.textLabel.text = @"test";//[self.searchResults objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // make sure cell is no longer highighlted (highlit?)
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // create new nav controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigation"];
    
    // extract view controller from nav controller
    ShowResultsViewController *controller = (ShowResultsViewController *)navController.topViewController;
    
    // pass search result
    controller.theResult = [self.searchResults objectAtIndex:indexPath.row];
    
    // present view controller via navigation controller
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    NSLog(@"observeValueForKeyPath");
    // extract array from observer
    // self.searchResults = [(NSArray *)object valueForKey:@"results"];

}


@end
