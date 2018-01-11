//
//  SetMyID.m
//  Heart
//
//  Created by Somkid on 12/29/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "SetMyID.h"
#import "SetMyIDThread.h"
#import "AppConstant.h"
#import "Configs.h"
#import "ProfilesRepo.h"

@interface SetMyID (){
    
    ProfilesRepo *profilesRepo;
    NSMutableDictionary *profiles;
}

@end

@implementation SetMyID

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    profilesRepo = [[ProfilesRepo alloc] init];
    
    NSArray *pf = [profilesRepo get];
    NSData *data =  [[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    [self.textFieldMessage setText:@""];
    if ([profiles objectForKey:@"my_id"]) {
        [self.textFieldMessage setText:[profiles objectForKey:@"my_id"]];
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

- (IBAction)onSave:(id)sender {
    
    NSString *strName = [self.textFieldMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([strName isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Empty."];
    }else {
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update."];
        
        SetMyIDThread *eThread = [[SetMyIDThread alloc] init];
        [eThread setCompletionHandler:^(NSData *data) {
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
                [newProfiles addEntriesFromDictionary:profiles];
        
                if ([newProfiles objectForKey:@"my_id"]) {
                    [newProfiles removeObjectForKey:@"my_id"];
                }
                [newProfiles setValue:strName forKey:@"my_id"];
                
                Profiles *pfs = [[Profiles alloc] init];
                NSError * err;
                NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfiles options:0 error:&err];
                pfs.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
                pfs.update    = [timeStampObj stringValue];
                
                BOOL sv = [profilesRepo update:pfs];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
            }
        }];
        
        [eThread setErrorHandler:^(NSString *error) {
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        [eThread start:strName];
    }
}
@end
