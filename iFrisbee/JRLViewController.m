//
//  JRLViewController.m
//  iFrisbee
//
//  Created by Jurriaan Lindhout on 23-04-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

#import "JRLViewController.h"

@interface JRLViewController ()

@end

@implementation JRLViewController {
    Boolean _startIsSet;
    Boolean _goalIsSet;
    Boolean _throwDirectionIsSet;
    GMSMarker *_start;
    GMSMarker *_goal;
    GMSMarker *_frisbee;
    JRLView *_view;
    UILabel *_title;
    UIButton *_button;
    GMSMapView *_mapView;
    GMSPanoramaView *_panoView;
    GMSCameraPosition *_cameraPosition;
    CLLocationDirection headingFrisbeeToGoal;
    Boolean mayThrow;
    CMMotionManager *motionManager;
    float xAxes;
    float speed;
    float throwDirection;
    float _heading;
    UIImageView *_imageView;
    UIImage *_frisbeeImg;
    float _currentView;
    GMSMutablePath *_throwCoordinates;
    Boolean _isAnimating;
    float _throwNumber;
    Boolean _mayThrow;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationController = [[JRLCLLocationController alloc] init];
    
    [self firstView];
}

-(void)firstView
{
    _isAnimating = false;
    _currentView = 1;
    _throwNumber = 0;
    
    _view = [[JRLView alloc] initWithFrame:self.view.bounds];
    
    _title = [_view newTitle:@"Choose startposition" frame:CGRectMake(_view.bounds.origin.x, _view.bounds.origin.y, _view.bounds.size.width, 50)];
    
    _button = [_view newButton:@"Next" frame:CGRectMake(_view.bounds.origin.x, _view.bounds.size.height - 50, _view.bounds.size.width, 50)];
    [_button addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _mapView = [_view newMap:CLLocationCoordinate2DMake(52.2129918, 5.2793703) zoomLevel:7 frame:CGRectMake(_view.bounds.origin.x, _view.bounds.origin.y + 50, _view.bounds.size.width, _view.bounds.size.height - 100) myLocation:YES myLocationBtn:YES];
    
    [_mapView setDelegate:self];
    
    [self.view addSubview:_view];
}

-(void)secondView
{
    _currentView = 2;
    _title.text = @"Choose Goal!";
    [_button setTitle:@"Lets Throw!" forState:UIControlStateNormal];
}

-(void)thirdView
{
    _currentView = 3;
    
    _title.text = @"Choose the throw direction.";
    
    [_button setTitle:@"Let's throw!" forState:UIControlStateNormal];
    _button.hidden = false;
    
    if (_panoView == NULL) {
        _panoView = [_view newPano:_start.position gesturesEnabled:YES heading:20 frame:CGRectMake(_view.bounds.origin.x, _view.bounds.origin.y + 50, _view.bounds.size.width, _view.bounds.size.height - 100)];
    } else {
        _panoView.frame = CGRectMake(_view.bounds.origin.x, _view.bounds.origin.y + 50, _view.bounds.size.width, _view.bounds.size.height - 100);
        [_panoView moveNearCoordinate:_frisbee.position];
        _panoView.hidden = false;
        _frisbee.icon = [UIImage imageNamed:@"frisbee_arrow.png"];
    }
    
    
    _goal.panoramaView = _panoView;
    _start.map = nil;
    
    [_mapView removeFromSuperview];
    [_mapView setFrame:CGRectMake(_view.bounds.size.width - 120, _view.bounds.size.height - 240, 110, 170)];
    [_mapView setMyLocationEnabled:NO];
    [_mapView.settings setMyLocationButton:NO];
    [_mapView.settings setAllGesturesEnabled:NO];
    
    
    [self.view addSubview:_mapView];
}

-(void)fourthView
{
    _currentView = 4;
    
    _title.text = @"Throw the frisbee!";
    
    _button.hidden = true;
    
    throwDirection = _heading;
    
    [_panoView setFrame:CGRectMake(_view.bounds.origin.x, _view.bounds.origin.y + 50, _view.bounds.size.width, _view.bounds.size.height - 50)];
    
    _mapView.hidden = true;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_view.bounds.size.width - 500, _view.bounds.size.height - 500, 500, 500)];
    _frisbeeImg = [UIImage imageNamed:@"frisbee_big.png"];
    _imageView.image = _frisbeeImg;
    [self.view addSubview:_imageView];
    _mayThrow = true;
    [self setMotionManager];
}

