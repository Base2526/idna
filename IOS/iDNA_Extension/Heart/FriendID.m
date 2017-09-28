//
//  FriendID.m
//  Heart
//
//  Created by Somkid on 12/1/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "FriendID.h"
#import "SendHeartToFriend.h"
#import "AppDelegate.h"
#import "MyIDHeaderCell.h"
#import "HJManagedImageV.h"
#import "AppConstant.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "GKImagePicker.h"
#import "EditDisplayName.h"
#import "MyQRCode.h"
#import "UpdatePictureProfileThread.h"
#import "EditPhone.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "EditDisplayName.h"
#import "ViewImageView.h"
#import "ClassFriends.h"
#import "HideFriendThread.h"
#import "DeleteFriendThread.h"
#import "SetClassFriendThread.h"
#import "Utility.h"
#import "WYPopoverController.h"
#import "FriendID_Menu.h"
#import "FriendIDCell.h"

@interface FriendID ()<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, WYPopoverControllerDelegate, UIImagePickerControllerDelegate>{
    WYPopoverController *settingsPopoverController;
}

@end

@implementation FriendID
@synthesize data;
@synthesize uid;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendIDCell" bundle:nil] forCellReuseIdentifier:@"FriendIDCell"];
    
    /*
    self.ref = [[FIRDatabase database] reference];
    NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/friends/%@", [[Configs sharedInstance] getUIDU], [self.data valueForKey:@"uid"]];
    
    [[self.ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
    
        if ([snapshot.key isEqualToString:@"phone"]) {
            
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            
            [userDict addEntriesFromDictionary:self.data];
            
            [userDict removeObjectForKey:@"phone"];
            
            [userDict setObject:snapshot.value forKey:@"phone"];
            
            self.data = userDict;
            
            [self.tableView reloadData];
            
//            [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
//            
//            [preferences synchronize];
        }else if ([snapshot.key isEqualToString:@"picture"]) {
            
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict addEntriesFromDictionary:self.data];
            
            [dict removeObjectForKey:@"picture"];
            
            // [userDict setObject:snapshot.value forKey:@"field_profile_image"];
            
            NSMutableDictionary *new_field_profile_image = [NSMutableDictionary
                                                            dictionaryWithDictionary:@{
                                                                                       @"und" :@[snapshot.value]
                                                                                       }];
            
            [dict setObject:snapshot.value forKey:@"picture"];
            
            self.data = dict;
            
            [self.tableView reloadData];
         //
        }else if ([snapshot.key isEqualToString:@"friend_status"]) {
            
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            
            [userDict addEntriesFromDictionary:self.data];
            
            [userDict removeObjectForKey:@"friend_status"];
            
            [userDict setObject:snapshot.value forKey:@"friend_status"];
            
            self.data = userDict;
            
            [self.tableView reloadData];
            
        }
        else if ([snapshot.key isEqualToString:@"display_name"]) {
            
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            
            [userDict addEntriesFromDictionary:self.data];
            
            [userDict removeObjectForKey:@"display_name"];
            
            [userDict setObject:snapshot.value forKey:@"display_name"];
            
            self.data = userDict;
            
            [self.tableView reloadData];
            
        }
    }];
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"reloadData"
                                               object:nil];
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadData" object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    // return [all_data count];
    
    return 5;
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
    
    
    // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    // NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
    //
    // self.title = [NSString stringWithFormat:@"%@", [_dict objectForKey:@"user"][@"name"]];//;
    
//    if (img != nil) {
//        hjmPicture.image = img;
//    }else{
    
    NSMutableDictionary *picture = [data valueForKey:@"picture"];
    if ([picture count] > 0 ) {
        [hjmPicture clear];
        [hjmPicture showLoadingWheel];
        
        NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [hjmPicture setUrl:[NSURL URLWithString:url]];
        // [img setImage:[UIImage imageWithData:fileData]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:hjmPicture ];
    }else{
        [hjmPicture setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
    }
    
    /*
    // ทำกรอบรูปหัวใจ
    [hjmPicture setBackgroundColor:[UIColor colorWithRed:1.00 green:0.61 blue:0.87 alpha:1.0]];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    UIBezierPath * bezirePath = [Utility heartShape:CGRectMake(0, 0, hjmPicture.bounds.size.width, hjmPicture.bounds.size.height)];
    maskLayer.path =bezirePath.CGPath;
    hjmPicture.layer.mask = maskLayer;
    // ทำกรอบรูปหัวใจ
    */
    
    hjmPicture.userInteractionEnabled = YES;
    [hjmPicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)]];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    

    // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    // NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
    
    
    switch (indexPath.row) {
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            UILabel *labelName = (UILabel *)[cell viewWithTag:100];
            UILabel *labelText = (UILabel *)[cell viewWithTag:101];
            
            labelName.text = @"Display Name";
            labelText.text = [self.data valueForKey:@"display_name"];
            
            return  cell;
            break;
        }
        
        case 1:{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
            // cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            UILabel *labelName = (UILabel *)[cell viewWithTag:100];
            UILabel *labelText = (UILabel *)[cell viewWithTag:101];
            
            labelName.text = @"Email";
            // labelText.text = self.mail_friend;
            
            
            
            NSMutableArray *mail = [[self.data objectForKey:@"mail"] componentsSeparatedByString:@"@"];
            
            if ([mail[1] isEqualToString:@"annmousu"]) {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                labelText.text =@"Not Register";
                
                // cell.tag = indexPath.row;
                // cell.userInteractionEnabled = YES;
                // [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRegisterTapped:)]];
                
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                labelText.text =[self.data objectForKey:@"mail"] ;
                
                [cell setUserInteractionEnabled:YES];
                [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSendEmailTapped:)]];
            }
        
            
            break;
        }
            
        case 2:{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
            UILabel *labelName = (UILabel *)[cell viewWithTag:100];
            UILabel *labelText = (UILabel *)[cell viewWithTag:101];
            
            labelName.text = [NSString stringWithFormat:@"Phone"];
            
//            NSArray*profile2_phone =  [_dict objectForKey:@"profile2"][@"field_profile_phone"];
//            
//            if ([profile2_phone count] > 0) {
//                labelText.text = [_dict objectForKey:@"profile2"][@"field_profile_phone"][@"und"][0][@"value"];
//            }else{
//                labelText.text = @"";
//            }
            
            if ([self.data objectForKey:@"phone"]) {
                // contains object
                labelText.text = [self.data valueForKey:@"phone"];
            }else{
                labelText.text = @"";
            }
            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
//            labelText.text = @"";

            // labelText.text = [NSString stringWithFormat:@"0988428420"];
            
            // [cell setUserInteractionEnabled:YES];
            // [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellHeartTapped:)]];
            
            break;
        }

        case 3:{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            UILabel *labelName = (UILabel *)[cell viewWithTag:103];
            
            labelName.text = [NSString stringWithFormat:@"Send heart to %@", [self.data valueForKey:@"display_name"]];
            
            [cell setUserInteractionEnabled:YES];
            [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellHeartTapped:)]];
             
            
            break;
        }
            
        case 4:{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            UILabel *labelName = (UILabel *)[cell viewWithTag:100];
            UILabel *labelText = (UILabel *)[cell viewWithTag:101];
            
            labelName.text = [NSString stringWithFormat:@"Class"];
            labelText.text = @"Friends";
            
            switch ([[self.data valueForKey:@"friend_status"] integerValue]) {
                
                case 0:
                    labelText.text = @"Family";
                    break;
                case 1:
                    labelText.text = @"Favorite";
                    break;
                case 2:
                    labelText.text = @"Friends";
                    break;
                    
                default:
                    break;
            }
            
            [cell setUserInteractionEnabled:YES];
            [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellGroupsTapped:)]];
        
            break;
        }
            
        
            
        default:
            break;
    }
    
    return cell;
     */
    
    switch (indexPath.row) {
        case 0:{
            FriendIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendIDCell" forIndexPath:indexPath];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            cell.label.text = @"Display Name";
            cell.labelName.text = [data objectForKey:@"default_name"];
        }
            break;
        case 1:{
            FriendIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendIDCell" forIndexPath:indexPath];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            cell.label.text = @"Display Name 1";
            cell.labelName.text = [data objectForKey:@"default_name"];
        }
            break;
        case 2:{
            FriendIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendIDCell" forIndexPath:indexPath];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            cell.label.text = @"Display Name 2";
            cell.labelName.text = [data objectForKey:@"default_name"];
        }
            break;
        case 3:
        {
            FriendIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendIDCell" forIndexPath:indexPath];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            cell.label.text = @"Display Name 3";
            cell.labelName.text = [data objectForKey:@"default_name"];
        }
            break;
        case 4:
        {
            FriendIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendIDCell" forIndexPath:indexPath];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            cell.label.text = @"Display Name 4";
            cell.labelName.text = [data objectForKey:@"default_name"];
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return  [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
    
    switch (indexPath.row) {
        case 0:{
            
            
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            EditDisplayName *v = [storybrd instantiateViewControllerWithIdentifier:@"EditDisplayName"];
            
            v.uid_friend = [self.data objectForKey:@"uid"];
            v.name = [self.data objectForKey:@"display_name"];
            v.isfriend = @"1";
            [self.navigationController pushViewController:v animated:YES];
            
            
            // http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller
            // get register to fetch notification
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(reloadData:)
                                                         name:@"reloadData" object:nil];
            

            break;
        }
        case 2:{
            
            if ([[self.data valueForKey:@"phone"] isEqualToString:@""] || ![self.data objectForKey:@"phone"]) {
                
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"No Phone number."];
            }else{
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone"
                                                            message:[self.data valueForKey:@"phone"]
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
                
                alert.tag = 10;
                [alert show];
            }

            break;
        }
            
        default:
            break;
    }
    */
    
    [self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    // NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
    
    switch (alertView.tag) {
            
        case 10:{
            // the user clicked OK
            if (buttonIndex == 0) {
                // cancel
            } else if(buttonIndex == 1){
                // ok
                
                /*
                NSString *phone = [NSString stringWithFormat:@"tel:%@",[self.data valueForKey:@"phone"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: phone]];
                 */
            }
            break;
        }
            
            // Delete Friend
        case -999:{
            
            if (buttonIndex == 0){
            }
            else if(buttonIndex == 1){
                
                __block NSString* uid_friend = [data valueForKey:@"uid"];
                
                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
                DeleteFriendThread *dfThread = [[DeleteFriendThread alloc] init];
                [dfThread setCompletionHandler:^(NSString *data) {
                    
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                    
                    if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
                    }
                }];
                
                [dfThread setErrorHandler:^(NSString *error) {
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                }];
                [dfThread start:uid_friend];
            }
            break;
        }
            
        default:
            break;
    }
}

