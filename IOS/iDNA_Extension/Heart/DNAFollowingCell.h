//
//  DNAFollowingCell.h
//  Heart
//
//  Created by Somkid on 4/15/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface DNAFollowingCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmImage;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelNew;
@end
