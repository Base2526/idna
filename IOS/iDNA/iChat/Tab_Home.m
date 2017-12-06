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
#import "SWRevealViewController.h"

#import "UserDataUIAlertView.h"

#import "AddByID.h"

@interface Tab_Home ()


@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

#define kWIDTH          UIScreen.mainScreen.bounds.size.width
@end

@implementation Tab_Home
@synthesize imageProfile, labelName;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    labelName.text = [profiles objectForKey:@"name"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onAddFriend:(id)sender {
    UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:nil
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"QRCode", @"By ID", @"Close", nil];
    
    // alert.userData = section;
    alert.tag = 1;
    [alert show];
}

- (IBAction)onSettings:(id)sender {
    NSLog(@"onSettings");
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
@end
