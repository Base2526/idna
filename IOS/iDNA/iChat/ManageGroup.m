//
//  ManageGroup.m
//  iChat
//
//  Created by Somkid on 30/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "ManageGroup.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "UpdatePictureGroupThread.h"
#import "GroupMembers.h"
#import "GroupInvite.h"
#import "UserDataUIAlertView.h"

#import "GroupChatRepo.h"

@interface ManageGroup (){
    NSDictionary *group;
    
    GroupChatRepo *groupChatRepo;
}

@end

@implementation ManageGroup

@synthesize group_id;
@synthesize imageV, ref;
@synthesize imagePicker;
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ref = [[FIRDatabase database] reference];
    
    groupChatRepo  = [[GroupChatRepo alloc] init];
    
    imageV.userInteractionEnabled = YES;
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadData];
}

-(void)dismissKeyboard {
    [self.view endEditing:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData{
    NSArray *_group = [groupChatRepo get:group_id];
    NSString *data = [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]];
    NSMutableDictionary *items = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    group = [NSJSONSerialization JSONObjectWithData:items options:0 error:nil];
    
    if ([group objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel]; // API_URL
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [group objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{
        [imageV clear];
    }
    self.txtGroupName.text = [group objectForKey:@"name"];
    
    NSDictionary *members = [group objectForKey:@"members"];
    self.title = [NSString stringWithFormat:@"Manage Group(%d)", [members count] ];
    NSLog(@"");
    
    [self.btnManageMembers setTitle:[NSString stringWithFormat:@"Manage Group(%d)", [members count] ] forState:UIControlStateNormal];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)selectImage:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Library", nil];
    
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
        case 1:{
            self.imagePicker = [[GKImagePicker alloc] init];
            self.imagePicker.cropSize = CGSizeMake(280, 280);
            self.imagePicker.delegate = self;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                [self.popoverController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            } else {
                [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

/*
 กรณีเลือกรูปจาก gallery ในเครื่อง
 */
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
//    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
//    UpdateProfileGroupThread *uThread = [[UpdateProfileGroupThread alloc] init];
//    [uThread setCompletionHandler:^(NSString *data) {
//
//        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
//
//        [[Configs sharedInstance] SVProgressHUD_Dismiss];
//
//        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
//
////            [imageV clear];
////            [imageV showLoadingWheel];
////            [imageV setUrl:[NSURL URLWithString:jsonDict[@"url"]]];
////            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
////
////            [self updateURI:jsonDict[@"url"]];
//        }
//        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
//    }];
//
//    [uThread setErrorHandler:^(NSString *error) {
//        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
//    }];
//    [uThread start:[self.group objectForKey:@"group_id"] :image];
    
    // [self.imageV setImage:image];
    
    [self UpdatePicture:image];
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSLog(@"");
}

/*
 กรณีถ่ายรูปจาก camera
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self UpdatePicture:image];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onSave:(id)sender {

    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    
    /*
     Update name ของ group
     
    NSMutableDictionary *tgroup = [[NSMutableDictionary alloc] init];
    [tgroup addEntriesFromDictionary:group];
    [tgroup removeObjectForKey:@"name"];
    [tgroup setObject:self.txtGroupName.text forKey:@"name"];
    
    /*
     Update group ของ groups
     
    NSMutableDictionary *newGroups = [[NSMutableDictionary alloc] init];
    [newGroups addEntriesFromDictionary:[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"groups"]];
    [newGroups removeObjectForKey:[tgroup objectForKey:@"group_id"]];
    [newGroups setValue:tgroup forKey:[tgroup objectForKey:@"group_id"]];
     */
    
    /*
     Update groups ของ DATA
     
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
    [newDict removeObjectForKey:@"groups"];
    [newDict setObject:newGroups forKey:@"groups"];
    */
    
   // [[Configs sharedInstance] saveData:_DATA :newDict];
    
    // ดึงข้อมูลจาก local มาเพื่อเราจะมา update field image_url
    NSArray *_group = [groupChatRepo get:group_id];
    NSString *data = [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]];
    
    NSMutableDictionary *items = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    NSMutableDictionary *tgroup = [[NSMutableDictionary alloc] init];
    [tgroup addEntriesFromDictionary:items];
    [tgroup removeObjectForKey:@"name"];
    [tgroup setObject:self.txtGroupName.text forKey:@"name"];
    
    GroupChat *groupChat = [[GroupChat alloc] init];
    groupChat.group_id =  [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"group_id"]];
    groupChat.create   =  [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"create"]];
    
    // แปลกข้อมูลก่อนบันทึก local
    NSError * err;
    NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:tgroup options:0 error:&err];
    groupChat.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    groupChat.update    = [timeStampObj stringValue];
    
    // Update local database
    [groupChatRepo update:groupChat];
    
    NSString *child = [NSString stringWithFormat:@"%@%@/groups/%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU], groupChat.group_id];
    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@", child]: tgroup};
    
    [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error == nil) {
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            [self.navigationController popViewControllerAnimated:NO];
        }else{
        }
    }];
}

