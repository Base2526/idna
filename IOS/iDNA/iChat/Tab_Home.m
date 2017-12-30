//
//  Tab_Home.m
//  iDNA
//
//  Created by Somkid on 4/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "Tab_Home.h"
#import "Configs.h"
#import "AppDelegate.h"
// #import "SWRevealViewController.h"
#import "UserDataUIAlertView.h"
#import "AddByID.h"
#import "MyProfile.h"

@interface Tab_Home (){
    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

#define kWIDTH          UIScreen.mainScreen.bounds.size.width
@end

@implementation Tab_Home
@synthesize imageProfile, labelName, labelEmail, imageBG, imageV_edit, imageV_qrcode;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        revealViewController.rightViewRevealWidth = kWIDTH;
        revealViewController.rightViewRevealOverdraw = 0;
        
        [self.revealButton setTarget:revealViewController];
        [self.revealButton setAction: @selector(revealToggle:)];
        
        [self.rightButton setTarget:revealViewController];
        [self.rightButton setAction: @selector(rightRevealToggle:)];
        
        [self.revealViewController panGestureRecognizer];
        [self.revealViewController tapGestureRecognizer];
    }
    */
    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [[UIImage imageNamed:@"man7.jpg"] drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSMutableDictionary *data = [[Configs sharedInstance] loadData:_DATA];
 
    // #1 profile
    // NSMutableDictionary *dic_profile= [[NSMutableDictionary alloc] init];

    // NSDictionary *profiles = [data objectForKey:@"profiles"];
    // NSLog(@"");
    
    NSMutableDictionary *profiles = [data objectForKey:@"profiles"];
    if ([profiles objectForKey:@"image_url"]) {
        [imageProfile clear];
        [imageProfile showLoadingWheel];
        [imageProfile setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageProfile];
    }else{}
    
    labelName.text = [NSString stringWithFormat:@"Name : %@", [profiles objectForKey:@"name"]];
    labelEmail.text = [NSString stringWithFormat:@"Email : %@", [profiles objectForKey:@"mail"]];
    
    // BG
    if ([profiles objectForKey:@"bg_url"]) {
        
        imageBG.callbackOnSetImage = (id)self;
        [imageBG clear];
        [imageBG showLoadingWheel];
        [imageBG setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"bg_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageBG];
    }else{}
    
    
//    [imageBG clear];
//    [imageBG showLoadingWheel];
//    // [imageBG setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url"]]]];
//    [imageBG setImage:[UIImage imageNamed:@"man7.jpg"]];
//    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageBG];
    
    if ([profiles objectForKey:@"image_url_ios_qrcode"]) {
        [imageV_qrcode clear];
        [imageV_qrcode showLoadingWheel];
        [imageV_qrcode setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url_ios_qrcode"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_qrcode ];
    }
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    imageV_edit.userInteractionEnabled = YES;
    [imageV_edit addGestureRecognizer:singleFingerTap];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (IBAction)onAddFriend:(id)sender {
//    UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:nil
//                                                       message:nil
//                                                      delegate:self
//                                             cancelButtonTitle:nil
//                                             otherButtonTitles:@"QRCode", @"By ID", @"Close", nil];
//
//    // alert.userData = section;
//    alert.tag = 1;
//    [alert show];
//}

- (IBAction)onSettings:(id)sender {
    NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";
    NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
    
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
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) managedImageSet:(HJManagedImageV*)mi{
    mi.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)alertView:(UserDataUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 1) {
        NSLog(@"");
        
        switch (buttonIndex) {
            case 0:{
                // QRCode
            }
                break;
                
            case 1:{
                // By ID
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AddByID *changeFN = [storybrd instantiateViewControllerWithIdentifier:@"AddByID"];
                
                // changeFN.friend_id = [sortedKeys objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:changeFN animated:YES];
            }
                break;
            case 2:{
                
            }
                break;
        }
    }
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
//    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//    Tab_Home* tabHome = [storybrd instantiateViewControllerWithIdentifier:@"Tab_Home"];
//    UINavigationController* navTabHome = [[UINavigationController alloc] initWithRootViewController:tabHome];
//    navTabHome.navigationBar.topItem.title = @"My Profile";
//    [self presentViewController:navTabHome animated:YES completion:nil];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // if (indexPath.section == 0) {
        MyProfile* profile = [storybrd instantiateViewControllerWithIdentifier:@"MyProfile"];
        [self.navigationController pushViewController:profile animated:YES];
    // }
}

@end
