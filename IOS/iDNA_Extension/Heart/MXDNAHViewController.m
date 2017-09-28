// MXFalconViewController.m
//
// Copyright (c) 2017 Maxime Epain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MXDNAHViewController.h"

// #import <MXParallaxHeader/MXScrollViewController.h>
#import "MXScrollViewController.h"

#import "Utility.h"

@interface MXDNAHViewController () <MXParallaxHeaderDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *falcon;
@end

@implementation MXDNAHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.parallaxHeader.delegate = self;
    [self.parallaxHeader setHeight:200.f];
    
    /*
     ความสูงเมือ = minimumHeight จะหยุด
     */
    self.parallaxHeader.minimumHeight = self.navigationController.navigationBar.frame.size.height + [Utility statusBarHeight];
    
    [Utility makeImageTriangular:self.falcon];
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

@end
