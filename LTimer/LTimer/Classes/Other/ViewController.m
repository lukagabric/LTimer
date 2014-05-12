//
//  Created by Luka Gabrić.
//  Copyright (c) 2013 Luka Gabrić. All rights reserved.
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LTimer freeTimersForTarget:self];
        
        [LTimer LTimerWithTimeInterval:2 target:self selector:@selector(testUserInfo:) userInfo:@123 repeats:NO];
    });
}


- (void)testUserInfo:(id)userInfo
{
    NSLog(@"%@", userInfo);
}


@end