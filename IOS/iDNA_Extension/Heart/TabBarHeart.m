//
//  TabBarWallet.m
//  wireframe
//
//  Created by somkid simajarn on 5/5/2559 BE.
//  Copyright © 2559 somkid simajarn. All rights reserved.
//

#import "TabBarHeart.h"
#import "AppConstant.h"
#import "IDFriendViewController.h"
#import "UserFriendHeartThread.h"
#import "SendHeartToFriendThread.h"
#import "SVProgressHUD.h"
#import "SendHeartToFriend.h"
#import "PreLogin.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "Utility.h"

@interface TabBarHeart ()
@property (strong, nonatomic) LGPlusButtonsView *floatingActionButton; 
@end

@implementation TabBarHeart{
    // NSMutableArray *listItems;
    
    // NSMutableArray *all_data;
    
    NSMutableDictionary *dictUserHeart;
}
@synthesize ref;
@synthesize preferences;
@synthesize floatingActionButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // transparent top bar
    /*
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    */
    
    // set title top bar
    self.navigationController.navigationBar.topItem.title = @"HEART";
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self._table.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    
    ref = [[FIRDatabase database] reference];
    preferences = [NSUserDefaults standardUserDefaults];
    // all_data = [[NSMutableArray alloc] init];
    
    dictUserHeart = [[Configs sharedInstance] loadData:_USER_HEART];
    
    if (dictUserHeart == nil) {
        dictUserHeart = [[NSMutableDictionary alloc] init];
    }
}

