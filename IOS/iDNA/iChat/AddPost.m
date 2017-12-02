//
//  AddPost.m
//  Heart
//
//  Created by Somkid on 1/16/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "AddPost.h"
#import "AddPostThread.h"
#import "EditPostThread.h"
#import "Configs.h"
#import "GKImagePicker.h"
#import "AppDelegate.h"

#import "MyApplicationsRepo.h"
#import "MyApplications.h"

@interface AddPost ()<GKImagePickerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>{
    UIImage *img;
}
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;
@end

@implementation AddPost
@synthesize imagePicker;
@synthesize popoverController;
@synthesize app_id, category_id, is_edit, post_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    if ([is_add isEqualToString:@"1"]) {
        self.title = @"Add Post";
        self.btnSave.enabled = NO;
        [self.textViewMessage setPlaceholder:@"Message"];
        
    }else if ([is_add isEqualToString:@"0"]){
        
        self.title = @"Edit Post";
        self.btnSave.enabled = YES;
        
        NSMutableDictionary *picture = [self.edit_data valueForKey:@"picture"];
        if ([picture count] > 0 ) {
            [self.hjmImage clear];
            [self.hjmImage showLoadingWheel];
            
            NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]];
            
            [self.hjmImage setUrl:[NSURL URLWithString:url]];
            // [img setImage:[UIImage imageWithData:fileData]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImage ];
            
            img = self.hjmImage.image;
        }else{
        }
        
        self.edit_item_id = [self.edit_data objectForKey:@"item_id"];
        
        self.txtTitle.text = [self.edit_data objectForKey:@"title"];
        [self.textViewMessage setText:[self.edit_data objectForKey:@"message"]]; // [anObject objectForKey:@"message"];
    }
    */
    
    if ([is_edit isEqualToString:@"0"]) {
        self.title = @"Add Post";
        
        self.btnSave.enabled = NO;
    }else{
        self.title = @"Edit Post";
        
        self.btnSave.enabled = YES;
        
        MyApplicationsRepo *myAppRepo = [[MyApplicationsRepo alloc] init];
        
        NSMutableArray* _t_myApp = [myAppRepo get:app_id];
        
        NSData *data =  [[_t_myApp objectAtIndex:[myAppRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSMutableDictionary *posts = [f objectForKey:@"posts"];
    
        NSDictionary *post = [posts objectForKey:post_id];

        if ([post objectForKey:@"image_url"]) {
            [self.hjmImage clear];
            [self.hjmImage showLoadingWheel]; // API_URL
            [self.hjmImage setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [post objectForKey:@"image_url"]]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImage ];
        }else{
            [self.hjmImage clear];
        }
        
        self.txtTitle.text = [post objectForKey:@"title"];
        self.textViewMessage.text = [post objectForKey:@"message"];
    }
    
    self.txtTitle.delegate = self;
    [self.hjmImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker:)]];
}

