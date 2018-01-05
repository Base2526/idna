//
//  ListPhone.m
//  Heart
//
//  Created by Somkid on 1/23/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ListPhone.h"
#import "AppConstant.h"
#import "EditPhone.h"
#import "Configs.h"
#import "CustomAlertView.h"
#import "EditPhoneThread.h"

#import "ProfilesRepo.h"

@interface ListPhone (){
    NSMutableArray *fieldSelected;
    NSMutableDictionary *phones;
    // NSMutableArray *childObservers;
    
     NSMutableDictionary *profiles;
    
    ProfilesRepo*profilesRepo;
}
@end

@implementation ListPhone
@synthesize ref;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // ref = [[FIRDatabase database] reference];
    // childObservers = [[NSMutableArray alloc] init];
    fieldSelected = [[NSMutableArray alloc] init];
    
    
    /*
    NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/data/profile/phones/", [[Configs sharedInstance] getUIDU]];
    [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        
        // Firebase *childRef = [ref childByAppendingPath...];
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        NSMutableDictionary*data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] mutableCopy];
        
        NSMutableDictionary*profile =  [[data objectForKey:@"profile"] mutableCopy];
        
        NSMutableDictionary*phones = [[profile objectForKey:@"phones"] mutableCopy];
        
        [phones removeObjectForKey:snapshot.key];
        [phones setObject:snapshot.value forKey:snapshot.key];
        
        NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
        [newProfile addEntriesFromDictionary:profile];
        [newProfile removeObjectForKey:@"phones"];
        [newProfile setObject:phones forKey:@"phones"];
        
        NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
        [newData addEntriesFromDictionary:data];
        [newData removeObjectForKey:@"profile"];
        [newData setObject:newProfile forKey:@"profile"];
        
        [[Configs sharedInstance] saveData:_DATA :@{@"data": newData}];
        
        [self reloadData];
    }];
    [[ref child:child] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        BOOL flag = TRUE;
        for (NSString* key in phones) {
            if ([key isEqualToString:snapshot.key]) {
                flag = FALSE;
                break;
            }
        }
        
        if (flag) {
            
            NSMutableDictionary*data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] mutableCopy];
            
            NSMutableDictionary*profile =  [[data objectForKey:@"profile"] mutableCopy];
            
            // NSMutableDictionary*phones = [[NSMutableDictionary alloc] init];
            NSMutableDictionary*phones = [[NSMutableDictionary alloc] init];
            if ([profile objectForKey:@"phones"]) {
                phones = [[profile objectForKey:@"phones"] mutableCopy];
            }
            
            // [phones removeObjectForKey:jsonDict[@"item_id"]];
            [phones setObject:snapshot.value forKey:snapshot.key];
            
            NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
            [newProfile addEntriesFromDictionary:profile];
            [newProfile removeObjectForKey:@"phones"];
            [newProfile setObject:phones forKey:@"phones"];
            
            NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
            [newData addEntriesFromDictionary:data];
            [newData removeObjectForKey:@"profile"];
            [newData setObject:newProfile forKey:@"profile"];
            
            [[Configs sharedInstance] saveData:_DATA :@{@"data": newData}];
            
            [self reloadData];
        }
    }];
    
    [[ref child:child] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        
        NSMutableDictionary*data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] mutableCopy];
        
        NSMutableDictionary*profile =  [[data objectForKey:@"profile"] mutableCopy];
        
        NSMutableDictionary*phones = [[profile objectForKey:@"phones"] mutableCopy];
        
        [phones removeObjectForKey:snapshot.key];
        // [phones setObject:snapshot.value forKey:snapshot.key];
        
        NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
        [newProfile addEntriesFromDictionary:profile];
        [newProfile removeObjectForKey:@"phones"];
        [newProfile setObject:phones forKey:@"phones"];
        
        NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
        [newData addEntriesFromDictionary:data];
        [newData removeObjectForKey:@"profile"];
        [newData setObject:newProfile forKey:@"profile"];
        
        [[Configs sharedInstance] saveData:_DATA :@{@"data": newData}];
        
        [self reloadData];
    }];
    */
    
    ref         = [[FIRDatabase database] reference];
    profilesRepo = [[ProfilesRepo alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"reloadData"
                                               object:nil];
    
  
    
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadData" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if ([segue.identifier isEqualToString:@"EditPhone"]) {
         EditPhone* v = segue.destinationViewController;
         v.fction = @"add";
     }
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return  [phones count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    
//    NSDictionary* item = [data_profile2 objectAtIndex:indexPath.row] ;
//    label.text = [item objectForKey:@"value"];
//    
//    NSDictionary *_items = [data_profile2 objectForKey:indexPath.row];
    // id aKey = [keys objectAtIndex:indexPath.row];
    // id anObject = [[all_data objectForKey:[sectionTitleArray objectAtIndex:1]] objectForKey:aKey];
    
    
    NSArray *keys = [phones allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [phones objectForKey:aKey];
    
    label.text = [anObject objectForKey:@"name"];
    
    if ([fieldSelected containsObject:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //the below code will allow multiple selection
    if ([fieldSelected containsObject:indexPath]){
        [fieldSelected removeObject:indexPath];
    }else{
        [fieldSelected addObject:indexPath];
    }
    [self reloadData:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *blockAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        // [self.tableView setEditing:NO];
        
        NSArray *keys = [phones allKeys];
        id aKey = [keys objectAtIndex:indexPath.row];
        id anObject = [phones objectForKey:aKey];
        
        // NSDictionary* item = [data_profile2 objectAtIndex:indexPath.row];
        
        EditPhone *v = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPhone"];
        v.fction = @"edit";
        v.item_id = aKey;
        v.number =[anObject objectForKey:@"name"];
        
        [self.navigationController pushViewController:v animated:YES];
    }];
    // blockAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *hiddenAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // NSDictionary* item = [data_profile2 objectAtIndex:indexPath.row];
        // NSLog(@"");
        
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Delete" message:@"Confirm Delete." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        
        alertView.tag = -999;
        
        alertView.object = @{@"indexPath" : indexPath};
        
        [alertView show];
        
    }];
    
    return @[hiddenAction, blockAction];
}

