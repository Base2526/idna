//
//  ContactusViewController.m
//  SidebarDemo
//
//  Created by Somkid on 10/3/2559 BE.
//  Copyright © 2559 AppCoda. All rights reserved.
//

#import "ContactusViewController.h"
//#import "SWRevealViewController.h"
//#import "MyWebViewViewController.h"
#import "UIImage+animatedGIF.h"

#import "SWRevealViewController.h"

@interface ContactusViewController ()

@end

@implementation ContactusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Friend ID";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
//        [self.sidebarButton setTarget: self.revealViewController];
//        [self.sidebarButton setAction: @selector( revealToggle: )];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        
         self.revealViewController.rightViewRevealOverdraw = 0.0f;
         [self.sidebarButton setTarget:self.revealViewController];
         [self.sidebarButton setAction:@selector( rightRevealToggle: )];
         [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];

        
    }
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"001_1" ofType:@"gif"];
    NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
    self.imgGif.image= [UIImage animatedImageWithAnimatedGIFURL:url];
    self.imgGif.backgroundColor = [UIColor blackColor];
    self.imgGif.contentMode = UIViewContentModeScaleAspectFit;
    
    
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
@end
