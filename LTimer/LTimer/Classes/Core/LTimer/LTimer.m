//
//  Created by Luka Gabrić.
//  Copyright (c) 2013 Luka Gabrić. All rights reserved.
//


#import "LTimer.h"


@implementation LTimer


static NSMutableArray *timers = nil;


+ (void)freeTimer:(LTimer *)timer
{
    [timer freeLTimer];
    
    @synchronized(timers)
    {
        [timers removeObject:timer];
    }
}


+ (void)freeTimerWithTag:(int)tag
{
    @synchronized(timers)
    {
        NSMutableArray *timersToRemove = [NSMutableArray array];
        
        for (LTimer *timer in timers)
        {
            if (timer.tag == tag)
            {
                [timer freeLTimer];
                [timersToRemove addObject:timer];
            }
        }
        
        [timers removeObjectsInArray:timersToRemove];
    }
}


+ (void)freeTimersForTarget:(id)target
{
    @synchronized(timers)
    {
        NSMutableArray *timersToRemove = [NSMutableArray array];
    
        for (LTimer *timer in timers)
        {
            if (timer.target == target)
            {
                [timer freeLTimer];
                [timersToRemove addObject:timer];
            }
        }

        [timers removeObjectsInArray:timersToRemove];
    }
}


+ (void)freeTimerForTarget:(id)target andSelector:(SEL)selector
{
    @synchronized(timers)
    {
        NSMutableArray *timersToRemove = [NSMutableArray array];
        
        for (LTimer *timer in timers)
        {
            if (timer.target == target && timer.selector == selector)
            {
                [timer freeLTimer];
                [timersToRemove addObject:timer];
            }
        }
        
        [timers removeObjectsInArray:timersToRemove];
    }
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector
{
    return [LTimer LTimerWithTimeInterval:timeInterval target:target selector:selector userInfo:nil repeats:NO tag:-9999];
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo
{
    return [LTimer LTimerWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:NO tag:-9999];
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats
{
    return [LTimer LTimerWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats tag:-9999];
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats
{
    return [LTimer LTimerWithTimeInterval:timeInterval target:target selector:selector userInfo:nil repeats:repeats tag:-9999];
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector tag:(int)tag
{
    return [LTimer LTimerWithTimeInterval:timeInterval target:target selector:selector userInfo:nil repeats:NO tag:tag];
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats tag:(int)tag
{
    return [[LTimer alloc] initWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats tag:tag fireBlock:nil];
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target fireBlock:(FireBlock)fireBlock
{
    return [LTimer LTimerWithTimeInterval:timeInterval target:target userInfo:nil repeats:NO tag:-9999 fireBlock:fireBlock];
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target repeats:(BOOL)repeats fireBlock:(FireBlock)fireBlock
{
    return [LTimer LTimerWithTimeInterval:timeInterval target:target userInfo:nil repeats:repeats tag:-9999 fireBlock:fireBlock];
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target tag:(int)tag fireBlock:(FireBlock)fireBlock
{
    return [LTimer LTimerWithTimeInterval:timeInterval target:target userInfo:nil repeats:NO tag:tag fireBlock:fireBlock];
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target userInfo:(id)userInfo fireBlock:(FireBlock)fireBlock
{
    return [LTimer LTimerWithTimeInterval:timeInterval target:target userInfo:userInfo repeats:NO tag:-9999 fireBlock:fireBlock];
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target userInfo:(id)userInfo repeats:(BOOL)repeats fireBlock:(FireBlock)fireBlock
{
    return [LTimer LTimerWithTimeInterval:timeInterval target:target userInfo:userInfo repeats:repeats tag:-9999 fireBlock:fireBlock];
}


+ (LTimer *)LTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target userInfo:(id)userInfo repeats:(BOOL)repeats tag:(int)tag fireBlock:(FireBlock)fireBlock
{
    return [[LTimer alloc] initWithTimeInterval:timeInterval target:target selector:nil userInfo:userInfo repeats:repeats tag:tag fireBlock:fireBlock];
}


- (id)initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats tag:(int)tag fireBlock:(FireBlock)fireBlock
{
    self = [super init];
    if (self)
    {
        _target = target;
        _selector = selector;
        
        if (fireBlock)
            _fireBlock = [fireBlock copy];
        
        _userInfo = userInfo;
        _repeats = repeats;
        _tag = tag;
        
        @synchronized(timers)
        {
            if (!timers)
                timers = [NSMutableArray new];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerFired) userInfo:nil repeats:repeats];
            [timers addObject:self];
        }
    }
    
    return self;
}


- (void)timerFired
{
    id target = _target;
    SEL selector = _selector;
    
    if (!target)
    {
        [LTimer freeTimer:self];
    }
    else if (_fireBlock)
    {
        _fireBlock(self, _userInfo);
    }
    else
    {
        if ([target respondsToSelector:selector])
        {
            NSMethodSignature *methodSig = [[target class] instanceMethodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
            [invocation setSelector:selector];
            [invocation setTarget:target];
            if (_userInfo)
                [invocation setArgument:&_userInfo atIndex:2];
            [invocation invoke];
        }
    }
    
    if (_repeats == NO)
        [LTimer freeTimer:self];
}


- (void)freeLTimer
{
    if ([_timer isValid])
        [_timer invalidate];
    
    _target = nil;
    _fireBlock = nil;
    _timer = nil;
}


- (void)invalidate
{
    [LTimer freeTimer:self];
}


#pragma mark - dealloc


- (void)dealloc
{
    [self freeLTimer];
}


@end