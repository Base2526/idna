//
//  MainTabBarController.m
//  wireframe
//
//  Created by somkid simajarn on 5/5/2559 BE.
//  Copyright © 2559 somkid simajarn. All rights reserved.
//

#import "MainTabBar.h"
#import "TabBarContacts.h"
#import "TabBarHeart.h"
#import "TabBarDNA.h"
#import "TabBarDNA2.h"
#import "MXMyIDHViewController.h"
#import "MXScrollViewController.h"

#import "TabBarStore.h"
#import "AFViewController.h"


#import "TabBarMore.h"
#import "PreLogin.h"
#import "Configs.h"

#import "SearchResultsViewController.h"

@interface MainTabBar ()<UITabBarControllerDelegate, UITabBarDelegate, UITabBarControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>
{
     NSMutableArray *childObservers;
    
}

// search
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UISearchController *controller;
@property (strong, nonatomic) NSArray *results;
// search
@end

@implementation MainTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"CONTACTS";
    
    /*
     กำหนด font sanfracisco uitabbar
     */
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Light" size:11.0f]
                                                        } forState:UIControlStateNormal];
    
//    var userDefaults = NSUserDefaults(suiteName: "group.com.company.myApp")
//    userDefaults!.setObject("user12345", forKey: "userId")
//    userDefaults!.synchronize()
    
    // http://stackoverflow.com/questions/471830/why-nsuserdefaults-failed-to-save-nsmutabledictionary-in-iphone-sdk
    NSUserDefaults *userDefaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.heart.idna"];
    [userDefaults setObject:@"user12345" forKey:@"userId"];
    [userDefaults synchronize];
    
    
    childObservers = [[NSMutableArray alloc] init];
    
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:1.00 green:0.25 blue:0.50 alpha:1.0]];

    self.tabBarController.delegate = self;
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MXScrollViewController *tabBarContacts =[storybrd instantiateViewControllerWithIdentifier:@"MXContactsScrollViewController"];
    tabBarContacts.title = @"CONTACTS";
    
    //  self.tabBarItem.selectedImage = [[UIImage imageNamed:@"yourImage_selectedImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBarContacts.tabBarItem setImage:[UIImage imageNamed:@"ic_contacts"]];
    // setTitleTextAttributes
    // [tabBarContacts.tabBarItem setTitleTextAttributes:[NSDictionary  dictionaryWithObjectsAndKeys: [UIColor colorWithRed:1.00 green:0.25 blue:0.50 alpha:1.0], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    // [item1 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
    [tabBarContacts.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.00 green:0.25 blue:0.50 alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    // เป็นการ add observer tab Heart
    // [tabBarContacts NotificationCenterAddObserver];
    UINavigationController* heartNavController = [[UINavigationController alloc] initWithRootViewController:tabBarContacts];
    heartNavController.navigationBar.topItem.title = @"CONTACTS";
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchContactsItemClicked:)];
    heartNavController.visibleViewController.navigationItem.rightBarButtonItem = searchItem;
    

