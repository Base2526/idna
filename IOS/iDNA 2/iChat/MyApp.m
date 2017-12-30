//
//  MyApp.m
//  Heart
//
//  Created by Somkid on 1/16/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "MyApp.h"
#import "MyAppHeaderCell.h"
#import "HJManagedImageV.h"
#import "MyAppProfile.h"
#import "Follower.h"
#import "TopAlignedLabel.h"
#import "Configs.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "AddPost.h"
#import "MyAppMyPostHeaderCell.h"
#import "MenuMyApp.h"
#import "WYPopoverController.h"
#import "MyAppCell.h"
#import "CustomAlertView.h"
#import "DeletePostThread.h"
#import "ViewPost.h"
#import "GetAppDetailThread.h"
#import "CustomUIActionSheet.h"
#import "ListPeopleLike.h"
#import "ViewComment.h"
#import "AddPostThread.h"

@interface MyApp () <WYPopoverControllerDelegate>{
    WYPopoverController *settingsPopoverController;
    NSMutableDictionary*data, *external;
    NSMutableArray *center;
    BOOL isOwner, isRefresh /* จะเอามาใช้ในกรณี กด follow, like เราจะไม่ get data จาก server ใหม่*/;
    UIActivityIndicatorView *activityIndicator;
    
    NSMutableArray *childObservers;
}

@end

@implementation MyApp
@synthesize owner_id, item_id, category;
@synthesize ref;

@synthesize is_following;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isRefresh  = TRUE;
    
    ref = [[FIRDatabase database] reference];
    
    // Observers
    childObservers = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
    [self._table registerNib:[UINib nibWithNibName:@"MyAppCell" bundle:nil] forCellReuseIdentifier:@"MyAppCell"];
    
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center=self.view.center;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    // [self reloadData:nil];
    
    CGFloat bottom =  self.tabBarController.tabBar.frame.size.height;
    NSLog(@"%f",bottom);
    [self._table setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -bottom, 0)];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"reloadData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadDataCenter:)
                                                 name:@"reloadDataCenter"
                                               object:nil];
    
    [self reloadData:nil];
    
    
    // กรณี คนที่กำลังดูไม่ใช่เจ้าของ application เราต้องเช็กว่าเจ้าของ application  มันการ update อะไรเกียวกับ application(กรณีมีการ update)
    if (![owner_id isEqualToString:[Configs sharedInstance].getUIDU]) {
        /*
         กรณีเจ้าของ application update ข้อมูลแบบ realtime
         */
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadDataCenter" object:nil];
    
    for (FIRDatabaseReference *ref in childObservers) {
        [ref removeAllObservers];
    }
}

- (void)viewDidLayoutSubviews {
    activityIndicator.center = self.view.center;
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
     
    // select_category
    if ([segue.identifier isEqualToString:@"AddPost"]) {
        // http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller
        // get register to fetch notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(AddPost:)
                                                  name:@"AddPost" object:nil];
     
        AddPost* v = segue.destinationViewController;
        v.is_add = @"1";
        v.item_id = item_id;
    }
}

