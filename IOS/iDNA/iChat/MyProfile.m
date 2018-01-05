//
//  MyProfile.m
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import "MyProfile.h"

#import "Configs.h"
#import "AppDelegate.h"
#import "ManageClass.h"
#import "UpdatePictureProfileThread.h"
#import "UpdateMyProfileThread.h"
#import "UpdatePictureBGThread.h"

#import "ManageClass.h"

#import "TopAlignedLabel.h"
#import "HJManagedImageV.h"

#import "EditDisplayName.h"

#import "Profiles.h"
#import "ProfilesRepo.h"

#import "EditStatusMessage.h"
#import "EditAddress.h"
#import "ListPhone.h"
#import "ListEmail.h"
#import "Gender.h"
#import "Birthday.h"

@interface MyProfile (){
    NSMutableDictionary *profiles;
    ProfilesRepo *profileRepo;
}
@end

@implementation MyProfile
//@synthesize imageV, imageV_QRCode, imageV_bg, ref, txtFName, lblEmail, txtFStatus;
@synthesize imagePicker;
//@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    profileRepo = [[ProfilesRepo alloc] init];
    
    /*
    ref = [[FIRDatabase database] reference];
    
    imageV.userInteractionEnabled = YES;
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectProfileImage:)]];
    
    
    imageV_bg.userInteractionEnabled = YES;
    [imageV_bg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBGImage:)]];
    

    NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    if ([profiles objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
    }
    
    //
    // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    if ([profiles objectForKey:@"bg_url"]) {
        [imageV_bg clear];
        [imageV_bg showLoadingWheel];
        
        [imageV_bg setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"bg_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_bg ];
    }
    
    if ([profiles objectForKey:@"image_url_ios_qrcode"]) {
        [imageV_QRCode clear];
        [imageV_QRCode showLoadingWheel];
        [imageV_QRCode setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url_ios_qrcode"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_QRCode ];
    }
    
    txtFName.text =[profiles objectForKey:@"name"];
    lblEmail.text =[profiles objectForKey:@"mail"];
    
    // txtFStatus
    if ([profiles objectForKey:@"status_message"]) {
        txtFStatus.text =[profiles objectForKey:@"status_message"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
////    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+500);
//    
//    scrollView.showsVerticalScrollIndicator=YES;
//    scrollView.scrollEnabled=YES;
//    scrollView.userInteractionEnabled=YES;
//    // [self.view addSubview:scrollview];
//    scrollView.contentSize = CGSizeMake(500,1200);
    
    // scrollView.contentSize = CGSizeMake(320, 800);
     */
}

-(void) viewWillAppear:(BOOL)animated{
    [self reloadData:nil];
}