-(void)showPicture:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"View Picture", nil];
            
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 101) {
        NSLog(@"The Normal action sheet.");
        
        switch (buttonIndex) {
                // View Picture
            case 0:{
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ViewImageView *v = [storybrd instantiateViewControllerWithIdentifier:@"ViewImageView"];
                
                NSMutableDictionary *picture = [data valueForKey:@"picture"];
                if ([picture count] > 0 ) {
                    v.uri = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
                
                UINavigationController* navV = [[UINavigationController alloc] initWithRootViewController:v];
                [self presentViewController:navV animated:YES completion:nil];
                
                break;
            }
            default:
                break;
        }
    }
    else if(actionSheet.tag == 102){
        NSLog(@"%d", buttonIndex);
        switch (buttonIndex) {
            case 0:
            {
                // Confire Delete Friend
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm delete friend " message:@"Delete friend." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
                
                    alertView.tag = -999;
                [alertView show];

            }
                break;
                
            case 1:
            {
                // Confire Report Friend
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm Report this friend " message:@"Report this friend." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
                
                    // alertView.tag = -999;
                [alertView show];
            }
                break;
                
            default:
                break;
        }
    }
    
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}

-(void)vTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    /*
    if (![self.profile_picture isEqualToString:@""]) {
        
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ViewImageView *v = [storybrd instantiateViewControllerWithIdentifier:@"ViewImageView"];
        
        if (![self.profile_picture isEqualToString:@""]) {
            v.uri = self.profile_picture;
        }
        
        UINavigationController* navV = [[UINavigationController alloc] initWithRootViewController:v];
        [self presentViewController:navV animated:YES completion:nil];
    }
    */
}