#pragma mark -
#pragma mark Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            break;
        case 1:{
            if ([data objectForKey:@"posts"]) {
                // contains object
                if ([[data objectForKey:@"posts"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary* posts = [data objectForKey:@"posts"];
                    return [posts count];
                }
            }
            
            return 0;
            break;
        }
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 120;
        }
            break;
            
        case 1:{
            return 30;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"MyAppHeaderCell" owner:self options:nil];
            MyAppHeaderCell *view = [viewArray objectAtIndex:0];
            
            // HJManagedImageV *photo = view.hjmPhoto;
            // UIButton *btnFollower  = view.btnFollower;
            
//            hjmPicture.userInteractionEnabled = YES;
            
            if ([external objectForKey:@"follower"]) {
                
                NSMutableDictionary *cfollower = [[external objectForKey:@"follower"] objectForKey:item_id];
                int count = 0;
                for (NSMutableDictionary* key in cfollower) {
                    id value = [cfollower objectForKey:key];
                    
                    if ([[value objectForKey:@"status"] isEqualToString:@"1"]) {
                        count++;
                    }
                }
                
                [view.btnFollower setTitle:[NSString stringWithFormat:@"Follower(%d)", count] forState:UIControlStateNormal];
            }else{
                [view.btnFollower setTitle:[NSString stringWithFormat:@"Follower(0)"] forState:UIControlStateNormal];
            }
            
            [view.btnFollower addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFollower:)]];
            
        
            if (![[data objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
                view.labelName.text = [data objectForKey:@"name"];
            }
            
            /*
            view.labelFollow.layer.cornerRadius = 5;
            view.labelFollow.layer.borderWidth = 1;
            view.labelFollow.layer.borderColor = [UIColor greenColor].CGColor;
             */
            
            if (isOwner) {
                view.btnFollow.hidden = YES;
                view.btnFollower.hidden = NO;
            }else{
                view.btnFollow.hidden = NO;
                view.btnFollower.hidden = YES;
                
                if ([external objectForKey:@"following"]) {
                    NSMutableDictionary *following = [external objectForKey:@"following"];
                    
                    if ([following objectForKey:item_id]) {
                        NSDictionary *item = [following objectForKey:item_id];
                        
                        if ([item isKindOfClass:[NSDictionary class]]) {
                            if ([item objectForKey:@"status"]) {
                                if ([[item objectForKey:@"status"] isEqualToString:@"0"]) {
                                    [view.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
                                }else{
                                    [view.btnFollow setTitle:@"Following" forState:UIControlStateNormal];
                                }
                            }
                        }else{
                             [view.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
                        }
                    }else{
                        [view.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
                    }
                }else{
                    [view.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
                }

                // [view.btnFollow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFollow:)]]; //
            
                [view.btnFollow addTarget:self action:@selector(onFollow:) forControlEvents:UIControlEventTouchDown];
            }
            
            /*
            NSMutableDictionary *picture = [data valueForKey:@"image"];
            if ([picture count] > 0 ) {
                [view.hjmPhoto showLoadingWheel];
                
                NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]];
                
                [view.hjmPhoto setUrl:[NSURL URLWithString:url]];
                // [img setImage:[UIImage imageWithData:fileData]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:view.hjmPhoto ];
            }else{
                [view.hjmPhoto setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
            }
            */
            
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMyAppProfile:)]];
            [view.hjmPhoto clear];
            if ([data objectForKey:@"picture"]) {
                if (![[data objectForKey:@"picture"] isKindOfClass:[NSNull class]]) {
                    NSDictionary *picture       = [data objectForKey:@"picture"];
                    
                    if ([[data objectForKey:@"picture"] isKindOfClass:[NSDictionary class]]) {
                        NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        
                        [view.hjmPhoto showLoadingWheel];
                        [view.hjmPhoto setUrl:[NSURL URLWithString:url]];
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:view.hjmPhoto ];
                    }else{
                        [view.hjmPhoto setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
                    }
                }else{
                    [view.hjmPhoto setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
                }
            }else{
                [view.hjmPhoto setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
            }

            
            return view;
        }
            break;
            
        case 1:{
            NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"MyAppMyPostHeaderCell" owner:self options:nil];
            MyAppMyPostHeaderCell *view = [viewArray objectAtIndex:0];
            
            
            /*
            NSString *textMyPost = [NSString stringWithFormat:@"My Post"];
            if ([all_data objectForKey:@"post"]) {
                // contains object
                NSDictionary* post = [all_data objectForKey:@"post"];
                // return [post count];
                
                textMyPost = [NSString stringWithFormat:@"My Post (%d)", [post count]];
            }
            
            view.labelName.text = textMyPost;
             */
            
            return view;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAppCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // items_post
    NSArray *keys = [[data objectForKey:@"posts"] allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [[data objectForKey:@"posts"] objectForKey:aKey];
    
    NSMutableDictionary *picture = [anObject valueForKey:@"picture"];
    if ([picture count] > 0 ) {
        [cell.hjmImage clear];
        [cell.hjmImage showLoadingWheel];
        
        NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell.hjmImage setUrl:[NSURL URLWithString:url]];
        // [img setImage:[UIImage imageWithData:fileData]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
    }else{
    }

    cell.title.text = [anObject objectForKey:@"title"];
    cell.labelMessage.text = [anObject objectForKey:@"message"];
    
    cell.btnPopup.hidden = TRUE;
    cell.btnPopup.enabled = FALSE;
    if (isOwner) {
        cell.btnPopup.hidden = FALSE;
        cell.btnPopup.enabled = TRUE;
        
        cell.btnPopup.tag = indexPath.row;
        NSLog(@"indexPath : %d", indexPath.row);
        [cell.btnPopup addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchDown];
    }
    
    // Buttom Like
    cell.btnLike.tag = indexPath.row;
    [cell.btnLike addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchDown];
    
    // center
    /*
     NSString *ochild = [NSString stringWithFormat:@"heart-id/center/data/%@/%@/%@/like/", category, item_id, post_id];
     */
    int clike = 0;
    if([[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:aKey]){
        NSDictionary *plike = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:aKey];
        if ([plike objectForKey:@"like"]) {
            NSDictionary* like = [plike objectForKey:@"like"];
            
            NSLog(@"");
            for (NSString* key in like) {
                id value = [like objectForKey:key];
                // do stuff
                
                if ([[value objectForKey:@"isLike"] isEqualToString:@"1"]) {
                    clike++;
                }
            }
        }
    }
    
    if([[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:aKey]){
        // [cell.btnLike setTitle:[NSString stringWithFormat:@"Like (%d)", clike] forState:UIControlStateNormal];
        
        NSDictionary *plike = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:aKey];
        if ([plike objectForKey:@"like"]) {
            NSDictionary* like = [[plike objectForKey:@"like"] objectForKey:[[Configs sharedInstance] getUIDU]];
            
            if ([[like objectForKey:@"isLike"] isEqualToString:@"1"]) {
                [cell.btnLike setTitle:[NSString stringWithFormat:@"Unlike (%d)", clike] forState:UIControlStateNormal];
            }else{
                [cell.btnLike setTitle:[NSString stringWithFormat:@"Like (%d)", clike] forState:UIControlStateNormal];
            }
        }
    }else{
        [cell.btnLike setTitle:[NSString stringWithFormat:@"Like (%d)", clike] forState:UIControlStateNormal];
    }
    
    /*
    if ([external objectForKey:@"like"]) {
        NSMutableDictionary *like = [external objectForKey:@"like"];
        
        if ([like objectForKey:aKey]) {
            NSDictionary *key = [like objectForKey:aKey];
            if ([[key objectForKey:@"isLike"] isEqualToString:@"0"]) {
                // view.labelFollow.text = @"Follow";
                [cell.btnLike setTitle:[NSString stringWithFormat:@"Like (%d)", clike] forState:UIControlStateNormal];
            }else{
                // view.labelFollow.text = @"Following";
                [cell.btnLike setTitle:[NSString stringWithFormat:@"Unlike (%d)", clike] forState:UIControlStateNormal];
            }
        }else{
            [cell.btnLike setTitle:[NSString stringWithFormat:@"Like (%d)", clike] forState:UIControlStateNormal];
        }
    }else{
        [cell.btnLike setTitle:[NSString stringWithFormat:@"Like (%d)", clike] forState:UIControlStateNormal];
    }

     */
    /*
    if ([anObject objectForKey:@"like"]) {

        if ([[anObject objectForKey:@"like"] objectForKey:[[Configs sharedInstance] getUIDU]]) {
            
            NSString* is_like = [[[anObject objectForKey:@"like"] objectForKey:[[Configs sharedInstance] getUIDU]] objectForKey:@"is_like"];
            if ([is_like isEqualToString:@"0"]) {
                [cell.btnLike setTitle:@"Like" forState:UIControlStateNormal];
            }else{
                [cell.btnLike setTitle:@"Unlike" forState:UIControlStateNormal];
            }
        }else{
            [cell.btnLike setTitle:@"Like" forState:UIControlStateNormal];
        }
    }else{
        [cell.btnLike setTitle:@"Like" forState:UIControlStateNormal];
    }
    */
    
    // Buttom Comment
    cell.btnComment.tag = indexPath.row;
    [cell.btnComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchDown];
    
    if ([anObject objectForKey:@"comment"]) {
        NSDictionary *comment = [anObject objectForKey:@"comment"];
        [cell.btnComment setTitle:[NSString stringWithFormat:@"Comment(%lu)", [comment count]] forState:UIControlStateNormal];
    }else{
        [cell.btnComment setTitle:[NSString stringWithFormat:@"Comment(0)"] forState:UIControlStateNormal];
    }

    // Buttom Share
    cell.btnShare.tag = indexPath.row;
    [cell.btnShare addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section : %i" , indexPath.section);
    NSLog(@"row : %i" , indexPath.row);
    
    // คำนวณหา array อันสุดท้าย(คือปุ่ม status)
    //    if ([all_data count] == indexPath.row + 1) {
    //    }else{
    
    /*
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //if you want only one cell to be selected use a local NSIndexPath property instead of array. and use the code below
    //self.selectedIndexPath = indexPath;
    
    //the below code will allow multiple selection
    if ([fieldSelected containsObject:indexPath])
    {
        [fieldSelected removeObject:indexPath];
    }
    else
    {
        [fieldSelected addObject:indexPath];
    }
    //    }
    [self reloadData];
     */
    
    /*
    ViewPost *v = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewPost"];
    
    NSDictionary *post = [all_data objectForKey:@"post"];
    NSArray *keys = [post allKeys];
    id nid_item = [keys objectAtIndex:indexPath.row];
    
    v.nid  = item_id;
    v.nid_item = nid_item;
    v.data_item =[[all_data objectForKey:@"post"] objectForKey:nid_item];
    
    [self.navigationController pushViewController:v animated:YES];
    */
}

-(void)showMenu:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NSLog(@"%i", btn.tag);
    
    NSMutableDictionary *tposts = [data objectForKey:@"posts"];
    NSArray *keys = [tposts allKeys];
    
    // จะได้ id post
    NSString *post_id = [keys objectAtIndex:[btn tag]];
    
    
    CustomUIActionSheet *actionSheet = [[CustomUIActionSheet alloc] initWithTitle:@"Post"
                                                                         delegate:self
                                                                cancelButtonTitle:@"Cancel"
                                                           destructiveButtonTitle:@"Delete"
                                                                otherButtonTitles:@"Edit", nil];
    
    actionSheet.tag = 501;
    actionSheet.object = @{@"post_id":post_id};
    
    [actionSheet showInView:self.view];
}

-(void)onLike:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"onLike > %d", [btn tag]);
    
    NSMutableDictionary *tposts = [data objectForKey:@"posts"];
    NSArray *keys = [tposts allKeys];
    
    // จะได้ id post
    NSString *post_id = [keys objectAtIndex:[btn tag]];
    
    int clike = 0;
    if([[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id]){
        NSDictionary *plike = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id];
        if ([plike objectForKey:@"like"]) {
            NSDictionary* like = [plike objectForKey:@"like"];
            
            NSLog(@"");
            for (NSString* key in like) {
                id value = [like objectForKey:key];
                // do stuff
                
                if ([[value objectForKey:@"isLike"] isEqualToString:@"1"]) {
                    clike++;
                }
            }
        }
    }
    
    NSString *_TEXT_LIKE = @"";
    
    NSDictionary *plike = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id];
    if ([plike objectForKey:@"like"]) {
        NSDictionary* like = [[plike objectForKey:@"like"] objectForKey:[[Configs sharedInstance] getUIDU]];
        
        if ([[like objectForKey:@"isLike"] isEqualToString:@"1"]) {
            _TEXT_LIKE = [NSString stringWithFormat:@"Unlike (%d)", clike];
        }else{
            _TEXT_LIKE = [NSString stringWithFormat:@"Like (%d)", clike];
        }
    }else{
        _TEXT_LIKE = @"Like (0)";
    }
    
    if (clike > 0) {
        CustomUIActionSheet *actionSheet = [[CustomUIActionSheet alloc] initWithTitle:@"Like"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"Cancel"
                                                               destructiveButtonTitle:nil
                                                                    otherButtonTitles:_TEXT_LIKE, @"List people like", nil];
        
        actionSheet.tag = 500;
        actionSheet.object = @{@"sender":btn, @"post_id":post_id};
        
        [actionSheet showInView:self.view];
    }else{
        CustomUIActionSheet *actionSheet = [[CustomUIActionSheet alloc] initWithTitle:@"Like"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"Cancel"
                                                               destructiveButtonTitle:nil
                                                                    otherButtonTitles:_TEXT_LIKE, nil];
        
        actionSheet.tag = 500;
        actionSheet.object = @{@"sender":btn, @"post_id":post_id};
        
        [actionSheet showInView:self.view];
    }
}

