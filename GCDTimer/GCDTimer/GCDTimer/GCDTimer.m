//
//  GCDTimer.m
//  test
//
//  Created by 灰兔子 on 2020/10/12.
//  Copyright © 2020 灰兔子. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer ()

@property (nonatomic, strong) dispatch_queue_t timerQueue;

@property (nonatomic, strong) dispatch_source_t timerSource;

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, weak) id target;

@property (nonatomic, assign) BOOL repeat;

@property (nonatomic, copy) GCDTimerBlock block;

@property (nonatomic) SEL selector;

@property (nonatomic, assign) BOOL isRunning;

@end

@implementation GCDTimer

#pragma mark - initialization

+ (instancetype)scheduleWithDuration:(NSTimeInterval)duration
                              target:(id)target
                              repeat:(BOOL)repeat
                            selector:(SEL)selector {
    
    GCDTimer *timer = [[GCDTimer alloc] initWithDuration:duration
                                                  target:target
                                                  repeat:repeat
                                                selector:selector
                                                   block:nil];
    [timer start];
    return timer;
}

+ (instancetype)scheduleWithDuration:(NSTimeInterval)duration
                              target:(id)target
                              repeat:(BOOL)repeat
                               block:(GCDTimerBlock)block {
    
    GCDTimer *timer = [[GCDTimer alloc] initWithDuration:duration
                                                  target:target
                                                  repeat:repeat
                                                selector:nil
                                                   block:block];
    [timer start];
    return timer;
}

- (instancetype)initWithDuration:(NSTimeInterval)duration
                          target:(id)target
                          repeat:(BOOL)repeat
                        selector:(SEL)selector {
    
    return [[GCDTimer alloc] initWithDuration:duration
                                       target:target
                                       repeat:repeat
                                     selector:selector
                                        block:nil];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration
                          target:(id)target
                          repeat:(BOOL)repeat
                           block:(GCDTimerBlock)block {
    
    return [[GCDTimer alloc] initWithDuration:duration
                                       target:target
                                       repeat:repeat
                                     selector:nil
                                        block:block];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration
                          target:(id)target
                          repeat:(BOOL)repeat
                        selector:(SEL)selector
                           block:(GCDTimerBlock)block{
    self = [super init];
    if (self) {
        _duration = duration;
        _target = target;
        _selector = selector;
        _block = block;
        _repeat = repeat;
        
        _timerQueue = dispatch_queue_create("com.huituzi.GCDTimer", DISPATCH_QUEUE_SERIAL);
        _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _timerQueue);
        dispatch_source_set_timer(_timerSource, DISPATCH_TIME_NOW, duration * NSEC_PER_SEC, 0);
        
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_timerSource, ^{
            [weakSelf timerAction];
        });
    }
    return self;
}

#pragma mark - Actions

- (void)timerAction {
    
    if ([self.target respondsToSelector:self.selector]) {
        [self.target performSelectorOnMainThread:self.selector withObject:self waitUntilDone:YES];
    }
    
    if (self.block) {
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.block(weakself);
        });
    }
    
    if (!self.repeat) {
        self.isRunning = NO;
        dispatch_suspend(self.timerQueue);
        dispatch_suspend(self.timerSource);
    }
}

#pragma mark - Public Actions

- (void)start {
    if (self.isRunning) {
        return;
    }
    
    self.isRunning = YES;
    dispatch_resume(self.timerSource);
}

- (void)suspend {
    self.isRunning = NO;
    dispatch_suspend(self.timerQueue);
    dispatch_suspend(self.timerSource);
}

- (void)cancel {
    if (self.isRunning) {
        dispatch_source_cancel(self.timerSource);
    }
    
    self.target = nil;
    self.selector = nil;
    self.block = nil;
    self.isRunning = NO;
    self.timerSource = nil;
    self.timerQueue = nil;
}

@end
