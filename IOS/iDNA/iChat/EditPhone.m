//
//  EditPhone.m
//  Heart
//
//  Created by Somkid on 12/22/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "EditPhone.h"
#import "EditPhoneThread.h"
#import "SVProgressHUD.h"
#import "AppConstant.h"
#import "Configs.h"

@interface EditPhone ()

@end

@implementation EditPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnSave.enabled = NO;
    self.textFieldName.delegate = self;
    
    if (![self.fction isEqualToString:@"add"]) {
        self.title =@"Edit Phone";
        [self.textFieldName setText:self.number];
    }else{
        self.title =@"Add Phone";
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
    NSString *text = [self.textFieldName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([text isEqualToString:@""] || [[Configs sharedInstance] NSStringIsValidPhone:text]) {
        [SVProgressHUD showErrorWithStatus:@"Phone is Empty or Invalid."];
    }else {
        
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
        
        EditPhoneThread *eThread = [[EditPhoneThread alloc] init];
        [eThread setCompletionHandler:^(NSString *data) {
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                if ([jsonDict[@"is_edit"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    // add new phone number
                    /*
                    NSMutableDictionary*data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] mutableCopy];
                    
                    NSMutableDictionary*profile =  [[data objectForKey:@"profile"] mutableCopy];
                    // NSMutableDictionary*profile =  [[profile objectForKey:@"phones"] mutableCopy];
                    
                    NSMutableDictionary*phones = [[NSMutableDictionary alloc] init];
                    if ([profile objectForKey:@"phones"]) {
                        phones =  [[profile objectForKey:@"phones"] mutableCopy];
                    }
                    
                    [phones setObject:jsonDict[@"data"] forKey:jsonDict[@"item_id"]];
                    
                    NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                    [newProfile addEntriesFromDictionary:profile];
                    [newProfile removeObjectForKey:@"phones"];
                    [newProfile setObject:phones forKey:@"phones"];
                    
                    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
                    [newData addEntriesFromDictionary:data];
                    [newData removeObjectForKey:@"profile"];
                    [newData setObject:newProfile forKey:@"profile"];
                    
                    [[Configs sharedInstance] saveData:_DATA :@{@"data": newData}];
                    */
                }else{
                    /*
                    // edit phone number
                    NSMutableDictionary*data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] mutableCopy];
                    
                    NSMutableDictionary*profile =  [[data objectForKey:@"profile"] mutableCopy];
                    // NSMutableDictionary*profile =  [[profile objectForKey:@"phones"] mutableCopy];
                    
                    NSMutableDictionary*phones = [[profile objectForKey:@"phones"] mutableCopy];
                
                    [phones removeObjectForKey:jsonDict[@"item_id"]];
                    [phones setObject:jsonDict[@"data"] forKey:jsonDict[@"item_id"]];
                    
                    NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                    [newProfile addEntriesFromDictionary:profile];
                    [newProfile removeObjectForKey:@"phones"];
                    [newProfile setObject:phones forKey:@"phones"];
                    
                    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
                    [newData addEntriesFromDictionary:data];
                    [newData removeObjectForKey:@"profile"];
                    [newData setObject:newProfile forKey:@"profile"];
                    
                    [[Configs sharedInstance] saveData:_DATA :@{@"data": newData}];
                    */
                }
                
                [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
            }
        }];
        
        [eThread setErrorHandler:^(NSString *text) {
            NSLog(@"%@", text);
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:text];
        }];
        // self.number
        [eThread start:self.fction :self.item_id : text];
    }
}
@end
