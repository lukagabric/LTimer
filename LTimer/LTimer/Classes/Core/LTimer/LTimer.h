//
//  Created by Luka Gabrić.
//  Copyright (c) 2013 Luka Gabrić. All rights reserved.
//


@class LTimer;


typedef void(^FireBlock)(LTimer *timer, id userInfo);


@interface LTimer : NSObject
{
    NSTimer *_timer;
    __weak id _target;
    SEL _selector;
    BOOL _repeats;
    int _tag;
    id _userInfo;
    FireBlock _fireBlock;
}


@property (nonatomic, readonly) int tag;
@property (nonatomic, readonly) id target;
@property (nonatomic, readonly) SEL selector;
@property (nonatomic, readonly) BOOL repeats;


- (id)initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats tag:(int)tag fireBlock:(FireBlock)fireBlock;
- (void)invalidate;


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector;
+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo;
+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;
+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats;
+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector tag:(int)tag;
+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats tag:(int)tag;

+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target fireBlock:(FireBlock)fireBlock;
+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target repeats:(BOOL)repeats fireBlock:(FireBlock)fireBlock;
+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target tag:(int)tag fireBlock:(FireBlock)fireBlock;
+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target userInfo:(id)userInfo fireBlock:(FireBlock)fireBlock;
+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target userInfo:(id)userInfo repeats:(BOOL)repeats fireBlock:(FireBlock)fireBlock;
+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target userInfo:(id)userInfo repeats:(BOOL)repeats tag:(int)tag fireBlock:(FireBlock)fireBlock;

+ (void)freeTimerForTarget:(id)target andSelector:(SEL)selector;
+ (void)freeTimersForTarget:(id)target;
+ (void)freeTimerWithTag:(int)tag;
+ (void)freeTimer:(LTimer *)timer;


@end