//    TabBarDNA *tarBarHome =[storybrd instantiateViewControllerWithIdentifier:@"TabBarDNA"];
//    tarBarHome.title = @"DNA";
//    [tarBarHome.tabBarItem setImage:[UIImage imageNamed:@"ic-dna.png"]];
//    UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:tarBarHome];

    MXScrollViewController *tarBarHome =[storybrd instantiateViewControllerWithIdentifier:@"MXiDNAScrollViewController"];
    tarBarHome.title = @"iDNA";
    
    UIImage *ic_idna = [UIImage imageNamed:@"ic_idna"];
    [tarBarHome.tabBarItem setImage:ic_idna];
    UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:tarBarHome];

    homeNavController.visibleViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchiDNAItemClicked:)];
    
    
    
    TabBarHeart *tabBarHeart =[storybrd instantiateViewControllerWithIdentifier:@"TabBarHeart"];
    tabBarHeart.title = @"HEART";
    [tabBarHeart.tabBarItem setImage:[UIImage imageNamed:@"ic-heart.png"]];
    // [tabBarHeart.tabBarItem setTitleTextAttributes:[NSDictionary  dictionaryWithObjectsAndKeys: [UIColor colorWithRed:1.00 green:0.25 blue:0.50 alpha:1.0], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [tabBarHeart.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.00 green:0.25 blue:0.50 alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    // [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:@"2"];
    // [tabBarHeart.tabBarItem setBadgeValue:@"3"];

    UINavigationController* friendsNavController = [[UINavigationController alloc] initWithRootViewController:tabBarHeart];
    
    
    TabBarMore *tabBarMore =[storybrd instantiateViewControllerWithIdentifier:@"TabBarMore"];
    tabBarMore.title = @"MORE";
    [tabBarMore.tabBarItem setImage:[UIImage imageNamed:@"ic_more"]];
    // [tabBarMore.tabBarItem setTitleTextAttributes:[NSDictionary  dictionaryWithObjectsAndKeys: [UIColor colorWithRed:1.00 green:0.25 blue:0.50 alpha:1.0], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [tabBarMore.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.00 green:0.25 blue:0.50 alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    UINavigationController* moreNavController = [[UINavigationController alloc] initWithRootViewController:tabBarMore];
    
    // UITabBarController* tabBar = [[UITabBarController alloc] init];
    //    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:nav3,nil]];
    //
    //    // [self.navigationController pushViewController:tabBar animated:YES];
    //
    //[self.navigationController pushViewController:self.tabBarController animated:YES];
    
    // [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    AFViewController *tabBarStore = [[AFViewController alloc] initWithStyle:UITableViewStylePlain];;//[storybrd instantiateViewControllerWithIdentifier:@"AFViewController"];
    tabBarStore.title = @"CENTER";
    [tabBarStore.tabBarItem setImage:[UIImage imageNamed:@"ic_center"]];
    UINavigationController* storeNavController = [[UINavigationController alloc] initWithRootViewController:tabBarStore];
    storeNavController.visibleViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchCenterItemClicked:)];

    NSArray *controllers = @[heartNavController, homeNavController, storeNavController, moreNavController];
    
    // populate our tab bar controller with the above
    
    [self setViewControllers:controllers animated:YES];
//    [self setSelectedIndex:1];
    
    // UITabBar.appearance().tintColor = UIColor.redColor()
    
    // item.selectedImage = [[UIImage imageNamed:@"ic-heart.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    // UITabBarItem
    
    /*
     UITabBar *tabBar = tabBarController.tabBar;
     
     // repeat for every tab, but increment the index each time
     UITabBarItem *firstTab = [tabBar.items objectAtIndex:0];
     */
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ManageTabBar:)
                                                 name:@"ManageTabBar"
                                               object:nil];
    */
    
    
    [self initFirebase];
    
    
    NSUserDefaults *_uDefaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.heart.idna"];
    NSDictionary* ur = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"user"]];
    
    if (ur == NULL) {
        NSMutableDictionary *_dict = [[Configs sharedInstance] loadData:_USER];
        
        if(_dict != NULL){
            [_uDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_dict] forKey:@"user"];
            [_uDefaults synchronize];
        }
    }
    
    
    
    // Remove the titles and adjust the inset to account for missing title
//    for(UITabBarItem * tabBarItem in self.tabBar.items){
//        tabBarItem.title = @"";
//        tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    }
    
    
    // search
    
    SearchResultsViewController *searchResults = (SearchResultsViewController *)self.controller.searchResultsController;
    
    /*
     https://stackoverflow.com/questions/14871799/send-notification-when-a-property-is-changed-using-kvo
     เป็นการ addObserver อีกแบบหนึ่งโดยที่ viewcontroller ต้อง ทำ function
     - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
     {
     
     }
     
     ไว้รับค่าด้วย โดยแยตาม keyPath = ก็คือ NSArrays
     */
    [self addObserver:searchResults forKeyPath:@"results" options:NSKeyValueObservingOptionNew context:nil];
    // search
}


