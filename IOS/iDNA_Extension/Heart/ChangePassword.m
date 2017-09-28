//
//  ChangePasswordViewController.m
//  Heart
//
//  Created by Somkid on 1/9/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ChangePassword.h"
#import "UpdateNewPasswordThread.h"
#import "Configs.h"

@interface ChangePassword ()

@end

@implementation ChangePassword
@synthesize textFieldOldpassword, textFieldNewpassword, textFieldConfirmpassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onSave:(id)sender {
    
    
    // [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Success"];
    
    // [self.navigationController popViewControllerAnimated:NO];
    
    
    NSString *oldPassword = [textFieldOldpassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *newPassword = [textFieldNewpassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *confirmPassword = [textFieldConfirmpassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([oldPassword isEqualToString:@""] && [newPassword isEqualToString:@""] && [confirmPassword isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Old, New, Confirm password is empty"];
    }else if([oldPassword isEqualToString:@""]){
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Old password is empty"];
    }else if([newPassword isEqualToString:@""]){
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"New password is empty"];
    }else if([confirmPassword isEqualToString:@""]){
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Confirm password is empty"];
    }else if(![newPassword isEqualToString:confirmPassword]){
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"New & Confirm password not match"];
    }else{
    
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
        UpdateNewPasswordThread *unpThread = [[UpdateNewPasswordThread alloc] init];
        [unpThread setCompletionHandler:^(NSString *data) {
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
                [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update new password success."];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
            }
        }];
    
        [unpThread setErrorHandler:^(NSString *error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        [unpThread start:oldPassword :newPassword];
    }
}
@end
