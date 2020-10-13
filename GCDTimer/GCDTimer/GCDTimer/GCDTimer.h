//
//  GCDTimer.h
//  test
//
//  Created by 灰兔子 on 2020/10/12.
//  Copyright © 2020 灰兔子. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDTimer;

NS_ASSUME_NONNULL_BEGIN

typedef void(^GCDTimerBlock)(GCDTimer *timer);

@interface GCDTimer : NSObject

+ (instancetype)scheduleWithDuration:(NSTimeInterval)duration
                              target:(id)target
                              repeat:(BOOL)repeat
                            selector:(SEL)selector;

+ (instancetype)scheduleWithDuration:(NSTimeInterval)duration
                              target:(id)target
                              repeat:(BOOL)repeat
                               block:(GCDTimerBlock)block;

- (instancetype)initWithDuration:(NSTimeInterval)duration
                          target:(id)target
                          repeat:(BOOL)repeat
                        selector:(SEL)selector;

- (instancetype)initWithDuration:(NSTimeInterval)duration
                          target:(id)target
                          repeat:(BOOL)repeat
                           block:(GCDTimerBlock)block;

- (void)start;

- (void)suspend;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