/*
 การเพิ่มขนาดความสูงของ tabBar
 */
- (void)viewWillLayoutSubviews {
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = [Configs sharedInstance].kBarHeight;
    tabFrame.origin.y = self.view.frame.size.height - [Configs sharedInstance].kBarHeight;
    self.tabBar.frame = tabFrame;
}

-(void)viewDidDisappear:(BOOL)animated{
    /*
    for (FIRDatabaseReference *ref in childObservers) {
        [ref removeAllObservers];
    }
    */
}

//http://stackoverflow.com/questions/2191594/send-and-receive-messages-through-nsnotificationcenter-in-objective-c
- (void) ManageTabBar:(NSNotification *) notification
{
    /*
    Ex. การส่ง
     // set your message properties
     NSDictionary *dict =  @{
        @"function" : @"badge",
        @"tabN" : @"1",
        @"value" : @"100",
     };
     
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
     */
    
    /*
     NSDictionary *dict =  @{
     @"function" : @"badge",
     @"tabN" : @"1",
     @"value" : @"100",
     };
     */
    
    if ([[notification name] isEqualToString:@"ManageTabBar"]){
    
        NSDictionary* userInfo = notification.userInfo;
        
        if ([userInfo[@"function"] isEqualToString:@"badge"]) {
            UIViewController *view = [[self viewControllers] objectAtIndex:[userInfo[@"tabN"] integerValue]];
            
            if ([userInfo[@"value"] isEqualToString:@"0"]) {
                [view.tabBarItem setBadgeValue:nil];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            }else{
                [view.tabBarItem setBadgeValue:userInfo[@"value"]];
                
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[userInfo[@"value"] integerValue]];
            }
        }else if ([userInfo[@"function"] isEqualToString:@"reset"]){
            [self setSelectedIndex:0];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kFIRInstanceIDTokenRefreshNotification object:nil userInfo:nil];
        }
    }
}

-(void)viewPreLogin{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    self.title =item.title;
    
    //  self.tabBarItem.selectedImage = [[UIImage imageNamed:@"yourImage_selectedImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // item.selectedImage = [[UIImage imageNamed:@"ic-heart.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

-(void)searchContactsItemClicked:(UITapGestureRecognizer *)gestureRecognizer{    
    [self presentViewController:[self controller:@"contacts"]animated:YES completion:nil];
}

-(void)searchiDNAItemClicked:(UITapGestureRecognizer *)gestureRecognizer{
    [self presentViewController:[self controller:@"idna"]animated:YES completion:nil];
}

-(void)searchCenterItemClicked:(UITapGestureRecognizer *)gestureRecognizer{
    [self presentViewController:[self controller:@"center"]animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// init firebase
-(void)initFirebase{

    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/", [[Configs sharedInstance] getUIDU]];
    [[ref child:child] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        // FIRDatabaseReference *childRef = [ref child:child];
        // [childObservers addObject:childRef];
        
        // เป็นการ ลบ user จากหลังบ้าน
        [[Configs sharedInstance] removeData:_USER];
        [[Configs sharedInstance] removeData:_DATA];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
        // เรียก หน้า login ขึ้นมา
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PreLogin *preLogin = [storybrd instantiateViewControllerWithIdentifier:@"PreLogin"];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:preLogin];
        
        UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        
        [topController presentViewController:nav animated:YES completion:nil];
    }];
    
    [[ref child:child] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        if([snapshot.key isEqualToString:@"data"]){
            
            [[Configs sharedInstance] saveData:_DATA :snapshot.value];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil userInfo:nil];
        }
    }];
    
    [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        if([snapshot.key isEqualToString:@"data"]){
            
            [[Configs sharedInstance] saveData:_DATA :snapshot.value];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil userInfo:nil];
        }
    }];
    
    // ส่วน external เราต้องเช็กก่อนว่ามี หรือเปล่า ถ้าไม่มีให้สร้าง เพราะว่า เราส้รางหลังจากมี user แล้ว
    NSString *external_child = [NSString stringWithFormat:@"heart-id/external/%@/", [[Configs sharedInstance] getUIDU]];
    [[ref child:external_child] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
    }];
    
    [[ref child:external_child] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        if([snapshot.key isEqualToString:@"data"]){
            [[Configs sharedInstance] saveData:_EXTERNAL :snapshot.value];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil userInfo:nil];
        }
    }];
    
    [[ref child:external_child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        if([snapshot.key isEqualToString:@"data"]){
            [[Configs sharedInstance] saveData:_EXTERNAL :snapshot.value];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil userInfo:nil];
        }
    }];
    
    
    // ส่วน center
    NSString *center_child = @"heart-id/center/";
    [[ref child:center_child] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
    }];
    
    [[ref child:center_child] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        if([snapshot.key isEqualToString:@"data"]){
            [[Configs sharedInstance] saveData:_CENTER :snapshot.value];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataCenter" object:nil userInfo:nil];
        }
    }];
    
    [[ref child:center_child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        if([snapshot.key isEqualToString:@"data"]){
            [[Configs sharedInstance] saveData:_CENTER :snapshot.value];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataCenter" object:nil userInfo:nil];
        }
    }];
    // ส่วน center
    
    // ส่วน center slide
    NSString *center_slide = @"heart-id/center-slide/";
    [[ref child:center_slide] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
    }];
    
    [[ref child:center_slide] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        if([snapshot.key isEqualToString:@"data"]){
            // [[Configs sharedInstance] saveData:_CENTERSLIDE :snapshot.value];
            
            [[Configs sharedInstance] saveData:_CENTER_SLIDE :snapshot.value];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataCenterSlide" object:nil userInfo:nil];
        }
    }];
    
    [[ref child:center_slide] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        if([snapshot.key isEqualToString:@"data"]){
            [[Configs sharedInstance] saveData:_CENTER_SLIDE :snapshot.value];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataCenterSlide" object:nil userInfo:nil];
        }
    }];
    // ส่วน center slide
    
}
// init firebase


