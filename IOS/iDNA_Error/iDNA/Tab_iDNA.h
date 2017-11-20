//
//  Tab_iDNA.h
//  iChat
//
//  Created by Somkid on 10/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab_iDNA  : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *_collection;
@property (strong, nonatomic) NSUserDefaults *preferences;

@end