-(void)fithView
{
    _currentView = 5;
    _frisbee.icon = [UIImage imageNamed:@"frisbee.png"];
    _imageView.hidden = YES;
    _mapView.hidden = NO;
    _mapView.frame = CGRectMake(_view.bounds.origin.x, _view.bounds.origin.y + 50, _view.bounds.size.width, _view.bounds.size.height - 50);
    
    _mapView.camera = [GMSCameraPosition cameraWithTarget:_frisbee.position zoom:17 bearing:headingFrisbeeToGoal viewingAngle:0];
    
    
    
    [_mapView.settings setAllGesturesEnabled:YES];
}

-(void)sixthView
{
    _currentView = 6;
    _mapView.frame = CGRectMake(_view.bounds.origin.x, _view.bounds.origin.y + 50, _view.bounds.size.width, _view.bounds.size.height - 100);
    [_button setTitle:@"Next throw!" forState:UIControlStateNormal];
    _panoView.hidden = true;
    _button.hidden = false;
}

-(void)glkViewControllerUpdate:(GLKViewController *)controller
{
    NSLog(@"glkviewcontrollerupdate");
}

- (void)update
{
    headingFrisbeeToGoal = GMSGeometryHeading(_frisbee.position, _goal.position);
    [locationController.locationManager startUpdatingHeading];
    _heading = locationController.getTrueHeading;
    
    if (!_throwDirectionIsSet) {
        _panoView.camera = [GMSPanoramaCamera cameraWithHeading:round(_heading) pitch:10 zoom:1];
    } else {
        _panoView.camera = [GMSPanoramaCamera cameraWithHeading:round(_heading) pitch:-90 zoom:1];
    }
    
    if (_frisbee == NULL && _panoView.panorama.coordinate.latitude != 0) {
        _frisbee = [_view addMarkerToMap:_mapView position:_panoView.panorama.coordinate icon:@"frisbee_arrow.png" groundAnchor:CGPointMake(0.5f, 0.5f)];
        [_frisbee setFlat:YES];
        
        _start.position = _panoView.panorama.coordinate;
        
        
    } else if (_frisbee != NULL && _currentView != 5 && _currentView != 6) {
        _mapView.camera = [GMSCameraPosition cameraWithTarget:_frisbee.position zoom:15 bearing:_heading viewingAngle:45];
        _frisbee.rotation = _heading;
    }
    
    if (_isAnimating) {
        _frisbee.rotation += 10;
    }
    
}

