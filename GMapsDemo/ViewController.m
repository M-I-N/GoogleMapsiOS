//
//  ViewController.m
//  GMapsDemo
//
//  Created by Nayem BJIT on 6/21/17.
//  Copyright © 2017 Nayem BJIT. All rights reserved.
//

@import GoogleMaps;
#import "ViewController.h"

#pragma mark - Constants
NSString * const kJSONAssetName = @"LocationData";
NSString * const kLocationInfoKey = @"LocationInfo";
NSString * const kLatitudeKey = @"Latitude";
NSString * const kLongitudeKey = @"Longitude";
NSString * const kAddressKey = @"Address";
NSString * const kImageName = @"MapMarker";

@interface ViewController () <GMSMapViewDelegate>

@property (strong, nonatomic) GMSMapView *mapView;

@end

@implementation ViewController {
    GMSMarker *_marker;
    UIImageView *_markerImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CLLocationCoordinate2D cameraPosition = [self initialCameraPosition];
    [self loadGMapsInViewWithLatitude:cameraPosition.latitude logitude:cameraPosition.longitude andZoomLevel:13];
    [self configureMarkerAppearance];
    [self putMarkersInMapView];
    [self drawPolyLines];
}

- (CLLocationCoordinate2D)initialCameraPosition {
    NSDictionary *locationInfoDictionary = [self JSONFromFile];
    NSArray *locationInfos = [locationInfoDictionary valueForKey:kLocationInfoKey];
    NSUInteger count = [locationInfos count];
    NSUInteger midposition = (count - 1)/2;
    NSDictionary *middleLocation = [locationInfos objectAtIndex:midposition-1];
    NSString *latitudeString = middleLocation[kLatitudeKey];
    NSString *longitudeString = middleLocation[kLongitudeKey];
    CLLocationDegrees latitude = latitudeString.doubleValue;
    CLLocationDegrees longitude = longitudeString.doubleValue;
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
    return position;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Configuration Methods

- (void)loadGMapsInViewWithLatitude:(CLLocationDegrees)latitude logitude:(CLLocationDegrees)longitude andZoomLevel:(float)zoom {
    
    // Create a GMSCameraPosition that tells the map to display the coordinate (latitude, longitude) with zoom
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:zoom];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    self.view = self.mapView;
    
}

- (void)configureMarkerAppearance {
    UIImage *image = [UIImage imageNamed:kImageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _markerImageView = [[UIImageView alloc]initWithImage:image];
    _markerImageView.tintColor = [UIColor blueColor];
}

#pragma mark - Marker placing & Line drawing

- (void)putMarkersInMapView {
    
    NSDictionary *locationInfoDictionary = [self JSONFromFile];
    NSArray *locationInfos = [locationInfoDictionary valueForKey:kLocationInfoKey];
    for (NSDictionary *each in locationInfos) {
        
        NSString *latitudeString = each[kLatitudeKey];
        NSString *longitudeString = each[kLongitudeKey];
        CLLocationDegrees latitude = latitudeString.doubleValue;
        CLLocationDegrees longitude = longitudeString.doubleValue;
        
        // Creates a marker in the center of the map.
        _marker = [[GMSMarker alloc] init];
        _marker.position = CLLocationCoordinate2DMake(latitude, longitude);
        //        marker.title = each[@"Id"];
        _marker.snippet = each[kAddressKey];
        _marker.iconView = _markerImageView;
        _marker.appearAnimation = kGMSMarkerAnimationPop;
        _marker.map = self.mapView;
    }
}

- (void)drawPolyLines {
    NSDictionary *locationInfoDictionary = [self JSONFromFile];
    NSArray *locationInfos = [locationInfoDictionary valueForKey:kLocationInfoKey];
    GMSMutablePath *path = [GMSMutablePath path];
    for (NSDictionary *each in locationInfos) {
        NSString *latitudeString = each[kLatitudeKey];
        NSString *longitudeString = each[kLongitudeKey];
        CLLocationDegrees latitude = latitudeString.doubleValue;
        CLLocationDegrees longitude = longitudeString.doubleValue;
        [path addLatitude:latitude longitude:longitude];
    }
    GMSPolyline *polyLine = [GMSPolyline polylineWithPath:path];
    polyLine.strokeColor = [UIColor purpleColor];
    polyLine.strokeWidth = 5.0f;
    polyLine.map = self.mapView;
    
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    [UIView animateWithDuration:5.0 animations:^{
        _markerImageView.tintColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        _marker.tracksViewChanges = NO;
    }];
}

#pragma mark - Helper Methods

- (NSDictionary *)JSONFromFile {
    NSDataAsset *locationAsset = [[NSDataAsset alloc]initWithName:kJSONAssetName bundle:[NSBundle mainBundle]];
    
    return [NSJSONSerialization JSONObjectWithData:locationAsset.data options:kNilOptions error:nil];
}

@end
