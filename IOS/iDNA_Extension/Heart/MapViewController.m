//
//  MapViewController.m
//  SidebarDemo
//
//  Created by Simon Ng on 10/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"

//define global constants to store the location
//for central park
#define CENTRAL_PARK_LAT 13.740196;
#define CENTRAL_PARK_LON 100.534208;

@interface MapViewController ()
{
    CLLocationManager *myLocationManager;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"แผนที่โรงเรียน";

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
   
    //the center of the region we'll move the map to
    CLLocationCoordinate2D center;
    center.latitude = CENTRAL_PARK_LAT;
    center.longitude = CENTRAL_PARK_LON;
    
    //set up zoom level
    MKCoordinateSpan zoom;
    zoom.latitudeDelta = .01f; //the zoom level in degrees
    zoom.longitudeDelta = .01f;//the zoom level in degrees
    
    //stores the region the map will be showing
    MKCoordinateRegion myRegion;
    myRegion.center = center;//the location
    myRegion.span = zoom;//set zoom level
    
    
    //programmatically create a map that fits the screen
    CGRect screen = [[UIScreen mainScreen] bounds];
    // MKMapView *mapView = [[MKMapView alloc] initWithFrame:screen ];
    
    //set the map location/region
    [self._map setRegion:myRegion animated:YES];
    
    self._map.mapType = MKMapTypeStandard;//standard map(not satellite)
    
    // Place a single pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:center];
    [annotation setTitle:@"Title"]; //You can set the subtitle too
    [self._map addAnnotation:annotation];
    
    // [self._map addSubview:mapView];//add map to the view
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


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self._map setCenterCoordinate:userLocation.coordinate animated:YES];
}

@end
