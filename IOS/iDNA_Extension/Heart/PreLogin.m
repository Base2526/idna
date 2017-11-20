//
//  PreLoginViewController.m
//  Heart
//
//  Created by Somkid on 12/17/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "PreLogin.h"
#import "AnNmousUThread.h"
#import "SVProgressHUD.h"
#import "AppConstant.h"
#import "Configs.h"
#import "MainTabBar.h"

@interface PreLogin ()
@end

@implementation PreLogin
@synthesize btnLogin, btnAnnonymous;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Welcome to DNA";
    
    btnLogin.layer.cornerRadius = 5;
    btnLogin.layer.borderWidth = 1;
    btnLogin.layer.borderColor = [UIColor blueColor].CGColor;
    
    btnAnnonymous.layer.cornerRadius = 5;
    btnAnnonymous.layer.borderWidth = 1;
    btnAnnonymous.layer.borderColor = [UIColor blueColor].CGColor;
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

- (IBAction)onAnnmousu:(id)sender {
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    
    AnNmousUThread * nThread = [[AnNmousUThread alloc] init];
    [nThread setCompletionHandler:^(NSString * data) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            NSMutableDictionary *idata  = jsonDict[@"data"];
        
            if (![idata isKindOfClass:[NSDictionary class]]) {
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[NSString stringWithFormat:@"%@", idata]];
            }else{
                
                if ([idata count] > 0) {
                    // http://stackoverflow.com/questions/19206762/equivalent-to-shared-preferences-in-ios
                    // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                    
                    // NSLog(@"%@", [idata objectForKey:@"user"][@"uid"]);
                    
                    // const NSInteger currentLevel = ...;
                    // [preferences setInteger:currentLevel forKey:currentLevelKey];
                    // [preferences setObject:[idata objectForKey:@"user"][@"uid"] forKey:_UID];
                    // [preferences setObject:[idata objectForKey:@"sessid"] forKey:_SESSION_ID];
                    // [preferences setObject:[idata objectForKey:@"session_name"] forKey:_SESSION_NAME];
                    
                    // NSUserDefaults save NSMutableDictionary
                    // http://stackoverflow.com/questions/471830/why-nsuserdefaults-failed-to-save-nsmutabledictionary-in-iphone-sdk
                    // [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: idata] forKey:_USER];
                    
                    [[Configs sharedInstance] saveData:_USER :idata];
                    //if ([preferences synchronize])
                    // {
//                        NSDictionary *dict =  @{@"function" : @"reset"};
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
//                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        // [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
                        
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(synchronizeData:)
                                                                     name:@"synchronizeData"
                                                                   object:nil];
                        
                    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait Synchronize data"];
                    [[Configs sharedInstance] synchronizeData];
                    
                }else{
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Login Error"];
                }
            }
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[jsonDict valueForKey:@"message"]];
        }
    }];
    [nThread setErrorHandler:^(NSString * data) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:data];
    }];
    [nThread start];
}

-(void)synchronizeData:(NSNotification *) notification{
    
    [[Configs sharedInstance] SVProgressHUD_Dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"synchronizeData" object:nil];
    
    NSDictionary *dict =  @{@"function" : @"reset"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBar *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
    [self presentViewController:tabBar animated:YES completion:nil];
    NSLog(@"");
}
@end