- (void)throw
{
    _isAnimating = true;
    _throwNumber++;
    [self fithView];
    
    float earthRadial = 6371.1; // radial of earth
    float angle = throwDirection * M_PI / 180; // degrees to radians
    //float angle = 1.57;
    float distance = xAxes * 0.01 * -1; // distance in km
    
    float tempLat = _frisbee.position.latitude * M_PI / 180; // latitude in radians
    float tempLong = _frisbee.position.longitude * M_PI / 180; // longitude in radians
    
    
    float newLat = asin(sin(tempLat) * cos(distance / earthRadial) + cos(tempLat) * sin(distance / earthRadial) * cos(angle));
    
    float newLong = tempLong + atan2(sin(angle) * sin(distance / earthRadial) * cos(tempLat), cos(distance / earthRadial) - sin(tempLat) * sin(newLat));
    
    CLLocationCoordinate2D newCoordinate = CLLocationCoordinate2DMake(newLat * 180 / M_PI, newLong * 180 / M_PI);
    
    NSLog(@"coordinates: %f, %f", newCoordinate.latitude, newCoordinate.longitude);
    NSLog(@"distance: %f", GMSGeometryDistance(_frisbee.position, newCoordinate));
    NSLog(@"heading: %f", GMSGeometryHeading(_frisbee.position, newCoordinate));
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:5];
    [CATransaction setCompletionBlock:^{
        [self checkFinished];
    }];
    _start.map = _mapView;
    _frisbee.position = newCoordinate;
    [_mapView animateToLocation:newCoordinate];
    
    [_throwCoordinates addCoordinate:newCoordinate];
    if (_throwCoordinates == NULL) {
        _throwCoordinates = [[GMSMutablePath alloc] init];
        [_throwCoordinates insertCoordinate:newCoordinate atIndex:0];
    } else {
        [_throwCoordinates addCoordinate:newCoordinate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (!_startIsSet) {
        if (_start == NULL) {
            _start = [_view addMarkerToMap:mapView position:coordinate icon:@"start.png" groundAnchor:CGPointMake(0.5f, 1)];
        } else {
            [_start setPosition:coordinate];
        }
        
    } else if (!_goalIsSet) {
        if (_goal == NULL) {
            _goal = [_view addMarkerToMap:mapView position:coordinate icon:@"goal.png" groundAnchor:CGPointMake(0.5f, 0.5)];
        } else {
            [_goal setPosition:coordinate];
        }
    }
}

-(void)btnPressed
{
    if (!_startIsSet) {
        if (_start == NULL) {
            [self alert:@"Set startposition!" body:@"tap the map for 2 seconds."];
        } else {
            _startIsSet = true;
            [self secondView];
        }
        
    } else if (!_goalIsSet) {
        if (_goal == NULL) {
            [self alert:@"Set your Goal!" body:@"tap the map for 2 seconds."];
        } else {
            _goalIsSet = true;
            [self thirdView];
        }
    } else if (!_throwDirectionIsSet) {
        [self fourthView];
        _throwDirectionIsSet = true;
    } else if (_currentView == 6) {
        [self throwAgain];
    }
}



-(void)alert:(NSString*)title body:(NSString*)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)setMotionManager
{
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 0.1;

    if ([motionManager isAccelerometerAvailable])
    {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"x: %f", round(accelerometerData.acceleration.x * 100));
                xAxes = round(accelerometerData.acceleration.x * 10);
                
                if (xAxes < -12 ) {
                    if (_mayThrow) {
                        speed = xAxes * -1 / 10;
                        NSLog(@"trow with speed: %f, %@ %f", xAxes * -1 / 10, @"m/s and direction ", throwDirection);
                        [self throw];
                        _mayThrow = false;
                    }
                }
                
            });
        }];
    } else {
        NSLog(@"not active");
    }
}

-(void)checkFinished
{
    _isAnimating = false;
    CLLocationCoordinate2D lastLoc = [_throwCoordinates coordinateAtIndex:_throwCoordinates.count - 1];
    
    if (GMSGeometryDistance(lastLoc, _goal.position) < 50) {
        int num = (int)_throwNumber;
        NSString *body = [NSString stringWithFormat:@"You have reached your goal in %d %@", num, @" throws"];
        [self alert:@"Congratulations!!" body:body];
        [self firstView];
    } else {
        NSLog(@"not yet");
        int meters = GMSGeometryDistance(_frisbee.position, _goal.position);
        NSString *body = [NSString stringWithFormat:@"Yet %d %@", meters, @" meters to the centre of you goal."];
        [self alert:@"Not reached your goal yet!" body:body];
        [self sixthView];
    }
}

-(void)throwAgain
{
    _throwDirectionIsSet = false;
    [self thirdView];
}


@end
