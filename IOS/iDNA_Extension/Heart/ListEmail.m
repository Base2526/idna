//
//  ListEmail.m
//  Heart
//
//  Created by Somkid on 1/24/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ListEmail.h"

#import "AppConstant.h"
#import "EditEmail.h"
#import "Configs.h"
#import "AnNmousURegister.h"
#import "AnNmousUVerify.h"
#import "CustomAlertView.h"
#import "EditEmailThread.h"

@interface ListEmail (){
    NSMutableDictionary *mails;
    NSMutableArray *sectionTitleArray;
    NSMutableArray *fieldSelected;
}
@end

@implementation ListEmail
// @synthesize ref;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    fieldSelected = [[NSMutableArray alloc] init];
    mails = [[NSMutableDictionary alloc] init];
    sectionTitleArray = [NSMutableArray arrayWithObjects: @"Email Register", @"Email", nil];
    // ref = [[FIRDatabase database] reference];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
- (void)viewWillAppear:(BOOL)animated{
    NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/data/profile/mails/", [[Configs sharedInstance] getUIDU]];
    [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        
        // Firebase *childRef = [ref childByAppendingPath...];
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        NSMutableDictionary*data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] mutableCopy];
        
        NSMutableDictionary*profile =  [[data objectForKey:@"profile"] mutableCopy];
        
        NSMutableDictionary*mails = [[profile objectForKey:@"mails"] mutableCopy];
        
        [mails removeObjectForKey:snapshot.key];
        [mails setObject:snapshot.value forKey:snapshot.key];
        
        NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
        [newProfile addEntriesFromDictionary:profile];
        [newProfile removeObjectForKey:@"mails"];
        [newProfile setObject:mails forKey:@"mails"];
        
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
        for (NSString* key in all_data) {
            if ([key isEqualToString:snapshot.key]) {
                flag = FALSE;
                break;
            }
        }
        
        if (flag) {
            
            NSMutableDictionary*data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] mutableCopy];
            
            NSMutableDictionary*profile =  [[data objectForKey:@"profile"] mutableCopy];
            
            NSMutableDictionary*mails = [[NSMutableDictionary alloc] init];
            if ([profile objectForKey:@"mails"]) {
                mails = [[profile objectForKey:@"mails"] mutableCopy];
            }
            
            // [phones removeObjectForKey:jsonDict[@"item_id"]];
            [mails setObject:snapshot.value forKey:snapshot.key];
            
            NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
            [newProfile addEntriesFromDictionary:profile];
            [newProfile removeObjectForKey:@"mails"];
            [newProfile setObject:mails forKey:@"mails"];
            
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
        
        NSMutableDictionary*mails = [[profile objectForKey:@"mails"] mutableCopy];
        
        [mails removeObjectForKey:snapshot.key];
        // [phones setObject:snapshot.value forKey:snapshot.key];
        
        NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
        [newProfile addEntriesFromDictionary:profile];
        [newProfile removeObjectForKey:@"mails"];
        [newProfile setObject:mails forKey:@"mails"];
        
        NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
        [newData addEntriesFromDictionary:data];
        [newData removeObjectForKey:@"profile"];
        [newData setObject:newProfile forKey:@"profile"];
        
        [[Configs sharedInstance] saveData:_DATA :@{@"data": newData}];
        
        [self reloadData];
    }];
    
    [self reloadData];
}
*/

