//
//  Tab_iDNA_MyApp.m
//  iDNA
//
//  Created by Somkid on 10/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "Tab_iDNA_Following.h"
#import "Configs.h"
#import "Cell_H_TabiDNA.h"
#import "Cell_H_S_TabiDNA.h"
#import "Cell_Item_TabiDNA.h"
#import "Cell_Item_Following_TabiDNA.h"
#import "RecipeViewCell.h"
#import "AppDelegate.h"
#import "CreateMyApplication.h"
#import "MyApp.h"
#import "FollowingRepo.h"
#import "Following.h"

#import "CenterRepo.h"
#import "Center.h"

#import "Tab_Center_Detail.h"

@interface Tab_iDNA_Following ()
{
    // NSMutableArray *sectionTitleArray;
    // NSMutableDictionary *DNA;
    
    FollowingRepo* followingRepo;
    
    
    NSMutableArray *allFollowing;
}

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

#define kWIDTH          UIScreen.mainScreen.bounds.size.width

@end

@implementation Tab_iDNA_Following
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
                                                 name:@"Tab_iDNA_reloadData"
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
//    if (!sectionTitleArray) {
//        sectionTitleArray = [NSMutableArray arrayWithObjects: @"Following", nil];
//    }
    
    allFollowing = [[NSMutableArray alloc] init];
    
    CGFloat bottom =  self.tabBarController.tabBar.frame.size.height;
    NSLog(@"%f",bottom);
    [self._collection setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -bottom, 0)];
    
    
    followingRepo =[[FollowingRepo alloc] init];
    
    [self reloadData:nil];
}

- (void) reloadData:(NSNotification *) notification{
    
    allFollowing = [followingRepo getFollowingAll];
   
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
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return [allFollowing count];
//}

/* จำนวน item ของแต่ละ section */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [allFollowing count];
}

//  section inset, spacing margins
/*
 โดย section 0 คือ profile เราจะให้ pading 0 ทั้งหมดเพราะไม่ต้องการให้มี ขอบ
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// ความสูงของแต่ Section header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
     // NSMutableArray * _items = [DNA valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
    
     NSMutableArray *_item = [allFollowing objectAtIndex:indexPath.row];
    
    
    
    
    CenterRepo *centerRepo = [[CenterRepo alloc] init];
    
    NSArray *lll = [centerRepo getCenterAll];
    NSArray *item_ct =  [centerRepo get:[_item objectAtIndex:[followingRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]]];
    
    NSData *data_ct =  [[item_ct objectAtIndex:[centerRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data_ct options:0 error:nil];
    
    Cell_Item_Following_TabiDNA* cell = (Cell_Item_Following_TabiDNA *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_Item_Following_TabiDNA" forIndexPath:indexPath];
    
    cell.labelName.text = [f objectForKey:@"name"];
    if ([f objectForKey:@"image_url"]) {
        [cell.hjmImage clear];
        [cell.hjmImage showLoadingWheel];
        
        [cell.hjmImage setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[f objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
    }
    
    /*
            if ([[f valueForKey:@"picture"] isKindOfClass:[NSDictionary class]]) {
                
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
    */
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *_item = [allFollowing objectAtIndex:indexPath.row];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Tab_Center_Detail *tab_Center_Detail    = [storybrd instantiateViewControllerWithIdentifier:@"Tab_Center_Detail"];
    tab_Center_Detail.app_id   = [_item objectAtIndex:[followingRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
    [self.navigationController pushViewController:tab_Center_Detail animated:YES];
    /*
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
                // NSMutableArray * _items = [DNA valueForKey:[sectionTitleArray objectAtIndex:0]];
                NSMutableArray *_item   = [allFollowing objectAtIndex:indexPath.row];
                
                NSString *app_id =  [_item objectAtIndex:[followingRepo.dbManager.arrColumnNames indexOfObject:@"app_id"]];
                
                MyApp *myApp    = [storybrd instantiateViewControllerWithIdentifier:@"MyApp"];
                myApp.app_id  = app_id;
                [self.navigationController pushViewController:myApp animated:YES];
            }
            
        }
            break;
            
        case 1:{
            // Following
            
        }
            break;
        default:
            break;
    }
    */
}


@end