-(void)reportThisFriendTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm Report this friend " message:@"Report this friend." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    
        // alertView.tag = -999;
    [alertView show];
    
}

-(void)deleteFriendTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm delete friend " message:@"Delete friend." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    
        alertView.tag = -999;
    [alertView show];

}

-(void)cellGroupsTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    ClassFriends *classFriends = [self.storyboard instantiateViewControllerWithIdentifier:@"ClassFriends"];
    
    //    sendHeartToFriend.user_heart = self.user_heart;
    //    sendHeartToFriend.name_friend = self.name_friend;
    //    sendHeartToFriend.uid_friend = self.uid_friend;
    //    sendHeartToFriend.friend_status = self.friend_status;
    //    sendHeartToFriend.heart_send = self.heart_send;
    //    sendHeartToFriend.heart_receive = self.heart_receive;
    
    /*
    classFriends.friend_uid = [self.data valueForKey:@"uid"];
    classFriends.friend_status = [self.data valueForKey:@"friend_status"];
     */
    
    [self.navigationController pushViewController:classFriends animated:YES];
    
}

-(void)cellHeartTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    //    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    UIViewController *mtc = [storybrd instantiateViewControllerWithIdentifier:@"MyID"];
    //    // [self presentViewController:mtc animated:YES completion:nil];
    //
    //    [self.navigationController pushViewController:mtc animated:YES];
    
    SendHeartToFriend *sendHeartToFriend = [self.storyboard instantiateViewControllerWithIdentifier:@"SendHeartToFriend"];
    
    /*
    sendHeartToFriend.user_heart = self.user_heart;
    sendHeartToFriend.name_friend = self.name_friend;
    sendHeartToFriend.uid_friend = self.uid_friend;
    sendHeartToFriend.friend_status = self.friend_status;
    sendHeartToFriend.heart_send = self.heart_send;
    sendHeartToFriend.heart_receive = self.heart_receive;
    */
    
    // sendHeartToFriend.data = self.data;
    [self.navigationController pushViewController:sendHeartToFriend animated:YES];
}