-(void)actionSheet:(CustomUIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 500) {
        
        NSDictionary *item = actionSheet.object;
        UIButton *sender = [item objectForKey:@"sender"];
        // จะได้ id post
        NSString *post_id = [item objectForKey:@"post_id"];
        
        // [sender setTitle:[NSString stringWithFormat:@"Like (%d)", 100] forState:UIControlStateNormal];
        switch (buttonIndex) {
            case 0:{
                NSMutableDictionary *tposts = [data objectForKey:@"posts"];
                
                NSArray *keys = [tposts allKeys];
                
                // NSMutableDictionary*_item = [tposts objectForKey:[keys objectAtIndex:[btn tag]]];
                
                
                // จะเก็บว่าเราไป liking อะไรไว้บ้าง
                __block NSString *child = [NSString stringWithFormat:@"heart-id/external/%@/data/like/", [[Configs sharedInstance] getUIDU]];
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    
                    FIRDatabaseReference *childRef = [ref child:child];
                    [childObservers addObject:childRef];
                    
                    NSMutableDictionary *val = [[NSMutableDictionary alloc] init];
                    // [val setObject:owner_id forKey:@"owner_id"];
                    // [val setObject:post_id forKey:@"post_id"];
                    
                    BOOL flag = TRUE;
                    for(FIRDataSnapshot* snap in snapshot.children){
                        flag = FALSE;
                        
                        NSMutableDictionary *like = snapshot.value;
                        if ([like objectForKey:post_id]) {
                            NSDictionary* key = [like objectForKey:post_id];
                            
                            if ([[key objectForKey:@"isLike"] isEqualToString:@"0"]) {
                                
                                [val setObject:@"1" forKey:@"isLike"];
                                
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, post_id]: val};
                                [ref updateChildValues:childUpdates];
                                
                                [self ownerPost:post_id :val];
                            }else{
                                
                                [val setObject:@"0" forKey:@"isLike"];
                                
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, post_id]: val};
                                [ref updateChildValues:childUpdates];
                                
                                [self ownerPost:post_id :val];
                            }
                        }else{
                            
                            [val setObject:@"1" forKey:@"isLike"];
                            
                            NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, post_id]: val};
                            [ref updateChildValues:childUpdates];
                            
                            [self ownerPost:post_id :val];
                        }
                    }
                    
                    //  กรณียังไม่มี child like
                    if (flag) {
                        
                        [val setObject:@"1" forKey:@"isLike"];
                        
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, post_id]: val};
                        [ref updateChildValues:childUpdates];
                        
                        [self ownerPost:post_id :val];
                    }
                }];
                
                isRefresh = FALSE;
       
                int clike = 0;
                if([[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id]){
                    NSDictionary *plike = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id];
                    if ([plike objectForKey:@"like"]) {
                        NSDictionary* like = [plike objectForKey:@"like"];
                        
                        NSLog(@"");
                        for (NSString* key in like) {
                            id value = [like objectForKey:key];
                            // do stuff
                            
                            if ([[value objectForKey:@"isLike"] isEqualToString:@"1"]) {
                                clike++;
                            }
                        }
                    }
                }
                
                NSDictionary *plike = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id];
                if ([plike objectForKey:@"like"]) {
                    NSDictionary* like = [[plike objectForKey:@"like"] objectForKey:[[Configs sharedInstance] getUIDU]];
                    
                    if ([[like objectForKey:@"isLike"] isEqualToString:@"1"]) {
                        [sender setTitle:[NSString stringWithFormat:@"Unlike (%d)", clike] forState:UIControlStateNormal];
                    }else{
                        [sender setTitle:[NSString stringWithFormat:@"Like (%d)", clike] forState:UIControlStateNormal];
                    }
                }
            }
                break;
            case 1:{
                // List people like
                int clike = 0;
                if([[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id]){
                    NSDictionary *plike = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id];
                    if ([plike objectForKey:@"like"]) {
                        NSDictionary* like = [plike objectForKey:@"like"];
                        
                        NSLog(@"");
                        for (NSString* key in like) {
                            id value = [like objectForKey:key];
                            // do stuff
                            
                            if ([[value objectForKey:@"isLike"] isEqualToString:@"1"]) {
                                clike++;
                            }
                        }
                    }
                }
                
                if (clike > 0) {
                    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ListPeopleLike *v = [storybrd instantiateViewControllerWithIdentifier:@"ListPeopleLike"];
                    
                    v.application_id = item_id;
                    v.post_id        = post_id;
                    v.category       = category;
                    
                    [self.navigationController pushViewController:v animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
    }else if(actionSheet.tag == 501){
        NSDictionary *item = actionSheet.object;
        // จะได้ post id
        NSString *post_id = [item objectForKey:@"post_id"];
        
        switch (buttonIndex) {
            case 0:{
                // Delete
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete Post?" message:@"Are you sure you want to delete this." delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
//                [alert show];
                
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Confirm Delete Post?" message:@"Are you sure you want to delete this." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete",nil];
                
                    alertView.tag = -999;
                alertView.object = post_id;
                [alertView show];
            }
                break;
            case 1:{
                // Edit
                AddPost *v  = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPost"];
                v.is_add    = @"0";
                v.item_id   = item_id;
                v.post_nid  = post_id;
                v.edit_data = [[data objectForKey:@"posts"] objectForKey:post_id];
                
                [self.navigationController pushViewController:v animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

-(void)ownerPost:(NSString* )post_id :(NSDictionary *)val{
    NSString *ochild = [NSString stringWithFormat:@"heart-id/center/data/%@/%@/%@/like/", category, item_id, post_id];
    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", ochild, [[Configs sharedInstance] getUIDU]]: val};
    [ref updateChildValues:childUpdates];
}

-(void)onComment:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"onComment > %d", [btn tag]);
    
    /*
    ViewPost *v = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewPost"];
    
    NSDictionary *post = [all_data objectForKey:@"post"];
    NSArray *keys = [post allKeys];
    id aKey = [keys objectAtIndex:[btn tag]];
    
    // v.item_data =[[all_data objectForKey:@"post"] objectForKey:aKey];
    
    [self.navigationController pushViewController:v animated:YES];
    */
    
    
    ViewComment *v = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewComment"];
    // v.owner_id = owner_id;
    /*
    NSDictionary *post = [all_data objectForKey:@"post"];
    NSArray *keys = [post allKeys];
    id nid_item = [keys objectAtIndex:[btn tag]];
    
    v.nid  = item_id;
    v.nid_item = nid_item;
    v.data_item =[[all_data objectForKey:@"post"] objectForKey:nid_item];
    */
    
    [self.navigationController pushViewController:v animated:YES];
    
}

-(void)onShare:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSLog(@"onLike > %d", [btn tag]);
    
    NSMutableDictionary *tposts = [data objectForKey:@"posts"];
    NSArray *keys = [tposts allKeys];
    
    // จะได้ id post
    NSString *post_id = [keys objectAtIndex:[btn tag]];
    
    // UIImage *image = [UIImage imageNamed:@"roadfire-icon-square-200"];
    NSArray * activityItems = @[@"somkid test http://klovers.org", [NSURL URLWithString:@"http://klovers.org"], [UIImage imageNamed:@"bcc59e573a289.png"]];
    // NSArray * activityItems = @[[NSString stringWithFormat:@"MY ID : Mr.Somkid Simajarn"], [NSURL URLWithString:@"http://128.199.247.179/sites/default/files/bcc59e573a289.png"]];
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities =  @[UIActivityTypePostToWeibo,
                                     UIActivityTypeMessage,
                                     UIActivityTypeMail,
                                     UIActivityTypePrint,
                                     UIActivityTypeCopyToPasteboard,
                                     UIActivityTypeAssignToContact,
                                     UIActivityTypeSaveToCameraRoll,
                                     UIActivityTypeAddToReadingList,
                                     UIActivityTypePostToFlickr,
                                     UIActivityTypePostToVimeo,
                                     UIActivityTypePostToTencentWeibo,
                                     UIActivityTypeAirDrop];
    
    NSMutableDictionary *_dict = [[Configs sharedInstance] loadData:_USER];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/field-collection/field-my-app-update/%@", [Configs sharedInstance].API_URL, post_id]];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
}

-(void)MenuMyApp:(NSNotification *)notification{
    
    NSDictionary* userInfo = notification.userInfo;
    NSString *row   = (NSString*)userInfo[@"row"];
    NSString *index = (NSString*)userInfo[@"index"];
    
    [settingsPopoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:settingsPopoverController];
    }];
    
    switch ([index integerValue]) {
        case 0:{
            //Edit
            AddPost *v = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPost"];

            v.is_add = @"0";
            // v.key = key;
            v.item_id = item_id;
            
            
            /*
            // ดึงข้อมูลเพือทำการแก้ไข
            NSDictionary *post = [all_data objectForKey:@"post"];
            NSArray *keys = [post allKeys];
            id aKey = [keys objectAtIndex:[row integerValue]];
            
            v.post_nid = aKey;
            v.edit_data =[[all_data objectForKey:@"post"] objectForKey:aKey];
            
            [self.navigationController pushViewController:v animated:YES];
            */
        }
            break;
            
        case 1:{
            //Delete
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Delete" message:@"Confirm Delete." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
            
                alertView.tag = -999;
            alertView.object = userInfo;
            [alertView show];

        }
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MenuMyApp" object:nil];
}

-(void)AddPost:(NSNotification *)notification{
    NSMutableDictionary* userInfo = notification.userInfo;
    
    id post_id = [[userInfo allKeys] objectAtIndex:0];
    
    NSMutableDictionary *_tmp_data = [[[Configs sharedInstance] loadData:_DATA] mutableCopy];
    
    NSMutableDictionary *_tmp_my_application = [[_tmp_data objectForKey:@"my_applications"] mutableCopy];
    
    if ([[_tmp_my_application objectForKey:item_id] objectForKey:@"posts"]) {
        NSMutableDictionary *titem_id = [[_tmp_my_application objectForKey:item_id] mutableCopy];
        NSMutableDictionary *tposts   = [[[_tmp_my_application objectForKey:item_id] objectForKey:@"posts"] mutableCopy];
        
        if(![tposts objectForKey:post_id]){
            [tposts setObject:[userInfo objectForKey:post_id] forKey:post_id];
            
            NSMutableDictionary *new_item_id = [[NSMutableDictionary alloc] init];
            [new_item_id addEntriesFromDictionary:titem_id];
            [new_item_id removeObjectForKey:@"posts"];
            [new_item_id setObject:tposts forKey:@"posts"];
            
            NSMutableDictionary *new_my_application = [[NSMutableDictionary alloc] init];
            [new_my_application addEntriesFromDictionary:_tmp_my_application];
            [new_my_application removeObjectForKey:item_id];
            [new_my_application setObject:new_item_id forKey:item_id];
            
            NSMutableDictionary *new_data = [[NSMutableDictionary alloc] init];
            [new_data addEntriesFromDictionary:_tmp_data];
            [new_data removeObjectForKey:@"my_applications"];
            [new_data setObject:new_my_application forKey:@"my_applications"];
            
            [[Configs sharedInstance] saveData:_DATA :new_data];
        }
    }else{
        NSMutableDictionary *titem_id = [[_tmp_my_application objectForKey:item_id] mutableCopy];
        
        NSMutableDictionary *tposts   = [[NSMutableDictionary alloc] init];
        
        [tposts setObject:[userInfo objectForKey:post_id] forKey:post_id];
        NSMutableDictionary *new_item_id = [[NSMutableDictionary alloc] init];
        [new_item_id addEntriesFromDictionary:titem_id];
        [new_item_id removeObjectForKey:@"posts"];
        [new_item_id setObject:tposts forKey:@"posts"];
        
        NSMutableDictionary *new_my_application = [[NSMutableDictionary alloc] init];
        [new_my_application addEntriesFromDictionary:_tmp_my_application];
        [new_my_application removeObjectForKey:item_id];
        [new_my_application setObject:new_item_id forKey:item_id];
        
        NSMutableDictionary *new_data = [[NSMutableDictionary alloc] init];
        [new_data addEntriesFromDictionary:_tmp_data];
        [new_data removeObjectForKey:@"my_applications"];
        [new_data setObject:new_my_application forKey:@"my_applications"];
        
        [[Configs sharedInstance] saveData:_DATA :new_data];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddPost" object:nil];
    [self reloadData:nil];
}

-(void)onMyAppProfile:(UITapGestureRecognizer *)gestureRecognizer{
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyAppProfile *v = [storybrd instantiateViewControllerWithIdentifier:@"MyAppProfile"];
    
    v.owner_id = owner_id;
    v.isOwner  = isOwner;
    v.item_id = item_id;
    v.data = data;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteMyApplication:)
                                                 name:@"deleteMyApplication" object:nil];
    
    [self.navigationController pushViewController:v animated:YES];
}

