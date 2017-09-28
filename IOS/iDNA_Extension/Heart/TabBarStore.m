//
//  TabBarHome.m
//  Heart
//
//  Created by Somkid on 1/11/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "TabBarStore.h"
#import "RecipeViewCell.h"
#import "RecipeCollectionHeaderView.h"
#import "IDReusableView.h"
#import "MyID.h"
#import "CreateMyApplication.h"
#import "CreateMyCard.h"
#import "Configs.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "PreLogin.h"
#import "MyApp.h"
#import "MyCard.h"
#import "HeaderTabStoreCell.h"
#import "GetStoreThread.h"
#import "TabStoreCell.h"

#import "Utility.h"

@interface TabBarStore (){
    NSMutableArray *sectionTitleArray;
    NSMutableDictionary *data;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSMutableArray * _datasource;
    
    UIPageControl* pageControl;
}
@end

@implementation TabBarStore
@synthesize preferences;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _datasource = [[NSMutableArray alloc] init];
    
    preferences = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary* capplication = [[Configs sharedInstance] loadData:_CATEGORY_APPLICATION];
    
    // ชื่อ Section
    if (!sectionTitleArray) {
        // sectionTitleArray = [NSMutableArray arrayWithObjects: @"", @"My Application 1", @"My Application 2", @"My Application 3", @"My Application 4", @"My Application 5", nil];
        
        sectionTitleArray = [NSMutableArray arrayWithObjects: @"", @"Brand and Business", @"Services", @"Entertainment", @"Finance", @"Academy", @"Medical", @"IT and Technology", @"Other" , @"Personal", nil];
    }
    
    /*
    // Initialize recipe image array
    NSArray *arrProfile = [NSArray arrayWithObjects: nil];
    
    NSArray *arrMyCard = [NSArray arrayWithObjects: nil];
    
    NSArray *arrMyApplication = [NSArray arrayWithObjects: nil];
    */
    
    // recipeImages = [NSArray arrayWithObjects:arrProfile, arrMyCard, arrMyApplication, nil];
    
//    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self._collection.collectionViewLayout;
//    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
    
    
    [self._collection registerNib:[UINib nibWithNibName:@"HeaderTabStoreCell" bundle:nil]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:@"HeaderTabStoreCell"];
    
    [self._collection registerNib:[UINib nibWithNibName:@"RecipeCollectionHeaderView" bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:@"RecipeCollectionHeaderView"];
    
    [self._collection registerNib:[UINib nibWithNibName:@"TabStoreCell" bundle:nil] forCellWithReuseIdentifier:@"TabStoreCell"];

    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center=self.view.center;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    self._collection.hidden = YES;
    
    CGFloat bottom =  self.tabBarController.tabBar.frame.size.height;
    NSLog(@"%f",bottom);
    [self._collection setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -bottom, 0)];
    
    [self._collection setBackgroundColor:[Utility colorDefualt]];
    
    
    [self reloadDataCenter:nil];
    [self reloadDataCenterSlide:nil];
}

- (void)viewDidLayoutSubviews {
    activityIndicator.center = self.view.center;
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadDataCenter:)
                                                     name:@"reloadDataCenter"
                                                   object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadDataCenterSlide:)
                                                 name:@"reloadDataCenterSlide"
                                               object:nil];
    

}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadDataCenter" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadDataCenterSlide" object:nil];
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

-(void) managedImageSet:(HJManagedImageV*)mi
{
    mi.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

/* จำนวน section */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [sectionTitleArray count];
}

