//
//  MXContactsBViewController.m
//  Heart
//
//  Created by Somkid on 9/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "MXContactsBViewController.h"
#import "Contacts_AllFriendsCell.h"
#import "AppDelegate.h"
#import "HJManagedImageV.h"
#import "CategoriesLayout.h"

#import "UINavigationBar+CustomHeight.h"

@interface MXContactsBViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation MXContactsBViewController{
    HMSegmentedControl *hmSegmentC;
    UICollectionView *allFriends, *class, *group, *addFriend;

}
// @synthesize collectionView;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    /*
     กรณีเรา add collectionView 2 collectionView จะมี top space เราเลยต้องเครียออกก่อน แล้ว + hmSegmentC.frame.size.height
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /*
     กำหนดความสูงของ navigationBar
     */
    [self.navigationController.navigationBar setHeight:[Configs sharedInstance].navigationBarHeight];
    /*
     กำหนดสีของ navigationBar
     */
    [self.navigationController.navigationBar setBarTintColor:[Utility colorDefualt]];
    
    [self addHMSegmentedControl];
    
    [self addAllFriends];
    [self addClass];
    [self addGroup];
    [self addAddFriend];
    
    switch (hmSegmentC.selectedSegmentIndex) {
        case 0:{
            [allFriends setHidden:NO];
            [class setHidden:YES];
            [group setHidden:YES];
            [addFriend setHidden:YES];
        }
            break;
            
        case 1:{
            [allFriends setHidden:YES];
            [class setHidden:NO];
            [group setHidden:YES];
            [addFriend setHidden:YES];
        }
            break;
            
        case 2:{
            [allFriends setHidden:YES];
            [class setHidden:YES];
            [group setHidden:NO];
            [addFriend setHidden:YES];
        }
            break;
            
        case 3:{
            [allFriends setHidden:YES];
            [class setHidden:YES];
            [group setHidden:YES];
            [addFriend setHidden:NO];
        }
            break;
            
        default:
            break;
    }
    
//    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)addHMSegmentedControl{
    // Minimum code required to use the segmented control with the default styling.
    hmSegmentC = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"ALL FRIENDS", @"CLASS", @"GROUP", @"ADD FRIEND"]];
    hmSegmentC.frame = CGRectMake(0, 0, self.view.frame.size.width, [Configs sharedInstance].navigationBarHeight);//self.navigationController.navigationBar.frame;
    // [hmSegmentC setSectionTitles:@[@"MY APPLICATION", @"FOLLOWING"]];
    // hmSegmentC.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    hmSegmentC.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    hmSegmentC.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    // segmentedControl.verticalDividerEnabled = YES;
    // segmentedControl.verticalDividerColor = [UIColor blackColor];
    // segmentedControl.verticalDividerWidth = 1.0f;
    // CGFloat height = hmSegmentC.selectionIndicatorHeight;
    
    hmSegmentC.selectionIndicatorHeight = 1.0f;
    hmSegmentC.selectionIndicatorColor = [UIColor whiteColor];
    hmSegmentC.backgroundColor = [Utility colorDefualt];
    hmSegmentC.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [hmSegmentC setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        return attString;
    }];
    [hmSegmentC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationController.navigationBar addSubview:hmSegmentC];
}