-(void)deleteMyApplication:(NSNotification *)notification{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onFollower:(UITapGestureRecognizer *)gestureRecognizer{
    NSMutableDictionary *cfollower = [[external objectForKey:@"follower"] objectForKey:item_id];
    int count = 0;
    for (NSMutableDictionary* key in cfollower) {
        id value = [cfollower objectForKey:key];
        
        if ([[value objectForKey:@"status"] isEqualToString:@"1"]) {
            count++;
        }
    }
    
    if (count > 0) {
        
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Follower *v = [storybrd instantiateViewControllerWithIdentifier:@"Follower"];
        
        v.item_id = item_id;
        //    UINavigationController* navV = [[UINavigationController alloc] initWithRootViewController:v];
        //
        //    [self presentViewController:navV animated:YES completion:nil];
        
        [self.navigationController pushViewController:v animated:YES];
    }
}

-(void)onFollow:(id)sender{
    UIButton *btn = (UIButton *)sender;

    // เก็บว่าเราไป following application ไหนบ้าง
    __block NSString *child = [NSString stringWithFormat:@"heart-id/external/%@/data/following/", [[Configs sharedInstance] getUIDU]];
    [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        FIRDatabaseReference *childRef = [ref child:child];
        [childObservers addObject:childRef];
        
        NSMutableDictionary *item_udpate = [[NSMutableDictionary alloc] init];
        [item_udpate setObject:item_id forKey:@"item_id"];
        [item_udpate setObject:[data objectForKey:@"name"] forKey:@"name"];
        [item_udpate setObject:[data objectForKey:@"picture"] forKey:@"picture"];
        [item_udpate setObject:[data objectForKey:@"category"] forKey:@"category"];
        // [item_udpate setObject:isOwner forKey:@"is_owner"];
        [item_udpate setValue:[NSNumber numberWithBool:isOwner] forKey:@"is_owner"];
        [item_udpate setObject:@"1" forKey:@"isNew"];
        
        BOOL flag = TRUE;
        for(FIRDataSnapshot* snap in snapshot.children){
            flag = FALSE;
            
            NSMutableDictionary *follow = snapshot.value;
            if ([follow objectForKey:item_id]) {
                NSDictionary* item = [follow objectForKey:item_id];
                
                if ([item isKindOfClass:[NSDictionary class]]) {
                    if ([item objectForKey:@"status"]) {
                        if ([[item objectForKey:@"status"] isEqualToString:@"0"]) {
                            [item_udpate setObject:@"1" forKey:@"status"];

                            
                            NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, item_id]: item_udpate};
                            [ref updateChildValues:childUpdates];
                            
                            [self f_setFollower:@"1"];
                        }else{
                            [item_udpate setObject:@"0" forKey:@"status"];
                            
                            NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, item_id]: item_udpate};
                            [ref updateChildValues:childUpdates];
                            
                            [self f_setFollower:@"0"];
                        }
                    }
                }else{
                    [item_udpate setObject:@"1" forKey:@"status"];
                    
                    
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, item_id]: item_udpate};
                    [ref updateChildValues:childUpdates];
                    
                    [self f_setFollower:@"1"];
                }
            }else{
                [item_udpate setObject:@"1" forKey:@"status"];
                
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, item_id]: item_udpate};
                [ref updateChildValues:childUpdates];
                
                [self f_setFollower:@"1"];
            }
        }
        
        /*
          กรณียังไม่มี child following
         */
        if (flag) {            
            [item_udpate setObject:@"1" forKey:@"status"];
            
            NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, item_id]: item_udpate};
            [ref updateChildValues:childUpdates];
            
            [self f_setFollower:@"1"];
        }
    }];
    
    
    isRefresh = FALSE;
    
    NSLog(@"%@", btn.titleLabel.text);
    if ([btn.titleLabel.text isEqualToString:@"Follow"]) {
        [sender setTitle:@"Following" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"Follow" forState:UIControlStateNormal];
    }
}

