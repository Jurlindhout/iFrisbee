//
//  JRLViewController.h
//  iFrisbee
//
//  Created by Jurriaan Lindhout on 23-04-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>
#import "JRLView.h"
#import "JRLCLLocationController.h"


@interface JRLViewController : GLKViewController<GMSMapViewDelegate, GLKViewDelegate> {
    JRLCLLocationController *locationController;
}

@end
