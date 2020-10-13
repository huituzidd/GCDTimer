//
//  ViewController.m
//  GCDTimer
//
//  Created by 灰兔子 on 2020/10/13.
//

#import "ViewController.h"
#import "GCDTimer.h"

const NSUInteger MaxCount = 10;

@interface ViewController ()
@property (nonatomic, strong) GCDTimer *timer;
@property (nonatomic, assign) NSUInteger currentCount;
@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentCount = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self timerActionBySelector];
        [self timerActionByBlock];
}

- (void)timerActionBySelector {
    self.timer = [[GCDTimer alloc] initWithDuration:1 target:self repeat:YES selector:@selector(printTimerCount:)];
    [self.timer start];
}

- (void)printTimerCount:(GCDTimer *)timer {
    NSLog(@"current count = %ld",++self.currentCount);
    if (self.currentCount >= MaxCount) {
        [self.timer cancel];
        self.timer = nil;
    }
}

- (void)timerActionByBlock {
    self.timer = [GCDTimer scheduleWithDuration:1 target:self repeat:YES block:^(GCDTimer * _Nonnull timer) {
        NSLog(@"current count = %ld",++self.currentCount);
        if (self.currentCount >= MaxCount) {
            [self.timer cancel];
            self.timer = nil;
        }
    }];
}


@end
