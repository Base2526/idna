//
//  Contacts_AllFriendsCell.h
//  Heart
//
//  Created by Somkid on 9/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface Contacts_AllFriendsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end