- (IBAction)onManageMembers:(id)sender {
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupMembers *members = [storybrd instantiateViewControllerWithIdentifier:@"GroupMembers"];
    members.group_id = group_id;
    
    [self.navigationController pushViewController:members animated:YES];
}

- (IBAction)onInviteMember:(id)sender {
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupInvite *invite = [storybrd instantiateViewControllerWithIdentifier:@"GroupInvite"];
    invite.group_id = group_id;
    
    [self.navigationController pushViewController:invite animated:YES];
}

- (IBAction)onDeleteGroup:(id)sender {
    
    UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:@"Are you sure delete group?"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"Close"
                                     otherButtonTitles:@"Delete", nil];
    
    alert.userData = @"";
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UserDataUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 1) {
        
        NSIndexPath * indexPath = alertView.userData;
        
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
                
            case 1:{
                // Close
                NSLog(@"Delete");
                
                NSString *child = [NSString stringWithFormat:@"%@%@/groups/%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU], group_id];
                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    
                    if (error == nil) {
                        // [ref parent]
                        //NSString* parent = ref.parent.key;
                        
                        // จะได้ Group id
                        NSString* group_id = [ref key];
                        
                        // NSMutableDictionary *groups = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"groups"];
                        
                        /*
                         เช็ดก่อนว่ามี group_id นี้หรือเปล่าเพราะบางที่อาจโดนลบไปแล้ว ก็ได้จาก main control (firebase อาจ return มาเร็วมาก)
                         */
                        if ([groupChatRepo get:group_id]) {
                            
                            /*
                             Update group ของ groups
                             */
                            /*
                            NSMutableDictionary *newGroups = [[NSMutableDictionary alloc] init];
                            [newGroups addEntriesFromDictionary:groups];
                            [newGroups removeObjectForKey:key];
                             */
                            
                            /*
                             Update groups ของ DATA
                             */
                            /*
                            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
                            [newDict removeObjectForKey:@"groups"];
                            [newDict setObject:groups forKey:@"groups"];
                            
                            [[Configs sharedInstance] saveData:_DATA :newDict];
                            */
                            
                            [groupChatRepo deleteGroup:group_id];
                        
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                        
                    }
                }];
            }
                break;
        }
    }
}

-(void)UpdatePicture:(UIImage *)image{
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureGroupThread *updatePictureGroupThread = [[UpdatePictureGroupThread alloc] init];
    [updatePictureGroupThread setCompletionHandler:^(NSString *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            /*
             Update image_url ของ group
             
            NSMutableDictionary *tgroup = [[NSMutableDictionary alloc] init];
            [tgroup addEntriesFromDictionary:group];
            [tgroup removeObjectForKey:@"image_url"];
            [tgroup setObject:jsonDict[@"image_url"] forKey:@"image_url"];
            
            /*
             Update group ของ groups
             
            NSMutableDictionary *groups = [[NSMutableDictionary alloc] init];
            [groups addEntriesFromDictionary:[[[Configs sharedInstance] loadData:_DATA] valueForKey:@"groups"]];
            [groups removeObjectForKey:[tgroup objectForKey:@"group_id"]];
            [groups setObject:tgroup forKey:[tgroup objectForKey:@"group_id"]];
            
            /*
             Update groups ของ DATA
             
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:@"groups"];
            [newDict setObject:groups forKey:@"groups"];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
             */
            
            // ดึงข้อมูลจาก local มาเพื่อเราจะมา update field image_url
            NSArray *_group = [groupChatRepo get:group_id];
            NSString *data = [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]];

            NSMutableDictionary *items = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            
            NSMutableDictionary *tgroup = [[NSMutableDictionary alloc] init];
            [tgroup addEntriesFromDictionary:items];
            [tgroup removeObjectForKey:@"image_url"];
            [tgroup setObject:jsonDict[@"image_url"] forKey:@"image_url"];
            
            GroupChat *groupChat = [[GroupChat alloc] init];
            groupChat.group_id  = group_id;
            
            // แปลกข้อมูลก่อนบันทึก local
            NSError * err;
            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:tgroup options:0 error:&err];
            groupChat.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            groupChat.update    = [timeStampObj stringValue];
            
            // Update local database
            [groupChatRepo update:groupChat];
            
            // [self reloadData];
            
            //  Update UIImageView
            // [imageV setImage:image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update Erorr."];
        }
        
    }];
    
    [updatePictureGroupThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [updatePictureGroupThread start:group_id : image];
}

@end
