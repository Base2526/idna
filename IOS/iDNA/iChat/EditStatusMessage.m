//
//  EditStatusMessage.m
//  Heart
//
//  Created by Somkid on 12/27/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "EditStatusMessage.h"

#import "EditStatusMessageThread.h"
#import "Configs.h"
// #import "SVProgressHUD.h"
#import "AppConstant.h"

#import "ProfilesRepo.h"

@interface EditStatusMessage ()
{
    ProfilesRepo *profilesRepo;
}
@end

@implementation EditStatusMessage
@synthesize ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.textFieldMessage setText:self.message];
    self.btnSave.enabled = NO;
    self.textFieldMessage.delegate = self;
    
    ref         = [[FIRDatabase database] reference];
    profilesRepo = [[ProfilesRepo alloc] init];
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
    
    NSString *strName = [self.textFieldMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([strName isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Empty."];
    }else {
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
        
        NSArray *pf = [profilesRepo get];
        NSData *data =  [[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
        [newProfiles addEntriesFromDictionary:profiles];
        
        if ([newProfiles objectForKey:@"status_message"]) {
            [newProfiles removeObjectForKey:@"status_message"];
        }
        
        [newProfiles setValue:strName forKey:@"status_message"];
        
        /*
        Profiles *pfs = [[Profiles alloc] init];
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfiles options:0 error:&err];
        pfs.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        pfs.update    = [timeStampObj stringValue];
        
        // BOOL sv = [profilesRepo update:pfs];
        
        // [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:pfs];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL sv = [profilesRepo update:pfs];
        });
        */
        
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfiles options:0 error:&err];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        
        
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
    }
}
@end
