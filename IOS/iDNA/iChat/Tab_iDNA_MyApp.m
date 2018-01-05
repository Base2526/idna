//
//  Tab_iDNA_MyApp.m
//  iDNA
//
//  Created by Somkid on 10/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "Tab_iDNA_MyApp.h"

//@interface Tab_iDNA_MyApp ()
//
//@end
//
//@implementation Tab_iDNA_MyApp
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
//@end
#import "Configs.h"

#import "Cell_H_TabiDNA.h"
#import "Cell_H_S_TabiDNA.h"
#import "Cell_Item_TabiDNA.h"
#import "Cell_Item_Following_TabiDNA.h"

#import "RecipeViewCell.h"

#import "AppDelegate.h"

#import "CreateMyApplication.h"
#import "MyApp.h"

#import "MyApplicationsRepo.h"
#import "MyApplications.h"

// #import "SWRevealViewController.h"

@interface Tab_iDNA_MyApp ()
{
    NSMutableArray *sectionTitleArray;
    NSMutableDictionary *DNA;
    
    MyApplicationsRepo* myAppRepo;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

#define kWIDTH          UIScreen.mainScreen.bounds.size.width

@end

@implementation Tab_iDNA_MyApp
@synthesize preferences;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     SWRevealViewController *revealViewController = self.revealViewController;
     if ( revealViewController )
     {
     revealViewController.rightViewRevealWidth = kWIDTH;
     revealViewController.rightViewRevealOverdraw = 0;
     
     [self.revealButton setTarget:revealViewController];
     [self.revealButton setAction: @selector(revealToggle:)];
     
     [self.rightButton setTarget:revealViewController];
     [self.rightButton setAction: @selector(rightRevealToggle:)];
     
     [self.revealViewController panGestureRecognizer];
     [self.revealViewController tapGestureRecognizer];
     }
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"Tab_iDNA_MyApp_reloadData"
                                               object:nil];
    
    
    
    /*
     #1 Register: Cell Header คือส่วนหัวของ Tab idna
     */
    [self._collection registerNib:[UINib nibWithNibName:@"Cell_H_TabiDNA" bundle:nil]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:@"Cell_H_TabiDNA"];
    
    /*
     #2 Register: Cell Header Section
     */
    [self._collection registerNib:[UINib nibWithNibName:@"Cell_H_S_TabiDNA" bundle:nil]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:@"Cell_H_S_TabiDNA"];
    
    /*
     #3 Register: Cell Item
     */
    [self._collection registerNib:[UINib nibWithNibName:@"Cell_Item_TabiDNA" bundle:nil] forCellWithReuseIdentifier:@"Cell_Item_TabiDNA"];
    
    /*
     #3 Register: Cell Item Following
     */
    [self._collection registerNib:[UINib nibWithNibName:@"Cell_Item_Following_TabiDNA" bundle:nil] forCellWithReuseIdentifier:@"Cell_Item_Following_TabiDNA"];
    
    
    preferences = [NSUserDefaults standardUserDefaults];
    
    // ชื่อ Section
    if (!sectionTitleArray) {
        sectionTitleArray = [NSMutableArray arrayWithObjects: @"My Application", @"Following", nil];
    }
    
    CGFloat bottom =  self.tabBarController.tabBar.frame.size.height;
    NSLog(@"%f",bottom);
    [self._collection setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -bottom, 0)];
    
    myAppRepo =[[MyApplicationsRepo alloc] init];
    
    [self reloadData:nil];
}