/* จำนวน item ของแต่ละ section */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        
    @try {
        NSArray * tmp = [data valueForKey:[sectionTitleArray objectAtIndex:section]];
        switch (section) {
            case 0:
            {
                return 0;
            }
                break;
    
            default:
            {
                if ([tmp count] == 0) {
                    return 0;
                }else{
                    return [tmp count];
                }

            }
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
    
    switch (section) {
        case 0:
        {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
            break;
            
        default:
            break;
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// ความสูงของแต่ Section header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    
    switch (section) {
        case 0:
        {
            return CGSizeMake(0, 180);
        }
            break;
            
        default:{
            
            NSArray * tmp = [data valueForKey:[sectionTitleArray objectAtIndex:section]];
            
            if ([tmp count] == 0) {
                return CGSizeMake(0, 0);
            }else{
                return CGSizeMake(0, 30);
            }
        }
            break;
    }
    return CGSizeMake(0, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    NSLog(@"");
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        switch (indexPath.section) {
            case 0:
            {
                // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                // NSMutableDictionary *_dict = [[Configs sharedInstance] loadData:_USER]; // [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
                
                // NSDictionary*data =  [[Configs sharedInstance] loadData:_DATA];
                
                HeaderTabStoreCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderTabStoreCell" forIndexPath:indexPath];
                
                /*
                [headerView.photo clear];
                if ([data objectForKey:@"picture"]) {
                    NSDictionary *pic       = [data objectForKey:@"picture"];
                    
                    NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [pic objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    [headerView.photo showLoadingWheel];
                    [headerView.photo setUrl:[NSURL URLWithString:url]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:headerView.photo ];
                }else{
                    [headerView.photo setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
                }

                headerView.labelName.text = [data objectForKey:@"display_name"];
                
                headerView.tvStatus.text =  [data objectForKey:@"status_message"];
                
            
                headerView.tvStatus.textContainerInset = UIEdgeInsetsZero;
                
                UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
                [headerView addGestureRecognizer:headerTapped];
                */
                
                //
                
                
                // headerView.backgroundColor = [UIColor clearColor];
                
                // KASlideshow
                headerView.ksView.datasource = self;
                headerView.ksView.delegate = self;
                [headerView.ksView setDelay:3]; // Delay between transitions
                [headerView.ksView setTransitionDuration:.5]; // Transition duration
                [headerView.ksView setTransitionType:KASlideShowTransitionSlideHorizontal]; // Choose a transition type (fade or slide)
                [headerView.ksView setImagesContentMode:UIViewContentModeScaleToFill]; // Choose a content mode for images to display
                // [headerView.ksView addGesture:KASlideShowGestureTap]; // Gesture to go previous/next directly on the image
                [headerView.ksView addGesture:KASlideShowGestureSwipe];
                
//                UITapGestureRecognizer  *KASlideShowTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KASlideShowTapped:)];
//                [headerView.ksView addGestureRecognizer:KASlideShowTapped];
                
                [headerView.ksView start];
                
                
                pageControl = headerView.pageControl;
                // headerView.pageControl.numberOfPages = 3; //as we added 3 diff views
                // headerView.pageControl.currentPage = 0;
                pageControl.numberOfPages = [_datasource count];
                pageControl.currentPage = 0;
                
                reusableview = headerView;
            }
                break;
                
        
            default:{
                
                RecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RecipeCollectionHeaderView" forIndexPath:indexPath];
                NSString *title = [[NSString alloc]initWithFormat:@"My Application"];
                headerView.title.text = [sectionTitleArray objectAtIndex:indexPath.section];
                // UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
                // headerView.backgroundImage.image = headerImage;
                
                headerView.title.textColor = [UIColor whiteColor];

                
                headerView.labelSeeAll.text = @"See All";
                headerView.labelSeeAll.textColor = [UIColor whiteColor];
                
                reusableview = headerView;
            }
                break;
        }
    }

    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    RecipeViewCell *cell = nil;
    
    NSLog(@"%d", indexPath.section);
    
    switch (indexPath.section) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:{
            NSMutableArray * _items = [data valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
            NSDictionary *_item = [_items objectAtIndex:indexPath.row];
            
            TabStoreCell* cell = (TabStoreCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TabStoreCell" forIndexPath:indexPath];
            
            cell.labelName.text = [_item objectForKey:@"name"];
                
            NSMutableDictionary *picture = [_item valueForKey:@"picture"];
            
            HJManagedImageV *imageV =(HJManagedImageV *)cell.hjImageV;
            imageV.callbackOnSetImage = (id)self;
            [imageV clear];
            if ([picture count] > 0 ) {
                [imageV showLoadingWheel];
                    
                NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                [imageV setUrl:[NSURL URLWithString:url]];
                // [img setImage:[UIImage imageWithData:fileData]];
                imageV.layer.cornerRadius = 5;
                imageV.clipsToBounds = YES;
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
                
                
            }else{
                [imageV setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
            }
            
            [Utility roundView:imageV onCorner:UIRectCornerAllCorners radius:5.0f];
            
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
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:{
            NSMutableArray * _items = [data valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
            NSDictionary *_item = [_items objectAtIndex:indexPath.row];
            
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyApp *v    = [storybrd instantiateViewControllerWithIdentifier:@"MyApp"];
            v.owner_id  = [_item objectForKey:@"owner_id"];
            v.item_id   = [_item objectForKey:@"item_id"];
            v.category  = [_item objectForKey:@"category"];
            // [self.navigationController pushViewController:v animated:YES];
            
            // UIViewController *control = [[MyViewController alloc] initWithNibName: @"MyViewController" bundle: nil];
            UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController: v];
            [self presentModalViewController: navControl animated: YES];
        }
            break;
        default:
            break;
    }
}

- (void) reloadDataCenter:(NSNotification *) notification{
    
    NSMutableDictionary* center = [[Configs sharedInstance] loadData:_CENTER];
    
    NSMutableDictionary *_tmp = [[NSMutableDictionary alloc] init];
    NSMutableArray *_item1 = [[NSMutableArray alloc] init];
    NSMutableArray *_item2 = [[NSMutableArray alloc] init];
    NSMutableArray *_item3 = [[NSMutableArray alloc] init];
    NSMutableArray *_item4 = [[NSMutableArray alloc] init];
    NSMutableArray *_item5 = [[NSMutableArray alloc] init];
    NSMutableArray *_item6 = [[NSMutableArray alloc] init];
    NSMutableArray *_item7 = [[NSMutableArray alloc] init];
    NSMutableArray *_item8 = [[NSMutableArray alloc] init];
    NSMutableArray *_item9 = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary* items in center) {
        if (items != (id)[NSNull null]) {
            for (NSString* key in items) {
                NSDictionary * item =[items objectForKey:key];
                switch ([[item objectForKey:@"category"] integerValue]) {
                    case 1:{
                        [_item1 addObject:item];
                    }
                        break;
                        
                    case 2:{
                        [_item2 addObject:item];
                        
                    }
                        break;
                        
                    case 3:{
                        [_item3 addObject:item];
                    }
                        break;
                        
                    case 4:{
                        [_item4 addObject:item];
                    }
                        break;
                        
                    case 5:{
                        [_item5 addObject:item];
                    }
                        break;
                        
                    case 6:{
                        [_item6 addObject:item];
                    }
                        break;
                        
                    case 7:{
                        [_item7 addObject:item];
                    }
                        break;
                        
                    case 8:{
                        [_item8 addObject:item];
                    }
                        break;
                        
                    case 9:{
                        [_item9 addObject:item];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
        }
    }
    
    [_tmp setValue:_item1 forKey:[sectionTitleArray objectAtIndex:1]];
    [_tmp setValue:_item2 forKey:[sectionTitleArray objectAtIndex:2]];
    [_tmp setValue:_item3 forKey:[sectionTitleArray objectAtIndex:3]];
    [_tmp setValue:_item4 forKey:[sectionTitleArray objectAtIndex:4]];
    [_tmp setValue:_item5 forKey:[sectionTitleArray objectAtIndex:5]];
    [_tmp setValue:_item6 forKey:[sectionTitleArray objectAtIndex:6]];
    [_tmp setValue:_item7 forKey:[sectionTitleArray objectAtIndex:7]];
    [_tmp setValue:_item8 forKey:[sectionTitleArray objectAtIndex:8]];
    [_tmp setValue:_item9 forKey:[sectionTitleArray objectAtIndex:9]];
    
    data = _tmp;
    
    self._collection.hidden = NO;
    [self._collection reloadData];
    
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];


    /*
    GetStoreThread *sThread = [[GetStoreThread alloc] init];
    [sThread setCompletionHandler:^(NSString *output) {
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:output  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            NSMutableArray *_data = jsonDict[@"data"];
            NSMutableArray *_slide = jsonDict[@"slides"];
    
            NSMutableDictionary *_tmp = [[NSMutableDictionary alloc] init];
            
            // slide
            [_tmp setValue:[[NSMutableDictionary alloc] init] forKey:[sectionTitleArray objectAtIndex:0]];
            
            NSMutableArray *_item1 = [[NSMutableArray alloc] init];
            NSMutableArray *_item2 = [[NSMutableArray alloc] init];
            NSMutableArray *_item3 = [[NSMutableArray alloc] init];
            NSMutableArray *_item4 = [[NSMutableArray alloc] init];
            NSMutableArray *_item5 = [[NSMutableArray alloc] init];
            NSMutableArray *_item6 = [[NSMutableArray alloc] init];
            NSMutableArray *_item7 = [[NSMutableArray alloc] init];
            NSMutableArray *_item8 = [[NSMutableArray alloc] init];
            NSMutableArray *_item9 = [[NSMutableArray alloc] init];
            for (NSMutableDictionary* object in _data) {
                NSString *tid = [[[[object objectForKey:@"item"] objectForKey:@"field_my_app_category"] objectForKey:@"und"][0] objectForKey:@"tid"];
                
                switch ([tid integerValue]) {
                    case 1:{
                        [_item1 addObject:object];
                    }
                        break;
                        
                    case 2:{
                        [_item2 addObject:object];
                        
                    }
                        break;
                        
                    case 3:{
                        [_item3 addObject:object];
                    }
                        break;
                        
                    case 4:{
                        [_item4 addObject:object];
                    }
                        break;
                        
                    case 5:{
                        [_item5 addObject:object];
                    }
                        break;
                        
                    case 6:{
                        [_item6 addObject:object];
                    }
                        break;
                        
                    case 7:{
                        [_item7 addObject:object];
                    }
                        break;
                        
                    case 8:{
                        [_item8 addObject:object];
                    }
                        break;
                        
                    case 9:{
                        [_item9 addObject:object];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            [_tmp setValue:_item1 forKey:[sectionTitleArray objectAtIndex:1]];
            [_tmp setValue:_item2 forKey:[sectionTitleArray objectAtIndex:2]];
            [_tmp setValue:_item3 forKey:[sectionTitleArray objectAtIndex:3]];
            [_tmp setValue:_item4 forKey:[sectionTitleArray objectAtIndex:4]];
            [_tmp setValue:_item5 forKey:[sectionTitleArray objectAtIndex:5]];
            [_tmp setValue:_item6 forKey:[sectionTitleArray objectAtIndex:6]];
            [_tmp setValue:_item7 forKey:[sectionTitleArray objectAtIndex:7]];
            [_tmp setValue:_item8 forKey:[sectionTitleArray objectAtIndex:8]];
            [_tmp setValue:_item9 forKey:[sectionTitleArray objectAtIndex:9]];
            
            data = _tmp;
            
            
            self._collection.hidden = NO;
            [self._collection reloadData];
            
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        }else{}
    }];
    
    [sThread setErrorHandler:^(NSString *error) {
    }];
    [sThread start];
    */
}

- (void) reloadDataCenterSlide:(NSNotification *) notification{
    
    NSMutableDictionary* center_slide = [[Configs sharedInstance] loadData:_CENTER_SLIDE];
    
    _datasource = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary* item in center_slide) {
        NSString *URI = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL,  [[[[center_slide objectForKey:item] objectForKey:@"picture"] objectForKey:@"filename"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        
        [_datasource addObject:[NSURL URLWithString:URI]];
    }
    
    pageControl.numberOfPages = [_datasource count];
}

// set ให้ TextView มี padding l, t, r, b = 0
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv     contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    [tv setContentInset:UIEdgeInsetsMake(topCorrect,0,0,0)];
}

#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyID *myID = [storybrd instantiateViewControllerWithIdentifier:@"MyID"];
    [self.navigationController pushViewController:myID animated:YES];
}

#pragma mark - KASlideShow datasource
- (NSObject *)slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index
{
    return _datasource[index];
}

- (NSUInteger)slideShowImagesNumber:(KASlideShow *)slideShow
{
    return _datasource.count;
}

#pragma mark - KASlideShow delegate

- (void) slideShowWillShowNext:(KASlideShow *)slideShow
{
    NSLog(@"slideShowWillShowNext, index : %@",@(slideShow.currentIndex));
    
    pageControl.currentPage =slideShow.currentIndex;
}

- (void) slideShowWillShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"slideShowWillShowPrevious, index : %@",@(slideShow.currentIndex));
     pageControl.currentPage =slideShow.currentIndex;
}

- (void) slideShowDidShowNext:(KASlideShow *)slideShow
{
    NSLog(@"slideShowDidShowNext, index : %@",@(slideShow.currentIndex));
}

-(void) slideShowDidShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"slideShowDidShowPrevious, index : %@",@(slideShow.currentIndex));
}

@end
