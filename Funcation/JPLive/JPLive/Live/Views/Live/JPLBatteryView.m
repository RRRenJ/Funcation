//
//  JPLBatteryView.m
//  jper
//
//  Created by RRRenJ on 2020/5/28.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLBatteryView.h"


@interface JPLBatteryView ()

@property (nonatomic, strong) UIView *batteryView;

@end

@implementation JPLBatteryView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupViews];
        [self addActions];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupViews];
        [self addActions];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setupViews{
    [self addSubview:self.batteryView];
    [self creatBatteryView];
}

- (void)addActions{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    float level = [UIDevice currentDevice].batteryLevel;
    NSLog(@"电池电量：%.2f", level);
    if (level <= 1 && level >= 0) {
        CGFloat width = level * (self.width - 3);
        self.batteryView.frame = CGRectMake(1.5, 1.5, width, self.height - 3);
    }else{
        self.batteryView.frame = CGRectMake(1.5, 1.5, self.width - 3, self.height - 3);
    }
    [[NSNotificationCenter defaultCenter]
    addObserverForName:UIDeviceBatteryLevelDidChangeNotification
    object:nil queue:[NSOperationQueue mainQueue]
    usingBlock:^(NSNotification *notification) {
        float level = [UIDevice currentDevice].batteryLevel;
        NSLog(@"电池电量：%.2f", level);
        if (level <= 1 && level >= 0) {
            CGFloat width = level * (self.width - 3);
            self.batteryView.frame = CGRectMake(1.5, 1.5, width, self.height - 3);
        }else{
            self.batteryView.frame = CGRectMake(1.5, 1.5, self.width - 3, self.height - 3);
        }
    }];
}


- (void)creatBatteryView {

    // 电池的宽度

    CGFloat w = self.bounds.size.width;

    // 电池的高度

    CGFloat h = self.bounds.size.height;

    // 电池的x的坐标

    CGFloat x = self.bounds.origin.x;

    // 电池的y的坐标

    CGFloat y = self.bounds.origin.y;

    // 画电池

    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w, h) cornerRadius:2];

    CAShapeLayer *batteryLayer = [CAShapeLayer layer];

    batteryLayer.lineWidth = 1;

    batteryLayer.strokeColor = [UIColor whiteColor].CGColor;

    batteryLayer.fillColor = [UIColor clearColor].CGColor;

    batteryLayer.path = [path1 CGPath];

    [self.layer addSublayer:batteryLayer];

    UIBezierPath *path2 = [UIBezierPath bezierPath];

    [path2 moveToPoint:CGPointMake(x+w+1, y+h/3)];

    [path2 addLineToPoint:CGPointMake(x+w+1, y+h*2/3)];

    CAShapeLayer *layer2 = [CAShapeLayer layer];

    layer2.lineWidth = 2;

    layer2.strokeColor = [UIColor whiteColor].CGColor;

    layer2.fillColor = [UIColor clearColor].CGColor;

    layer2.path = [path2 CGPath];

    [self.layer addSublayer:layer2];

}

#pragma mark - set



#pragma mark - get

- (UIView *)batteryView{
    if (!_batteryView) {
        _batteryView = [[UIView alloc] initWithFrame:CGRectMake( 1.5, 1.5, 0, self.height - 3)];
        _batteryView.layer.cornerRadius = 2;
        _batteryView.backgroundColor = [UIColor whiteColor];
    }
    return _batteryView;
}

@end
