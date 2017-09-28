//
//  UICollectionViewFlowLayout+Helpers.h
//  CollectionView
//
//  Created by Somkid on 9/7/2560 BE.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionViewFlowLayout (Helpers)

- (BOOL)indexPathLastInSection:(NSIndexPath *)indexPath ;
- (BOOL)indexPathInLastLine:(NSIndexPath *)indexPath ;
- (BOOL)indexPathLastInLine:(NSIndexPath *)indexPath ;
@end