-(void)dismissKeyboard {
    [self.view endEditing:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    NSArray *pf = [profileRepo get];
    NSData *data =  [[pf objectAtIndex:[profileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    [self.tableView reloadData];
}

/*
-(void)selectProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Library", nil];
    
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

-(void)selectBGImage:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Library", nil];
    
    actionSheet.tag = 102;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 101) {
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
            
        case 1:
        {
            NSLog(@"");
            self.imagePicker = [[GKImagePicker alloc] init];
            self.imagePicker.cropSize = CGSizeMake(280, 280);
            self.imagePicker.delegate = self;
            
            self.imagePicker._tag = @"profile";
            
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                [self.popoverController presentPopoverFromRect:CGRectMake(100, 500, 10, 10)
                                    inView:self.view
                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                  animated:YES];
            } else {
                [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
    }else {
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
                break;
                
            case 1:
            {
                NSLog(@"");
                self.imagePicker = [[GKImagePicker alloc] init];
                self.imagePicker.cropSize = CGSizeMake(280, 280);
                self.imagePicker.delegate = self;
                
                self.imagePicker._tag = @"bg";
                
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    
                    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                    [self.popoverController presentPopoverFromRect:CGRectMake(100, 500, 10, 10)
                                                            inView:self.view
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
                } else {
                    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
        
    }
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    NSLog(@"%@", imagePicker._tag);
    
    if ([imagePicker._tag isEqualToString:@"profile"]) {
        [self updateProfilePicture:image];
    }else{
        
        [self updateBGPicture:image];
    }
    
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        // [self.popoverController dismissPopoverAnimated:YES];

        [self.popoverController dismissPopoverAnimated:NO];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    // img = image;

    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    // [self reloadData:nil];
    
    NSLog(@"");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
   
    // NSLog(@"%@", imagePicker._id);
    [self updateProfilePicture:image];
//
//    img = chosenImage;
//    // [self hideImagePicker];
//
//    [self reloadData:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onSave:(id)sender {
    // UpdateMyProfileThread
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    
    NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:profiles];
    [newDict removeObjectForKey:@"name"];
    [newDict removeObjectForKey:@"status_message"];
    
    [newDict setValue:txtFName.text forKey:@"name"];
    [newDict setValue:txtFStatus.text forKey:@"status_message"];
    
    NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newDict};
    
    [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error == nil) {
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            [self.navigationController popViewControllerAnimated:NO];
        }else{
        }
    }];
}

-(void)updateURI:(NSString *)uri{
    
    NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    [profiles setValue:uri forKey:@"image_url"];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    // เราต้อง addEntriesFromDictionary ก่อน ถึงจะสามารถลบได้ แ้วค่อย update ข้อมูล
    [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
    //  ลบข้อมูล key profiles ออกไป
    [newDict removeObjectForKey:@"profiles"];
    
    [newDict setObject:profiles forKey:@"profiles"];
    
    [[Configs sharedInstance] saveData:_DATA :newDict];
}

-(void)updateProfilePicture:(UIImage *)image{
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureProfileThread *uThread = [[UpdatePictureProfileThread alloc] init];
    [uThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // code here
                [imageV clear];
                [imageV showLoadingWheel];
                [imageV setUrl:[NSURL URLWithString:jsonDict[@"url"]]];
            
                [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,jsonDict[@"url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            });
            // [self updateURI:jsonDict[@"url"]];
            
            NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
            [profiles setValue:jsonDict[@"url"] forKey:@"image_url"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            // เราต้อง addEntriesFromDictionary ก่อน ถึงจะสามารถลบได้ แ้วค่อย update ข้อมูล
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            //  ลบข้อมูล key profiles ออกไป
            [newDict removeObjectForKey:@"profiles"];
            
            [newDict setObject:profiles forKey:@"profiles"];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [uThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [uThread start:image];
}

-(void)updateBGPicture:(UIImage *)image{
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureBGThread *updateBGThread = [[UpdatePictureBGThread alloc] init];
    [updateBGThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // code here
                [imageV_bg clear];
                [imageV_bg showLoadingWheel];
                [imageV_bg setUrl:[NSURL URLWithString:jsonDict[@"url"]]];
                
                [imageV_bg setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,jsonDict[@"url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_bg ];
            });
            // [self updateURI:jsonDict[@"url"]];
            
            NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
            [profiles setValue:jsonDict[@"url"] forKey:@"bg_url"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            // เราต้อง addEntriesFromDictionary ก่อน ถึงจะสามารถลบได้ แ้วค่อย update ข้อมูล
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            //  ลบข้อมูล key profiles ออกไป
            [newDict removeObjectForKey:@"profiles"];
            
            [newDict setObject:profiles forKey:@"profiles"];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [updateBGThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [updateBGThread start:image];
}
 */

#pragma mark - Table view data source
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"Select Friend";
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 80;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"cell_picture_profile"];
            
            cell.selectionStyle     = UITableViewCellSelectionStyleNone;
            UILabel *label1         = [cell viewWithTag:10];
            HJManagedImageV *imageV = [cell viewWithTag:11];
            
            if ([profiles objectForKey:@"image_url"]) {
                [imageV clear];
                [imageV showLoadingWheel];
                
                [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            }
            
            return cell;
        }
            break;
            
        case 1:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"ชื่อ :"];
            
            // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
            
            [label2 setText:[profiles objectForKey:@"name"]];
            NSLog(@"");
            
            return cell;
        }
             break;
            
            // Status message
        case 2:{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"ข้อความ :"];
            
            // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
            
            if ([profiles objectForKey:@"status_message"]) {
                [label2 setText:[profiles objectForKey:@"status_message"]];
            }else{
                [label2 setText:[profiles objectForKey:@"-"]];
            }
            
            NSLog(@"");
            return cell;
        }
            break;
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_address"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextView *textAddress = [cell viewWithTag:10];
                    
            if ([profiles objectForKey:@"address"]) {
                [textAddress setText:[profiles objectForKey:@"address"]];
            }else{
                [textAddress setText:[profiles objectForKey:@"-"]];
            }
            
            return cell;
        }
            break;
            
        case 4:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Emails :"];
            
