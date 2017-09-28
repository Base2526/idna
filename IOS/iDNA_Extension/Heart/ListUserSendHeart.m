//
//  ListUserSendHeart.m
//  Heart
//
//  Created by Somkid on 1/31/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ListUserSendHeart.h"

#import "SetClassFriendThread.h"
#import "SVProgressHUD.h"
#import "Configs.h"
#import "AppConstant.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"
#import "SHByClassThread.h"

@interface ListUserSendHeart ()
{
    NSMutableArray* all_data;
    NSMutableArray *fieldSelected;
}
@end

@implementation ListUserSendHeart
@synthesize _class;
@synthesize btnSend;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    fieldSelected = [[NSMutableArray alloc] init];
    
    all_data = [[[Configs sharedInstance] loadData:_USER_CONTACTS] objectForKey:_class];
    
    for (int i=0; i<[all_data count]; i++) {
        [fieldSelected addObject:[NSIndexPath indexPathForRow:i inSection:0]];
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

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return  [all_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //  cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    HJManagedImageV *hjmImg  = (UILabel *)[cell viewWithTag:10];
    UILabel *labelName       = (UILabel *)[cell viewWithTag:11];
    UITextView *tvDetail     = (UILabel *)[cell viewWithTag:12];
    
    [labelName setText:[[all_data objectAtIndex:indexPath.row] objectForKey:@"display_name"]];
    
    tvDetail.textContainer.lineFragmentPadding = 0; // pading 0
    tvDetail.userInteractionEnabled = NO;
    // [tvDetail addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    if ([[all_data objectAtIndex:indexPath.row] valueForKey:@"status_message"]) {
        [tvDetail setText:[[all_data objectAtIndex:indexPath.row] valueForKey:@"status_message"]];
    }else{
        [tvDetail setText:@""];
    }

    [hjmImg clear];
    NSMutableDictionary *picture = [[all_data objectAtIndex:indexPath.row] valueForKey:@"picture"];
    if ([picture count] > 0 ) {
        [hjmImg showLoadingWheel];
        
        NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]];
        
        [hjmImg setUrl:[NSURL URLWithString:url]];
        // [img setImage:[UIImage imageWithData:fileData]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:hjmImg ];
    }else{
        [hjmImg setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
    }
    
    if ([fieldSelected containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row); // you can see selected row number in your console;
    
    if ([fieldSelected containsObject:indexPath]){
        [fieldSelected removeObject:indexPath];
        
    }else{
        [fieldSelected addObject:indexPath];
    }
    
    if ([fieldSelected count] <= 0) {
        btnSend.enabled = NO;
    }else{
        btnSend.enabled = YES;
    }
    
    [self reloadData];
}

-(void)reloadData
{
    [self._table reloadData];
}

- (IBAction)onSend:(id)sender {
    
    NSMutableArray* value = [[NSMutableArray alloc] init];
    for (id object in fieldSelected) {
        NSIndexPath* indexPath = object;
        [value addObject:[[all_data objectAtIndex:indexPath.row] objectForKey:@"uid"]];
    }
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    SHByClassThread *shThread = [[SHByClassThread alloc] init];
    [shThread setCompletionHandler:^(NSString *data) {
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Send Heart Success."];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
        }
    }];
    
    [shThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
     [shThread start:value];
}
@end
