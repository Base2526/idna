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
    }/*else if(![[Configs sharedInstance] NSStringIsValidEmail:strEmail]){
        [SVProgressHUD showErrorWithStatus:@"Email is Invalid."];
    }*/else{
         [SVProgressHUD showWithStatus:@"Login"];
        
         LoginThread *lThread = [[LoginThread alloc] init];
         [lThread setCompletionHandler:^(NSData * str) {
             NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:str  options:kNilOptions error:nil];
         
             // [myObject isKindOfClass:[NSString class]]

             if ([jsonDict isKindOfClass:[NSArray class]]) {
                 [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[(NSArray *)jsonDict objectAtIndex:0]];
                 return;
             }
             
             if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                 
                 NSMutableDictionary *idata         = jsonDict[@"data"];
                 
                 if (![idata isKindOfClass:[NSDictionary class]]) {
                     [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[NSString stringWithFormat:@"%@", idata]];
                 }else{
                     if ([idata count] > 0) {
                         
                         [[Configs sharedInstance] saveData:_USER :idata];
                         
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
         [lThread setErrorHandler:^(NSString * str) {
             [SVProgressHUD  showErrorWithStatus:str];
         }];
         
         [lThread start:strEmail :strPassword];
    }
}

-(void)synchronizeData:(NSNotification *) notification{
    
    [[Configs sharedInstance] SVProgressHUD_Dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"synchronizeData" object:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] initMainView];
}

@end