-(NSMutableArray *)replaceObjectAtIndex:(int)index inArray:(NSArray *)array withObject:(id)object {
    NSMutableArray *mutableArray = [array mutableCopy];
    mutableArray[index] = object;
    return [NSMutableArray arrayWithArray:mutableArray];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (![[Configs sharedInstance] isLogin])
    {
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        PreLogin *preLogin = [storybrd instantiateViewControllerWithIdentifier:@"PreLogin"];
        
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:preLogin];
        
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        
        [self reloadData];
        
        NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/friends/", [[Configs sharedInstance] getUIDU]];
        [[ref child:child] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"TypeChildAdded : %@", snapshot);
            
            if(![snapshot.key isEqualToString:@"0"]){
                
                Boolean flag = true;
                for (NSString* key in dictUserHeart) {
                    
                    NSMutableDictionary *_item = [dictUserHeart objectForKey:key];
                    
                    if ([[_item objectForKey:@"uid"] isEqualToString:snapshot.key]) {
                        
                        flag = false;
                        
                        if ([_item objectForKey:@"send_heart"] != nil && [_item objectForKey:@"receive_heart"] != nil) {
                            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                            [newDict addEntriesFromDictionary:dictUserHeart];
                            [newDict removeObjectForKey:snapshot.key];
                            
                            [newDict setObject:snapshot.value forKey:snapshot.key];
                            
                            dictUserHeart = newDict;
                            
                            [[Configs sharedInstance] saveData:_USER_HEART :newDict];
                            
                            [self reloadData];
                            
                        }else if([_item objectForKey:@"send_heart"] != nil){
                            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                            [newDict addEntriesFromDictionary:dictUserHeart];
                            [newDict removeObjectForKey:snapshot.key];
                            
                            [newDict setObject:snapshot.value forKey:snapshot.key];
                            
                            dictUserHeart = newDict;
                            
                            [[Configs sharedInstance] saveData:_USER_HEART :newDict];
                            
                            [self reloadData];
                            
                        }else if([_item objectForKey:@"receive_heart"] != nil){
                            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                            [newDict addEntriesFromDictionary:dictUserHeart];
                            [newDict removeObjectForKey:snapshot.key];
                            
                            [newDict setObject:snapshot.value forKey:snapshot.key];
                            
                            dictUserHeart = newDict;
                            
                            [[Configs sharedInstance] saveData:_USER_HEART :newDict];
                            
                            [self reloadData];
                        }
                        
                        break;
                    }
                }
                
                if (flag) {
                    
                    NSMutableDictionary *_item = snapshot.value;
                    
                    if ([_item objectForKey:@"send_heart"] != nil && [_item objectForKey:@"receive_heart"] != nil) {
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        [newDict addEntriesFromDictionary:dictUserHeart];
                        
                        [newDict setObject:snapshot.value forKey:snapshot.key];
                        
                        dictUserHeart = newDict;
                        // เพิ่มเพือน
                        [[Configs sharedInstance] saveData:_USER_HEART :dictUserHeart];
                        [self reloadData];
                        
                    }else if([_item objectForKey:@"send_heart"] != nil){
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        [newDict addEntriesFromDictionary:dictUserHeart];
                        
                        [newDict setObject:snapshot.value forKey:snapshot.key];
                        
                        dictUserHeart = newDict;
                        // เพิ่มเพือน
                        [[Configs sharedInstance] saveData:_USER_HEART :dictUserHeart];
                        [self reloadData];
                        
                    }else if([_item objectForKey:@"receive_heart"] != nil){
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        [newDict addEntriesFromDictionary:dictUserHeart];
                        
                        [newDict setObject:snapshot.value forKey:snapshot.key];
                        
                        dictUserHeart = newDict;
                        // เพิ่มเพือน
                        [[Configs sharedInstance] saveData:_USER_HEART :dictUserHeart];
                        [self reloadData];
                        
                    }
                }
            }
        }];
        
        [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@", snapshot);
            NSLog(@"");
            
            if(![snapshot.key isEqualToString:@"0"]){
                NSMutableDictionary *_item = [dictUserHeart objectForKey:snapshot.key];
                if ([[_item objectForKey:@"uid"] isEqualToString:snapshot.key]) {
                    
                    if ([_item objectForKey:@"send_heart"] != nil && [_item objectForKey:@"receive_heart"] != nil) {
                        [_item setObject:snapshot.value forKey:snapshot.key];
                        
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        [newDict addEntriesFromDictionary:dictUserHeart];
                        [newDict removeObjectForKey:snapshot.key];
                        
                        [newDict setObject:snapshot.value forKey:snapshot.key];
                        
                        dictUserHeart = newDict;
                        
                        [[Configs sharedInstance] saveData:_USER_HEART :newDict];
                        
                        [self reloadData];
                    }else if([_item objectForKey:@"send_heart"] != nil){
                        [_item setObject:snapshot.value forKey:snapshot.key];
                        
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        [newDict addEntriesFromDictionary:dictUserHeart];
                        [newDict removeObjectForKey:snapshot.key];
                        
                        [newDict setObject:snapshot.value forKey:snapshot.key];
                        
                        dictUserHeart = newDict;
                        
                        [[Configs sharedInstance] saveData:_USER_HEART :newDict];
                        
                        [self reloadData];
                        
                    }else if([_item objectForKey:@"receive_heart"] != nil){
                        
                        [_item setObject:snapshot.value forKey:snapshot.key];
                        
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        [newDict addEntriesFromDictionary:dictUserHeart];
                        [newDict removeObjectForKey:snapshot.key];
                        
                        [newDict setObject:snapshot.value forKey:snapshot.key];
                        
                        dictUserHeart = newDict;
                        
                        [[Configs sharedInstance] saveData:_USER_HEART :newDict];
                        
                        [self reloadData];
                    }
                }
            }
        }];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [ref removeAllObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if ([segue.identifier isEqualToString:@"user_profile"]) {
//        
//        NSIndexPath *indexPath = [self._table indexPathForSelectedRow];
//        
//        Profile* profile = segue.destinationViewController;
//        profile.isAdmin = YES;
//    }
    
    [self._table reloadData];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [dictUserHeart count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // HeartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeartCell" forIndexPath:indexPath];
    // NSString *CellIdentifier = [listItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HJManagedImageV *imgVprofile = (HJManagedImageV *)[cell viewWithTag:10];
    UILabel *labelDisplayName = (UILabel *)[cell viewWithTag:11];
    
    // UIImageView *imgVheart = (UIImageView *)[cell viewWithTag:12];
    UIButton *btnCount = (UIButton *)[cell viewWithTag:13];
    UILabel *labelDateTime = (UILabel *)[cell viewWithTag:14];
    UITextView *textMessage = (UITextView *)[cell viewWithTag:15];
    textMessage.textContainer.lineFragmentPadding = 0; 
    textMessage.userInteractionEnabled = NO;
    [textMessage addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    NSMutableDictionary *_item = [dictUserHeart objectForKey:[[dictUserHeart allKeys] objectAtIndex:indexPath.row]];//[all_data objectAtIndex:indexPath.row];
    
    [imgVprofile clear];
    NSMutableDictionary *picture = [_item valueForKey:@"picture"];
    if ([picture count] > 0 ) {
        [imgVprofile showLoadingWheel];
        
        NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]];
        
        [imgVprofile setUrl:[NSURL URLWithString:url]];
        // [img setImage:[UIImage imageWithData:fileData]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imgVprofile ];
    }else{
        [imgVprofile setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
    }
    
    // ทำกรอบรูปหัวใจ
    [imgVprofile setBackgroundColor:[UIColor colorWithRed:1.00 green:0.61 blue:0.87 alpha:1.0]];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    UIBezierPath * bezirePath = [Utility heartShape:CGRectMake(0, 0, imgVprofile.bounds.size.width, imgVprofile.bounds.size.height)];
    maskLayer.path =bezirePath.CGPath;
    imgVprofile.layer.mask = maskLayer;
    // ทำกรอบรูปหัวใจ
    
    [labelDisplayName setText:[_item valueForKey:@"display_name"]];
    [textMessage setText:[_item valueForKey:@"status_message"]];
    
    NSLog(@"%@", [NSString stringWithFormat: @"%@", [_item valueForKey:@"receive"]]);
    // [label_count setText:[NSString stringWithFormat: @"%@", [_item valueForKey:@"receive"]]];
   
    // imgVheart.tag = indexPath.row;
    // imgVheart.userInteractionEnabled = YES;
    // [imgVheart addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVheartTapped:)]];
    
    if ([_item valueForKey:@"datetime_send"] != (id)[NSNull null] ) {
        
        /*
        NSString * timeStampString =[_item valueForKey:@"datetime_send"];
        //[timeStampString stringByAppendingString:@"000"];   //convert to ms
        NSTimeInterval _interval=[timeStampString doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"HH:mm:ss"];
        // [_formatter stringFromDate:date];
    
        [labelDateTime setText:[_formatter stringFromDate:date]];
        */
        
        /*
        NSTimeInterval epoch = [@"1483936178" doubleValue];
        NSDate *_date = [NSDate dateWithTimeIntervalSince1970:epoch];
        
        NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
        NSDate *dateInLocalTimezone = [_date dateByAddingTimeInterval:timeZoneSeconds];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"HH:mm:ss"];
        // [_formatter stringFromDate:date];
        
        [labelDateTime setText:[_formatter stringFromDate:dateInLocalTimezone]];
        
        NSLog(@"%@", dateInLocalTimezone);
        */
    }
    
    int count = 0;
    if ([_item objectForKey:@"receive_heart"] != (id)[NSNull null]) {
        
        NSDictionary *receive_heart =  [_item objectForKey:@"receive_heart"];
        
        
        if (receive_heart == nil) {
            receive_heart =  [_item objectForKey:@"send_heart"];
            
            count = 0;
        }else{
            // [all_data addObject:object];
            for (NSString* key in receive_heart) {
                if ([[[receive_heart objectForKey:key] objectForKey:@"is_read"] isEqualToString:@"0"]) {
                    count++;
                }
            }
        }
        
        /*
        NSArray *myArray = [receive_heart keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
            
            NSTimeInterval epoch1 = [[obj1 objectForKey:@"time"] doubleValue];
            NSDate *_date1 = [NSDate dateWithTimeIntervalSince1970:epoch1];
            
            
            NSTimeInterval epoch2 = [[obj2 objectForKey:@"time"] doubleValue];
            NSDate *_date2 = [NSDate dateWithTimeIntervalSince1970:epoch2];
            
            if ([_date1 compare:_date2]) {
                return (NSComparisonResult)NSOrderedDescending;
            }else{
                return (NSComparisonResult)NSOrderedAscending;
            }
            
            return (NSComparisonResult)NSOrderedSame;
        }];
        */
        
        
//        NSArray *sortedDatesArray = [[receive_heart sortedArrayUsingComparator: ^(id a, id b) {
//            NSTimeInterval epoch1 = [[a objectForKey:@"time"] doubleValue];
//            NSDate *d1 = [NSDate dateWithTimeIntervalSince1970:epoch1];
//            
//            
//            NSTimeInterval epoch2 = [[b objectForKey:@"time"] doubleValue];
//            NSDate *d2 = [NSDate dateWithTimeIntervalSince1970:epoch2];
//            return [d1 compare: d2];
//        }];
        
        
        NSLog(@"");
        
       
        
        // เรียบงลำดับตามวันที่
        NSArray *sorted = [[receive_heart allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSTimeInterval epoch1 = [[[receive_heart objectForKey:obj1] objectForKey:@"time"] doubleValue];
            NSDate *_date1 = [NSDate dateWithTimeIntervalSince1970:epoch1];
            
            
            NSTimeInterval epoch2 = [[[receive_heart objectForKey:obj2] objectForKey:@"time"] doubleValue];
            NSDate *_date2 = [NSDate dateWithTimeIntervalSince1970:epoch2];
            
            return [_date1 compare:_date2];
        }];

        NSLog(@"%@", [sorted lastObject]);
        
        NSDictionary *lastElement = [receive_heart objectForKey:[sorted lastObject]];
        // NSLog(@"%@", lastElement);
        
        NSTimeInterval epoch = [[lastElement objectForKey:@"time"] doubleValue];
        NSDate *_date = [NSDate dateWithTimeIntervalSince1970:epoch];
        
        NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
        NSDate *dateInLocalTimezone = [_date dateByAddingTimeInterval:timeZoneSeconds];
        // NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        // [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        // [_formatter stringFromDate:date];
        
        // [labelDateTime setText:[_formatter stringFromDate:dateInLocalTimezone]];
        
        NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
        [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        // [df_utc setDateFormat:@"yyyy.MM.dd G 'at' HH:mm:ss zzz"];
        [df_utc setDateFormat:@"yyyy.MM.dd HH:mm:ss"];

        
        [labelDateTime setText:[df_utc stringFromDate:dateInLocalTimezone]];
    }
    
    if (count > 0) {
        btnCount.hidden = NO;
        // [self applyBadge:label_count withText:[NSString stringWithFormat:@"%@", @(count)] withRadius:4.0 withBorder:2.0];
        
        [btnCount setTitle:[NSString stringWithFormat:@"%@", @(count)] forState:UIControlStateNormal];
        
        btnCount.layer.cornerRadius = 5;
        btnCount.layer.borderWidth = 1;
        btnCount.layer.borderColor = [UIColor blueColor].CGColor;
    }else{
        btnCount.hidden = YES;
    }
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *hideAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Hide" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        // [self.tableView setEditing:NO];
        
        // [SVProgressHUD showSuccessWithStatus:@"Click Hide"];
        NSLog(@"");
    }];
    // blockAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *archiveAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Archive"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            // [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // [SVProgressHUD showSuccessWithStatus:@"Click Delete"];
        NSLog(@"");
    }];
    
    // return @[hideAction, archiveAction];
    
    return @[];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SendHeartToFriend *sendHeartToFriend = [self.storyboard instantiateViewControllerWithIdentifier:@"SendHeartToFriend"];
    sendHeartToFriend.data = [dictUserHeart objectForKey:[[dictUserHeart allKeys] objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:sendHeartToFriend animated:YES];
    
    [self reloadData];
}

