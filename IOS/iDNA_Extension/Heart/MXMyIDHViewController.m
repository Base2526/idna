//
//  MXContactsViewController.m
//  Heart
//
//  Created by Somkid on 8/29/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "MXMyIDHViewController.h"


// #import <MXParallaxHeader/MXScrollViewController.h>
#import "MXScrollViewController.h"
#import "Utility.h"

@interface MXMyIDHViewController () <MXParallaxHeaderDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *falcon;
@property (weak, nonatomic) IBOutlet UIView *viewBG;

@end

@implementation MXMyIDHViewController
@synthesize falcon, labelName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareItemClicked:)];
    //heartNavController.visibleViewController.navigationItem.rightBarButtonItem = searchItem;
    
    
    self.navigationController.visibleViewController.navigationItem.rightBarButtonItem = shareItem;
    
    
    self.navigationController.visibleViewController.navigationItem.title = @"MY ID";
    
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
 
    
    self.parallaxHeader.delegate = self;
    [self.parallaxHeader setHeight:250.f];
    
    self.parallaxHeader.minimumHeight = 5 + self.navigationController.navigationBar.frame.size.height + [Utility statusBarHeight];
    
    [Utility makeImageTriangular:self.falcon];
    
    self.viewBG.backgroundColor = [UIColor colorWithRed:0.96 green:0.06 blue:0.31 alpha:1.0];
    
    
    falcon.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pgr = [[UIPinchGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(handlePinch:)];
    pgr.delegate = self;
    [falcon addGestureRecognizer:pgr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <MXParallaxHeaderDelegate>

- (void)parallaxHeaderDidScroll:(MXParallaxHeader *)parallaxHeader {
    
    NSLog(@"==> %f", parallaxHeader.progress* 0.1f);
    // CGFloat angle = parallaxHeader.progress * M_PI * 2;
    // self.falcon.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
    
    if (parallaxHeader.progress < 1) {
        // < 1 scroll ขึ้น
        [labelName setAlpha:parallaxHeader.progress * 0.2f];
    }else{
        // > 1 scroll ลง
         [labelName setAlpha:parallaxHeader.progress];
    }
}


- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    //handle pinch...
    NSLog(@"MM");
}

-(void)shareItemClicked:(UITapGestureRecognizer *)gestureRecognizer{
    // [self presentViewController:[self controller:@"contacts"]animated:YES completion:nil];
    
    NSLog(@"-->shareItemClicked");
}

//- (IBAction)onClose:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

@end

