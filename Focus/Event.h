//
//  Event.h
//  Focus
//
//  Created by Michael Scaria on 2/7/15.
//  Copyright (c) 2015 michaelscaria. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EVENT_TYPE) {
    kEvent,
    kPadding
};

@interface Event : NSObject

@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lon;
@property (nonatomic, assign) EVENT_TYPE type;
@end
