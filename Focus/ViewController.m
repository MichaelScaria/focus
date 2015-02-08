//
//  ViewController.m
//  Focus
//
//  Created by Michael Scaria on 2/7/15.
//  Copyright (c) 2015 michaelscaria. All rights reserved.
//

@import MapKit;

#import "ViewController.h"


#import "Event.h"
#import "Block.h"


#define GRAY       [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]
#define DARK_GRAY  [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1]

@interface ViewController ()
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ViewController

- (NSDate *)formatDate:(NSDate *)d {
    NSDateComponents *time = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:d];
    NSUInteger remainder = ([time minute] % 30);
    d = [d dateByAddingTimeInterval:60 * (30 - remainder)];
    return d;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    
    Event *e1 = [[Event alloc] init];
    e1.start = [NSDate new];
    e1.end = [NSDate dateWithTimeInterval:60 * 60 sinceDate:[NSDate new]];
    e1.title = @"Civitas Learning Hackathon";
    e1.location = @"Civitas Learning Center";
    e1.lat = 30.271350;
    e1.lon = -97.758080;
    
    
    Event *e2 = [[Event alloc] init];
    e2.start = [NSDate dateWithTimeInterval:60 * 60 * 3.5 sinceDate:[NSDate new]];
    e2.end = [NSDate dateWithTimeInterval:60 * 60 * 5 sinceDate:[NSDate new]];
    e2.title = @"Tea with Steve";
    e2.location = @"Cafe Medici";
    e2.lat = 30.284411;
    e2.lon = -97.742400;
    
    Event *e3 = [[Event alloc] init];
    e3.start = [NSDate dateWithTimeInterval:60 * 60 * 5.5 sinceDate:[NSDate new]];
    e3.end = [NSDate dateWithTimeInterval:60 * 60 * 6.5 sinceDate:[NSDate new]];
    e3.title = @"CS 429: Comp Arch";
    e3.location = @"Geary Hall";
    e3.lat = 30.287663;
    e3.lon = -97.739246;
    
    _events = @[e1, e2, e3];
    
    
    float sq = 50.0f;
    circle = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - sq/2.0, self.view.center.y - sq/2.0, sq, sq)];
    circle.backgroundColor = [UIColor colorWithRed:.3 green:.83 blue:.84 alpha:1];
    circle.layer.cornerRadius = sq/2;
    [self.view addSubview:circle];

}

- (void)setup {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.5 animations:^{
            circle.transform = CGAffineTransformMakeScale(20, 20);
        } completion:^(BOOL f) {
            self.view.backgroundColor = circle.backgroundColor;
            [circle removeFromSuperview];
            
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:_scrollView];
            
            [self insertEvents];
            
            int i = 0;
            int size = 90;
            int spacing = 20;
            for (Event *e in _events) {
                UIView *ev = [[UIView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height , self.view.frame.size.width - 10*2, size)];
                ev.backgroundColor = [UIColor whiteColor];
                ev.layer.cornerRadius = 2;
                ev.layer.shadowOffset = CGSizeMake(0.0f, 7.0f);
                ev.layer.shadowColor = [UIColor blackColor].CGColor;
                ev.clipsToBounds = NO;
                ev.layer.shadowOpacity = 0.3;
                
                
                [_scrollView addSubview:ev];
                
                [UIView animateWithDuration:.7 delay:i * .1 usingSpringWithDamping:.75 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    ev.center = CGPointMake(ev.center.x, i * (size + spacing) + size/2.0);
                } completion:^(BOOL f) {
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ev.frame.size.width - 20, 22)];
                    title.text = e.title;
                    title.textColor = [UIColor colorWithWhite:.45 alpha:1];
                    title.alpha = 0;
                    title.font = [UIFont fontWithName:@"RobotoDraft" size:17];
                    [ev addSubview:title];
                    
                    NSDateFormatter *df = [[NSDateFormatter alloc] init]; [df setDateFormat:@"h:mma"];
                    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, ev.frame.size.width - 20, 17)];
                    time.text = [NSString stringWithFormat:@"%@-%@", [df stringFromDate:[self formatDate:e.start]], [df stringFromDate:[self formatDate:e.end]]];
                    time.textColor = [UIColor colorWithWhite:.45 alpha:1];
                    time.alpha = 0;
                    time.font = [UIFont fontWithName:@"RobotoDraft" size:14];
                    [ev addSubview:time];
                    
//                    UILabel *dist = [[UILabel alloc] initWithFrame:CGRectMake(ev.frame.size.width - 120, 35, 110, 17)];
                    UILabel *dist = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 110, 17)];
                    if (i == 0) {
                        NSNumberFormatter *nf = [NSNumberFormatter new]; [nf setNumberStyle:NSNumberFormatterDecimalStyle];
                        dist.text = [NSString stringWithFormat:@"%@m away", [nf stringFromNumber:[NSNumber numberWithInt:(int)(sqrt(pow(location.latitude - e.lat, 2) + pow(location.longitude - e.lon, 2)) * 111319)]]];
                    }
                    else
                        dist.text = e.location;
                    
                    dist.textColor = [UIColor colorWithWhite:.65 alpha:0.9f];
                    dist.alpha = 0;
                    dist.font = [UIFont fontWithName:@"RobotoDraft" size:14];
                    [ev addSubview:dist];

                    
                    [UIView animateWithDuration:.5 animations:^{
                        title.alpha = time.alpha = dist.alpha = 1;
                    }];
                }];
                
                _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _events.count * (size + spacing));
                i++;
            }
        }];
    });
}

- (void)insertEvents {
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    for (int i = 0; i < _events.count - 1; i++) {
        Event *e1 = _events[i];
        Event *e2 = _events[i + 1];
        Block *b = [[Block alloc] init];
        b.start = e1.end;
        b.end = e2.start;
        b.length = [b.end timeIntervalSinceDate:b.start];
        [blocks addObject:b];
    }
    
    // start adding events
    BOOL breakfast, lunch, dinner;
    for (Block *b in blocks) {
        if (b.length < 20)
            return;
        NSDateComponents *start = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:b.start];
        if (!breakfast && start.hour > 5 && start.hour < 12) {
        }
        [self findPlace:@"breakfast"];
    }
}

- (void)findPlace:(NSString *)query {
    MKLocalSearchRequest *r = [[MKLocalSearchRequest alloc] init];
    r.naturalLanguageQuery = query;
    r.region = MKCoordinateRegionMake(location, MKCoordinateSpanMake(5000/111319.0f, 5000/111319.0f));
    MKLocalSearch *s = [[MKLocalSearch alloc] initWithRequest:r];
    [s startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        for (id item in response.mapItems) {
            NSLog(@"%@", item);
        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
    if (error.code == kCLErrorDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access" message:@"No Location Access" delegate:self cancelButtonTitle:@"Don't give my location" otherButtonTitles:@"Open in Settings", nil];
        [alert show];
    }

    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)updatedLocations
{
    [manager stopUpdatingLocation];
    manager.delegate = nil;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:[updatedLocations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        CLPlacemark *placemark = placemarks[0];
        location = placemark.location.coordinate;
        [self setup];
    }];
}

@end