/*
-(void)viewDidDisappear:(BOOL)animated{
    // http://stackoverflow.com/questions/26022245/removeallobservers-observer-not-removed/27329738#27329738
    for (FIRDatabaseReference *ref in childObservers) {
        [ref removeAllObservers];
    }
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"EditEmail"]) {
        EditEmail* v = segue.destinationViewController;
        v.fction = @"add";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor brownColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-30, 30)];
    
   
    headerString.textAlignment      = NSTextAlignmentLeft;
    headerString.textColor          = [UIColor blackColor];
    [headerView addSubview:headerString];
    
    switch (section) {
        case 0:
        {
             headerString.text = [NSString stringWithFormat:@"%@", [sectionTitleArray objectAtIndex:section]];
        }
            break;
        case 1:
        {
             headerString.text = [NSString stringWithFormat:@"%@ (%d)", [sectionTitleArray objectAtIndex:section], [[mails objectForKey:[sectionTitleArray objectAtIndex:1]] count]];
        }
            break;
            
        default:
            break;
    }
    
    return headerView;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    // return 2;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    // return  3;//[data_profile2 count];
    
    /*
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
            
        case 1:
        {
            return [[mails objectForKey:[sectionTitleArray objectAtIndex:1]] count];
        }
            break;
            
        default:
            break;
    }
    
    return 0;
    */
    
    return [mails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            UILabel *label = (UILabel *)[cell viewWithTag:10];
            
            
            
            NSDictionary* data =  [mails objectForKey:[sectionTitleArray objectAtIndex:0]];
            if ([[[data objectForKey:@"name"] componentsSeparatedByString:@"@"][1] isEqualToString:@"annmousu"]) {
                label.text = @"Not Register";
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                label.text =[data objectForKey:@"name"];
            }

            [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRegisterTapped:)]];
            return cell;
        }
            break;
            
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
            UILabel *label = (UILabel *)[cell viewWithTag:10];
            
            // NSDictionary* item = [all_data objectAtIndex:indexPath.row];
            // label.text = [item objectForKey:@"value"];
            
            NSDictionary *_items = [mails objectForKey:[sectionTitleArray objectAtIndex:1]];
            // id aKey = [keys objectAtIndex:indexPath.row];
            // id anObject = [[all_data objectForKey:[sectionTitleArray objectAtIndex:1]] objectForKey:aKey];
            
            NSArray *keys = [_items allKeys];
            id aKey = [keys objectAtIndex:indexPath.row];
            id anObject = [_items objectForKey:aKey];
            
            label.text = [anObject objectForKey:@"name"];
            
            if ([fieldSelected containsObject:indexPath])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
            
        }
            break;
            
        default:
            break;
    }
    */
    // return nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    
    // NSDictionary* item = [all_data objectAtIndex:indexPath.row];
    // label.text = [item objectForKey:@"value"];
    
    
    // id aKey = [keys objectAtIndex:indexPath.row];
    // id anObject = [[all_data objectForKey:[sectionTitleArray objectAtIndex:1]] objectForKey:aKey];
    
    NSArray *keys = [mails allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [mails objectForKey:aKey];
    
    label.text = [anObject objectForKey:@"name"];
    
    if ([fieldSelected containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    switch (indexPath.section) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            //the below code will allow multiple selection
            if ([fieldSelected containsObject:indexPath]){
                [fieldSelected removeObject:indexPath];
            }else{
                [fieldSelected addObject:indexPath];
            }
        }
            break;
            
        default:
            break;
    }
    */
    
    [self reloadData:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 1:
        {
            return YES;
        }
            break;
            
        default:
            break;
    }
    return NO;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *blockAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        // [self.tableView setEditing:NO];
        
        NSMutableDictionary *_items = [mails objectForKey:[sectionTitleArray objectAtIndex:1]];
        
        NSArray *keys = [_items allKeys];
        id aKey = [keys objectAtIndex:indexPath.row];
        id anObject = [_items objectForKey:aKey];

        EditEmail *v = [self.storyboard instantiateViewControllerWithIdentifier:@"EditEmail"];
        v.fction     = @"edit";
        v.item_id    = aKey;
        v.email      = [anObject objectForKey:@"email"];
        
        /*
         EditPhone *v = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPhone"];
         v.fction = @"edit";
         v.item_id = aKey;
         v.number =[anObject objectForKey:@"phone"];
         */
        
        [self.navigationController pushViewController:v animated:YES];
        
        
    }];
    // blockAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *hiddenAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        /*
        NSDictionary* item = [data_profile2 objectAtIndex:indexPath.row];
        NSLog(@"");
         */
        
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Delete" message:@"Confirm Delete." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        
        alertView.tag = -999;
        
        alertView.object = @{@"indexPath" : indexPath};

        [alertView show];
        
    }];
    
    return @[hiddenAction, blockAction];
}

-(void)onRegisterTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    
     UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     
     AnNmousURegister *anNmousURegister =[storybrd instantiateViewControllerWithIdentifier:@"AnNmousURegister"];
     
     // homeViewController.urlString = @"https://www.facebook.com/samosornpatumwan";
     // homeViewController.title = @"Home";
     // UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
     
     // http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller
     // set register notification
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(AnNmousURegisterRESULT:)
     name:@"AnNmousURegister_RESULT" object:nil];
     
     [self presentViewController:[[UINavigationController alloc] initWithRootViewController:anNmousURegister] animated:YES completion:nil];
}

-(void)AnNmousURegisterRESULT:(NSNotification *)notice{
    NSString *email = [notice object];
    
    // removeObserver : AnNmousURegister_RESULT
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AnNmousURegister_RESULT" object:nil];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AnNmousUVerify *anNmousUVerify =[storybrd instantiateViewControllerWithIdentifier:@"AnNmousUVerify"];
    anNmousUVerify.email = email;
    
    // set register notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AnNmousUVerifyRESULT:)
                                                 name:@"AnNmousUVerify_RESULT" object:nil];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:anNmousUVerify] animated:YES completion:nil];
}

-(void)AnNmousUVerifyRESULT:(NSNotification *)notice{
    // NSString *email = [notice object];
    
    NSLog(@"%@", [[notice userInfo] objectForKey:@"email"]);
    
    // NSDictionary *_userInfo = @{@"result" : @"1", @"email" : self.email};
    
    // removeObserver : AnNmousURegister_RESULT
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AnNmousUVerify_RESULT" object:nil];
    
    NSLog(@"");
}

