//
//  ManageClass.m
//  iDNA
//
//  Created by Somkid on 1/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "ManageClass.h"
#import "ClasssRepo.h"
#import "Classs.h"

#import "HJManagedImageV.h"
#import "AppDelegate.h"

#import "ClasssListFriends.h"

@interface ManageClass (){
    NSArray* data_all;
    ClasssRepo* classsRepo;
}
@end

@implementation ManageClass

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    data_all    = [[NSArray alloc] init];
    classsRepo  = [[ClasssRepo alloc] init];
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

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"ManageClass_reloadData"
                                               object:nil];
    
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ManageClass_reloadData" object:nil];
}

-(void)reloadData:(NSNotification *) notification{
    data_all = [classsRepo getClasssAll];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"Select Friend";
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data_all count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSArray *value = [data_all objectAtIndex:indexPath.row];
    
    NSString *item_id = [value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
    NSData *data =  [[value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    HJManagedImageV *imageV =(HJManagedImageV *)[cell viewWithTag:100];
    UILabel *lblName    =(UILabel *)[cell viewWithTag:101];
    UILabel *lblMembers =(UILabel *)[cell viewWithTag:102];
    
    lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], item_id] ;
    
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{
        
    }
    
    NSMutableDictionary *local_friends = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
    
    int count = 0;
    for (NSString* key in local_friends) {
        NSDictionary* value = [local_friends objectForKey:key];
        // do stuff

        if ([value objectForKey:@"classs"]) {
            NSString *classs = [value objectForKey:@"classs"];
            
            if ([classs isEqualToString:item_id]) {
                count++;
            }
        }
    }
    lblMembers.text =[NSString stringWithFormat:@"%d Users", count];
    /*
    NSMutableDictionary *local_friend  = [local_friends objectForKey:friend_id];
    // [friend setValue:class forKey:@"classs"];
    if ([local_friend objectForKey:@"classs"]) {
        ClasssRepo * classsRepo = [[ClasssRepo alloc] init];
        NSArray *class = [classsRepo get:[local_friend objectForKey:@"classs"]];
        
        
        NSString *item_id = [class objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
        //        NSData *class_data =  [[class objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        //
        //        NSMutableDictionary *tmp = [NSJSONSerialization JSONObjectWithData:class_data options:0 error:nil];
        //
        //        [btnClasss setTitle:[tmp objectForKey:@"name"] forState:UIControlStateNormal];
        
        select = item_id;
    }else{
        select = @"0";
    }
    */
    
    /*
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    // cell.textLabel.text = _dataArray[indexPath.row][@"text"];
    if (selectedIndex[indexPath] != nil) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    */
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSArray *value = [data_all objectAtIndex:indexPath.row];
    NSString *item_id = [value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClasssListFriends* classListFriends = [storybrd instantiateViewControllerWithIdentifier:@"ClasssListFriends"];
    classListFriends.item_id = item_id;
    [self.navigationController pushViewController:classListFriends animated:YES];
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *btnDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Delete");
        
//        NSArray *keys = [hideFriends allKeys];
//        id aKey = [keys objectAtIndex:indexPath.row];
//
//        NSString *child = [NSString stringWithFormat:@"%@%@/friends/%@/hide/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU], aKey];
//
//        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@", child]: @"0"};
//        [ref updateChildValues:childUpdates];
//
//        [self updateUnhideFriend:aKey];
    }];
    btnDelete.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *btnEdit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Edit");
        
        //        NSArray *keys = [hideFriends allKeys];
        //        id aKey = [keys objectAtIndex:indexPath.row];
        //
        //        NSString *child = [NSString stringWithFormat:@"%@%@/friends/%@/hide/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU], aKey];
        //
        //        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@", child]: @"0"};
        //        [ref updateChildValues:childUpdates];
        //
        //        [self updateUnhideFriend:aKey];
    }];
    btnEdit.backgroundColor = [UIColor blueColor];
    
    return @[btnDelete, btnEdit];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
