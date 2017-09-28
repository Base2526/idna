//
//  MyMapViewController.h
//  Heart
//
//  Created by Somkid on 11/9/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MyMapViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet MKMapView *_map;



@end
