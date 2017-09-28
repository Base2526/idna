//
//  MyWebViewViewController.m
//  Satitpatumwan
//
//  Created by somkid simajarn on 6/8/2559 BE.
//  Copyright © 2559 satitpatumwan.ac.th. All rights reserved.
//

#import "MyWebViewViewController.h"

@interface MyWebViewViewController ()

@end

@implementation MyWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    /*
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"ic_bg.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // transparent top bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    */
    
    // [self.urlString]
    
    [self.indicatorLoading startAnimating];
    [self.indicatorLoading setHidden:NO];
    
    // NSString *urlString = @"http://www.google.com";
    NSURL *url = [NSURL URLWithString:self.urlString ];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    [self.webView setHidden:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //Check here if still webview is loding the content
    if (webView.isLoading)
        return;
    
    [self.indicatorLoading stopAnimating];
    [self.indicatorLoading setHidden:YES];
    
    [self.webView setHidden:NO];
    
    //after code when webview finishes
    NSLog(@"Webview loding finished");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