// http://gootara.org/library/2014/07/uitableview-xcode.html
- (void)applyBadge:(UILabel *)badge withText:(NSString *)text withRadius:(CGFloat)radius withBorder:(CGFloat)borderWidth
{
    /**
     * バッジっぽい UILabel を適当に設定。
     * iOS の設定アプリから「文字サイズを変更」できる Dynamic Type 機能対応版。
     *
     * ハイライト時の色を指定したい場合も、通常の didHighlightRowAtIndexPath と didUnhighlightRowAtIndexPath で対応可能です。
     * didUnhighlightRowAtIndexPath の indexPath がおかしい場合は didHighlightRowAtIndexPath で
     * 前回のハイライト位置を覚えておいたりするといいと思います。別の問題なので、ここでは省略します。
     **/
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    CGFloat adjust = [font lineHeight] / [[UIFont systemFontOfSize:[UIFont smallSystemFontSize]] lineHeight];
    UIColor *foregroundColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.5 alpha:1.0];
    if (radius > 0.0) {
        // 角丸の設定
        [[badge layer] setCornerRadius:roundf(radius * adjust)];
        [[badge layer] setMasksToBounds:YES];
    }
    if (borderWidth > 0.0) {
        // ボーダーの設定
        [[badge layer] setBorderWidth:roundf(borderWidth * adjust)];
        [[badge layer] setBorderColor:[foregroundColor CGColor]];
        [badge setBackgroundColor:[UIColor whiteColor]];
        [badge setTextColor:foregroundColor];
    } else {
        [badge setBackgroundColor:radius == 0.0 ? [UIColor whiteColor] : foregroundColor];
        [badge setTextColor:radius == 0.0 ? foregroundColor : [UIColor whiteColor]];
    }
    // 並びとかも、適当に変えられるようにすればいいと思います。
    [badge setFont:font];
    [badge setTextAlignment:NSTextAlignmentCenter];
    [badge setText:text];
    // 幅を自動で伸縮する小細工。sizeWithFont が iOS 7.0 から非推奨になったみたいなので、boundingRectWithSize を使う。
    /*
    CGRect rect = [text boundingRectWithSize:CGSizeMake([[self._table] bounds].size.width * 0.5, [[badge font] lineHeight] * 2.0)
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
     */
    

    CGSize maximumLabelSize = CGSizeMake(310, CGFLOAT_MAX);
    CGRect rect = [text boundingRectWithSize:maximumLabelSize
                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName: font}
                                             context:nil];
    
    // Padding とかも、適当に変えられるようにすれば（略）
    CGFloat minWidth = roundf(32.0 * adjust);
    [badge setFrame:CGRectMake(0, 0, ceilf((rect.size.width < minWidth ? minWidth : rect.size.width) + (minWidth * 0.5)), ceilf(rect.size.height) + (minWidth * 0.25))];
}

