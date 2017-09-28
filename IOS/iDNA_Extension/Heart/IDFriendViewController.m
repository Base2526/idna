//
//  IDFriendViewController.m
//  Heart
//
//  Created by Somkid on 11/9/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "IDFriendViewController.h"

//@interface IDFriendViewController ()
//
//@end
//
//@implementation IDFriendViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end

//
//  TabBarChatWall.m
//  wireframe
//
//  Created by somkid simajarn on 5/5/2559 BE.
//  Copyright © 2559 somkid simajarn. All rights reserved.
//


#import "AppDelegate.h"
//#import "Profile.h"
//#import "XHDemoWeChatMessageTableViewController.h"

//#import "ChoiceInviteFriend.h"
#import "UIImage+animatedGIF.h"
#import "AppConstant.h"

#import "EditMyIDViewController.h"

#import "MyMapViewController.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface IDFriendViewController ()<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) LGPlusButtonsView *floatingActionButton; // FloatingActionButton

@end

@implementation IDFriendViewController
{
    NSArray *listItems;
}
@synthesize floatingActionButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"");
    
    listItems = @[@"profile", @"biosphere", @"wallet", @"playground"];
    
    //    NSString *path=[[NSBundle mainBundle]pathForResource:@"001_1" ofType:@"gif"];
    //    NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
    //    self.imgGif.image= [UIImage animatedImageWithAnimatedGIFURL:url];
    //    self.imgGif.backgroundColor = [UIColor blackColor];
    //    self.imgGif.contentMode = UIViewContentModeScaleAspectFit;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.main_content.hidden = YES;
    self.progressLoading.hidden = NO;
    
    GetMyProfileThread *getMyProfileThread = [[GetMyProfileThread alloc] init];
    [getMyProfileThread setCompletionHandler:^(NSString * data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        self.labelName.text =jsonDict[@"name"];
        
        
        // Image Profile
        [self.hjmImgProfile clear];
        
        if (![jsonDict[@"url_picture"] isEqualToString:@""]) {
            [self.hjmImgProfile showLoadingWheel];
            [self.hjmImgProfile  setUrl:[NSURL URLWithString:jsonDict[@"url_picture"]]];
            // [self.HJImageVProfile setImage:[UIImage imageWithData:fileData]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImgProfile ];
        }
        
        // Image Profile
        
        
        // Image QRCode
        [self.hjmImgQRCode clear];
        [self.hjmImgQRCode  showLoadingWheel];
        [self.hjmImgQRCode  setUrl:[NSURL URLWithString:jsonDict[@"url_qrcode" ]]];
        // [self.HJImageVProfile setImage:[UIImage imageWithData:fileData]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImgQRCode ];
        // Image QRCode
        
        
        //        heartImageView.userInteractionEnabled = YES;
        //        [heartImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heartImageViewTapped:)]];
        
        /*
         @property (weak, nonatomic) IBOutlet UIImageView *img_phone;
         @property (weak, nonatomic) IBOutlet UIImageView *img_location;
         @property (weak, nonatomic) IBOutlet UIImageView *img_email;
         @property (weak, nonatomic) IBOutlet UIImageView *img_google_plus;
         @property (weak, nonatomic) IBOutlet UIImageView *img_facebook;
         */
        
        self.img_phone.userInteractionEnabled = YES;
        [self.img_phone addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhoneTapped:)]];
        
        
        self.img_location.userInteractionEnabled = YES;
        [self.img_location addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgLocationTapped:)]];
        
        self.img_email.userInteractionEnabled = YES;
        [self.img_email addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgEmailTapped:)]];
        
        
        self.img_google_plus.userInteractionEnabled = YES;
        [self.img_google_plus addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgGooglePlusTapped:)]];
        
        self.img_facebook.userInteractionEnabled = YES;
        [self.img_facebook addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgFacebookTapped:)]];
        
        
        
        /*
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        
        // NSUserDefaults save NSMutableDictionary
        // http://stackoverflow.com/questions/471830/why-nsuserdefaults-failed-to-save-nsmutabledictionary-in-iphone-sdk
        
        [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: jsonDict] forKey:_PROFILE];
        
        [preferences synchronize];
        */
        
        self.main_content.hidden = NO;
        self.progressLoading.hidden = YES;
    }];
    [getMyProfileThread setErrorHandler:^(NSString *data) {
        self.main_content.hidden = NO;
        self.progressLoading.hidden = YES;
    }];
    [getMyProfileThread start];
    
    
    self.onAddFloatingButton;
    // [floatingActionButton showAnimated:YES completionHandler:nil];
    NSLog(@"");
    
    [floatingActionButton showAnimated:YES completionHandler:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"");
    
    [floatingActionButton hideAnimated:YES completionHandler:nil];
}