-(void)f_setFollower:(NSString *) status
{
    
    // จะไป update ให้เจ้าของ application ด้วย ว่า  ไครเป็น คน follower application
    
    // *owner_id, *item_id;
    
    __block NSString *fchild = [NSString stringWithFormat:@"heart-id/external/%@/data/follower/%@/", owner_id, item_id];
    
    [[ref child:fchild] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        FIRDatabaseReference *childRef = [ref child:fchild];
        [childObservers addObject:childRef];
        
        /*
        NSMutableDictionary *profile2 = [[[Configs sharedInstance] loadData:_USER] objectForKey:@"profile2"];
        
        NSString *fuid = [[Configs sharedInstance] getUIDU];
        NSString *fname               = [[[profile2 objectForKey:@"field_profile_display_name"] objectForKey:@"und"][0] objectForKey:@"value"];
        */
        
        /*
        NSMutableDictionary *picture  =[[NSMutableDictionary alloc] init];
        
        
        if (![[profile2 objectForKey:@"field_profile_image"] isKindOfClass:[NSArray class]]) {
            picture =  [[profile2 objectForKey:@"field_profile_image"] objectForKey:@"und"][0];
        }
        */
        
        NSMutableDictionary *fuser = [[NSMutableDictionary alloc] init];
        // [fuser setObject:fname forKey:@"fname"];
        // [fuser setObject:picture forKey:@"fpicture"];
        [fuser setObject:status forKey:@"status"];
        
        
        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", fchild, [[Configs sharedInstance] getUIDU]]: fuser};
        [ref updateChildValues:childUpdates];
        
    }];
}

