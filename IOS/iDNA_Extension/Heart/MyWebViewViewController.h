//
//  MyWebViewViewController.h
//  Satitpatumwan
//
//  Created by somkid simajarn on 6/8/2559 BE.
//  Copyright © 2559 satitpatumwan.ac.th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebViewViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorLoading;

@property(nonatomic) NSString *urlString; // @property(nonatomic) BOOL *isSomethingEnabled;

@end
