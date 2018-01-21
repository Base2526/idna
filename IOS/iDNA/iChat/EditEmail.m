//
//  EditEmail.m
//  Heart
//
//  Created by Somkid on 1/24/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "EditEmail.h"
#import "Configs.h"
#import "EditEmailThread.h"
#import "AppConstant.h"
#import "ProfilesRepo.h"

@interface EditEmail (){
    ProfilesRepo *profilesRepo;
    NSMutableDictionary *profiles;
}
@end

@implementation EditEmail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnSave.enabled = NO;
    self.textFieldEmail.delegate = self;
    
    if (![self.fction isEqualToString:@"add"]) {
        self.title = @"Edit Email";
        [self.textFieldEmail setText:self.email];
    }else{
        self.title = @"Add Email";
    }
    
    profilesRepo = [[ProfilesRepo alloc] init];
    
    NSArray *pf = [profilesRepo get];
    NSData *data =  [[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
//    if ([profiles objectForKey:@"mails"]) {
//        mails = [profiles objectForKey:@"mails"];
//    }
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
    
    NSString *_email = [self.textFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![[Configs sharedInstance] NSStringIsValidEmail:_email]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Email Invalid"];
    }else{
    
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
        
        EditEmailThread *editPhone = [[EditEmailThread alloc] init];
        [editPhone setCompletionHandler:^(NSData *data) {
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                if ([jsonDict[@"is_edit"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    if ([profiles objectForKey:@"mails"]) {
                        NSMutableDictionary * mails = [[profiles objectForKey:@"mails"] mutableCopy];
                        
                        if (![mails objectForKey:jsonDict[@"item"]]) {
                            
                            [mails setValue:jsonDict[@"item"] forKey:jsonDict[@"item_id"]];
                            
                            NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                            [newProfile addEntriesFromDictionary:profiles];
                            [newProfile removeObjectForKey:@"mails"];
                            [newProfile setObject:mails forKey:@"mails"];
                            
                            
                            // NSArray *profile = [profilesRepo get];
                            /*
                             Profiles *pf = [[Profiles alloc] init];
                             NSError * err;
                             NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfile options:0 error:&err];
                             pf.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                             NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                             NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
                             // pf.create    = [timeStampObj stringValue];
                             pf.update    = [timeStampObj stringValue];
                             
                             // BOOL sv = [profilesRepo update:pf];
                             
                             // [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:pf];
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                             BOOL sv = [profilesRepo update:pf];
                             
                             });
                             */
                            
                            NSError * err;
                            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfile options:0 error:&err];
                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
                        }
                    }else {
                        NSMutableDictionary * mails = [[NSMutableDictionary alloc] init];
                        
                        [mails setValue:jsonDict[@"item"] forKey:jsonDict[@"item_id"]];
                        
                        NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                        [newProfile addEntriesFromDictionary:profiles];
                        [newProfile setObject:mails forKey:@"mails"];
                        
                        
                        /*
                         NSArray *profile = [profilesRepo get];
                         
                         Profiles *pf = [[Profiles alloc] init];
                         NSError * err;
                         NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfile options:0 error:&err];
                         pf.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                         NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                         NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
                         // pf.create    = [timeStampObj stringValue];
                         pf.update    = [timeStampObj stringValue];
                         
                         // BOOL sv = [profilesRepo update:pf];
                         
                         // [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:pf];
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                         BOOL sv = [profilesRepo update:pf];
                         
                         });
                         */
                        
                        NSError * err;
                        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfile options:0 error:&err];
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
                    }
                }else{
                    NSMutableDictionary * mails = [[profiles objectForKey:@"mails"] mutableCopy];
                    if (![mails objectForKey:jsonDict[@"item"]]) {
                        
                        [mails setValue:jsonDict[@"item"] forKey:jsonDict[@"item_id"]];
                        
                        NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                        [newProfile addEntriesFromDictionary:profiles];
                        [newProfile removeObjectForKey:@"mails"];
                        [newProfile setObject:mails forKey:@"mails"];
                        
                        
                        /*
                         NSArray *profile = [profilesRepo get];
                         
                         Profiles *pf = [[Profiles alloc] init];
                         NSError * err;
                         NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfile options:0 error:&err];
                         pf.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                         NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                         NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
                         // pf.create    = [timeStampObj stringValue];
                         pf.update    = [timeStampObj stringValue];
                         
                         // BOOL sv = [profilesRepo update:pf];
                         // [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:pf];
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                         BOOL sv = [profilesRepo update:pf];
                         });
                         */
                        
                        NSError * err;
                        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfile options:0 error:&err];
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
                    }
                }
                [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
            }
        }];
        
        [editPhone setErrorHandler:^(NSString *error) {
            NSLog(@"%@", error);
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        // self.number
        [editPhone start:self.fction :self.item_id : _email];
    }
}
@end