- (void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case -999:
            if (buttonIndex == 0){
                NSLog(@"ยกเลิก");
            }else{
                NSDictionary* userInfo = alertView.object;
                
                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
                
                AddPostThread *apThread = [[AddPostThread alloc] init];
                [apThread setCompletionHandler:^(NSString *data) {
                    
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                    
                    if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        
                        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Delete success."];
                        
                      
                        // [[NSNotificationCenter defaultCenter] postNotificationName:@"AddPost" object:nil userInfo:jsonDict[@"values"]];
                        // [self.navigationController popViewControllerAnimated:YES];
                        
                        [self reloadData:nil];
                    }else{
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
                    }
                    
                }];
                
                [apThread setErrorHandler:^(NSString *error) {
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                }];
                
                [apThread start:@"-1":item_id :alertView.object :nil :@"" :@""];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - WYPopoverControllerDelegate
- (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller
{
    NSLog(@"popoverControllerDidPresentPopover");
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == settingsPopoverController)
    {
        settingsPopoverController.delegate = nil;
        settingsPopoverController = nil;
    }
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    return YES;
}

- (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value
{
    // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
    *value = 0; // set value to 0 if you want to avoid the popover to be moved
}

#pragma mark - UIViewControllerRotation

// Applications should use supportedInterfaceOrientations and/or shouldAutorotate..
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

// New Autorotation support.
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        /*
         CGRect frame = self.bottomRightButton.frame;
         frame.origin.y = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? self.bottomLeftButton.frame.origin.y : frame.origin.y - frame.size.height * 1.25f);
         self.bottomRightButton.frame = frame;
         */
    }];
}

