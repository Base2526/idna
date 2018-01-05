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
#import "AppConstant.h"
#import "Configs.h"
#import "Profiles.h"
#import "ProfilesRepo.h"

@interface EditDisplayName (){
    ProfilesRepo *profileRepo;
}
@end

@implementation EditDisplayName
@synthesize uid, ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ref         = [[FIRDatabase database] reference];
    profileRepo = [[ProfilesRepo alloc] init];

    self.btnSave.enabled = NO;
    self.textFieldName.delegate = self;
    // [self.textFieldName setText:self.name];
    
    if ([[[Configs sharedInstance] getUIDU] isEqualToString:uid]) {
        // แสดงว่าเป้น User
        // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
        
        NSArray *pf = [profileRepo get];
        NSData *data =  [[pf objectAtIndex:[profileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
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
            
            NSArray *pf = [profileRepo get];
            NSData *data =  [[pf objectAtIndex:[profileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
            [newProfiles addEntriesFromDictionary:profiles];
            [newProfiles removeObjectForKey:@"name"];
            [newProfiles setValue:strName forKey:@"name"];
            
            Profiles *pfs = [[Profiles alloc] init];
            NSError * err;
            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfiles options:0 error:&err];
            pfs.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            pfs.update    = [timeStampObj stringValue];
            
            BOOL sv = [profileRepo update:pfs];
            
            NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
            NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newProfiles};
            
            [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
               
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                if (error == nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:NO];
                    });
                }else{
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update name."];
                }
            }];
        }else {
           
        }
    }
}
@end
