//
//  AFViewController.m
//  AFTabledCollectionView
//
//  Created by Ash Furrow on 2013-03-14.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"
#import "AFTableViewCell.h"
#import "iCell.h"

#import "CollectionViewCell.h"

#import "Utility.h"
#import "AppDelegate.h"

#import "AFHeaderContentView.h"

@interface AFViewController (){
    NSMutableArray * _datasource;
    UIPageControl* pageControl;
}

@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;

@end

@implementation AFViewController

-(void)loadView
{
    [super loadView];
    
    const NSInteger numberOfTableViewRows = 8;
    const NSInteger numberOfCollectionViewCells = 10;
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
    
    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
    {
        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:numberOfCollectionViewCells];
        
        for (NSInteger collectionViewItem = 0; collectionViewItem < numberOfCollectionViewCells; collectionViewItem++)
        {
            
            CGFloat red = arc4random() % 255;
            CGFloat green = arc4random() % 255;
            CGFloat blue = arc4random() % 255;
            UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
            
            [colorArray addObject:color];
        }
        
        [mutableArray addObject:colorArray];
    }
    
    self.colorArray = [NSArray arrayWithArray:mutableArray];
    
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"iCell" bundle:nil] forCellReuseIdentifier:@"iCell"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // self.automaticallyAdjustsScrollViewInsets = NO;
    
    /*
     แก้ไขกรณี navigationbar headerview
     */
    self.edgesForExtendedLayout = UIRectEdgeNone;
   /*
    UIView *bottomFloatingView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 150)];
    [bottomFloatingView setBackgroundColor:[UIColor yellowColor]];
    // [self.tableView bringSubviewToFront:bottomFloatingView];
    
    self.tableView.tableHeaderView = bottomFloatingView;
    */
    
    _datasource = [[NSMutableArray alloc] init];
    [self reloadDataCenterSlide:nil];
    
    
    CGFloat headerHeight = 200.0f;
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, headerHeight)];
    // UIView *headerContentView = [[UIView alloc] initWithFrame:headerView.bounds];
    // headerContentView.backgroundColor = [UIColor greenColor];
    // headerContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    AFHeaderContentView *headerContentView = [[[NSBundle mainBundle] loadNibNamed:@"AFHeaderContentView" owner:self options:nil] objectAtIndex:0];
    [headerContentView setBackgroundColor:[Utility colorDefualt]];
    [headerContentView setFrame:headerView.bounds];
    

     // KASlideshow
     headerContentView.ksView.datasource = self;
     headerContentView.ksView.delegate = self;
     [headerContentView.ksView setDelay:3]; // Delay between transitions
     [headerContentView.ksView setTransitionDuration:.5]; // Transition duration
     [headerContentView.ksView setTransitionType:KASlideShowTransitionSlideHorizontal]; // Choose a transition type (fade or slide)
     [headerContentView.ksView setImagesContentMode:UIViewContentModeScaleToFill]; // Choose a content mode for images to display
     // [headerView.ksView addGesture:KASlideShowGestureTap]; // Gesture to go previous/next directly on the image
     [headerContentView.ksView addGesture:KASlideShowGestureSwipe];
     
     // UITapGestureRecognizer  *KASlideShowTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KASlideShowTapped:)];
     // [headerView.ksView addGestureRecognizer:KASlideShowTapped];
     
     [headerContentView.ksView start];
     
     pageControl = headerContentView.pageControl;
     // headerView.pageControl.numberOfPages = 3; //as we added 3 diff views
     // headerView.pageControl.currentPage = 0;
     pageControl.numberOfPages = [_datasource count];
     pageControl.currentPage = 0;
    
    [headerView addSubview:headerContentView];
    self.tableView.tableHeaderView = headerView;
    
    // layout.sectionInset = UIEdgeInsetsMake(hmSegmentC.frame.size.height + 5, 5, ([Configs sharedInstance].kBarHeight + 15), 5);

    self.tableView.allowsSelection = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[Utility colorDefualt]];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 25;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