- (void) reloadData
{
    /*
    if ([self isEmptyUserFriends]) {
        [self._table setHidden:YES];
        [self.labelIsEmpty setHidden:NO];
    }else{
        [self._table setHidden:NO];
        [self.labelIsEmpty setHidden:YES];
    }
    */
    
    [self._table reloadData];
}

-(void)imgVheartTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    IDFriendViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"IDFriendViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
    /*
    
    [SVProgressHUD showWithStatus:@"Send Heart"];
    SendHeartToFriendThread *sendHeartToFriendThread = [[SendHeartToFriendThread alloc] init];
    [sendHeartToFriendThread setCompletionHandler:^(NSString *data) {
        
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        NSLog(@"%@", jsonDict);
        //
        //        all_data = jsonDict[@"data"];
        //
        //        // NSLog(@"%@", all_data);
        //
        //        [self._table reloadData];
        
        [SVProgressHUD dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [SVProgressHUD showSuccessWithStatus:@"Send Heart success."];
        }else{
            [SVProgressHUD showErrorWithStatus:jsonDict[@"output"]];
        }
    }];
    
    [sendHeartToFriendThread setErrorHandler:^(NSString *data) {
        NSLog(@"%@", data);
        [SVProgressHUD showSuccessWithStatus:@"Send Heart error."];
        
    }];
    [sendHeartToFriendThread start:[[all_data objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag] objectForKey:@"uid"]];
     */

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv     contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    [tv setContentInset:UIEdgeInsetsMake(topCorrect,0,0,0)];
}

