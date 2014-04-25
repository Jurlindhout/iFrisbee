//
//  JRLCLLocationController.h
//  iFrisbee
//
//  Created by Jurriaan Lindhout on 24-04-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JRLCLLocationController : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (double)getTrueHeading;

- (double)getY;

@end