-(IBAction)onAddPost:(id)sender{
    NSLog(@"");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AddPost:)
                                                 name:@"AddPost" object:nil];

    
    AddPost *v = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPost"];
    v.is_add = @"1";
    v.item_id = item_id;
    [self.navigationController pushViewController:v animated:YES];
    
}

-(IBAction)onCloseApplication:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onShareApplication:(id)sender{
    NSLog(@"");
    
    // UIImage *image = [UIImage imageNamed:@"roadfire-icon-square-200"];
    NSArray * activityItems = @[@"somkid test http://klovers.org", [NSURL URLWithString:@"http://klovers.org"], [UIImage imageNamed:@"bcc59e573a289.png"]];
    // NSArray * activityItems = @[[NSString stringWithFormat:@"MY ID : Mr.Somkid Simajarn"], [NSURL URLWithString:@"http://128.199.247.179/sites/default/files/bcc59e573a289.png"]];
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities =  @[UIActivityTypePostToWeibo,
                                     UIActivityTypeMessage,
                                     UIActivityTypeMail,
                                     UIActivityTypePrint,
                                     UIActivityTypeCopyToPasteboard,
                                     UIActivityTypeAssignToContact,
                                     UIActivityTypeSaveToCameraRoll,
                                     UIActivityTypeAddToReadingList,
                                     UIActivityTypePostToFlickr,
                                     UIActivityTypePostToVimeo,
                                     UIActivityTypePostToTencentWeibo,
                                     UIActivityTypeAirDrop];
    
    /*
    
     // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
     NSMutableDictionary *_dict = [[Configs sharedInstance] loadData:_USER];//[NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
     
     
     NSString *text = [NSString stringWithFormat:@"HEART from %@ get the HEART app it's cool", [_dict objectForKey:@"user"][@"name"]];//;
     NSURL *url = [NSURL URLWithString:@"https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1184807478/testflight/external"];
     
     UIImage *image = [UIImage imageNamed:@"bcc59e573a289.png"];
    */
     
     UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:@[@"DNA", [NSURL URLWithString:[NSString stringWithFormat:@"%@/field-collection/field-my-application/%@", [Configs sharedInstance].API_URL,item_id]]] applicationActivities:applicationActivities];
     activityController.excludedActivityTypes = excludeActivities;
     
     [self presentViewController:activityController animated:YES completion:nil];
}

