//
//  Login.m
//  Heart-Basic
//
//  Created by somkid simajarn on 9/3/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "Login.h"
//#import "SWRevealViewController.h"

#import <Firebase/Firebase.h>
#import "SVProgressHUD.h"
#import "LoginThread.h"
#import "AppConstant.h"
#import "Configs.h"
#import "MainTabBarController.h"
#import <FirebaseInstanceID/FIRInstanceID.h>

@interface Login ()

@end

@implementation Login
@synthesize btnLogin, btnSignUp, btnForgotPassword;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
   
    // Firebase *ref = [[Firebase alloc] initWithUrl:@"https://blazing-torch-6635.firebaseio.com/web/saving-data/fireblog"];
    
    btnLogin.layer.cornerRadius = 5;
    btnLogin.layer.borderWidth = 1;
    btnLogin.layer.borderColor = [UIColor blueColor].CGColor;

    btnSignUp.layer.cornerRadius = 5;
    btnSignUp.layer.borderWidth = 1;
    btnSignUp.layer.borderColor = [UIColor blueColor].CGColor;
    
    btnForgotPassword.layer.cornerRadius = 5;
    btnForgotPassword.layer.borderWidth = 1;
    btnForgotPassword.layer.borderColor = [UIColor blueColor].CGColor;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([preferences objectForKey:_EMAIL_LAST] != nil){
        self.TxtEmail.text = [preferences objectForKey:_EMAIL_LAST];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 

 */

- (IBAction)onLogin:(id)sender {
//    SWRevealViewController *mtc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//    [self presentViewController:mtc animated:YES completion:nil];
    
    NSString *strEmail = [self.TxtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//self.TxtEmail.text;
    NSString *strPassword = [self.TxtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//
    
    if ([strEmail isEqualToString:@""] && [strPassword isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"Email & Password is Empty."];
    }else if([strEmail isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"Email is Empty."];
    }else if([strPassword isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"Password is Empty."];
    }else if(![[Configs sharedInstance] NSStringIsValidEmail:strEmail]){
        [SVProgressHUD showErrorWithStatus:@"Email is Invalid."];
    }else{
         [SVProgressHUD showWithStatus:@"Login"];
        
         LoginThread *lThread = [[LoginThread alloc] init];
         [lThread setCompletionHandler:^(NSString * str) {
         
             NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:str  options:kNilOptions error:nil];
         
             //  {"id":"Zye-y9A3mV5mEI4dmMrSXuJ1i82yA5ep_Ii9NRJuMrk","name":"SESSd7da75db715e9ec489582517601f380b"}
         
             /*
             if (![jsonDict isKindOfClass:[NSDictionary class]]) {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", jsonDict]];
             }else{
         
                 if ([jsonDict count] > 0) {
                    // http://stackoverflow.com/questions/19206762/equivalent-to-shared-preferences-in-ios
                    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
         
                    // NSLog(@"%@", [jsonDict objectForKey:@"user"][@"uid"]);
         
                     // const NSInteger currentLevel = ...;
                     // [preferences setInteger:currentLevel forKey:currentLevelKey];
                     //  [preferences setObject:[jsonDict objectForKey:@"user"][@"uid"] forKey:_UID];
                     // [preferences setObject:[jsonDict objectForKey:@"sessid"] forKey:_SESSION_ID];
                     // [preferences setObject:[jsonDict objectForKey:@"session_name"] forKey:_SESSION_NAME];
         
                     // NSUserDefaults save NSMutableDictionary
                     // http://stackoverflow.com/questions/471830/why-nsuserdefaults-failed-to-save-nsmutabledictionary-in-iphone-sdk
         
                     // [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: jsonDict] forKey:_USER];
                     
                     [preferences setObject:strEmail forKey:_EMAIL_LAST];
    

                     
                     //  Save to disk
                     // const BOOL didSave = [preferences synchronize];
                     
                     // if (didSave)
                     // {
                         NSDictionary *dict =  @{
                                                 @"function" : @"reset"
                                                 };
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
                         
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAfterLogin" object:self userInfo:@{}];
         
                         [self dismissViewControllerAnimated:YES completion:nil];
         
                        [SVProgressHUD  dismiss];
         
                     // }
                     
                 }else{
                     [SVProgressHUD showErrorWithStatus:@"Login Error."];
                 }
             }
             */
             
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
                         // }
                     }else{
                         [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Login Error"];
                     }
                 }
             }else{
                 [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[jsonDict valueForKey:@"message"]];
             }
         
         }];
         [lThread setErrorHandler:^(NSString * str) {
             [SVProgressHUD  showErrorWithStatus:str];
         }];
         
         [lThread start:strEmail :strPassword];
    }
}

-(void)synchronizeData:(NSNotification *) notification{
    
    [[Configs sharedInstance] SVProgressHUD_Dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"synchronizeData" object:nil];
    
    NSDictionary *dict =  @{@"function" : @"reset"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    [self presentViewController:tabBar animated:YES completion:nil];
}

@end
