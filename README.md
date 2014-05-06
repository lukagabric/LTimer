LTimer
======

iOS Timer

Implementation
--------------

Just import LTimer class to your project.


Sample usage
------------

    [LTimer LTimerWithTimeInterval:1 target:self repeats:YES fireBlock:^(LTimer *timer, id userInfo) {
        _label.text = [NSString stringWithFormat:@"%d", [_label.text integerValue] + 1];
    }];
    
To stop timers use these methods:

    + (void)freeTimerForTarget:(id)target andSelector:(SEL)selector;
    + (void)freeTimersForTarget:(id)target;
    + (void)freeTimerWithTag:(int)tag;
    + (void)freeTimer:(LTimer *)timer;
