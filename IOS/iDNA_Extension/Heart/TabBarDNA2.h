//
//  TabBarDNA2.h
//  Heart
//
//  Created by Somkid on 8/16/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface TabBarDNA2 : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSUserDefaults *preferences;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *hmSegmentC;
@property (weak, nonatomic) IBOutlet UICollectionView *_collection;

@end
