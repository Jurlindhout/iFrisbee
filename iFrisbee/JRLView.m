//
//  JRLView.m
//  iFrisbee
//
//  Created by Jurriaan Lindhout on 23-04-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

#import "JRLView.h"

@implementation JRLView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UILabel *)newTitle:(NSString *)title frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    return label;
}

-(UIButton *)newButton:(NSString *)title frame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}

-(GMSMapView *)newMap:(CLLocationCoordinate2D)cameraPosition zoomLevel:(float)zoomLevel frame:(CGRect)frame myLocation:(Boolean)myLocation myLocationBtn:(Boolean)myLocationBtn
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:cameraPosition.latitude longitude:cameraPosition.longitude zoom:zoomLevel];
    GMSMapView *mapView = [GMSMapView mapWithFrame:frame camera:camera];
    mapView.myLocationEnabled = myLocation;
    mapView.settings.myLocationButton = myLocationBtn;
    [self addSubview:mapView];
    return mapView;
}

-(GMSPanoramaView*)newPano:(CLLocationCoordinate2D)position gesturesEnabled:(Boolean)gesturesEnabled heading:(float)heading frame:(CGRect)frame
{
    GMSPanoramaView *panoView = [[GMSPanoramaView alloc] initWithFrame:frame];
    
    [panoView moveNearCoordinate:position];
    [panoView setAllGesturesEnabled:gesturesEnabled];
    
    
    panoView.camera = [GMSPanoramaCamera cameraWithHeading:heading
                                                      pitch:20
                                                       zoom:1];
    [self addSubview:panoView];
    return panoView;
}

-(GMSMarker*)addMarkerToMap:(GMSMapView*)map position:(CLLocationCoordinate2D)coordinates icon:(NSString*)fileName groundAnchor:(CGPoint)groundAnchor;
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinates;
    marker.map = map;
    marker.groundAnchor = groundAnchor;
    [marker setIcon:[UIImage imageNamed:fileName]];
    return marker;
}

@end
