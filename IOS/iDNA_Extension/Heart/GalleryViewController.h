//
//  GalleryViewController.h
//  SidebarDemo
//
//  Created by Somkid on 10/3/2559 BE.
//  Copyright © 2559 AppCoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *_collectionView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@end
