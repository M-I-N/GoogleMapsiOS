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

@property (strong, nonatomic) GMSMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CLLocationCoordinate2D cameraPosition = [self positionForCameraSetup];
    [self loadGMapsInViewWithLatitude:cameraPosition.latitude logitude:cameraPosition.longitude andZoomLevel:13];
    [self putMarkersInMapView];

}

- (void)loadGMapsInViewWithLatitude:(CLLocationDegrees)latitude logitude:(CLLocationDegrees)longitude andZoomLevel:(float)zoom {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.808114, 151.211825 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:zoom];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;

}

- (void)putMarkersInMapView {

    NSDictionary *locationInfoDictionary = [self JSONFromFile];
    NSArray *locationInfos = [locationInfoDictionary valueForKey:@"LocationInfo"];
    for (NSDictionary *each in locationInfos) {
        
        NSString *latitudeString = each[@"Latitude"];
        NSString *longitudeString = each[@"Longitude"];
        CLLocationDegrees latitude = latitudeString.doubleValue;
        CLLocationDegrees longitude = longitudeString.doubleValue;
        
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
//        marker.title = each[@"Id"];
        marker.snippet = each[@"Address"];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = self.mapView;
    }
}

- (NSDictionary *)JSONFromFile
{
    NSDataAsset *locationAsset = [[NSDataAsset alloc]initWithName:@"locationData" bundle:[NSBundle mainBundle]];
    
    return [NSJSONSerialization JSONObjectWithData:locationAsset.data options:kNilOptions error:nil];
}

- (CLLocationCoordinate2D)positionForCameraSetup {
    NSDictionary *locationInfoDictionary = [self JSONFromFile];
    NSArray *locationInfos = [locationInfoDictionary valueForKey:@"LocationInfo"];
    NSUInteger count = [locationInfos count];
    NSUInteger midposition = (count - 1)/2;
    NSDictionary *middleLocation = [locationInfos objectAtIndex:midposition-1];
    NSString *latitudeString = middleLocation[@"Latitude"];
    NSString *longitudeString = middleLocation[@"Longitude"];
    CLLocationDegrees latitude = latitudeString.doubleValue;
    CLLocationDegrees longitude = longitudeString.doubleValue;
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
    return position;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
