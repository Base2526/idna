//
//  CreateClass.m
//  iDNA
//
//  Created by Somkid on 2/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "CreateClass.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "CreateClassThread.h"

#import "ClasssRepo.h"
#import "Classs.h"

@interface CreateClass ()

@end

@implementation CreateClass
@synthesize imagePicker;
@synthesize popoverController;

@synthesize imageProfile, textfieldName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imageProfile.userInteractionEnabled = YES;
    [imageProfile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)]];
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

-(void)selectImage:(UITapGestureRecognizer *)gestureRecognizer{
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

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{

    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        // [self.popoverController dismissPopoverAnimated:YES];
        
        [self.popoverController dismissPopoverAnimated:NO];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
    
    [imageProfile setImage:image];
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onCreate:(id)sender {
    
    UIImage* image = imageProfile.image;
    NSString* name = [textfieldName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (image == nil || [name isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Picture or Name Empty."];
        return;
    }
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    CreateClassThread *createClassThread = [[CreateClassThread alloc] init];
    [createClassThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            /*
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
            */
            
            // NSMutableDictionary *data = [[Configs sharedInstance] loadData:_DATA];
            
            NSString*item_id = jsonDict[@"item_id"];
            
            ClasssRepo *classsRepo = [[ClasssRepo alloc] init];
            if ([classsRepo get:item_id] == nil){
             
                 Classs *class = [[Classs alloc] init];
                 class.item_id = item_id;
                 
                 NSError * err;
                 NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:jsonDict[@"value"] options:0 error:&err];
                 class.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                 
                 NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                 NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
                 class.create    = [timeStampObj stringValue];
                 class.update    = [timeStampObj stringValue];
                 
                 BOOL sv = [classsRepo insert:class];
                
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageClass_reloadData" object:self userInfo:@{}];
            }
            NSMutableArray * l = [classsRepo getClasssAll];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            NSLog(@"");
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [createClassThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    // [createClassThread start:image:name];
    
    [createClassThread start:image :name];
}
@end