- (void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case -999:
            if (buttonIndex == 0){
                NSLog(@"ยกเลิก");
            }else{
                
                NSDictionary* userInfo = alertView.object;
                NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
                
                NSArray *keys = [phones allKeys];
                id aKey = [keys objectAtIndex:indexPath.row];
                id anObject = [phones objectForKey:aKey];
                
                // NSDictionary* item = [data_profile2 objectAtIndex:indexPath.row];
                // NSString* phone = [anObject objectForKey:@"number"];
                
                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
                
                EditPhoneThread *dThread = [[EditPhoneThread alloc] init];
                [dThread setCompletionHandler:^(NSData *data) {
                    
                    NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                    
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        
                        /*
                        // delete phone number
                        NSMutableDictionary*data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] mutableCopy];
                        
                        NSMutableDictionary*profile =  [[data objectForKey:@"profile"] mutableCopy];
                        // NSMutableDictionary*profile =  [[profile objectForKey:@"phones"] mutableCopy];
                        
                        NSMutableDictionary*phones = [[profile objectForKey:@"phones"] mutableCopy];
                        
                        [phones removeObjectForKey:jsonDict[@"item_id"]];
                        // [phones setObject:jsonDict[@"data"] forKey:jsonDict[@"item_id"]];
                        
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
                        
                        NSMutableDictionary * phones = [[profiles objectForKey:@"phones"] mutableCopy];
                        
                        if ([phones objectForKey:jsonDict[@"item_id"]]) {
                            
                            // [phones setValue:jsonDict[@"item"] forKey:jsonDict[@"item_id"]];
                            [phones removeObjectForKey:jsonDict[@"item_id"]];
                            
                            NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                            [newProfile addEntriesFromDictionary:profiles];
                            [newProfile removeObjectForKey:@"phones"];
                            [newProfile setObject:phones forKey:@"phones"];
                            
                            NSArray *profile = [profilesRepo get];
                            
                            Profiles *pf = [[Profiles alloc] init];
                            NSError * err;
                            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfile options:0 error:&err];
                            pf.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
                            pf.update    = [timeStampObj stringValue];
                            
                            BOOL sv = [profilesRepo update:pf];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // code here
                            [self reloadData:nil];
                        });
                        
                    }else{
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
                    }
                }];
                
                [dThread setErrorHandler:^(NSString *error) {
                    NSLog(@"%@", error);
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                }];
                // self.number
                [dThread start:@"delete" :aKey : @""];
            }
            break;
        default:
            break;
    }
}

-(void)reloadData:(NSNotification *) notification{
    NSArray *pf = [profilesRepo get];
    NSData *data =  [[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([profiles objectForKey:@"phones"]) {
        phones = [profiles objectForKey:@"phones"];
        
        self._table.hidden = NO;
        self.emptyMessage.hidden = YES;
    }else{
        self._table.hidden = YES;
        self.emptyMessage.hidden = NO;
    }

    [self._table reloadData];
}
@end