- (IBAction)onHeartATAll:(id)sender {
    UINavigationController *navChatView = [self.storyboard instantiateViewControllerWithIdentifier:@"NavHeartATAll"];
    // [self.navigationController pushViewController:chatView animated:YES];
    [self presentViewController:navChatView animated:YES completion:nil];
    
}

- (void)NotificationCenterAddObserver{
    
    NSLog(@"");
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
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [listItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
     
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     
     UIImageView *profileImageView = (UIImageView *)[cell viewWithTag:100];
     profileImageView.tag = indexPath.row;
     profileImageView.userInteractionEnabled = YES;
     [profileImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageViewTapped:)]];
     
     UIImageView *heartImageView = (UIImageView *)[cell viewWithTag:101];
     heartImageView.tag = indexPath.row;
     heartImageView.userInteractionEnabled = YES;
     [heartImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heartImageViewTapped:)]];
     
     UILabel *nameLabel = (UILabel *)[cell viewWithTag:102];
     nameLabel.text = [NSString stringWithFormat:@"%@ %d", @"Name #", indexPath.row];
     
     
     return cell;
     */
    
    // HeartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeartCell" forIndexPath:indexPath];
    // NSString *CellIdentifier = [listItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    switch (indexPath.section) {
    //        case 0:
    //        case 1:
    //            return NO;
    //
    //        case 2:
    //            return YES;
    //        default:
    //            return NO;
    //    }
    
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *blockAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Archive" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        // [self.tableView setEditing:NO];
        NSLog(@"");
    }];
    // blockAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *hiddenAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"");
    }];
    
    return @[hiddenAction, blockAction];
}

-(void)profileImageViewTapped:(UITapGestureRecognizer *)gestureRecognizer{
    /*
     NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
     
     Profile *profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"Profile"];
     [self.navigationController pushViewController:profileView animated:YES];
     */
}

-(void)imgPhoneTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    /*
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [preferences objectForKey:_PROFILE];
    NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"tel:", _dict[@"phone_number"]]]];  //
    */
}

-(void)imgLocationTapped:(UITapGestureRecognizer *)gestureRecognizer{
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:12125551212"]];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyMapViewController *tabBarFriends =[storybrd instantiateViewControllerWithIdentifier:@"MyMapViewController"];
    // tabBarFriends.title = @"FRIENDS";
    // UINavigationController* friendsNavController = [[UINavigationController alloc] initWithRootViewController:tabBarFriends];
    
    [self.navigationController pushViewController:tabBarFriends animated:YES];
}

-(void)imgEmailTapped:(UITapGestureRecognizer *)gestureRecognizer{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"Email subject"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"android.somkid@gmail.com"]];
        [mailCont setMessageBody:@"Email message" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

-(void)imgGooglePlusTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://plus.google.com/"]];
}

-(void)imgFacebookTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.facebook.com/"]];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(void)heartImageViewTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    UINavigationController *navChatView = [self.storyboard instantiateViewControllerWithIdentifier:@"NavChat"];
    // [self.navigationController pushViewController:chatView animated:YES];
    [self presentViewController:navChatView animated:YES completion:nil];
    
    //    XHDemoWeChatMessageTableViewController *demoWeChatMessageTableViewController = [[XHDemoWeChatMessageTableViewController alloc] init];
    //    // [self.navigationController pushViewController:demoWeChatMessageTableViewController animated:YES];
    //
    //    UINavigationController* wallertNavController = [[UINavigationController alloc] initWithRootViewController:demoWeChatMessageTableViewController];
    //
    //    // wallertNavController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Add:)] ;
    //
    //    //    wallertNavController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"xyz" style:UIBarButtonItemStyleDone target:self action:@selector(Add:)];
    //
    //
    //    [self presentViewController:wallertNavController animated:YES completion:nil];
}


