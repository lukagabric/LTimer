//
//  ViewController.m
//  LTimer
//
//  Created by Luka Gabric on 06/05/14.
//  Copyright (c) 2014 LG. All rights reserved.
//


#import "ViewController.h"
#import "LTimer.h"


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [LTimer LTimerWithTimeInterval:1 target:self repeats:YES fireBlock:^(LTimer *timer, id userInfo) {
        _label.text = [NSString stringWithFormat:@"%d", [_label.text integerValue] + 1];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LTimer freeTimersForTarget:self];
    });
}


@end