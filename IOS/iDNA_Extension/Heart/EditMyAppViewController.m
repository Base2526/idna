//
//  EditMyAppViewController.m
//  Heart
//
//  Created by Somkid on 11/9/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

//#import "EditMyAppViewController.h"
//
//@interface EditMyAppViewController ()
//
//@end
//
//@implementation EditMyAppViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end

//
//  EditMyIDViewController.m
//  Heart
//
//  Created by Somkid on 11/6/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "EditMyAppViewController.h"
#import "SVProgressHUD.h"
#import "UpdateMyAppThread.h"

#import "AppConstant.h"

#import "AppDelegate.h"

@interface EditMyAppViewController ()

@end

@implementation EditMyAppViewController {
    UIImage *imgProfile;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UIImageView *heartImageView = (UIImageView *)[cell viewWithTag:101];
    // heartImageView.tag = indexPath.row;
    self.hjmImgVProfile.userInteractionEnabled = YES;
    [self.hjmImgVProfile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heartImageViewTapped:)]];
    
    self.txtName.text = self.name;
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    // NSUserDefaults save NSMutableDictionary
    // http://stackoverflow.com/questions/471830/why-nsuserdefaults-failed-to-save-nsmutabledictionary-in-iphone-sdk
    
    // [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: jsonDict[@"profile"]] forKey:_PROFILE];
    
    // [preferences synchronize];
    
    /*
    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [preferences objectForKey:_MYAPP];
    NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.txtName.text = _dict[@"name"];
    
    NSLog(@"%@", _dict[@"phone_number"]);

    if (!(_dict[@"phone_number"] == (id)[NSNull null])) {
        self.txtPhone.text = _dict[@"phone_number"];

    }
    
    if (!(_dict[@"location"] == (id)[NSNull null])) {
        self.txtLocation.text = _dict[@"location"];
    }
    
    if (!(_dict[@"google_plus"] == (id)[NSNull null])) {
        self.txtGooglePlus.text = _dict[@"google_plus"];
    }
    
    if (!(_dict[@"facebook"] == (id)[NSNull null])) {
        self.txtFacebook.text = _dict[@"facebook"];
    }
    
    
    [self.hjmImgVProfile clear];
    
    if (![_dict[@"url_picture"] isEqualToString:@""]) {
        [self.hjmImgVProfile showLoadingWheel];
        [self.hjmImgVProfile  setUrl:[NSURL URLWithString:_dict[@"url_picture"]]];
        // [self.HJImageVProfile setImage:[UIImage imageWithData:fileData]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImgVProfile ];
    }

    */
    NSLog(@"");
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
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    imgProfile = info[UIImagePickerControllerEditedImage];
    // self.imvPicProfile.image = chosenImage;
    
    [self.hjmImgVProfile clear];
    [self.hjmImgVProfile  showLoadingWheel];
    // [self.HJImageVProfile  setUrl:[NSURL URLWithString:[[preferences objectForKey:_USER] objectForKey:@"url_image"]]];
    
    [self.hjmImgVProfile setImage:imgProfile];
    // [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.HJImageVProfile ];
    
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
    
    
    if (imgProfile != nil) {
        
        [SVProgressHUD showWithStatus:@"Update Profile"];
        UpdateMyAppThread *updateMyProfileThread = [[UpdateMyAppThread alloc] init];
        [updateMyProfileThread setCompletionHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            
            
            [SVProgressHUD showSuccessWithStatus:@"Update Profile success."];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [updateMyProfileThread setErrorHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:data];
            
        }];
        
        [updateMyProfileThread start:imgProfile :strName :strPhone :strLocation :strGooglePlus :strFacebook];
    }else{
        
        [SVProgressHUD showWithStatus:@"Update Profile"];
        UpdateMyAppThread *updateMyProfileThread = [[UpdateMyAppThread alloc] init];
        [updateMyProfileThread setCompletionHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            
            [SVProgressHUD showSuccessWithStatus:@"Update Profile success."];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [updateMyProfileThread setErrorHandler:^(NSString * data) {
            
            [SVProgressHUD dismiss];
            
            [SVProgressHUD showErrorWithStatus:data];
        }];
        
        [updateMyProfileThread start:nil :strName :strPhone :strLocation :strGooglePlus :strFacebook];
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

