//
//  SetMyID.m
//  Heart
//
//  Created by Somkid on 12/29/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "SetMyID.h"
#import "AppConstant.h"
#import "Configs.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface SetMyID (){
    FIRDatabaseReference *ref;
    NSMutableDictionary *profiles;
}
@end

@implementation SetMyID

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ref         = [[FIRDatabase database] reference];
}

-(void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_PROFILES
                                               object:nil];
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_PROFILES object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    profiles = [[Configs sharedInstance] getUserProfiles];
    
    [self.textFieldMessage setText:@""];
    if ([profiles objectForKey:@"my_id"]) {
        [self.textFieldMessage setText:[profiles objectForKey:@"my_id"]];
    }
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
    
    NSString *strMyId = [self.textFieldMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([strMyId isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Empty."];
    }else {
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update."];
        
        NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
        [newProfiles addEntriesFromDictionary:profiles];
        if ([newProfiles objectForKey:@"my_id"]) {
            [newProfiles removeObjectForKey:@"my_id"];
        }
        [newProfiles setValue:strMyId forKey:@"my_id"];
        
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
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update My ID."];
            }
        }];
    }
}
@end
