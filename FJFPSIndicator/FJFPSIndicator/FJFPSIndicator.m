//
//  FJFPSIndicator.m
//  FJFPSIndicator
//
//  Created by MacBook on 2018/1/3.
//  Copyright © 2018年 MacBook. All rights reserved.
//

#import "FJFPSIndicator.h"

#define FJNotificationCenter [NSNotificationCenter defaultCenter]
@interface FJFPSIndicator ()

@property (nonatomic, strong) UILabel *indicatorLabel;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CFTimeInterval timeInterval;

@end

@implementation FJFPSIndicator

+ (FJFPSIndicator *)sharedInstance{
    static FJFPSIndicator *indicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        indicator = [[FJFPSIndicator alloc]init];
    });
    return indicator;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupDisplayLink];
        [self addNofication];
        
    }
    return self;
}


- (void)setupDisplayLink{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkFPS:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)addNofication{
    [FJNotificationCenter addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    [FJNotificationCenter addObserver:self selector:@selector(applicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)start{
    if (!_displayLink) {
        [self setupDisplayLink];
    }
    [_displayLink setPaused:NO];
    [[UIApplication sharedApplication].delegate.window addSubview:self.indicatorLabel];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self.indicatorLabel];
}

- (void)paused{
    if (_displayLink) {
        [_displayLink setPaused:YES];
    }
    self.indicatorLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"paused"];
    
}

- (void)close{
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    [self.indicatorLabel removeFromSuperview];
}


- (void)linkFPS:(CADisplayLink *)link{
    if (_timeInterval == 0) {
        _timeInterval = link.timestamp;
        return;
    }
    _count ++;
    float delta = link.timestamp - _timeInterval;
    if (delta < 1) return;
    _timeInterval = link.timestamp;
    int fps = roundf(_count / delta);
    _count = 0;
    
    CGFloat progress = fps / 60.f;
    NSString *fpsString = [NSString stringWithFormat:@"%d",fps];
    NSString *totalString = [NSString stringWithFormat:@"%d FPS",fps];
    NSRange range = [totalString rangeOfString:fpsString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:totalString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:progress green:0 blue:0 alpha:1] range:range];
    self.indicatorLabel.attributedText = attributedString;
}

#pragma mark - PanGestureRecognizer
- (void)indicatorLabelPaned:(UIPanGestureRecognizer *)gestureRecognizer{
    UIWindow *superView = [UIApplication sharedApplication].delegate.window;
    CGPoint position = [gestureRecognizer locationInView:superView];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        self.indicatorLabel.alpha = 0.5;
    }else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        self.indicatorLabel.center = position;
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        self.indicatorLabel.alpha = 1;
    }
}

#pragma mark - notification
- (void)applicationDidBecomeActiveNotification{
    [_displayLink setPaused:NO];
}

- (void)applicationWillResignActiveNotification{
    [_displayLink setPaused:YES];
}

- (UILabel *)indicatorLabel{
    if (_indicatorLabel == nil) {
        _indicatorLabel = [[UILabel alloc]init];
        _indicatorLabel.frame = CGRectMake(0, 220, 60, 30);
        _indicatorLabel.textColor = [UIColor whiteColor];
        _indicatorLabel.textAlignment = NSTextAlignmentCenter;
        _indicatorLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(indicatorLabelPaned:)];
        [_indicatorLabel addGestureRecognizer:pan];
        _indicatorLabel.userInteractionEnabled = YES;
    }
    return _indicatorLabel;
}


- (void)dealloc{
    [FJNotificationCenter removeObserver:self];
}

@end
