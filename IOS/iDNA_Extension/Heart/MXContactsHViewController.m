//
//  MXContactsHViewController.m
//  Heart
//
//  Created by Somkid on 9/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "MXContactsHViewController.h"

//#import <MXParallaxHeader/MXScrollViewController.h>
#import "MXScrollViewController.h"
#import "MXMyIDHViewController.h"

#import "Utility.h"


@interface MXContactsHViewController () <MXParallaxHeaderDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *falcon;
@end

@implementation MXContactsHViewController
@synthesize falcon;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.parallaxHeader.delegate = self;
    [self.parallaxHeader setHeight:200.f];
    
    self.parallaxHeader.minimumHeight = self.navigationController.navigationBar.frame.size.height + [Utility statusBarHeight];
    
    // self.scrollView.parallaxHeader.minimumHeight = 80;
    
    [Utility makeImageTriangular:self.falcon];
    
    
    
    // MXMyIDScrollViewController
    
    falcon.userInteractionEnabled = YES;
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(falconTapped:)];
    [falcon addGestureRecognizer:headerTapped];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <MXParallaxHeaderDelegate>

- (void)parallaxHeaderDidScroll:(MXParallaxHeader *)parallaxHeader {
    // CGFloat angle = parallaxHeader.progress * M_PI * 2;
    // self.falcon.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
}

#pragma mark - gesture tapped
- (void)falconTapped:(UITapGestureRecognizer *)gestureRecognizer{
    //handle pinch...
    // NSLog(@"falconTapped");
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MXMyIDHViewController *myid =[storybrd instantiateViewControllerWithIdentifier:@"MXMyIDScrollViewController"];
   // UINavigationController* navmyid = [[UINavigationController alloc] initWithRootViewController:myid];
   //  [self presentViewController:navmyid animated:YES completion:nil];
    
    [self.navigationController pushViewController:myid animated:YES];
}

@end
