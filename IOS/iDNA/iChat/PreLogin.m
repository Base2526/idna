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
#import "MainTabBarController.h"

#import "MainViewController.h"

@interface PreLogin ()
@end

@implementation PreLogin
@synthesize btnLogin, btnAnnonymous;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Welcome to iDNA";
    
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
    [nThread setCompletionHandler:^(NSData * data) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        
        NSObject* obj= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([obj isKindOfClass:[NSArray class]]) {
            
            NSArray *objArray = (NSArray *)obj;
            NSString* text = [objArray objectAtIndex:0];
        }
        
        NSDictionary *jsonDict = (NSDictionary *)obj;
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            NSMutableDictionary *idata  = jsonDict[@"data"];
        
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
    [nThread setErrorHandler:^(NSString * data) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:data];
    }];
    [nThread start];
}

-(void)synchronizeData:(NSNotification *) notification{
    
    [[Configs sharedInstance] SVProgressHUD_Dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"synchronizeData" object:nil];
    
    // NSDictionary *dict =  @{@"function" : @"reset"};
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] initMainView];
}
@end
