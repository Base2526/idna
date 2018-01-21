//
//  EditAddress.m
//  iDNA
//
//  Created by Somkid on 4/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "EditAddress.h"
#import "ProfilesRepo.h"
#import "Configs.h"

@interface EditAddress (){
    ProfilesRepo *profilesRepo;
    NSMutableDictionary *profiles;
}

@end

@implementation EditAddress
@synthesize ref, type;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref         = [[FIRDatabase database] reference];
    profilesRepo = [[ProfilesRepo alloc] init];
    
    NSArray *pf = [profilesRepo get];
    NSData *data =  [[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([type isEqualToString:@"address"]) {
        self.title = @"Address";
        if ([profiles objectForKey:@"address"]) {
            self.textAddress.text = [profiles objectForKey:@"address"];
        }
    }else if([type isEqualToString:@"school"]){
        self.title = @"School";
        if ([profiles objectForKey:@"school"]) {
            self.textAddress.text = [profiles objectForKey:@"school"];
        }
    }else if([type isEqualToString:@"company"]){
        self.title = @"Company";
        if ([profiles objectForKey:@"company"]) {
            self.textAddress.text = [profiles objectForKey:@"company"];
        }
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
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    NSString *strName = [self.textAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
    [newProfiles addEntriesFromDictionary:profiles];
    
    /*
    if ([newProfiles objectForKey:@"address"]) {
        [newProfiles removeObjectForKey:@"address"];
    }
        
    [newProfiles setValue:strName forKey:@"address"];
    */
    
    if ([type isEqualToString:@"address"]) {
        if ([newProfiles objectForKey:@"address"]) {
            [newProfiles removeObjectForKey:@"address"];
        }
        
        [newProfiles setValue:strName forKey:@"address"];
    }else if([type isEqualToString:@"school"]){
        if ([newProfiles objectForKey:@"school"]) {
            [newProfiles removeObjectForKey:@"school"];
        }
        
        [newProfiles setValue:strName forKey:@"school"];
    }else if([type isEqualToString:@"company"]){
        if ([newProfiles objectForKey:@"company"]) {
            [newProfiles removeObjectForKey:@"company"];
        }
        
        [newProfiles setValue:strName forKey:@"company"];
    }
    
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
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update address."];
            }
    }];
}
@end