- (void)reloadDataCenter:(NSNotification *) notification{
    // data     = [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"my_applications"] objectForKey:item_id];
    external = [[Configs sharedInstance] loadData:_EXTERNAL];
    center   = [[Configs sharedInstance] loadData:_CENTER];
    
    [self._table reloadData];
}

- (void) reloadData:(NSNotification *) notification{
    
    if (isRefresh) {
        data     = [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"my_applications"] objectForKey:item_id];
        external = [[Configs sharedInstance] loadData:_EXTERNAL];
        center   = [[Configs sharedInstance] loadData:_CENTER];
    
        if (data == nil) {
        //  แสดงว่าไม่ใด้ application ตัวเอง
        
        
            isRefresh  = TRUE;
            isOwner = FALSE;
            self._table.hidden = YES;
            
            // rightBarButtonItems
            // self.navigationItem.rightBarButtonItem.enabled = NO;
            // self.navigationItem.rightBarButtonItem= nil;
            
            UIBarButtonItem *closeApplicationButton = [[UIBarButtonItem alloc]
                                                       initWithTitle:@"Close"
                                                       style:UIBarButtonItemStyleBordered
                                                       target:self
                                                       action:@selector(onCloseApplication:)];
            
            UIBarButtonItem *shareApplicationButton = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Share"
                                           style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(onShareApplication:)];
            
            self.navigationItem.leftBarButtonItems = @[closeApplicationButton];
            self.navigationItem.rightBarButtonItems = @[shareApplicationButton];
            
            
            GetAppDetailThread *dThread = [[GetAppDetailThread alloc] init];
            [dThread setCompletionHandler:^(NSString *output) {
                NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:output  options:kNilOptions error:nil];
                
                if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    
                    data = jsonDict[@"data"];
                    
                    
                    
                    [UIView transitionWithView:self._table
                                      duration:0.2f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^(void) {
                                        [self._table reloadData];
                                    } completion:NULL];
                }else{
                    
                }
                self._table.hidden = NO;
                
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
            }];
            
            [dThread setErrorHandler:^(NSString *error) {
                NSLog(@"");
            }];
            [dThread start:item_id];
        }else{
            isOwner = TRUE;
        
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        
            [UIView transitionWithView:self._table
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^(void) {
                            [self._table reloadData];
                        } completion:NULL];
            
            UIBarButtonItem *addPostButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddPost:)];
            
            UIBarButtonItem *shareApplicationButton = [[UIBarButtonItem alloc]
                                                       initWithTitle:@"Share"
                                                       style:UIBarButtonItemStyleBordered
                                                       target:self
                                                       action:@selector(onShareApplication:)];
            
            self.navigationItem.rightBarButtonItems = @[addPostButton, shareApplicationButton];
        }
    }
}

@end
