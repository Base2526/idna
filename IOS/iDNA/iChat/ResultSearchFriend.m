//
//  ResultSearchFriend.m
//  Heart
//
//  Created by Somkid on 12/21/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "ResultSearchFriend.h"
#import "ResultSearchFriendThread.h"
#import "SVProgressHUD.h"

#import "Configs.h"

#import "AppDelegate.h"
#import "AppConstant.h"

@interface ResultSearchFriend ()

{
    NSDictionary *result;
}
@end

@implementation ResultSearchFriend


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", self.key_search);
    
    self.btnAdd.layer.cornerRadius = 5;
    self.btnAdd.layer.borderWidth = 1;
    self.btnAdd.layer.borderColor = [UIColor blueColor].CGColor;
    
    result = [[NSDictionary alloc] init];
    
    [SVProgressHUD showWithStatus:@"Please Wait"];
    
    ResultSearchFriendThread *RSFThread = [[ResultSearchFriendThread alloc] init];
    [RSFThread setCompletionHandler:^(NSString * data) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([self.isQR isEqualToString:@"0"]) {
            NSLog(@"");
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
                result = jsonDict[@"data"];
                
                NSLog(@"%@", result);
                
                NSLog(@"%@", [result objectForKey:@"field_profile_name"][@"und"][0][@"value"]);
                
                self.labelName.text =[result objectForKey:@"field_profile_name"][@"und"][0][@"value"];
                
                NSArray*profile2_img = [result objectForKey:@"field_profile_image"]; //[_dict objectForKey:@"profile2"][@"field_profile_image"];
                
                
                if ([profile2_img count] > 0) {
                    NSLog(@"%@", [result objectForKey:@"field_profile_image"][@"und"][0][@"filename"]);
                    
                    NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [result objectForKey:@"field_profile_image"][@"und"][0][@"filename"]];
                    
                    // if (![self.profile_picture isEqualToString:@""]) {
                    [self.hjmImg clear];
                    [self.hjmImg showLoadingWheel];
                    [self.hjmImg setUrl:[NSURL URLWithString:url]];
                    // [img setImage:[UIImage imageWithData:fileData]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImg ];
                    // }
                }
                
                NSString *status;
                
                if([jsonDict[@"status"] isKindOfClass:[NSNumber class]])
                {
                    //do stuff for NSNumber
                    status = [NSString stringWithFormat:@"%i", jsonDict[@"status"]];
                }else{
                    status = jsonDict[@"status"];
                }
                
                if ([status isEqualToString:@"0"] || [status isEqualToString:@"1"] || [status isEqualToString:@"2"] || [status isEqualToString:@"3"] || [status isEqualToString:@"4"]) {
                    self.labelMessage.text = jsonDict[@"message"];
                    
                    [self.btnAdd setHidden:YES];
                }else{
                    [self.labelMessage setHidden:YES];
                    [self.btnAdd setTitle:@"Add Friend" forState:UIControlStateNormal];
                }

            }else{
                self.labelMessage.text = @"User not found";
                
                [self.btnAdd setHidden:YES];
                [self.labelName setHidden:YES];
            }
            
        }else{
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                result = jsonDict[@"data"];
                
                NSLog(@"%@", result);
                
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"");
                    
                    NSLog(@"%@", [result objectForKey:@"field_profile_name"][@"und"][0][@"value"]);
                    
                    self.labelName.text =[result objectForKey:@"field_profile_name"][@"und"][0][@"value"];
                    
                    
                    NSArray*profile2_img = [result objectForKey:@"field_profile_image"]; //[_dict objectForKey:@"profile2"][@"field_profile_image"];
                    
                    
                    if ([profile2_img count] > 0) {
                        NSLog(@"%@", [result objectForKey:@"field_profile_image"][@"und"][0][@"filename"]);
                        
                        NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [result objectForKey:@"field_profile_image"][@"und"][0][@"filename"]];
                        
                        // if (![self.profile_picture isEqualToString:@""]) {
                        [self.hjmImg clear];
                        [self.hjmImg showLoadingWheel];
                        [self.hjmImg setUrl:[NSURL URLWithString:url]];
                        // [img setImage:[UIImage imageWithData:fileData]];
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImg ];
                        // }
                    }
                    
                    NSString *status;
                    
                    if([jsonDict[@"status"] isKindOfClass:[NSNumber class]])
                    {
                        //do stuff for NSNumber
                        status = [NSString stringWithFormat:@"%i", jsonDict[@"status"]];
                    }else{
                        status = jsonDict[@"status"];
                    }
                    
                    if ([status isEqualToString:@"0"] || [status isEqualToString:@"1"] || [status isEqualToString:@"2"] || [status isEqualToString:@"3"] || [status isEqualToString:@"4"]) {
                        self.labelMessage.text = jsonDict[@"message"];
                        
                        [self.btnAdd setHidden:YES];
                    }else{
                        [self.labelMessage setHidden:YES];
                        [self.btnAdd setTitle:@"Add Friend" forState:UIControlStateNormal];
                    }
                }else{
                    self.labelMessage.text = @"User not found";
                    
                    [self.btnAdd setHidden:YES];
                    [self.labelName setHidden:YES];
                }
                // }
                
            }else{
                [SVProgressHUD showErrorWithStatus:jsonDict[@"output"]];
            }
        }
        
        
    }];

    [RSFThread setErrorHandler:^(NSString * data) {
        NSLog(@"%@", data);
        
        [SVProgressHUD dismiss];
    
        [SVProgressHUD  showErrorWithStatus:data];
    }];

    [RSFThread start:self.key_search: self.isQR];
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