-(void)onAddFloatingButton{
    
    floatingActionButton = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:3
                                                         firstButtonIsPlusButton:YES
                                                                   showAfterInit:YES
                                                                   actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
                            {
                                NSLog(@"actionHandler | title: %@, description: %@, index: %lu", title, description, (long unsigned)index);
                                
                                if (index == 0){
                                }else{
                                    //                                    UINavigationController *navView = [self.storyboard instantiateViewControllerWithIdentifier:@"choice_invite_friend"];
                                    //                                    navView.title = @"somkid";
                                    //                                    [self presentViewController:navView animated:YES completion:nil];
                                    
                                    switch (index) {
                                        case 1:{
                                            // Share
                                            NSLog(@"");
                                            
                                            // URIHEART
                                            
                                            
                                            NSString *textToShare = @"Klovers ORG";
                                            NSURL *myWebsite = [NSURL URLWithString:@"http://128.199.248.55/ext/redirect_app.php"];
                                            
                                            NSArray *objectsToShare = @[textToShare, myWebsite];
                                            
                                            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
                                            
                                            NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                                                           UIActivityTypePrint,
                                                                           UIActivityTypeAssignToContact,
                                                                           UIActivityTypeSaveToCameraRoll,
                                                                           UIActivityTypeAddToReadingList,
                                                                           UIActivityTypePostToFlickr,
                                                                           UIActivityTypePostToVimeo];
                                            
                                            activityVC.excludedActivityTypes = excludeActivities;
                                            
                                            [self presentViewController:activityVC animated:YES completion:nil];
                                            break;
                                        }
                                            
                                        case 2:{
                                            // Edit
                                            NSLog(@"");
                                            
                                            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                            EditMyIDViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"EditMyID"];
                                            
                                            vc.name =self.labelName.text;
                                            [self.navigationController pushViewController:vc animated:YES];
                                            break;
                                        }
                                            
                                        default:
                                            break;
                                    }
                                    
                                    
                                    
                                    //  [floatingActionButton hideAnimated:YES completionHandler:nil];
                                    [floatingActionButton hideButtonsAnimated:YES completionHandler:nil];
                                }
                            }];
    
    // floatingActionButton.observedScrollView = self.scrollView;
    floatingActionButton.coverColor = [UIColor colorWithWhite:1.f alpha:0.7];
    floatingActionButton.position = LGPlusButtonsViewPositionBottomRight;
    floatingActionButton.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    
    [floatingActionButton setButtonsTitles:@[@"+", @"", @""] forState:UIControlStateNormal];
    [floatingActionButton setDescriptionsTexts:@[@"", @"Share", @"Edit"]];
    [floatingActionButton setButtonsImages:@[[NSNull new], [UIImage imageNamed:@"Camera"], [UIImage imageNamed:@"Picture"]]
                                  forState:UIControlStateNormal
                            forOrientation:LGPlusButtonsViewOrientationAll];
    
    [floatingActionButton setButtonsAdjustsImageWhenHighlighted:NO];
    [floatingActionButton setButtonsBackgroundColor:[UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f] forState:UIControlStateNormal];
    [floatingActionButton setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted];
    [floatingActionButton setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted|UIControlStateSelected];
    [floatingActionButton setButtonsSize:CGSizeMake(44.f, 44.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [floatingActionButton setButtonsLayerCornerRadius:44.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
    [floatingActionButton setButtonsTitleFont:[UIFont boldSystemFontOfSize:24.f] forOrientation:LGPlusButtonsViewOrientationAll];
    [floatingActionButton setButtonsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [floatingActionButton setButtonsLayerShadowOpacity:0.5];
    [floatingActionButton setButtonsLayerShadowRadius:3.f];
    [floatingActionButton setButtonsLayerShadowOffset:CGSizeMake(0.f, 2.f)];
    [floatingActionButton setButtonAtIndex:0 size:CGSizeMake(56.f, 56.f)
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [floatingActionButton setButtonAtIndex:0 layerCornerRadius:56.f/2.f
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [floatingActionButton setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:40.f]
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [floatingActionButton setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -3.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [floatingActionButton setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:1.f green:0.f blue:0.5 alpha:1.f] forState:UIControlStateNormal];
    [floatingActionButton setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:1.f green:0.2 blue:0.6 alpha:1.f] forState:UIControlStateHighlighted];
    [floatingActionButton setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.5 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [floatingActionButton setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.6 blue:0.2 alpha:1.f] forState:UIControlStateHighlighted];
    //    [floatingActionButton setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.7 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    //    [floatingActionButton setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    
    [floatingActionButton setDescriptionsBackgroundColor:[UIColor whiteColor]];
    [floatingActionButton setDescriptionsTextColor:[UIColor blackColor]];
    [floatingActionButton setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [floatingActionButton setDescriptionsLayerShadowOpacity:0.25];
    [floatingActionButton setDescriptionsLayerShadowRadius:1.f];
    [floatingActionButton setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
    [floatingActionButton setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
    [floatingActionButton setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
    
    for (NSUInteger i=1; i<=2; i++)
        [floatingActionButton setButtonAtIndex:i offset:CGPointMake(-6.f, 0.f)
                                forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [floatingActionButton setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -2.f) forOrientation:LGPlusButtonsViewOrientationLandscape];
        [floatingActionButton setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:32.f] forOrientation:LGPlusButtonsViewOrientationLandscape];
    }
    
    [self.navigationController.view addSubview:floatingActionButton];
}

@end