-(void)cellSendEmailTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"Heart"];
        // [mailCont setToRecipients:[NSArray arrayWithObject:self.mail_friend]];
        [mailCont setMessageBody:@"Heart get this app and add me https://beta.itunes.apple.com/v1/app/1184807478" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }else{
        
#define URLEMail @"mailto:info@klovers.org?subject=subject&body=body"
        
        NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
        [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            // NSLog(@"You sent the email.");
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"You sent the email."];
            break;
        case MFMailComposeResultSaved:
            // NSLog(@"You saved a draft of this email");
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"You saved a draft of this email"];
            break;
        case MFMailComposeResultCancelled:
            // NSLog(@"You cancelled sending this email.");
            
            // [SVProgressHUD showErrorWithStatus:@"You cancelled sending this email."];
            break;
        case MFMailComposeResultFailed:
            // NSLog(@"Mail failed:  An error occurred when trying to compose this email");
      
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Mail failed:  An error occurred when trying to compose this email."];
            break;
        default:
            // NSLog(@"An error occurred when trying to compose this email");
            
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"An error occurred when trying to compose this email."];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)showMenuSetting:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%i", btn.tag);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete friend"
                                                    otherButtonTitles:@"Report this friend", nil];
    
    actionSheet.tag = 102;
    [actionSheet showInView:self.view];
}

-(void)reloadData:(NSNotification *)notice{
    data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"contacts"] objectForKey:uid];
    
    // self.name_friend = [notice object];
    [self.tableView reloadData];
}

@end
