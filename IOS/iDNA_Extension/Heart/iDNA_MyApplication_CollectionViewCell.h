//
//  iDNA_MyApplication_CollectionViewCell.h
//  Heart
//
//  Created by Somkid on 9/9/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface iDNA_MyApplication_CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end
