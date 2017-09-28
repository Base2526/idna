//
//  ViewController.m
//  UICollectionViewDemoObjectiveC
//
//  Created by Hardik Trivedi on 29/07/2016.
//  Copyright © 2016 iHart. All rights reserved.
//

#import "MXDNABViewController.h"
#import "CategoriesLayout.h"
#import "Configs.h"

#import "iDNA_MyApplication_CollectionViewCell.h"
#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>

#import "CreateMyApplication.h"

#import "UINavigationBar+CustomHeight.h"

@interface MXDNABViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation MXDNABViewController{
    HMSegmentedControl *hmSegmentC;
    UICollectionView *cVMyApplication, *cVFollowing;

}
// @synthesize collectionView;

- (void)viewDidLoad
{
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
    [self addcVFollowing];
    [self addcVMyApplication];
    
    
    switch (hmSegmentC.selectedSegmentIndex) {
        case 0:{
            [cVMyApplication setHidden:NO];
            [cVFollowing setHidden:YES];
        }
            break;
            
        case 1:{
            [cVMyApplication setHidden:YES];
            [cVFollowing setHidden:NO];
        }
            break;
            
        default:
            break;
    }
    
    
    
}

-(void)addHMSegmentedControl{
    // Minimum code required to use the segmented control with the default styling.
    hmSegmentC = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"MY APPLICATION", @"FOLLOWING"]];
    // hmSegmentC.frame = self.navigationController.navigationBar.frame;
    
    hmSegmentC.frame = CGRectMake(0, 0, self.view.frame.size.width, [Configs sharedInstance].navigationBarHeight);//self.navigationController.navigationBar.frame;
    // [hmSegmentC setSectionTitles:@[@"MY APPLICATION", @"FOLLOWING"]];
    // hmSegmentC.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    hmSegmentC.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    hmSegmentC.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    // segmentedControl.verticalDividerEnabled = YES;
    // segmentedControl.verticalDividerColor = [UIColor blackColor];
    // segmentedControl.verticalDividerWidth = 1.0f;
    
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

