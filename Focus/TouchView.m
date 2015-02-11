//
//  TouchView.m
//  Focus
//
//  Created by Michael Scaria on 2/11/15.
//  Copyright (c) 2015 michaelscaria. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    float s = 6.0f;
    self.clipsToBounds = YES;
    if (!tv) {
        tv = [[UIView alloc] init];
        tv.backgroundColor = [UIColor colorWithWhite:.4 alpha:0.3f];
        tv.layer.cornerRadius = s/2;
    }
    tv.frame = CGRectMake(point.x - s/2, point.y - s/2, s, s);
    tv.alpha = 1;

    [self addSubview:tv];
    float scale = MAX(self.frame.size.width/s, self.frame.size.height/s) * 10;
    
    [UIView animateWithDuration:.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        tv.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:.4 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tv.alpha = 0;
    } completion:^(BOOL finished) {
        tv.transform = CGAffineTransformIdentity;
        [tv removeFromSuperview];
    }];
}
@end
