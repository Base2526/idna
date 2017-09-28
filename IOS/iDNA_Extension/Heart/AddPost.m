//
//  AddPost.m
//  Heart
//
//  Created by Somkid on 1/16/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "AddPost.h"
#import "AddPostThread.h"
#import "Configs.h"
#import "GKImagePicker.h"
#import "AppDelegate.h"

@interface AddPost ()<GKImagePickerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>{
    UIImage *img;
}
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;
@end

@implementation AddPost
@synthesize imagePicker;
@synthesize popoverController;
@synthesize is_add;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    AddPostThread *apThread = [[AddPostThread alloc] init];
    [apThread setCompletionHandler:^(NSString *data) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Add Post success."];
            
            /*
            NSDictionary *dict =  @{
                                    @"image" : img,
                                    @"tabN" : @"1",
                                    @"value" : @"100",
                                    };
             */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddPost" object:nil userInfo:jsonDict[@"values"]];
            [self.navigationController popViewControllerAnimated:YES];
             
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
        }
        
    }];
    
    [apThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    
    [apThread start:is_add:self.item_id :self.post_nid :img :self.txtTitle.text :self.textViewMessage.text];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // [inputTexts replaceObjectAtIndex:textField.tag withObject:textField.text];
    NSLog(@"%@", textField.text);
    return YES;
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string {
    NSLog(@"%@", [self.txtTitle.text stringByReplacingCharactersInRange:range withString:string]);
    
    NSUInteger newLength = [theTextField.text length] + [string length] - range.length;
    
    if (newLength > 0 && img != nil) {
        self.btnSave.enabled = YES;
    }else{
        self.btnSave.enabled = NO;
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