//    [label setFont:[UIFont boldSystemFontOfSize:12]];
//    // NSString *string =[list objectAtIndex:section];
//    /* Section header is in 0th index... */
//    [label setText:[NSString stringWithFormat:@"Section : %ld", (long)section]];
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
//    
//    
//    tableView.tableHeaderView =view;
//    return view;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    // self.tableView.tag = 1;
//    // if ( [tableView tag] == 1 ) {
//    //    return @"TableView One Title";
//    // }
//    return @"other Tableview Title";
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.colorArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int section = indexPath.section;
    if (indexPath.row % 2 == 0) {
        //
        static NSString *CellIdentifier = @"iCell";
//        iCell *cell = (iCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        if (!cell)
//        {
//            cell = [[iCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
        
        iCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iCell" forIndexPath:indexPath];
        
        [cell setBackgroundColor:[Utility colorDefualt]];
        
        return cell;
        
    }else{
        static NSString *CellIdentifier = @"CellIdentifier";
    
        AFTableViewCell *cell = (AFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if (!cell)
        {
            cell = [[AFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        /*
         จะได้ row แต่ละ tableview เราจะได้รู็ว่าเรา click row ไหนของ tableview
         */
        cell.collectionView.tableViewSection = indexPath.section;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(AFTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[AFTableViewCell class]]){
        
        [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
        NSInteger index = cell.collectionView.indexPath.row;
        
        CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
        [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
    }
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return 40;
    }else{
        return 140;
    }
}

#pragma mark - UICollectionViewDataSource Methods
// https://stackoverflow.com/questions/10317169/setcontentmode-for-hjmanagedimagev-is-not-working-for-ios
-(void) managedImageSet:(HJManagedImageV*)mi
{
    mi.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [Utility roundView:mi onCorner:UIRectCornerAllCorners radius:5.0f];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 120);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *collectionViewArray = self.colorArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
    return collectionViewArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
//    
//    NSArray *collectionViewArray = self.colorArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
//    cell.backgroundColor = collectionViewArray[indexPath.item];
    
    CollectionViewCell* cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    // [cell setBackgroundColor:[UIColor greenColor]];
    
    HJManagedImageV *imageV =(HJManagedImageV *)cell.imageV;
    imageV.callbackOnSetImage = (id)self;

    [imageV clear];
    [imageV showLoadingWheel];
    [imageV setUrl:[NSURL URLWithString:@"http://idna.center/sites/default/files/ic_profile.png"]];
    // [imageV setImage:[UIImage imageNamed:@"ic_create_new_application.png"]];
    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
    
    
    NSIndexPath *path = [(AFIndexedCollectionView *)collectionView indexPath];
    
    
    /*
     จะได้ row แต่ละ tableview เราจะได้รู็ว่าเรา click row ไหนของ tableview
    
     [(AFIndexedCollectionView *)collectionView tableViewSection]
     */

    
    NSLog(@"cellForItemAtIndexPath >  : %d - %d - %d", path.section, path.row, [(AFIndexedCollectionView *)collectionView tableViewSection]);
    // NSLog(@"cellForItemAtIndexPath : %d - %d - %d", indexPath.section, indexPath.row, [(AFIndexedCollectionView *)collectionView indexPath].row);
    
//    imageV.userInteractionEnabled = YES;
//    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(falconTapped:)];
//    [imageV addGestureRecognizer:headerTapped];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d - %d - %d", indexPath.section, indexPath.row, [(AFIndexedCollectionView *)collectionView tableViewSection]);
}

#pragma mark - gesture tapped
- (void)falconTapped:(UITapGestureRecognizer *)gestureRecognizer{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cell Tap" message:[NSString stringWithFormat:@"Cell selected"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]){
        
        CGFloat offsetY = scrollView.contentOffset.y;
        UIView *headerContentView = self.tableView.tableHeaderView.subviews[0];
        
        NSLog(@"--> contentOffset.y %f ", offsetY);
        NSLog(@"--> contentOffset.y MIN %f ", MIN(offsetY, 0));
        
        if (offsetY < 0) {
            headerContentView.transform = CGAffineTransformMakeTranslation(0, MIN(offsetY, 0));
        }
        
        // return;
    }else{
    
        CGFloat horizontalOffset = scrollView.contentOffset.x;
    
        AFIndexedCollectionView *collectionView = (AFIndexedCollectionView *)scrollView;
        NSInteger index = collectionView.indexPath.row;
        self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
    }
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