- (IBAction)onAddFriend:(id)sender {
    
    __block NSString* uid_friend = [result objectForKey:@"uid"];
    
    
    [SVProgressHUD showWithStatus:@"Add Friend"];
    
    AddFriendThread *addFriendsThread = [[AddFriendThread alloc] init];
    [addFriendsThread setCompletionHandler:^(NSString *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [SVProgressHUD dismiss];
        
        NSMutableDictionary *dict = [[Configs sharedInstance] loadData:_USER_CONTACTS];
        
        BOOL flag = TRUE;
        NSString*key =@"Wait to Accept";
        
        NSMutableArray *_items = [[dict objectForKey:key] mutableCopy];
        if (_items == nil) {
            _items = [[NSMutableArray alloc] init];
        }
        if ([_items count] > 0) {
            for (int i = 0; i < [_items count]; i++) {
                if ([[[_items objectAtIndex:i] objectForKey:@"uid"] isEqualToString:[jsonDict[@"data_friend"] objectForKey:@"uid"]]) {
                    flag = FALSE;
                    
                    break;
                }
            }
        }
        
        if (flag) {
            
            
            [_items addObject:jsonDict[@"data_friend"]];
            
            NSMutableDictionary *_newHideDict = [[NSMutableDictionary alloc] init];
            [_newHideDict addEntriesFromDictionary:dict];
            [_newHideDict removeObjectForKey:key];
            
            [_newHideDict setObject:_items forKey:key];
            
            [[Configs sharedInstance] saveData:_USER_CONTACTS :_newHideDict];
        }
        
                
        
        [SVProgressHUD showSuccessWithStatus:@"Add Friend Success"];
        
        if ([self.isQR isEqualToString:@"0"]) {
            // AddByID
            NSDictionary *value =  @{@"uid_friend" : uid_friend };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddByID" object:nil userInfo:value];
        }else{
            
            NSDictionary *value =  @{@"uid_friend" : uid_friend };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ResultSearchFriend" object:nil userInfo:value];
        }
        
         [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [addFriendsThread setErrorHandler:^(NSString *data) {
        NSLog(@"%@", data);
    }];
    [addFriendsThread start:uid_friend];
}

- (IBAction)onClose:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResultSearchFriend" object:nil userInfo:@{}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
