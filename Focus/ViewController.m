//
//  ViewController.m
//  Focus
//
//  Created by Michael Scaria on 2/7/15.
//  Copyright (c) 2015 michaelscaria. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float sq = 50.0f;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - sq/2.0, self.view.center.y - sq/2.0, sq, sq)];
    v.backgroundColor = [UIColor colorWithRed:.3 green:.83 blue:.84 alpha:1];
    v.layer.cornerRadius = sq/2;
    [self.view addSubview:v];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.5 animations:^{
            v.transform = CGAffineTransformMakeScale(20, 20);
        } completion:^(BOOL f) {
            ;
        }];
    });
    
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