-(void)onAddFloatingButton{
    
    floatingActionButton = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:4
                                                         firstButtonIsPlusButton:YES
                                                                   showAfterInit:YES
                                                                   actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
                            {
                                NSLog(@"actionHandler | title: %@, description: %@, index: %lu", title, description, (long unsigned)index);
                                
                                if (index == 0){
                                }else{
                                    //                                    UINavigationController *navView = [self.storyboard instantiateViewControllerWithIdentifier:@"choice_invite_friend"];
                                    //                                    navView.title = @"somkid";
                                    //                                    [self presentViewController:navView animated:YES completion:nil];
                                    
                                    switch (index) {
                                        case 1:
                                            NSLog(@"");
                                            break;
                                            
                                        case 2:
                                            NSLog(@"");
                                            break;
                                            
                                            
                                            
                                        default:
                                            break;
                                    }
                                    
                                    
                                    
                                    [floatingActionButton hideAnimated:YES completionHandler:nil];
                                    [floatingActionButton hideButtonsAnimated:YES completionHandler:nil];
                                }
                            }];
    
    // floatingActionButton.observedScrollView = self.scrollView;
    floatingActionButton.coverColor = [UIColor colorWithWhite:1.f alpha:0.7];
    floatingActionButton.position = LGPlusButtonsViewPositionBottomRight;
    floatingActionButton.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    
    [floatingActionButton setButtonsTitles:@[@"+", @"", @"", @""] forState:UIControlStateNormal];
    [floatingActionButton setDescriptionsTexts:@[@"", @"Invite friend for contacts", @"Invit friend for facebook", @"Invite friend for twitter"]];
    [floatingActionButton setButtonsImages:@[[NSNull new], [UIImage imageNamed:@"Camera"], [UIImage imageNamed:@"Picture"], [UIImage imageNamed:@"Message"]]
                                  forState:UIControlStateNormal
                            forOrientation:LGPlusButtonsViewOrientationAll];
    
    [floatingActionButton setButtonsAdjustsImageWhenHighlighted:NO];
    [floatingActionButton setButtonsBackgroundColor:[UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f] forState:UIControlStateNormal];
    [floatingActionButton setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted];
    [floatingActionButton setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted|UIControlStateSelected];
    [floatingActionButton setButtonsSize:CGSizeMake(44.f, 44.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [floatingActionButton setButtonsLayerCornerRadius:44.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
    [floatingActionButton setButtonsTitleFont:[UIFont boldSystemFontOfSize:24.f] forOrientation:LGPlusButtonsViewOrientationAll];
    [floatingActionButton setButtonsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [floatingActionButton setButtonsLayerShadowOpacity:0.5];
    [floatingActionButton setButtonsLayerShadowRadius:3.f];
    [floatingActionButton setButtonsLayerShadowOffset:CGSizeMake(0.f, 2.f)];
    [floatingActionButton setButtonAtIndex:0 size:CGSizeMake(56.f, 56.f)
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [floatingActionButton setButtonAtIndex:0 layerCornerRadius:56.f/2.f
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [floatingActionButton setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:40.f]
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [floatingActionButton setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -3.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [floatingActionButton setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:1.f green:0.f blue:0.5 alpha:1.f] forState:UIControlStateNormal];
    [floatingActionButton setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:1.f green:0.2 blue:0.6 alpha:1.f] forState:UIControlStateHighlighted];
    [floatingActionButton setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.5 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [floatingActionButton setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.6 blue:0.2 alpha:1.f] forState:UIControlStateHighlighted];
    [floatingActionButton setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.7 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [floatingActionButton setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    
    [floatingActionButton setDescriptionsBackgroundColor:[UIColor whiteColor]];
    [floatingActionButton setDescriptionsTextColor:[UIColor blackColor]];
    [floatingActionButton setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [floatingActionButton setDescriptionsLayerShadowOpacity:0.25];
    [floatingActionButton setDescriptionsLayerShadowRadius:1.f];
    [floatingActionButton setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
    [floatingActionButton setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
    [floatingActionButton setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
    
    for (NSUInteger i=1; i<=3; i++)
        [floatingActionButton setButtonAtIndex:i offset:CGPointMake(-6.f, 0.f)
                                forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [floatingActionButton setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -2.f) forOrientation:LGPlusButtonsViewOrientationLandscape];
        [floatingActionButton setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:32.f] forOrientation:LGPlusButtonsViewOrientationLandscape];
    }
    
    [self.navigationController.view addSubview:floatingActionButton];
}


@end
