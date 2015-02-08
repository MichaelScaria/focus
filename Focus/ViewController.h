//
//  ViewController.h
//  Focus
//
//  Created by Michael Scaria on 2/7/15.
//  Copyright (c) 2015 michaelscaria. All rights reserved.
//

@import CoreLocation;

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocationCoordinate2D location;
    
    UIView *circle;
}


@end

