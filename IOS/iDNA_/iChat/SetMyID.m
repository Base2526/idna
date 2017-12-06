//
//  SetMyID.m
//  Heart
//
//  Created by Somkid on 12/29/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "SetMyID.h"
#import "SetMyIDThread.h"
#import "AppConstant.h"
#import "Configs.h"

@interface SetMyID ()

@end

@implementation SetMyID

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.textFieldMessage setText:self.message];
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
    
    NSString *strName = [self.textFieldMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([strName isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Empty."];
    }else {
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update."];
        
        SetMyIDThread *eThread = [[SetMyIDThread alloc] init];
        [eThread setCompletionHandler:^(NSString *data) {
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                /*
                NSMutableDictionary*data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] mutableCopy];
                
                NSMutableDictionary*profile =  [[data objectForKey:@"profile"] mutableCopy];
                // NSMutableDictionary*profile =  [[profile objectForKey:@"phones"] mutableCopy];
                
                //NSMutableDictionary*phones = [[profile objectForKey:@"phones"] mutableCopy];
                
                // [phones removeObjectForKey:jsonDict[@"item_id"]];
                // [phones setObject:jsonDict[@"data"] forKey:jsonDict[@"item_id"]];
                
                NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                [newProfile addEntriesFromDictionary:profile];
                
                if ([profile objectForKey:@"my_id"]) {
                    [newProfile removeObjectForKey:@"my_id"];
                }
                [newProfile setObject:jsonDict[@"value"] forKey:@"my_id"];
                
                NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
                [newData addEntriesFromDictionary:data];
                [newData removeObjectForKey:@"profile"];
                [newData setObject:newProfile forKey:@"profile"];
                
                [[Configs sharedInstance] saveData:_DATA :@{@"data": newData}];
                */
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
            }
        }];
        
        [eThread setErrorHandler:^(NSString *error) {
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        [eThread start:strName :@"add"];
    }
}
@end
