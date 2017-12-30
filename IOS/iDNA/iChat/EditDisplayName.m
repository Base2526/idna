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
@synthesize uid, ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ref = [[FIRDatabase database] reference];

    self.btnSave.enabled = NO;
    self.textFieldName.delegate = self;
    // [self.textFieldName setText:self.name];
    
    if ([[[Configs sharedInstance] getUIDU] isEqualToString:uid]) {
        // แสดงว่าเป้น User
        NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
        [self.textFieldName setText:[profiles objectForKey:@"name"]];
    }else{
        // แสดงว่าเป้น Friend
        
    }
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
        
        
        if ([[[Configs sharedInstance] getUIDU] isEqualToString:uid]) {
            /*
            EditDisplayNameThread *eThread = [[EditDisplayNameThread alloc] init];
            [eThread setCompletionHandler:^(NSString *data) {
                
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                
                NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }];
            
            [eThread setErrorHandler:^(NSString *error) {
                NSLog(@"%@", error);
                
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
            }];
            [eThread start:strName];
            */
            
            [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
            
            NSMutableDictionary *data = [[Configs sharedInstance] loadData:_DATA];
            
            NSMutableDictionary *profiles = [data objectForKey:@"profiles"];
            NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
            [newProfiles addEntriesFromDictionary:profiles];
            [newProfiles removeObjectForKey:@"name"];
            [newProfiles setValue:strName forKey:@"name"];
            
            NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
            [newData addEntriesFromDictionary:data];
            [newData removeObjectForKey:@"profiles"];
            
            [newData setObject:newProfiles forKey:@"profiles"];
            
            [[Configs sharedInstance] saveData:_DATA :newData];
            
            NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
            NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newProfiles};
            
            [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                if (error == nil) {
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:NO];
                    });
                }else{
                }
            }];
        }else {
            /*
            EditFriendDisplayNameThread *eThread = [[EditFriendDisplayNameThread alloc] init];
            [eThread setCompletionHandler:^(NSString *data) {
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                
                NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }];
            
            [eThread setErrorHandler:^(NSString *error) {
                NSLog(@"%@", error);
                
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
            }];

            [eThread start:self.uid: strName];
            */
        }
    }
}
@end
