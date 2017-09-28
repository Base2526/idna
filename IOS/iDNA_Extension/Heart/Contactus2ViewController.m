//
//  ContactusViewController.m
//  SidebarDemo
//
//  Created by Somkid on 10/3/2559 BE.
//  Copyright © 2559 AppCoda. All rights reserved.
//

#import "Contactus2ViewController.h"
//#import "SWRevealViewController.h"
//#import "MyWebViewViewController.h"
#import "UIImage+animatedGIF.h"

#import "SWRevealViewController.h"

#import "GetMyAppThread.h"
#import "AppDelegate.h"

#import "AppConstant.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "MyMapViewController.h"


@interface Contactus2ViewController ()<MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) LGPlusButtonsView *floatingActionButton; 

@end

@implementation Contactus2ViewController

@synthesize floatingActionButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"MY APP";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
                [self.sidebarButton setTarget: self.revealViewController];
                [self.sidebarButton setAction: @selector( revealToggle: )];
                [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        
//        self.revealViewController.rightViewRevealOverdraw = 0.0f;
//        [self.sidebarButton setTarget:self.revealViewController];
//        [self.sidebarButton setAction:@selector( rightRevealToggle: )];
//        [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        
    }
    
//    NSString *path=[[NSBundle mainBundle]pathForResource:@"001_1" ofType:@"gif"];
//    NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
//    self.imgGif.image= [UIImage animatedImageWithAnimatedGIFURL:url];
//    self.imgGif.backgroundColor = [UIColor blackColor];
//    self.imgGif.contentMode = UIViewContentModeScaleAspectFit;
    
    
    //    int64_t delayInSeconds = 5;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //
    //        if (self.isViewLoaded && self.view.window) {
    //            // viewController is visible
    //            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //            UINavigationController *mtc = [storybrd instantiateViewControllerWithIdentifier:@"Reveal"];
    //            [self presentViewController:mtc animated:YES completion:nil];
    //        }
    //    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 -(void)viewWillAppear:(BOOL)animated{
 
 self.main_content.hidden = YES;
 self.progressLoading.hidden = NO;
 
 GetMyProfileThread *getMyProfileThread = [[GetMyProfileThread alloc] init];
 [getMyProfileThread setCompletionHandler:^(NSString * data) {
 */

-(void)viewWillAppear:(BOOL)animated
{
    
    GetMyAppThread *getMyAppThread = [[GetMyAppThread alloc] init];
    [getMyAppThread setCompletionHandler:^(NSString * data) {
        NSLog(@"");
        
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
        
        [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: jsonDict] forKey:_MYAPP];
        
        [preferences synchronize];
         */
    }];
    [getMyAppThread setErrorHandler:^(NSString *data) {
        NSLog(@"");
    }];
    
    [getMyAppThread start];
    
    self.onAddFloatingButton;
    // [floatingActionButton showAnimated:YES completionHandler:nil];
    NSLog(@"");
    
    [floatingActionButton showAnimated:YES completionHandler:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"");
    
    [floatingActionButton hideAnimated:YES completionHandler:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)onClickFacebook:(id)sender {
    
    //    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    MyWebViewViewController *homeViewController =[storybrd instantiateViewControllerWithIdentifier:@"MyWebViewViewController"];
    //
    //    homeViewController.urlString = @"https://www.facebook.com/samosornpatumwan";
    //    // homeViewController.title = @"Home";
    //    // UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    //
    //    // [self presentViewController:homeNavController animated:YES completion:nil];
    //
    //    [self.navigationController pushViewController:homeViewController animated:YES];
    
    // Facebook Page : http://www.facebook.com/PRPDS
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.facebook.com/PRPDS"]];
}

- (IBAction)onClickGoogleplus:(id)sender {
    //    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    MyWebViewViewController *homeViewController =[storybrd instantiateViewControllerWithIdentifier:@"MyWebViewViewController"];
    //
    //    homeViewController.urlString = @"https://plus.google.com/111809891029576965143";
    //    // homeViewController.title = @"Home";
    //    // UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    //
    //    // [self presentViewController:homeViewController animated:YES completion:nil];
    //
    //    [self.navigationController pushViewController:homeViewController animated:YES];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://plus.google.com/111809891029576965143"]];
    
}

- (IBAction)onClickWWW:(id)sender {
    
    //    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    MyWebViewViewController *homeViewController =[storybrd instantiateViewControllerWithIdentifier:@"MyWebViewViewController"];
    //
    //    homeViewController.urlString = @"http://128.199.188.171";
    //    // homeViewController.title = @"Home";
    //    // UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    //
    //    // [self presentViewController:homeNavController animated:YES completion:nil];
    //    
    //    [self.navigationController pushViewController:homeViewController animated:YES];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://128.199.188.171"]];
}

- (IBAction)onMyId:(id)sender {
    
[self dismissViewControllerAnimated:YES completion:nil];
}



-(void)imgPhoneTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    /*
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [preferences objectForKey:_MYAPP];
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

-(void)onAddFloatingButton{
    
    floatingActionButton = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:2
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
//                                        case 1:{
//                                            // Share
//                                            NSLog(@"");
//                                            
//                                            // URIHEART
//                                            
//                                            [SVProgressHUD showSuccessWithStatus:@"Edit"];
//                                            
////                                            NSString *textToShare = @"Klovers ORG";
////                                            NSURL *myWebsite = [NSURL URLWithString:@"http://128.199.248.55/ext/redirect_app.php"];
////                                            
////                                            NSArray *objectsToShare = @[textToShare, myWebsite];
////                                            
////                                            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
////                                            
////                                            NSArray *excludeActivities = @[UIActivityTypeAirDrop,
////                                                                           UIActivityTypePrint,
////                                                                           UIActivityTypeAssignToContact,
////                                                                           UIActivityTypeSaveToCameraRoll,
////                                                                           UIActivityTypeAddToReadingList,
////                                                                           UIActivityTypePostToFlickr,
////                                                                           UIActivityTypePostToVimeo];
////                                            
////                                            activityVC.excludedActivityTypes = excludeActivities;
////                                            
////                                            [self presentViewController:activityVC animated:YES completion:nil];
//                                            break;
//                                        }
                                            
                                        case 1:{
                                            // Edit
                                            NSLog(@"");
                                            
                                            
                                            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                            EditMyAppViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"EditMyAppViewController"];
                                            
                                            // vc.name =self.labelName.text;
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
    
    [floatingActionButton setButtonsTitles:@[@"+", @""] forState:UIControlStateNormal];
    [floatingActionButton setDescriptionsTexts:@[@"", @"Edit"]];
    [floatingActionButton setButtonsImages:@[[NSNull new], [UIImage imageNamed:@"Picture"]]
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
    //[floatingActionButton setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.5 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    // [floatingActionButton setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.6 blue:0.2 alpha:1.f] forState:UIControlStateHighlighted];
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
    
    for (NSUInteger i=1; i<=1; i++)
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

