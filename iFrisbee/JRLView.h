//
//  JRLView.h
//  iFrisbee
//
//  Created by Jurriaan Lindhout on 23-04-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface JRLView : UIView<GMSMapViewDelegate, GMSPanoramaViewDelegate>

-(UILabel*)newTitle:(NSString*)title frame:(CGRect)frame;

-(UIButton*)newButton:(NSString*)title frame:(CGRect)frame;

-(GMSMapView*)newMap:(CLLocationCoordinate2D)cameraPosition zoomLevel:(float)zoomLevel frame:(CGRect)frame myLocation:(Boolean)myLocation myLocationBtn:(Boolean)myLocationBtn;

-(GMSPanoramaView*)newPano:(CLLocationCoordinate2D)position gesturesEnabled:(Boolean)gesturesEnabled heading:(float)heading frame:(CGRect)frame;

-(GMSMarker*)addMarkerToMap:(GMSMapView*)map position:(CLLocationCoordinate2D)coordinates icon:(NSString*)fileName groundAnchor:(CGPoint)groundAnchor;

@end
