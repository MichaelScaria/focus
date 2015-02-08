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

#define BREAKFAST @"morning breakfast"
#define LUNCH     @"lunch"
#define DINNER    @"late night food"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *events;
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
    _events = [[NSMutableArray alloc] init];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        locationManager = [[CLLocationManager alloc] init];
        [locationManager requestWhenInUseAuthorization];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    });
    
    
    
    
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
    e3.start = [NSDate dateWithTimeInterval:60 * 60 * 6 sinceDate:[NSDate new]];
    e3.end = [NSDate dateWithTimeInterval:60 * 60 * 7 sinceDate:[NSDate new]];
    e3.title = @"CS 429: Comp Arch";
    e3.location = @"Geary Hall";
    e3.lat = 30.287663;
    e3.lon = -97.739246;
    
    _events = [@[e1, e2, e3] mutableCopy];
    
    
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
            
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:_scrollView];
            
            [self insertEvents:^{
                int i = 0;
                int size = 90;
                int offset = 10;
                int spacing = 20;
                
                // sort events
                [_events sortUsingComparator:^NSComparisonResult(Event *obj1, Event *obj2) {
                    return [obj1.start compare:obj2.start];
                }];
                
                for (Event *e in _events) {
                    BOOL isEvent = e.type == kEvent;
                    UIView *ev = [[UIView alloc] initWithFrame:isEvent ? CGRectMake(10, self.view.frame.size.height , self.view.frame.size.width - 10*2, size) : CGRectMake(30, self.view.frame.size.height , self.view.frame.size.width - 30*2, size * 1.25)];
                    ev.backgroundColor = [UIColor whiteColor];
                    ev.layer.cornerRadius = 2;
                    ev.layer.shadowOffset = CGSizeMake(0.0f, 7.0f);
                    ev.layer.shadowColor = [UIColor blackColor].CGColor;
                    ev.clipsToBounds = NO;
                    ev.layer.shadowOpacity = 0.3;
                    [_scrollView addSubview:ev];
                    
                    [UIView animateWithDuration:.7 delay:i * .1 usingSpringWithDamping:.75 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        ev.frame = (CGRect){ev.frame.origin.x, offset, ev.frame.size};
                    } completion:^(BOOL f) {
                        if (isEvent) {
                            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ev.frame.size.width - 20, 22)];
                            title.text = e.title;
                            title.textColor = [UIColor colorWithWhite:.45 alpha:1];
                            title.alpha = 0;
                            title.font = [UIFont fontWithName:@"RobotoDraft" size:17];
                            [ev addSubview:title];
                            
                            NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"CST"];
                            NSDateFormatter *df = [[NSDateFormatter alloc] init]; [df setDateFormat:@"h:mma"]; [df setTimeZone:tz];
                            UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, ev.frame.size.width - 20, 17)];
                            time.text = [NSString stringWithFormat:@"%@-%@", [df stringFromDate:[self formatDate:e.start]], [df stringFromDate:[self formatDate:e.end]]];
                            time.textColor = [UIColor colorWithWhite:.45 alpha:1];
                            time.alpha = 0;
                            time.font = [UIFont fontWithName:@"RobotoDraft" size:14];
                            [ev addSubview:time];
                            
                            UILabel *dist = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 210, 17)];
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
                        }
                        else {
                            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, ev.frame.size.width, 50)];
                            int min = [e.end timeIntervalSinceDate:e.start] / 60.0;
                            title.text = [NSString stringWithFormat:@"%dmin", min];
                            title.textColor = [UIColor colorWithWhite:.45 alpha:1];
                            title.alpha = 0;
                            title.font = [UIFont fontWithName:@"RobotoDraft" size:43];
                            title.textAlignment = NSTextAlignmentCenter;
                            [ev addSubview:title];
                            
                            UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, ev.frame.size.width, 19)];
                            subtitle.text = @"Of free time";
                            subtitle.textColor = [UIColor colorWithWhite:.6 alpha:0.9f];
                            subtitle.alpha = 0;
                            subtitle.font = [UIFont fontWithName:@"RobotoDraft" size:15];
                            subtitle.textAlignment = NSTextAlignmentCenter;
                            [ev addSubview:subtitle];
                            
                            [UIView animateWithDuration:.5 animations:^{
                                title.alpha = subtitle.alpha = 1;
                            }];
                        }
                        
                    }];
                    offset += ev.frame.size.height + spacing;
                    
                    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, MAX(offset + 30, _scrollView.frame.size.height + 5));
                    i++;
                }
            }];
            
            
        }];
    });
}

