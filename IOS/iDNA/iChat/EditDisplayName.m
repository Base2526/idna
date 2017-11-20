//
//  EditDisplayName.m
//  Heart
//
//  Created by Somkid on 12/22/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "EditDisplayName.h"

#import "EditDisplayNameThread.h"
#import "EditFriendDisplayNameThread.h"

// #import "SVProgressHUD.h"
#import "AppConstant.h"
#import "Configs.h"

@interface EditDisplayName ()

@end

@implementation EditDisplayName
@synthesize isfriend;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.btnSave.enabled = NO;
    self.textFieldName.delegate = self;
    [self.textFieldName setText:self.name];
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // [inputTexts replaceObjectAtIndex:textField.tag withObject:textField.text];
    NSLog(@"%@", textField.text);
    return YES;
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string {
    NSUInteger newLength = [theTextField.text length] + [string length] - range.length;
    if (newLength > 0) {
        self.btnSave.enabled = YES;
    }else{
        self.btnSave.enabled = NO;
    }
    return YES;
}

- (IBAction)onSave:(id)sender {
    
    NSString *strName = [self.textFieldName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([strName isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Empty"];
    }else {
        
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update."];
        
        if ([self.isfriend isEqualToString:@"0"]) {
            EditDisplayNameThread *eThread = [[EditDisplayNameThread alloc] init];
            [eThread setCompletionHandler:^(NSString *data) {
                
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                
                NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            
            [eThread setErrorHandler:^(NSString *error) {
                NSLog(@"%@", error);
                
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
            }];
            [eThread start:strName];
        }else if([self.isfriend isEqualToString:@"1"]){
            EditFriendDisplayNameThread *eThread = [[EditFriendDisplayNameThread alloc] init];
            [eThread setCompletionHandler:^(NSString *data) {
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                
                NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            
            [eThread setErrorHandler:^(NSString *error) {
                NSLog(@"%@", error);
                
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
            }];

            [eThread start:self.uid_friend: strName];
        }
    }
}
@end