//            NSArray *pf = [profilesRepo get];
//            NSData *data =  [[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
//
//            profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([profiles objectForKey:@"mails"]) {
                NSDictionary *mails = [profiles objectForKey:@"mails"];
                label2.text =[NSString stringWithFormat:@"%d", [mails count]]  ;
            }else{
                label2.text = @"not email";
            }
            
            return cell;
        }
            
        case 5:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Phones :"];
            
            if ([profiles objectForKey:@"phones"]) {
                NSDictionary *phones = [profiles objectForKey:@"phones"];
                label2.text = [NSString stringWithFormat:@"%d", [phones count]];
            }else{
                label2.text = @"not phones";
            }
            
            return cell;
        }
            
//        case 5:{
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            UILabel *label1 = [cell viewWithTag:10];
//            UILabel *label2 = [cell viewWithTag:11];
//
//            [label1 setText:@"QR Code :"];
//            [label2 setText:@""];
//
//            return cell;
//        }
            
        case 6:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_picture_profile"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            HJManagedImageV *imageV = [cell viewWithTag:11];
            
            [label1 setText:@"BG :"];
            
            // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
            if ([profiles objectForKey:@"bg_url"]) {
                [imageV clear];
                [imageV showLoadingWheel];
                
                [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"bg_url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            }
            
            return cell;
        }
            
        case 7:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Gender :"];
            
            if ([profiles objectForKey:@"gender"]) {
                
                NSDictionary* gd = [[Configs sharedInstance] loadData:_GENDER];
                // NSString* key = [sortedKeys objectAtIndex:indexPath.row];
                id anObject = [gd objectForKey:[profiles objectForKey:@"gender"]];
                
                // [labelName setText:[anObject objectForKey:@"name"]];
                [label2 setText:[anObject objectForKey:@"name"]];
            }else{
                [label2 setText:@""];
            }
            
            
            return cell;
        }
            
        case 8:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Age :"];
            [label2 setText:@""];
            
            if ([profiles objectForKey:@"birthday"]) {
                // selectedIndex = [profiles objectForKey:@"birthday"];
                
                NSTimeInterval timestamp = [[profiles objectForKey:@"birthday"] doubleValue];
                NSDate *lastUpdate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];
                
                label2.text = [[self getDateFormatter]  stringFromDate:lastUpdate];
            }
            
            return cell;
        }
            
        case 9:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"School :"];
            [label2 setText:@""];
            
            if ([profiles objectForKey:@"school"]) {
                [label2 setText:[profiles objectForKey:@"school"]];
            }else{
                [label2 setText:@""];
            }
            
            return cell;
        }
            
        case 10:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Company :"];
            // [label2 setText:@""];
            
            if ([profiles objectForKey:@"company"]) {
                [label2 setText:[profiles objectForKey:@"company"]];
            }else{
                [label2 setText:@""];
            }
            
            return cell;
        }
        
        default:{
            
        }
            break;
    }
    
    return nil;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"Take Photo", @"Library", nil];
            
            actionSheet.tag = 101;
            [actionSheet showInView:self.view];
                
            }
            break;
            
        case 1:{
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            EditDisplayName* editName = [storybrd instantiateViewControllerWithIdentifier:@"EditDisplayName"];
            editName.uid = [[Configs sharedInstance] getUIDU];
            [self.navigationController pushViewController:editName animated:YES];
        }
            break;
            
        case 2:{
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EditStatusMessage* editStatusMessage = [storybrd instantiateViewControllerWithIdentifier:@"EditStatusMessage"];
            
            if ([profiles objectForKey:@"status_message"]) {
                editStatusMessage.message = [profiles objectForKey:@"status_message"];
            }else{
                editStatusMessage.message = @"";
            }
            [self.navigationController pushViewController:editStatusMessage animated:YES];
        }
            break;
            
        case 3:{
            // NSLog(@"Address");

            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EditAddress* editAddress = [storybrd instantiateViewControllerWithIdentifier:@"EditAddress"];
            editAddress.type = @"address";
            [self.navigationController pushViewController:editAddress animated:YES];
        }
            break;
            
        case 4:{
            // Email
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            ListEmail *v = [storybrd instantiateViewControllerWithIdentifier:@"ListEmail"];
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
            
        case 5:{
            // Phone
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            ListPhone *v = [storybrd instantiateViewControllerWithIdentifier:@"ListPhone"];
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
        
        case 6:{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"Take Photo", @"Library", nil];
            
            actionSheet.tag = 102;
            [actionSheet showInView:self.view];
        }
            break;
            
        case 7:{
            // Gender
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            Gender *v = [storybrd instantiateViewControllerWithIdentifier:@"Gender"];
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
            
        case 8:{
            // Birthday
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            Birthday *v = [storybrd instantiateViewControllerWithIdentifier:@"Birthday"];
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
            
            
        case 9:{
            // School
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EditAddress* editAddress = [storybrd instantiateViewControllerWithIdentifier:@"EditAddress"];
            editAddress.type = @"school";
            [self.navigationController pushViewController:editAddress animated:YES];
        }
            break;
            
        case 10:{
            // Company
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EditAddress* editAddress = [storybrd instantiateViewControllerWithIdentifier:@"EditAddress"];
            editAddress.type = @"company";
            [self.navigationController pushViewController:editAddress animated:YES];
        }
            break;
            
        default:
            break;
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 101) {
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
                break;
                
            case 1:
            {
                NSLog(@"");
                self.imagePicker = [[GKImagePicker alloc] init];
                self.imagePicker.cropSize = CGSizeMake(280, 280);
                self.imagePicker.delegate = self;
                
                self.imagePicker._tag = @"profile";
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    
                    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                    [self.popoverController presentPopoverFromRect:CGRectMake(100, 500, 10, 10)
                                                            inView:self.view
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
                } else {
                    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
    }else {
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
                break;
                
            case 1:
            {
                self.imagePicker = [[GKImagePicker alloc] init];
                self.imagePicker.cropSize = CGSizeMake(280, 280);
                self.imagePicker.delegate = self;
                
                self.imagePicker._tag = @"bg";
                
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    
                    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                    [self.popoverController presentPopoverFromRect:CGRectMake(100, 500, 10, 10)
                                                            inView:self.view
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
                } else {
                    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
        
    }
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    NSLog(@"%@", imagePicker._tag);
    
    if ([imagePicker._tag isEqualToString:@"profile"]) {
        [self updateProfilePicture:image];
    }else{
        
        [self updateBGPicture:image];
    }

    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        // [self.popoverController dismissPopoverAnimated:YES];
        
        [self.popoverController dismissPopoverAnimated:NO];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)updateProfilePicture:(UIImage *)image{
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureProfileThread *uThread = [[UpdatePictureProfileThread alloc] init];
    [uThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            NSArray *pf = [profileRepo get];
            NSData *data =  [[pf objectAtIndex:[profileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
            [newProfiles addEntriesFromDictionary:profiles];
            [newProfiles removeObjectForKey:@"image_url"];
            [newProfiles setValue:jsonDict[@"url"] forKey:@"image_url"];
            
            Profiles *pfs = [[Profiles alloc] init];
            NSError * err;
            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfiles options:0 error:&err];
            pfs.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            pfs.update    = [timeStampObj stringValue];
            
            BOOL sv = [profileRepo update:pfs];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData:nil];
            });
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [uThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [uThread start:image];
}

-(void)updateBGPicture:(UIImage *)image{
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureBGThread *updateBGThread = [[UpdatePictureBGThread alloc] init];
    [updateBGThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            /*
            NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
            [profiles setValue:jsonDict[@"url"] forKey:@"bg_url"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            // เราต้อง addEntriesFromDictionary ก่อน ถึงจะสามารถลบได้ แ้วค่อย update ข้อมูล
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            //  ลบข้อมูล key profiles ออกไป
            [newDict removeObjectForKey:@"profiles"];
            
            [newDict setObject:profiles forKey:@"profiles"];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
            */
            
            NSArray *pf = [profileRepo get];
            NSData *data =  [[pf objectAtIndex:[profileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
            [newProfiles addEntriesFromDictionary:profiles];
            [newProfiles removeObjectForKey:@"bg_url"];
            [newProfiles setValue:jsonDict[@"url"] forKey:@"bg_url"];
            
            Profiles *pfs = [[Profiles alloc] init];
            NSError * err;
            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfiles options:0 error:&err];
            pfs.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            pfs.update    = [timeStampObj stringValue];
            
            BOOL sv = [profileRepo update:pfs];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData:nil];
            });
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [updateBGThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [updateBGThread start:image];
}

-(NSDateFormatter *)getDateFormatter{
    NSDateFormatter __autoreleasing *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    
    return dateFormat;
}

@end