// search
- (NSMutableArray *)data {
    
    if (!_data) {
        _data = [[NSMutableArray alloc]init];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        formatter.numberStyle = NSNumberFormatterSpellOutStyle;
        
        for (int i = 0; i < 30; i++) {
            NSNumber *thisNumber = [NSNumber numberWithInt:i];
            NSString *spelledOutNumber = [formatter stringFromNumber:thisNumber];
            [_data addObject:spelledOutNumber];
        }
    }
    return _data;
}

- (UISearchController *)controller :(NSString *) tabsName{
    
    if (!_controller) {
        _controller = nil;
    }
        
    // instantiate search results table view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchResultsViewController *resultsController = [storyboard instantiateViewControllerWithIdentifier:@"SearchResults"];
        
    resultsController.tabsName = tabsName;
        
    // create search controller
    _controller = [[UISearchController alloc]initWithSearchResultsController:resultsController];
    _controller.searchResultsUpdater = self;
        
    // optional: set the search controller delegate
    _controller.delegate = self;
        
    _controller.searchBar.delegate = self;
    
    return _controller;
}


# pragma mark - Search Results Updater

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    // filter the search results
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", self.controller.searchBar.text];
    self.results = [self.data filteredArrayUsingPredicate:predicate];
    
    // NSLog(@"Search Results are: %@", [self.results description]);
}

- (IBAction)searchButtonPressed:(id)sender {
    
    // present the search controller
    
    
}

# pragma mark - Search Controller Delegate (optional)

- (void)didDismissSearchController:(UISearchController *)searchController {
    
    // called when the search controller has been dismissed
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    
    // called when the serach controller has been presented
}

- (void)presentSearchController:(UISearchController *)searchController {
    
    // if you want to implement your own presentation for how the search controller is shown,
    // you can do that here
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    
    // called just before the search controller is dismissed
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    
    // called just before the search controller is presented
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // [self.searchDisplayController setActive:NO animated:YES];
    
}


// search

@end
