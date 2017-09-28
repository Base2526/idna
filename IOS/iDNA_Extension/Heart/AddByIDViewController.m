//
//  AddByIDViewController.m
//  Heart
//
//  Created by Somkid on 12/20/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "AddByIDViewController.h"
#import "SVProgressHUD.h"

#import "ResultSearchFriend.h"

#import "AppConstant.h"

@interface AddByIDViewController ()

@end

@implementation AddByIDViewController
@synthesize btnAdd;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    btnAdd.layer.cornerRadius = 5;
    btnAdd.layer.borderWidth = 1;
    btnAdd.layer.borderColor = [UIColor blueColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAdd:(id)sender {
    
    NSString *text = [self.textfID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([text length] < 1) {
        [SVProgressHUD showErrorWithStatus:@"ID Empty."];
    }else{
        
        /*
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
        NSArray*profile2_heart_id =  [_dict objectForKey:@"profile2"][@"field_profile_heart_id"];
        
        if ([profile2_heart_id count] > 0) {
            NSString* text_id =[_dict objectForKey:@"profile2"][@"field_profile_heart_id"][@"und"][0][@"value"];
            
            if ([text isEqualToString: text_id]) {
                [SVProgressHUD showErrorWithStatus:@"You cannot add yourself as a friend."];
                // Delay execution of my block for 10 seconds.
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }else{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ResultSearchFriend *ivFriend = [storybrd instantiateViewControllerWithIdentifier:@"ResultSearchFriend"];
                ivFriend.key_search = text;
                ivFriend.isQR = @"0";
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ivFriend];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(AddByID:)
                                                             name:@"AddByID" object:nil];
                
                [self presentViewController:nav animated:YES completion:nil];
            }
        }else{
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            ResultSearchFriend *ivFriend = [storybrd instantiateViewControllerWithIdentifier:@"ResultSearchFriend"];
            ivFriend.key_search = text;
            ivFriend.isQR = @"0";
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ivFriend];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(AddByID:)
                                                         name:@"AddByID" object:nil];
            
            [self presentViewController:nav animated:YES completion:nil];
        }
        */
    }
}

-(void)AddByID:(NSNotification *)notice{
        
    NSDictionary *userInfo = notice.userInfo;
    
    NSString *uid_friend = @"";
    if ([userInfo objectForKey:@"uid_friend"]) {
        uid_friend = [userInfo objectForKey:@"uid_friend"];
    }
    
    NSDictionary *value =  @{@"uid_friend" : uid_friend };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResultSearchFriend" object:nil userInfo:value];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