- (void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case -999:
            if (buttonIndex == 0){
                NSLog(@"ยกเลิก");
            }else{
                NSLog(@"ตกลง");
                
                NSDictionary* userInfo = alertView.object;
                
                NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
                
                NSMutableDictionary *_items = [mails objectForKey:[sectionTitleArray objectAtIndex:1]];
                
                NSArray *keys = [_items allKeys];
                id aKey = [keys objectAtIndex:indexPath.row];
                id anObject = [_items objectForKey:aKey];
                
                // NSString* email = [[_items objectAtIndex:indexPath.row] objectForKey:@"value"];
    
                
                /*
                 NSMutableDictionary *_items = [all_data objectForKey:[sectionTitleArray objectAtIndex:1]];
                 
                 NSArray *keys = [_items allKeys];
                 id aKey = [keys objectAtIndex:indexPath.row];
                 id anObject = [_items objectForKey:aKey];
                 
                 EditEmail *v = [self.storyboard instantiateViewControllerWithIdentifier:@"EditEmail"];
                 v.fction     = @"edit";
                 v.item_id    = aKey;
                 v.email      = [anObject objectForKey:@"email"];
                 */

                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
                
                EditEmailThread *editPhone = [[EditEmailThread alloc] init];
                [editPhone setCompletionHandler:^(NSString *data) {
                    
                    NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                    
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        
                        /*
                        if ([jsonDict[@"status"] isEqualToString:@"0"]) {
                            NSMutableDictionary *_dict = [[Configs sharedInstance] loadData:_USER];
                            
                                // delete
                                if([[[_dict objectForKey:@"profile2"] objectForKey:@"field_profile_multi_email"][@"und"] count] > 0){
                                    NSMutableDictionary* field_profile_multi_phone =  [[[_dict objectForKey:@"profile2"] objectForKey:@"field_profile_multi_email"][@"und"] mutableCopy];
                                    
                                    NSMutableDictionary *profile2Dict = [[NSMutableDictionary alloc] init];
                                    
                                    [profile2Dict addEntriesFromDictionary:[_dict objectForKey:@"profile2"]];
                                    
                                    [profile2Dict removeObjectForKey:@"field_profile_multi_email"];
                                    
                                    // NSMutableDictionary *field_profile_image = [profile2Dict objectForKey:@"field_profile_image"];
                                    
                                    
                                    
                                    for (NSString* key in field_profile_multi_phone) {
                                        NSMutableDictionary* value = [field_profile_multi_phone objectForKey:key];
                                        // do stuff
                                        
                                        if ([key isEqualToString:jsonDict[@"item_id"]]) {
                                            [field_profile_multi_phone removeObjectForKey:key];
                                            
                                            break;
                                        }
                                    }

                                    
                                    NSLog(@"");
                                    [profile2Dict setObject:@{@"und" :field_profile_multi_phone} forKey:@"field_profile_multi_email"];
                                    
                                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                                    [newDict addEntriesFromDictionary:_dict];
                                    [newDict removeObjectForKey:@"profile2"];
                                    
                                    [newDict setObject:profile2Dict forKey:@"profile2"];
                                    
                                    
                                    // [[Configs sharedInstance] saveData:_USER :newDict];
                                    
                                    [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success"];
                                    // [self.navigationController popViewControllerAnimated:YES];
                                    
                                    //raise notification about dismiss
                                    // [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:@""];
                                    
                                    [self reloadData];
                                }
                        }else{
                            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
                        }
                        */
                    }else{
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
                    }
                }];
                
                [editPhone setErrorHandler:^(NSString *error) {
                    NSLog(@"%@", error);
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                }];
                // self.number
                [editPhone start:@"delete" :aKey : @""];
            }
            
            break;
            
        default:
            break;
    }
}

-(void)reloadData:(NSNotification *) notification{
    if([[[Configs sharedInstance] loadData:_DATA] objectForKey:@"mails"]){
        mails = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"mails"];
        if ([mails count] > 0) {
            self._table.hidden = NO;
            // self.emptyMessage.hidden = YES;
        }
    }else{
        mails = [[NSMutableDictionary alloc] init];
        self._table.hidden = YES;
        // self.emptyMessage.hidden = NO;
    }
    
    
    // self._table.hidden = YES;
    
    /*
    if ([[[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] objectForKey:@"profile"] objectForKey:@"mails"]) {
        NSDictionary* mails = [[[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] objectForKey:@"profile"] objectForKey:@"mails"];
        
        NSLog(@"%@", mails);
        if ([mails count] > 0) {
            self._table.hidden = NO;
            
            for (NSString* key in mails) {
                NSDictionary* value = [mails objectForKey:key];
                if ([[value objectForKey:@"enabled"] isEqualToString:@"1"]) {
                    if ([[value objectForKey:@"level"] isEqualToString:@"0"]) {
                        [all_data setValue:value forKey:[sectionTitleArray objectAtIndex:0]];
                        
                        // Email
                        NSMutableDictionary*_mails = [mails mutableCopy];
                        [_mails removeObjectForKey:key];

                        [all_data setValue:_mails forKey:[sectionTitleArray objectAtIndex:1]];
                        break;
                    }
                }
            }
        }
    }
    */
    
    [self._table reloadData];
}


@end