-(void)addAllFriends{
//    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(hmSegmentC.frame.size.height + 5, 5, 5, 5);
    
    UICollectionViewFlowLayout* layout = [self getCategoriesLayout];
    
    allFriends=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    allFriends.contentInset = UIEdgeInsetsMake(hmSegmentC.frame.size.height + 5, 5, ([Configs sharedInstance].kBarHeight + 15), 5);
    
    // [allFriends setScrollIndicatorInsets:UIEdgeInsetsMake(hmSegmentC.frame.size.height + 5, 5, ([Configs sharedInstance].kBarHeight + 15), 5)];
    // allFriends.contentInset  = UIEdgeInsetsMake(hmSegmentC.frame.size.height + 5, 5, ([Configs sharedInstance].kBarHeight + 15), 5);;//UIEdgeInsetsMake(0, 0, 30, 0);
    
    [allFriends setDataSource:self];
    [allFriends setDelegate:self];
    
    // [allFriends registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"allFriends"];
    // [allFriends registerClass:[Contacts_AllFriendsCell class] forCellWithReuseIdentifier:@"Contacts_AllFriendsCell"];
    
    [allFriends registerNib:[UINib nibWithNibName:@"Contacts_AllFriendsCell" bundle:nil] forCellWithReuseIdentifier:@"Contacts_AllFriendsCell"];
    [allFriends setBackgroundColor:[Utility colorDefualt]];
    
    [self.view addSubview:allFriends];
}

-(void)addClass{
    UICollectionViewFlowLayout *layout= [self getCategoriesLayout];
    class=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [class setDataSource:self];
    [class setDelegate:self];
    
    [class registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"class"];
    [class setBackgroundColor:[Utility colorDefualt]];
    
    [self.view addSubview:class];
}

// group
-(void)addGroup{
    UICollectionViewFlowLayout *layout= [self getCategoriesLayout];
    group=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [group setDataSource:self];
    [group setDelegate:self];
    
    [group registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"group"];
    [group setBackgroundColor:[Utility colorDefualt]];
    
    [self.view addSubview:group];
}

-(void)addAddFriend{
    UICollectionViewFlowLayout *layout= [self getCategoriesLayout];
    addFriend=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [addFriend setDataSource:self];
    [addFriend setDelegate:self];
    
    [addFriend registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"addFriend"];
    [addFriend setBackgroundColor:[Utility colorDefualt]];
    
    [self.view addSubview:addFriend];
}

-(CategoriesLayout *)getCategoriesLayout
{
    CategoriesLayout* layout = [[CategoriesLayout alloc] init];
    // layout.minimumLineSpacing = 10.0f;
    // layout.minimumInteritemSpacing = ([[UIScreen mainScreen] applicationFrame].size.width / 12.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // layout.sectionInset = UIEdgeInsetsMake( 5, 5, 5, 5);
    
    // layout.sectionInset = UIEdgeInsetsMake(hmSegmentC.frame.size.height + 5, 5, ([Configs sharedInstance].kBarHeight + 15), 5);
    layout.minimumInteritemSpacing = 2 ;//minimumInteritemSpacing
    layout.minimumLineSpacing = 2 ;//minimumLineSpacing
    
    return layout;
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:{
            //action for the first button (Current)
            NSLog(@"-0-");
            [allFriends setHidden:NO];
            [class setHidden:YES];
            [group setHidden:YES];
            [addFriend setHidden:YES];
            
            break;
        }
        case 1:{
            //action for the first button (Current)
            NSLog(@"-1-");
            [allFriends setHidden:YES];
            [class setHidden:NO];
            [group setHidden:YES];
            [addFriend setHidden:YES];

            break;
        }
        case 2:{
            NSLog(@"-2-");
            [allFriends setHidden:YES];
            [class setHidden:YES];
            [group setHidden:NO];
            [addFriend setHidden:YES];
            
            break;
        }
        case 3:{
            NSLog(@"-3-");
            [allFriends setHidden:YES];
            [class setHidden:YES];
            [group setHidden:YES];
            [addFriend setHidden:NO];
            
            break;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(150, 180);
    
    /*
    CGFloat w =collectionView.bounds.size.width;
    int i =  collectionView.bounds.size.width/150;
    
    // fmod()
    float fm = 290 % 150;
    NSLog(@"");
    return CGSizeMake(collectionView.bounds.size.width, 150);
    
    */
    
    /*
     NSInteger numberOfColumns = 3;
     
     CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - (numberOfColumns - 1)) / numberOfColumns;
     return CGSizeMake(itemWidth, itemWidth);
     */
    /*
    NSInteger numberOfColumns = 2;
    CGFloat itemWidth = (collectionView.bounds.size.width - (numberOfColumns - 1) )/ numberOfColumns;
    
    return CGSizeMake(itemWidth, itemWidth);
    */
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == allFriends) {
        return 1;
    }else if (collectionView == class) {
        return 1;
    }else if (collectionView == group) {
        return 1;
    }else if (collectionView == addFriend) {
        return 1;
    }

    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == allFriends) {
        return 30;
    }else if (collectionView == class) {
        return 20;
    }else if (collectionView == group) {
        return 10;
    }else if (collectionView == addFriend) {
        return 11;
    }
    
    return 0;
}