-(void)addcVMyApplication{
    // UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    // layout.sectionInset = UIEdgeInsetsMake(hmSegmentC.frame.size.height, 0, 0, 0);
    
    UICollectionViewFlowLayout* layout = [[CategoriesLayout alloc] init];
    // layout.minimumLineSpacing = 10.0f;
    // layout.minimumInteritemSpacing = ([[UIScreen mainScreen] applicationFrame].size.width / 12.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // layout.sectionInset = UIEdgeInsetsMake( 5, 5, 5, 5);
    layout.sectionInset = UIEdgeInsetsMake(hmSegmentC.frame.size.height + 5, 5, ([Configs sharedInstance].kBarHeight + 15), 5);
    layout.minimumInteritemSpacing = 2 ;//minimumInteritemSpacing
    layout.minimumLineSpacing = 2 ;//minimumLineSpacing
    cVMyApplication=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    // cVMyApplication.contentInset = UIEdgeInsets(10, 10, 10, 10);
    // cVMyApplication.contentInset  = UIEdgeInsetsMake(10, 10, 10, 10);

    [cVMyApplication setDataSource:self];
    [cVMyApplication setDelegate:self];
    
    // [cVMyApplication registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cVMyApplication"];
    
    [cVMyApplication registerNib:[UINib nibWithNibName:@"iDNA_MyApplication_CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"iDNA_MyApplication_CollectionViewCell"];
    [cVMyApplication setBackgroundColor:[Utility colorDefualt]];
    
    [self.view addSubview:cVMyApplication];
}

-(void)addcVFollowing{
    // UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    // layout.sectionInset = UIEdgeInsetsMake(hmSegmentC.frame.size.height, 0, 0, 0);
    
    UICollectionViewFlowLayout* layout = [[CategoriesLayout alloc] init];
    // layout.minimumLineSpacing = 10.0f;
    // layout.minimumInteritemSpacing = ([[UIScreen mainScreen] applicationFrame].size.width / 12.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // layout.sectionInset = UIEdgeInsetsMake( 5, 5, 5, 5);
    layout.sectionInset = UIEdgeInsetsMake(hmSegmentC.frame.size.height + 5, 5, ([Configs sharedInstance].kBarHeight + 15), 5);
    layout.minimumInteritemSpacing = 2 ;//minimumInteritemSpacing
    layout.minimumLineSpacing = 2 ;//minimumLineSpacing
    
    cVFollowing=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [cVFollowing setDataSource:self];
    [cVFollowing setDelegate:self];
    
    [cVFollowing registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cVFollowing"];
    [cVFollowing setBackgroundColor:[Utility colorDefualt]];
    
    [self.view addSubview:cVFollowing];
}

// https://stackoverflow.com/questions/10317169/setcontentmode-for-hjmanagedimagev-is-not-working-for-ios
-(void) managedImageSet:(HJManagedImageV*)mi{
    mi.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [Utility roundView:mi onCorner:UIRectCornerAllCorners radius:5.0f];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:{
            //action for the first button (Current)
            NSLog(@"-0-");
            [cVMyApplication setHidden:NO];
            [cVFollowing setHidden:YES];
            break;
        }
        case 1:{
            //action for the first button (Current)
            NSLog(@"-1-");
            [cVMyApplication setHidden:YES];
            [cVFollowing setHidden:NO];
            break;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(150, 180);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == cVMyApplication) {
        return 1;
    }else if (collectionView == cVFollowing) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == cVMyApplication) {
        return 30;
    }else if (collectionView == cVFollowing) {
        return 20;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == cVMyApplication) {
        
        iDNA_MyApplication_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iDNA_MyApplication_CollectionViewCell" forIndexPath:indexPath];
        
        /*
        UILabel *lbl = [[UILabel alloc] initWithFrame:[[cell contentView] frame]];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setText:[NSString stringWithFormat:@"MPP : %ld", indexPath.row + 1]];
        
        
        [cell setBackgroundColor:[UIColor greenColor]];
        [cell addSubview:lbl];
        */
        
        HJManagedImageV *imageV =(HJManagedImageV *)cell.imageV;
        
        if (indexPath.row == 0) {
            
            [imageV clear];
            // if (![[[all_data objectAtIndex:indexPath.row - 2] valueForKey:@"url_image"] isEqualToString:@""]) {
            [imageV showLoadingWheel];
            // [imageV setUrl:[NSURL URLWithString:@"http://idna.center/sites/default/files/ic_profile.png"]];
            [imageV setImage:[UIImage imageNamed:@"ic_create_new_application.png"]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            
            cell.labelName.text =@"CREATE NEW APP";
            cell.labelName.textColor = [UIColor whiteColor];

        }else{
            imageV.callbackOnSetImage = (id)self;
        
            [imageV clear];
            // if (![[[all_data objectAtIndex:indexPath.row - 2] valueForKey:@"url_image"] isEqualToString:@""]) {
            [imageV showLoadingWheel];
            [imageV setUrl:[NSURL URLWithString:@"http://idna.center/sites/default/files/ic_profile.png"]];
            // [img setImage:[UIImage imageWithData:fileData]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            
            cell.labelName.text =[NSString stringWithFormat:@"MPP : %ld", indexPath.row + 1];
            cell.labelName.textColor = [UIColor whiteColor];
        }
        
        return cell;
    }else if (collectionView == cVFollowing) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cVFollowing" forIndexPath:indexPath];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:[[cell contentView] frame]];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setText:[NSString stringWithFormat:@"FLL : %ld", indexPath.row + 1]];
        
        
        [cell setBackgroundColor:[UIColor greenColor]];
        [cell addSubview:lbl];
        
        return cell;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cell Tap" message:[NSString stringWithFormat:@"Cell : %ld selected", indexPath.row + 1] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    */
    
    if (collectionView == cVMyApplication) {
    
        if (indexPath.row == 0) {
            // Create New MyApplication
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            CreateMyApplication *ivAddNew = [storybrd instantiateViewControllerWithIdentifier:@"CreateMyApplication"];
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ivAddNew];
            
            // http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller
            // get register to fetch notification
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(createMyApp:)
                                                         name:@"createMyApp" object:nil];
            
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

@end
