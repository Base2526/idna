//
//  AddNewMyApplication.m
//  Heart
//
//  Created by Somkid on 1/11/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "CreateMyApplication.h"
#import "HJManagedImageV.h"
#import "CategoryViewController.h"
#import "ViewImageView.h"
#import "GKImagePicker.h"
#import "FieldDisplayMyApplication.h"
#import "CreateMyApplicationThread.h"
#import "Configs.h"
#import "MyApp.h"
#import "Utility.h"

@interface CreateMyApplication (){
    NSArray *all_data;
    NSString *name, *indexCategory, *textCategory;
    
    UIImage *imgPhoto;
}

@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

@end

@implementation CreateMyApplication
@synthesize btnCreate;

@synthesize imagePicker;
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnCreate.enabled = NO;

    name = @"";
    textCategory = @"";
    all_data = @[@"display_name", @"category"];
    
    
//    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)hideKeyboard
//{
//
//    if([Utility isKeyboardOnScreen]){
//        [self.view endEditing:YES];
//    }
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // select_category
    if ([segue.identifier isEqualToString:@"select_category"]) {
        
        // http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller
        // get register to fetch notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(selectCategory:)
                                                     name:@"selectCategory" object:nil];

        CategoryViewController* v = segue.destinationViewController;
        v.category = indexCategory;
    }else if([segue.identifier isEqualToString:@"next_field_display"]){
        
        FieldDisplayMyApplication *v = segue.destinationViewController;
        v.photo     = imgPhoto;
        v.name      = name;
        v.category  = indexCategory;
    }
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [all_data count];//[[contact allKeys] count]-3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    //    headerView.tag                  = section;
    //    headerView.backgroundColor      = [UIColor brownColor];
    //    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-30, 30)];
    //
    //    headerString.text = @"test";
    //
    //    return headerView;
    
    NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"MyIDHeaderCell" owner:self options:nil];
    UIView *view = [viewArray objectAtIndex:0];
    
    
    HJManagedImageV *hjmPicture = [view viewWithTag:100];
    // lblTitle.text = @"Text you want to set";
    
    /*
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
    //
    // self.title = [NSString stringWithFormat:@"%@", [_dict objectForKey:@"user"][@"name"]];//;
    
    //    if (img != nil) {
    //        hjmPicture.image = img;
    //    }else{
    
    NSMutableDictionary *picture = [self.data valueForKey:@"picture"];
    if ([picture count] > 0 ) {
        [hjmPicture clear];
        [hjmPicture showLoadingWheel];
        
        NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]];
        
        [hjmPicture setUrl:[NSURL URLWithString:url]];
        // [img setImage:[UIImage imageWithData:fileData]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:hjmPicture ];
    }else{
        */
    
   /* }
    */
    
    if (imgPhoto != nil) {
        [hjmPicture setImage:imgPhoto];
    }else{
        [hjmPicture setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
    }
    
    hjmPicture.userInteractionEnabled = YES;
    [hjmPicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)]];
    
    /*
    // set ให้รูปเราเป้นวงกรม : http://www.appcoda.com/ios-programming-circular-image-calayer/
    // cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-green.png"]];
    hjmPicture.layer.cornerRadius = hjmPicture.frame.size.width / 2;
    hjmPicture.clipsToBounds = YES;
    
    // set border
    hjmPicture.layer.borderWidth = 3.0f;
    hjmPicture.layer.borderColor = [UIColor grayColor].CGColor;
    // set border
    */
    
    return view;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            static NSString *CellIdentifier = @"Cell-Displayname";
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            }
            UITextField *texField = (UITextField *)[cell viewWithTag:10];
            
            
            texField.delegate = self;
        }
            break;
            
        case 1:
        {

            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell-Category" forIndexPath:indexPath];
            
            UILabel *labelCategory = (UILabel *)[cell viewWithTag:10];
            
            if ([textCategory isEqualToString:@""]) {
                [labelCategory setText:@"Select Category"];
            }else{
                [labelCategory setText:textCategory];
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self reloadData];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // [inputTexts replaceObjectAtIndex:textField.tag withObject:textField.text];
    name = textField.text;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    /*
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 25;
    */
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength == 0) {
        self.btnCreate.enabled = NO;
    }else if(newLength > 0 && imgPhoto != nil && ![textCategory isEqualToString:@""])
    {
        self.btnCreate.enabled = YES;
    }
    return YES;
}

