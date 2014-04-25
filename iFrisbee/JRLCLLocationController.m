//
//  JRLCLLocationController.m
//  iFrisbee
//
//  Created by Jurriaan Lindhout on 24-04-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

#import "JRLCLLocationController.h"

@implementation JRLCLLocationController {
    float trueHeading;
    float y;
}

@synthesize locationManager;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        //self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self; // send loc updates to myself
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", [newLocation description]);
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    
    trueHeading = newHeading.trueHeading;
    y = newHeading.y;
    y = roundf(y);
    //NSLog(@"heading: %f", y);
}

- (double)getTrueHeading
{
    return (double)trueHeading;
}

- (double)getY
{
    return (double)y;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}

- (void)dealloc {
    //[self.locationManager release];
    //[super dealloc];
}

@end
