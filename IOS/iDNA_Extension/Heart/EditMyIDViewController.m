//
//  EditMyIDViewController.m
//  Heart
//
//  Created by Somkid on 11/6/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "EditMyIDViewController.h"
#import "SVProgressHUD.h"
#import "UpdateMyProfileThread.h"

#import "AppConstant.h"

#import "AppDelegate.h"

@interface EditMyIDViewController ()

@end

@implementation EditMyIDViewController {
    UIImage *imgProfile, *imgProfileBG;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UIImageView *heartImageView = (UIImageView *)[cell viewWithTag:101];
    // heartImageView.tag = indexPath.row;
    self.hjmImgVProfile.userInteractionEnabled = YES;
    [self.hjmImgVProfile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heartImageViewTapped:)]];
    
    
    //
    self.hjmImgVBG.userInteractionEnabled = YES;
    [self.hjmImgVBG addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hjmImgVBGTapped:)]];
    
    self.txtName.text = self.name;
    
    
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    
    // NSUserDefaults save NSMutableDictionary
    // http://stackoverflow.com/questions/471830/why-nsuserdefaults-failed-to-save-nsmutabledictionary-in-iphone-sdk
    
    // [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: jsonDict[@"profile"]] forKey:_PROFILE];
    
    // [preferences synchronize];
    
    
    /*
    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [preferences objectForKey:_PROFILE];
    NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.txtName.text = _dict[@"name"];
    self.txtPhone.text = _dict[@"phone_number"];
    self.txtLocation.text = _dict[@"location"];
    self.txtGooglePlus.text = _dict[@"google_plus"];
    self.txtFacebook.text = _dict[@"facebook"];
    */
    
    [self.hjmImgVProfile clear];
    
    /*
    if (![_dict[@"url_picture"] isEqualToString:@""]) {
        [self.hjmImgVProfile showLoadingWheel];
        [self.hjmImgVProfile  setUrl:[NSURL URLWithString:_dict[@"url_picture"]]];
        // [self.HJImageVProfile setImage:[UIImage imageWithData:fileData]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImgVProfile ];
    }
    
    [self.hjmImgVBG clear];
    
    if (![_dict[@"url_picture_bg"] isEqualToString:@""]) {
        [self.hjmImgVBG showLoadingWheel];
        [self.hjmImgVBG  setUrl:[NSURL URLWithString:_dict[@"url_picture_bg"]]];
        // [self.HJImageVProfile setImage:[UIImage imageWithData:fileData]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImgVBG ];
    }
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{


    
    
    
    NSLog(@"");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)heartImageViewTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Select Picture"
                          message:@""
                          delegate:self
                          cancelButtonTitle:@"Close"
                          otherButtonTitles:@"Take Photo", @"Select Photo", nil];
    
    alert.tag =1;
    [alert show];
}

-(void)hjmImgVBGTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Select Picture"
                          message:@""
                          delegate:self
                          cancelButtonTitle:@"Close"
                          otherButtonTitles:@"Take Photo", @"Select Photo", nil];
    alert.tag =2;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case 1:{
            switch (buttonIndex) {
                case 0:
                {
                    NSLog(@"");
                    break;
                }
                    
                case 1:
                {
                    // take photo
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.view.tag = 1;
                    picker.allowsEditing = YES;
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [self presentViewController:picker animated:YES completion:NULL];
                    
                    break;
                }
                    
                case 2:
                {
                    // select photo
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.view.tag = 1;
                    picker.allowsEditing = YES;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    [self presentViewController:picker animated:YES completion:NULL];
                    break;
                }
                default:
                    break;
            }
            break;
        }
            
        case 2:{
            
            switch (buttonIndex) {
                case 0:
                {
                    NSLog(@"");
                    break;
                }
                    
                case 1:
                {
                    // take photo
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.view.tag = 2;
                    picker.allowsEditing = YES;
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [self presentViewController:picker animated:YES completion:NULL];
                    
                    break;
                }
                    
                case 2:
                {
                    // select photo
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.view.tag = 2;
                    picker.allowsEditing = YES;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    [self presentViewController:picker animated:YES completion:NULL];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
            
        default:
            break;
    }
   
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    NSLog(@"%d", picker.view.tag);
    switch (picker.view.tag) {
        case 1:{
            
            imgProfile = info[UIImagePickerControllerEditedImage];
            // self.imvPicProfile.image = chosenImage;
            
            [self.hjmImgVProfile clear];
            [self.hjmImgVProfile  showLoadingWheel];
            // [self.HJImageVProfile  setUrl:[NSURL URLWithString:[[preferences objectForKey:_USER] objectForKey:@"url_image"]]];
            
            [self.hjmImgVProfile setImage:imgProfile];
            // [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.HJImageVProfile ];
            
            break;
        }
            
        case 2:{
            
            imgProfileBG = info[UIImagePickerControllerEditedImage];
            // self.imvPicProfile.image = chosenImage;
            
            [self.hjmImgVBG clear];
            [self.hjmImgVBG  showLoadingWheel];
            // [self.HJImageVProfile  setUrl:[NSURL URLWithString:[[preferences objectForKey:_USER] objectForKey:@"url_image"]]];
            
            [self.hjmImgVBG setImage:imgProfileBG];
            // [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.HJImageVProfile ];
            
            break;
            
            break;
        }
            
        default:
            break;
    }
    
   
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)onSave:(id)sender {
    
    /*
     @property (weak, nonatomic) IBOutlet UITextField *txtName;
     @property (weak, nonatomic) IBOutlet UITextField *txtPhone;
     @property (weak, nonatomic) IBOutlet UITextField *txtLocation;
     @property (weak, nonatomic) IBOutlet UITextField *txtGooglePlus;
     @property (weak, nonatomic) IBOutlet UITextField *txtFacebook;
     */
    NSString *strName = self.txtName.text;
    NSString *strPhone = self.txtPhone.text;
    NSString *strLocation = self.txtLocation.text;
    NSString *strGooglePlus = self.txtGooglePlus.text;
    NSString *strFacebook = self.txtFacebook.text;
    
    NSLog(@"%@", strPhone);
    
    
    if (imgProfile != nil && imgProfileBG != nil) {
        
        [SVProgressHUD showWithStatus:@"Update Profile"];
        UpdateMyProfileThread *updateMyProfileThread = [[UpdateMyProfileThread alloc] init];
        [updateMyProfileThread setCompletionHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            
            
            [SVProgressHUD showSuccessWithStatus:@"Update Profile success."];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [updateMyProfileThread setErrorHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:data];

        }];
        
        [updateMyProfileThread start:imgProfile :imgProfileBG :strName :strPhone :strLocation :strGooglePlus :strFacebook];
    }else if(imgProfile != nil){
        
        [SVProgressHUD showWithStatus:@"Update Profile"];
        UpdateMyProfileThread *updateMyProfileThread = [[UpdateMyProfileThread alloc] init];
        [updateMyProfileThread setCompletionHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            
            
            [SVProgressHUD showSuccessWithStatus:@"Update Profile success."];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [updateMyProfileThread setErrorHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:data];
            
        }];
        
        [updateMyProfileThread start:imgProfile :nil :strName :strPhone :strLocation :strGooglePlus :strFacebook];
    
    }else if(imgProfileBG != nil){
        [SVProgressHUD showWithStatus:@"Update Profile"];
        UpdateMyProfileThread *updateMyProfileThread = [[UpdateMyProfileThread alloc] init];
        [updateMyProfileThread setCompletionHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            
            
            [SVProgressHUD showSuccessWithStatus:@"Update Profile success."];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [updateMyProfileThread setErrorHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:data];
            
        }];
        
        [updateMyProfileThread start:nil :imgProfileBG :strName :strPhone :strLocation :strGooglePlus :strFacebook];
    
    }else{

        [SVProgressHUD showWithStatus:@"Update Profile"];
        UpdateMyProfileThread *updateMyProfileThread = [[UpdateMyProfileThread alloc] init];
        [updateMyProfileThread setCompletionHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            
            [SVProgressHUD showSuccessWithStatus:@"Update Profile success."];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [updateMyProfileThread setErrorHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            
            [SVProgressHUD showErrorWithStatus:data];
        }];
        
        [updateMyProfileThread start:nil :nil :strName :strPhone :strLocation :strGooglePlus :strFacebook];
    }
    
    /*
     1. imageProfile
     2. Heart URL
     3. Phone
     4. Location
     5. Google+
     6. Facebook
     */
}
@end