/*
 ระยะหว่างของขอบนอก top, left, bottom, right
 */
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}


// https://stackoverflow.com/questions/10317169/setcontentmode-for-hjmanagedimagev-is-not-working-for-ios
-(void) managedImageSet:(HJManagedImageV*)mi
{
    mi.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [Utility makeImageTriangular:mi.imageView :[UIColor whiteColor]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{    
    if (collectionView == allFriends) {
        
        Contacts_AllFriendsCell* cell = (Contacts_AllFriendsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Contacts_AllFriendsCell" forIndexPath:indexPath];
        // Contacts_AllFriendsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Contacts_AllFriendsCell" forIndexPath:indexPath];
        
        // [cell setBackgroundColor:[UIColor greenColor]];
        
//        UILabel *lbl = [[UILabel alloc] initWithFrame:[[cell contentView] frame]];
//        [lbl setTextColor:[UIColor whiteColor]];
//        [lbl setTextAlignment:NSTextAlignmentCenter];
//        [lbl setText:[NSString stringWithFormat:@"ALL FRIENDS : %ld", indexPath.row + 1]];
//        
//        
//        [cell setBackgroundColor:[UIColor greenColor]];
//        [cell addSubview:lbl];
        
        HJManagedImageV *imageV =(HJManagedImageV *)cell.imageV;
        imageV.callbackOnSetImage = (id)self;
        
        [imageV clear];
        // if (![[[all_data objectAtIndex:indexPath.row - 2] valueForKey:@"url_image"] isEqualToString:@""]) {
        [imageV showLoadingWheel];
        [imageV setUrl:[NSURL URLWithString:@"http://idna.center/sites/default/files/ic_profile.png"]];
        // [img setImage:[UIImage imageWithData:fileData]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
        
        
        // [imageV setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
        
        // [Utility makeImageTriangular:imageV.imageView :[UIColor whiteColor]];
        
        cell.labelName.textColor = [UIColor whiteColor];
        cell.labelName.text = [NSString stringWithFormat:@"Friend : %d", indexPath.row];

        
        return cell;
    }else if (collectionView == class) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"class" forIndexPath:indexPath];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:[[cell contentView] frame]];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setText:[NSString stringWithFormat:@"CLASS : %ld", indexPath.row + 1]];
        
        
        [cell setBackgroundColor:[UIColor greenColor]];
        [cell addSubview:lbl];
        
        return cell;
    }else if (collectionView == group) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"group" forIndexPath:indexPath];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:[[cell contentView] frame]];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setText:[NSString stringWithFormat:@"GROUP : %ld", indexPath.row + 1]];
        
        
        [cell setBackgroundColor:[UIColor greenColor]];
        [cell addSubview:lbl];
        
        return cell;
    }else if (collectionView == addFriend) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addFriend" forIndexPath:indexPath];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:[[cell contentView] frame]];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setText:[NSString stringWithFormat:@"ADD FRIEND : %ld", indexPath.row + 1]];
        
        
        [cell setBackgroundColor:[UIColor greenColor]];
        [cell addSubview:lbl];
        
        return cell;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cell Tap" message:[NSString stringWithFormat:@"Cell : %ld selected", indexPath.row + 1] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