- (void) reloadData:(NSNotification *) notification{
    
    NSMutableDictionary *_DNA = [[NSMutableDictionary alloc] init];
    
    // profile
    // [_DNA setValue:[[NSMutableDictionary alloc] init] forKey:[sectionTitleArray objectAtIndex:0]];
    
    // my application
    [_DNA setValue:[[NSMutableDictionary alloc] init] forKey:[sectionTitleArray objectAtIndex:0]];
    
    
    NSDictionary*data =  [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"my_applications"];
    
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSString* key in data){
        // [items setObject:[data objectForKey:key] forKey:key];
        
        [items addObject:[data objectForKey:key]];
    }
    
    [items addObject:@{@"item_id":@"0"}];
    
    NSArray *sortedArray = [items sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([[obj1 valueForKey:@"item_id"] integerValue] < [[obj2 valueForKey:@"item_id"] integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([[obj1 valueForKey:@"item_id"] integerValue] > [[obj2 valueForKey:@"item_id"] integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // [_DNA setValue:sortedArray forKey:[sectionTitleArray objectAtIndex:0]];
    
    
    // ดึงข้อมูลจาก Database My Application
    /*
     #import "MyApplicationsRepo.h"
     #import "MyApplications.h"
     */
    
    
    
    NSMutableArray *allMyApp = [myAppRepo getMyApplicationAll];
    [_DNA setValue:allMyApp forKey:[sectionTitleArray objectAtIndex:0]];
    
    /*
    if ([[[Configs sharedInstance] loadData:_EXTERNAL] objectForKey:@"following"]) {
        NSMutableArray *following = [[NSMutableArray alloc] init];
        
        for (NSString* key in [[[Configs sharedInstance] loadData:_EXTERNAL] objectForKey:@"following"]) {
            id value = [[[[Configs sharedInstance] loadData:_EXTERNAL] objectForKey:@"following"] objectForKey:key];
            
            if ([value isKindOfClass:[NSDictionary class]]) {
                if ([value objectForKey:@"item_id"]) {
                    if ([[value objectForKey:@"status"] isEqualToString:@"1"]) {
                        [following addObject:value];
                    }
                }
            }
        }
        
        NSArray *sortedFollowing = [following sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([[obj1 valueForKey:@"item_id"] integerValue] < [[obj2 valueForKey:@"item_id"] integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([[obj1 valueForKey:@"item_id"] integerValue] > [[obj2 valueForKey:@"item_id"] integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        NSLog(@"");
        
        [_DNA setValue:sortedFollowing forKey:[sectionTitleArray objectAtIndex:1]];
    }else{
        [_DNA setValue:[[NSArray alloc] init] forKey:[sectionTitleArray objectAtIndex:1]];
    }
     */
    
    [DNA removeAllObjects];
    DNA = _DNA;
    
    [self._collection reloadData];
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

/* จำนวน section */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [DNA count];
}

/* จำนวน item ของแต่ละ section */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    @try {
        NSArray * tmp = [DNA valueForKey:[sectionTitleArray objectAtIndex:section]];
        switch (section) {
                //            case 0:
                //            {
                //                return 0;
                //            }
                //                break;
            case 0:
            {
                return [tmp count] + 1;
            }
                break;
            case 1:
            {
                if ([tmp count] == 0) {
                    return 0;
                }else{
                    return [tmp count];
                }
            }
                break;
            default:
                break;
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        NSLog(@"finally");
    }
    
    return 0;
}

//  section inset, spacing margins
/*
 โดย section 0 คือ profile เราจะให้ pading 0 ทั้งหมดเพราะไม่ต้องการให้มี ขอบ
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    //    switch (section) {
    //        case 0:
    //        {
    //            return UIEdgeInsetsMake(0, 0, 0, 0);
    //        }
    //            break;
    //
    //        default:
    //            break;
    //    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// ความสูงของแต่ Section header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 00);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    RecipeViewCell *cell = nil;
    
    NSLog(@"%d", indexPath.section);
    
    switch (indexPath.section) {
        case 0:
        {
            // [collectionView deq]
            
            
            
            // UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
            
            // NSArray* tmp =recipeImages[indexPath.section];
            
            /*
             NSArray * tmp = [DNA valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
             
             NSLog(@"> %d", [tmp count]+ 1);
             NSLog(@">> %d", indexPath.row + 1);
             
             // คำนวณหา array อันสุดท้าย(คือปุ่ม add new card)
             if ([tmp count] == indexPath.row ) {
             NSLog(@"");
             
             //                // set ให้รูปเราเป้นวงกรม : http://www.appcoda.com/ios-programming-circular-image-calayer/
             //                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-white.png"]];
             //                cell.backgroundView.layer.cornerRadius = cell.backgroundView.frame.size.width / 2;
             //                cell.backgroundView.clipsToBounds = YES;
             //
             //                // set border
             //                cell.backgroundView.layer.borderWidth = 3.0f;
             //                cell.backgroundView.layer.borderColor = [UIColor grayColor].CGColor;
             //                // set border
             
             // cell.labelText.text = @"+";
             
             RecipeViewCell* cell = (RecipeViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:nil];
             
             
             cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-white.png"]];
             cell.backgroundView.layer.cornerRadius = cell.backgroundView.frame.size.width / 2;
             cell.backgroundView.clipsToBounds = YES;
             
             // set border
             cell.backgroundView.layer.borderWidth = 3.0f;
             cell.backgroundView.layer.borderColor = [UIColor grayColor].CGColor;
             // set border
             
             cell.labelText.text = @"+";
             
             return cell;
             }else{
             
             HomeMyCardCell* cell = (HomeMyCardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeMyCardCell" forIndexPath:indexPath];
             
             NSMutableDictionary * dict = [DNA valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
             
             NSArray *keys = [dict allKeys];
             id aKey = [keys objectAtIndex:indexPath.row];
             NSMutableDictionary *anObject = [dict objectForKey:aKey];
             
             // NSLog(@"%@", [anObject objectForKey:@"name"]);
             
             // cell.labelName.text = [anObject objectForKey:@"name"];
             
             [cell.hjmImage setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
             cell.labelName.text = [anObject objectForKey:@"name"];
             
             return cell;
             }
             */
            
            
            if (indexPath.row == 0) {
                RecipeViewCell* cell = (RecipeViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:nil];
                
                
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-white.png"]];
                cell.backgroundView.layer.cornerRadius = cell.backgroundView.frame.size.width / 2;
                cell.backgroundView.clipsToBounds = YES;
                
                // set border
                cell.backgroundView.layer.borderWidth = 3.0f;
                cell.backgroundView.layer.borderColor = [UIColor grayColor].CGColor;
                // set border
                
                cell.labelText.text = @"+";
                
                return cell;
            }else{
                
                Cell_Item_TabiDNA* cell = (Cell_Item_TabiDNA *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_Item_TabiDNA" forIndexPath:indexPath];
                
                NSMutableArray * _items = [DNA valueForKey:[sectionTitleArray objectAtIndex:0]];
                NSMutableArray *_item = [_items objectAtIndex:indexPath.row - 1];
                /****/
                
                NSData *data =  [[_item objectAtIndex:[myAppRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
                
                if (data == nil) {
                    return  cell;
                }
                
                NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                /***/
                
                
                cell.labelName.text = [f objectForKey:@"name"];
                // [cell.hjmImage setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
                
                /*
                 NSMutableDictionary *picture = [_item valueForKey:@"picture"];
                 [cell.hjmImage clear];
                 if ([picture count] > 0 ) {
                 [cell.hjmImage showLoadingWheel];
                 
                 NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 
                 [cell.hjmImage setUrl:[NSURL URLWithString:url]];
                 // [img setImage:[UIImage imageWithData:fileData]];
                 [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
                 }else{
                 [cell.hjmImage setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
                 }
                 */
                
                if ([f objectForKey:@"image_url"]) {
                    [cell.hjmImage clear];
                    [cell.hjmImage showLoadingWheel]; // API_URL
                    [cell.hjmImage setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
                }else{
                    [cell.hjmImage clear];
                }
                
                return cell;
                
            }
            
            /*
             if ([[_item objectForKey:@"item_id"] isEqualToString:@"0"]) {
             
             RecipeViewCell* cell = (RecipeViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:nil];
             
             
             cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-white.png"]];
             cell.backgroundView.layer.cornerRadius = cell.backgroundView.frame.size.width / 2;
             cell.backgroundView.clipsToBounds = YES;
             
             // set border
             cell.backgroundView.layer.borderWidth = 3.0f;
             cell.backgroundView.layer.borderColor = [UIColor grayColor].CGColor;
             // set border
             
             cell.labelText.text = @"+";
             
             return cell;
             }else{
             
             Cell_Item_TabiDNA* cell = (Cell_Item_TabiDNA *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_Item_TabiDNA" forIndexPath:indexPath];
             
             
             
             cell.labelName.text = [_item objectForKey:@"name"];
             // [cell.hjmImage setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
             
             NSMutableDictionary *picture = [_item valueForKey:@"picture"];
             [cell.hjmImage clear];
             if ([picture count] > 0 ) {
             [cell.hjmImage showLoadingWheel];
             
             NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             
             [cell.hjmImage setUrl:[NSURL URLWithString:url]];
             // [img setImage:[UIImage imageWithData:fileData]];
             [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
             }else{
             [cell.hjmImage setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
             }
             
             return cell;
             }
             */
        }
            break;
        case 1:{
            NSMutableArray * _items = [DNA valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
            
            NSDictionary *_item = [_items objectAtIndex:indexPath.row];
            
            Cell_Item_Following_TabiDNA* cell = (Cell_Item_Following_TabiDNA *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_Item_Following_TabiDNA" forIndexPath:indexPath];
            
            cell.labelName.text = [_item objectForKey:@"name"];
            // [cell.hjmImage setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
            
            if ([[_item valueForKey:@"picture"] isKindOfClass:[NSDictionary class]]) {
                
                NSMutableDictionary *picture = [_item valueForKey:@"picture"];
                [cell.hjmImage clear];
                if ([picture count] > 0 ) {
                    [cell.hjmImage showLoadingWheel];
                    
                    NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    [cell.hjmImage setUrl:[NSURL URLWithString:url]];
                    // [img setImage:[UIImage imageWithData:fileData]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
                }else{
                    [cell.hjmImage setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
                }
            }
            
            
            if ([_item objectForKey:@"isNew"]) {
                if ([[_item objectForKey:@"isNew"] isEqualToString:@"1"]) {
                    cell.labelNew.hidden = FALSE;
                }else{
                    cell.labelNew.hidden = TRUE;
                }
            }
            
            return cell;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (indexPath.row == 0) {
                CreateMyApplication *createMyApplication = [storybrd instantiateViewControllerWithIdentifier:@"CreateMyApplication"];
                UINavigationController* navCreateMyApplication = [[UINavigationController alloc] initWithRootViewController:createMyApplication];
                
                // http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller
                // get register to fetch notification
                //                [[NSNotificationCenter defaultCenter] addObserver:self
                //                                                         selector:@selector(createMyApp:)
                //                                                             name:@"createMyApp" object:nil];
                
                [self presentViewController:navCreateMyApplication animated:YES completion:nil];
            }else{
                NSMutableArray * _items = [DNA valueForKey:[sectionTitleArray objectAtIndex:0]];
                NSMutableArray *_item   = [_items objectAtIndex:indexPath.row - 1];
                
                NSString *app_id =  [_item objectAtIndex:[myAppRepo.dbManager.arrColumnNames indexOfObject:@"app_id"]];
                
                MyApp *myApp    = [storybrd instantiateViewControllerWithIdentifier:@"MyApp"];
                myApp.app_id  = app_id;
                [self.navigationController pushViewController:myApp animated:YES];
            }
            /*
             // My Application
             NSMutableArray * _items = [DNA valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
             
             NSDictionary *_item = [_items objectAtIndex:indexPath.row];
             
             if ([[_item objectForKey:@"item_id"] isEqualToString:@"0"]) {
             
             UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             
             CreateMyApplication *createMyApplication = [storybrd instantiateViewControllerWithIdentifier:@"CreateMyApplication"];
             UINavigationController* navCreateMyApplication = [[UINavigationController alloc] initWithRootViewController:createMyApplication];
             
             // http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller
             // get register to fetch notification
             //                [[NSNotificationCenter defaultCenter] addObserver:self
             //                                                         selector:@selector(createMyApp:)
             //                                                             name:@"createMyApp" object:nil];
             
             [self presentViewController:navCreateMyApplication animated:YES completion:nil];
             
             }else{
             UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             MyApp *v    = [storybrd instantiateViewControllerWithIdentifier:@"MyApp"];
             v.owner_id  = [[Configs sharedInstance] getUIDU];
             v.item_id   = [_item objectForKey:@"item_id"];
             v.category  = [_item objectForKey:@"category"];
             [self.navigationController pushViewController:v animated:YES];
             }
             */
        }
            break;
            
        case 1:{
            // Following
            /*
             NSMutableArray * _items = [DNA valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
             
             NSDictionary *_item = [_items objectAtIndex:indexPath.row];
             
             UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             MyApp *v    = [storybrd instantiateViewControllerWithIdentifier:@"MyApp"];
             v.owner_id  = [[Configs sharedInstance] getUIDU];
             v.item_id   = [_item objectForKey:@"item_id"];
             v.category  = [_item objectForKey:@"category"];
             [self.navigationController pushViewController:v animated:YES];
             */
        }
            break;
        default:
            break;
    }
}


@end