- (void)insertEvents:(void (^)(void))completion {
    NSArray *blocks = [self getBlocks];
   
    BOOL breakfast = NO, lunch = NO, dinner = NO;
    __block NSNumber *pcount = @0;
    __block int pcomp = 0;
    for (Block *b in blocks) {
        void (^success)(NSString *,MKMapItem *) = ^(NSString *type, MKMapItem *item){
            pcomp++;
            Event *e = [[Event alloc] init];
            e.start = b.start;
            if ([type isEqualToString:BREAKFAST] || [type isEqualToString:LUNCH] || [type isEqualToString:DINNER]) {
                e.end = [b.start dateByAddingTimeInterval:60 * 30];
            }
            else
                e.end = b.end;
            e.title = item.name;
            e.location = item.placemark.name;
            e.lat = item.placemark.coordinate.latitude;
            e.lon = item.placemark.coordinate.longitude;
            [_events addObject:e];
            if (pcomp == [pcount intValue]) {
                //insert empty events
                NSArray *pBlocks = [self getBlocks];
                for (Block *pb in pBlocks) {
                    Event *pe = [[Event alloc] init];
                    pe.start = pb.start;
                    pe.end = pb.end;
                    pe.type = kPadding;
                    [_events addObject:pe];
                }
                completion();
            }
            
        };
        NSDateComponents *start = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:b.start];
        NSLog(@"hour:%ld", start.hour);
        if (!breakfast && start.hour > 5 && start.hour < 12) {
            NSLog(@"breakfast");
            breakfast = YES;
            pcount = [NSNumber numberWithInt:[pcount intValue] + 1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .05 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self findPlace:BREAKFAST success:success];
            });
            
        }
        else if (!lunch && start.hour >= 12 && start.hour < 17) {
            NSLog(@"lunch");
            lunch = YES;
            pcount = [NSNumber numberWithInt:[pcount intValue] + 1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .05 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self findPlace:LUNCH success:success];
            });
        }
        else if (!dinner && start.hour >= 17 && start.hour < 24) {
            NSLog(@"dinner");
            dinner = YES;
            pcount = [NSNumber numberWithInt:[pcount intValue] + 1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .05 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self findPlace:DINNER success:success];
            });
        }
    }
    
    if (blocks.count == 0)
        completion();
    
//    [self iterateBlocks:blocks index:0];
}

- (NSArray *)getBlocks {
    [_events sortUsingComparator:^NSComparisonResult(Event *obj1, Event *obj2) {
        return [obj1.start compare:obj2.start];
    }];
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    for (int i = 0; i < _events.count - 1; i++) {
        Event *e1 = _events[i];
        Event *e2 = _events[i + 1];
        Block *b = [[Block alloc] init];
        b.start = e1.end;
        b.end = e2.start;
        b.length = [b.end timeIntervalSinceDate:b.start];
        if (b.length > 60 * 30)
            [blocks addObject:b];
    }
    
    Event *e = [_events lastObject];
    NSDateComponents *end = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitHour fromDate:e.end];
    if (end.hour < 24) {
        Block *b = [[Block alloc] init];
        b.start = e.end;
        end.hour = 23;
        end.minute = 30;
        b.end = [[NSCalendar currentCalendar] dateFromComponents:end];
        b.length = [b.end timeIntervalSinceDate:b.start];
        [blocks addObject:b];
    }
    
    for (Block *b in blocks) {
        NSLog(@"%@ - %@", b.start, b.end);
    }
    return (NSArray *)blocks;
}


- (void)findPlace:(NSString *)query success:(void (^)(NSString *, MKMapItem *))success {
    MKLocalSearchRequest *r = [[MKLocalSearchRequest alloc] init];
    r.naturalLanguageQuery = query;
    r.region = MKCoordinateRegionMake(location, MKCoordinateSpanMake(5000/111319.0f, 5000/111319.0f));
    MKLocalSearch *s = [[MKLocalSearch alloc] initWithRequest:r];
    [s startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        MKMapItem *item = response.mapItems[0];
        success(query, item);
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
