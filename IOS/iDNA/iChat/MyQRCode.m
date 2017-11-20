//
//  MyQRCode.m
//  Heart
//
//  Created by Somkid on 12/22/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "MyQRCode.h"
#import "AppDelegate.h"
@interface MyQRCode ()

@end

@implementation MyQRCode

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//                NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/qrcode/%@", [Configs sharedInstance].API_URL, [_dict objectForKey:@"profile2"][@"field_profile_my_qrcode"][@"und"][0][@"filename"]];
    
                // if (![self.profile_picture isEqualToString:@""]) {
    [self.hjhQR clear];
    [self.hjhQR showLoadingWheel];
    [self.hjhQR setUrl:[NSURL URLWithString:self.uri]];
    // [img setImage:[UIImage imageWithData:fileData]];
    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjhQR];
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

@end