//-(void)dismissAddNewMyApplication:(NSNotification *)notification{
//
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//}

-(void)selectCategory:(NSNotification *)notification{
    
    NSDictionary* userInfo = notification.userInfo;
    indexCategory = (NSString*)userInfo[@"index"];
    textCategory = (NSString*)userInfo[@"value"];
    
    [self reloadData];
}

-(void)reloadData
{
    if (imgPhoto != nil && ![textCategory isEqualToString:@""] && ![name isEqualToString:@""]) {
        self.btnCreate.enabled = YES;
    }else{
        self.btnCreate.enabled = NO;
    }
    
    [self._table reloadData];
}

//- (void)showPicker:(UIButton *)btn{
-(void)selectPhoto:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                    otherButtonTitles: /*@"View Picture",*/ @"Edit Picture", nil];
            
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"The Normal action sheet.");
        
        switch (buttonIndex) {
                // View Picture
            case 2:{
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ViewImageView *v = [storybrd instantiateViewControllerWithIdentifier:@"ViewImageView"];
                
                //                if (![self.profile_picture isEqualToString:@""]) {
                //                    v.uri = self.profile_picture;
                //                }
                
                /*
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
                
                NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
                
                if ([profile2_img count] > 0) {
                    NSLog(@"%@", [_dict objectForKey:@"profile2"][@"field_profile_image"][@"und"][0][@"filename"]);
                    
                    NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [_dict objectForKey:@"profile2"][@"field_profile_image"][@"und"][0][@"filename"]];
                    
                    v.uri = url;
                }
                */
                
                // v.name = self.name_friend;
                // [self.navigationController pushViewController:v animated:YES];
                
                UINavigationController* navV = [[UINavigationController alloc] initWithRootViewController:v];
                
                [self presentViewController:navV animated:YES completion:nil];
                
                break;
            }
                
                // Edit Picture
            case 0:{
                
                self.imagePicker = [[GKImagePicker alloc] init];
                self.imagePicker.cropSize = CGSizeMake(280, 280);
                self.imagePicker.delegate = self;
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    
                    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                    [self.popoverController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    
                } else {
                    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
                }
                
                break;
            }
            default:
                break;
        }
    }
    
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}


# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    // self.imgView.image = image;
    
    // self.hjmPicture.image = image;

    imgPhoto = image;
    [self hideImagePicker];
    
    [self reloadData];
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
    
    imgPhoto = image;
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    [self reloadData];
}


- (IBAction)onClose:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCreate:(id)sender {
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    
    CreateMyApplicationThread *createAppThread = [[CreateMyApplicationThread alloc] init];
    [createAppThread setCompletionHandler:^(NSString * data) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        // homeViewController.urlString = @"https://www.facebook.com/samosornpatumwan";
        // homeViewController.title = @"Home";
        // UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        
        NSLog(@"+ %@ +", jsonDict);
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {

            NSDictionary *vl =  @{
             @"item_id" : jsonDict[@"item_id"],
             @"item" : jsonDict[@"item"]
            };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"createMyApp" object:nil userInfo:vl];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        }else{
            /*
             email นี้มีการ register แล้ว
             */
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
        }
    }];
    [createAppThread setErrorHandler:^(NSString * error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    
    // [anNThread start:strEmail];
    [createAppThread start:imgPhoto :name :indexCategory];
}
@end
