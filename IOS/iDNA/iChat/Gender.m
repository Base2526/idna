//
//  Gender.m
//  iDNA
//
//  Created by Somkid on 5/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "Gender.h"
#import "ProfilesRepo.h"
#import "GenderThread.h"

@interface Gender (){
    FIRDatabaseReference *ref;
    NSString* selectedIndex;
    
    ProfilesRepo *profilesRepo;
    NSMutableDictionary *profiles;
    
    NSDictionary *all_data;
    NSMutableArray * sortedKeys;
}

@end

@implementation Gender
@synthesize tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    profilesRepo = [[ProfilesRepo alloc] init];
    
    
    all_data = [[Configs sharedInstance] loadData:_GENDER];
    
    if ([all_data count] == 0){
        GenderThread *gd = [[GenderThread alloc] init];
        [gd setCompletionHandler:^(NSData * data) {
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                all_data = jsonDict[@"data"];
                
                [[Configs sharedInstance] saveData:_GENDER :all_data];
                
                sortedKeys = [[all_data allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
                
                [self reloadData:nil];
            }else{
                
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
            }
            
        }];
        [gd setErrorHandler:^(NSString * error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        
        [gd start];
    }else{
        sortedKeys = [[all_data allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    }
    
    NSArray *pf = [profilesRepo get];
    NSData *data =  [[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([profiles objectForKey:@"gender"]) {
        selectedIndex = [profiles objectForKey:@"gender"];
    }else{
        selectedIndex = @"";
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadData:nil];
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

-(void)reloadData:(NSNotification *) notification{
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *labelName = (UILabel *)[cell viewWithTag:10];
        
    NSString* key = [sortedKeys objectAtIndex:indexPath.row];
    id anObject = [all_data objectForKey:key];
    
    [labelName setText:[anObject objectForKey:@"name"]];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([selectedIndex isEqualToString:key]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //the below code will allow multiple selection
    
    // [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    
    if ([selectedIndex isEqualToString:[sortedKeys objectAtIndex:indexPath.row]]) {
        return;
    }
    selectedIndex = [sortedKeys objectAtIndex:indexPath.row];
    
    NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
    [newProfiles addEntriesFromDictionary:profiles];
    
    if ([newProfiles objectForKey:@"gender"]) {
        [newProfiles removeObjectForKey:@"gender"];
    }
    
    [newProfiles setValue:selectedIndex forKey:@"gender"];
    
    /*
    Profiles *pfs = [[Profiles alloc] init];
    NSError * err;
    NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfiles options:0 error:&err];
    pfs.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    pfs.update    = [timeStampObj stringValue];
    
    // BOOL sv = [profilesRepo update:pfs];
    
    // [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:pfs];
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL sv = [profilesRepo update:pfs];
    });
    */
    
    NSError * err;
    NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfiles options:0 error:&err];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    
    
    NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newProfiles};
    
    [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        // [[Configs sharedInstance] SVProgressHUD_Dismiss];
        if (error == nil) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:NO];
//            });
            
            
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update name."];
        }
    }];
    
    [self reloadData:nil];
}

@end
