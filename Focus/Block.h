//
//  Block.h
//  Focus
//
//  Created by Michael Scaria on 2/7/15.
//  Copyright (c) 2015 michaelscaria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Block : NSObject
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;
@property (nonatomic, assign) int length;
@end
