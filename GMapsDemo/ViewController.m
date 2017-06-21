//
//  ViewController.m
//  GMapsDemo
//
//  Created by Nayem BJIT on 6/21/17.
//  Copyright © 2017 Nayem BJIT. All rights reserved.
//

@import GoogleMaps;
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (GMSMapView *)loadGMapsInView:(UIView *)view withLatitude:(CLLocationDegrees)latitude logitude:(CLLocationDegrees)longitude andZoomLevel:(float)zoom {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.808114, 151.211825 at zoom level 6.
      GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:zoom];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    view = mapView;
    return mapView;
}

- (void)loadView {
    
    GMSMapView *commonMapView = [self loadGMapsInView:self.view withLatitude:33.808114 logitude:151.211825 andZoomLevel:6];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.808114, 151.211825);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = commonMapView;
    
    GMSMarker *marker2 = [[GMSMarker alloc] init];
    marker2.position = CLLocationCoordinate2DMake(-32.865032, 151.785861);
    marker2.title = @"Newcastle";
    marker2.snippet = @"Australia";
    marker2.map = commonMapView;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