//- (void)showPicker:(UIButton *)btn{
-(void)showPicker:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
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
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
    
    if ([is_edit isEqualToString:@"0"]) {
    
        AddPostThread *apThread = [[AddPostThread alloc] init];
        [apThread setCompletionHandler:^(NSData *data) {
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            NSString *post_id = jsonDict[@"post_id"];
            NSDictionary *values = jsonDict[@"values"];
            
            MyApplicationsRepo *myAppRepo = [[MyApplicationsRepo alloc] init];
            
            NSMutableArray* _t_myApp = [myAppRepo get:app_id];
            
            NSData *data =  [[_t_myApp objectAtIndex:[myAppRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            if (data == nil) {
                // บางกรณี firebase จะ  tigger value  เร้วมากนทำให้ data == nil  เราต้องเปลียนการ write data เป็นบาง transiton  ติดไว้ก่อน
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
                return;
            }
            NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([f objectForKey:@"posts"]) {
                NSMutableDictionary *posts = [[f objectForKey:@"posts"] mutableCopy];
                if (![posts objectForKey:post_id]) {
                    [posts setObject:values forKey:post_id];
                    
                    NSMutableDictionary *newF = [[NSMutableDictionary alloc] init];
                    [newF addEntriesFromDictionary:f];
                    [newF removeObjectForKey:@"posts"];
                    [newF setObject:posts forKey:@"posts"];
                    
                    f = newF;
                }
            }else{
                NSMutableDictionary *posts = [[NSMutableDictionary alloc] init];
                [posts setObject:values forKey:post_id];
                
                NSMutableDictionary *newF = [[NSMutableDictionary alloc] init];
                [newF addEntriesFromDictionary:f];
                [newF setObject:posts forKey:@"posts"];
                
                f = newF;
            }
            
            MyApplications *myApp = [[MyApplications alloc] init];
            myApp.app_id = app_id;

            NSError * err;
            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:f options:0 error:&err];
            myApp.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            BOOL sv = [myAppRepo update:myApp];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
            }
        
        }];
    
        [apThread setErrorHandler:^(NSString *error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
    
        [apThread start:app_id :img :self.txtTitle.text :self.textViewMessage.text];
    
    }else{
        // Edit Post
        EditPostThread *editThread = [[EditPostThread alloc] init];
        [editThread setCompletionHandler:^(NSData *data) {
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                // NSString *post_id = jsonDict[@"post_id"];
                // NSDictionary *values = jsonDict[@"values"];
                
                MyApplicationsRepo *myAppRepo = [[MyApplicationsRepo alloc] init];
                
                NSMutableArray* _t_myApp = [myAppRepo get:app_id];
                
                NSData *data =  [[_t_myApp objectAtIndex:[myAppRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
                
                if (data == nil) {
                    // บางกรณี firebase จะ  tigger value  เร้วมากนทำให้ data == nil  เราต้องเปลียนการ write data เป็นบาง transiton  ติดไว้ก่อน
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                    return;
                }
                NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([f objectForKey:@"posts"]) {
                    NSMutableDictionary *posts = [[f objectForKey:@"posts"] mutableCopy];
                    if ([posts objectForKey:post_id]) {
                        
                        NSMutableDictionary *post = [[NSMutableDictionary alloc] init];;
            
                        NSMutableDictionary *newPost = [[NSMutableDictionary alloc] init];
                        [newPost addEntriesFromDictionary:[posts objectForKey:post_id]];
                        [newPost removeObjectForKey:@"title"];
                        [newPost removeObjectForKey:@"message"];
                        [newPost setObject:self.txtTitle.text forKey:@"title"];
                        [newPost setObject:self.textViewMessage.text forKey:@"message"];
                        
                        if ([jsonDict objectForKey:@"image_url"]) {
                            [newPost removeObjectForKey:@"image_url"];
                            [newPost setObject:jsonDict[@"image_url"] forKey:@"image_url"];
                        }
                        
                        post = newPost;
                        
                        NSMutableDictionary *newPosts = [[NSMutableDictionary alloc] init];
                        [newPosts addEntriesFromDictionary:posts];
                        [newPosts removeObjectForKey:post_id];
                        [newPosts setObject:post forKey:post_id];
                        
                        NSMutableDictionary *newF = [[NSMutableDictionary alloc] init];
                        [newF addEntriesFromDictionary:f];
                        [newF removeObjectForKey:@"posts"];
                        [newF setObject:newPosts forKey:@"posts"];
                        
                        f = newF;
                    }
                }
                
                MyApplications *myApp = [[MyApplications alloc] init];
                myApp.app_id = app_id;
                
                NSError * err;
                NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:f options:0 error:&err];
                myApp.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                BOOL sv = [myAppRepo update:myApp];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
                
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
            }
            
        }];
        
        [editThread setErrorHandler:^(NSString *error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        
        [editThread start:app_id: category_id :post_id :img :self.txtTitle.text :self.textViewMessage.text];
    }
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // [inputTexts replaceObjectAtIndex:textField.tag withObject:textField.text];
    NSLog(@"%@", textField.text);
    return YES;
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string {
    NSLog(@"%@", [self.txtTitle.text stringByReplacingCharactersInRange:range withString:string]);
    
    if ([is_edit isEqualToString:@"1"]) {
        
    }else{
        NSUInteger newLength = [theTextField.text length] + [string length] - range.length;
    
        if (newLength > 0 && img != nil) {
            self.btnSave.enabled = YES;
        }else{
            self.btnSave.enabled = NO;
        }
    }
    return YES;
}


# pragma mark -
# pragma mark GKImagePicker Delegate Methods
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    img = image;
    [self.hjmImage setImage:image];
    
    [self hideImagePicker];
    
    
    if (![self.txtTitle.text isEqualToString:@""]) {
        self.btnSave.enabled = YES;
    }
}

- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    // self.imgView.image = image;
    // self.hjmPicture.image = image;
    
    img = image;
    [self.hjmImage setImage:image];
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    // [self reloadData];
}
@end
