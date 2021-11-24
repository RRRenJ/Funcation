//
//  JPLLivePushView.m
//  jper
//
//  Created by RRRenJ on 2020/5/28.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLivePushView.h"
#import "JPLBatteryView.h"
#import "BarrageView.h"
#import "JPLBarrageCell.h"

@interface JPLLivePushView ()<BarrageViewDelegate,BarrageViewDataSouce>

@property (nonatomic, strong) UIButton * endBt;

@property (nonatomic, strong) UILabel * liveIDLb;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * timeLb;

@property (nonatomic, strong) UILabel * personLb;

@property (nonatomic, strong) JPLBatteryView * batteryView;

@property (nonatomic, strong) UIImageView * backIV;

@property (nonatomic, strong) UIView * topView;

@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, assign) int seconds;

@property (nonatomic, copy) NSString *  time;

@property (nonatomic, strong) BarrageView * barrageView;

@property (nonatomic, strong) CAGradientLayer * topLayer;

@property (nonatomic, assign) BOOL  isPortrait;

@property (nonatomic, strong) UIButton * locationBt;

@end

@implementation JPLLivePushView

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
    [self endTimer];
}


- (void)updateLayoutWithOrientation:(BOOL)isPortrait{
    self.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    self.isPortrait = isPortrait;
    if (isPortrait) {
        [self layoutWithPortrait];
    }else{
        [self layoutWithLandscape];
    }
    
}

- (void)setupViews{
    self.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    [self addSubview:self.topView];
    [self addSubview:self.endBt];
    [self addSubview:self.liveIDLb];
    [self addSubview:self.titleLb];
    [self addSubview:self.timeLb];
//    [self addSubview:self.personLb];
    [self addSubview:self.batteryView];
    [self addSubview:self.barrageView];
    [self addSubview:self.locationBt];
    
    
}

- (void)layoutWithLandscape{
    
    self.topView.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, 62);
    self.endBt.frame = CGRectMake(15, 10, 33, 33);
    self.batteryView.frame = CGRectMake(JPL_SCR_WIDTH - 44, 21, 24, 11);
    self.barrageView.frame = CGRectMake(0, 62, JPL_SCR_WIDTH - 48, 96);
    
    self.batteryView.hidden = NO;
    
    if (self.topLayer) {
        [self.topLayer removeFromSuperlayer];
    }
    self.topLayer = [UIColor jpl_gradientWith:self.topView.bounds fromeColor:[UIColor jpl_colorWithHexString:@"000000" alpha:0.47] toColor:[UIColor jpl_colorWithHexString:@"000000" alpha:0] fromePoint:CGPointMake(0, 0) toPoint:CGPointMake(0, 1)];
    [self.topView.layer addSublayer:self.topLayer];

    
    
    [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.endBt.mas_centerY);
        make.width.mas_equalTo(120);
    }];
    
    
    [self.liveIDLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.endBt.mas_right).mas_offset(26);
        make.centerY.mas_equalTo(self.endBt.mas_centerY);
    }];
    
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.liveIDLb.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.endBt.mas_centerY);
        make.right.mas_greaterThanOrEqualTo(self.timeLb.mas_left).mas_offset(-10);
    }];
    
    [self.locationBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-150);
        make.centerY.mas_equalTo(self.endBt.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(48, 20));
    }];
    
//    [self.personLb mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-69);
//        make.left.mas_equalTo(self.timeLb.right).mas_offset(10);
//        make.centerY.mas_equalTo(self.endBt.mas_centerY);
//    }];
//
    self.titleLb.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold];
    self.liveIDLb.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold];
    self.timeLb.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold];
    self.personLb.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold];
    self.timeLb.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutWithPortrait{
    
    self.topView.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, 44 + JPL_STATUS_HEIGHT);
    self.endBt.frame = CGRectMake(JPL_SCR_WIDTH - 54, JPL_STATUS_HEIGHT, 44, 44);
    self.barrageView.frame = CGRectMake(0, JPL_STATUS_HEIGHT + 44 , JPL_SCR_WIDTH, 96);
    
    self.batteryView.hidden = YES;
    
    if (self.topLayer) {
        [self.topLayer removeFromSuperlayer];
    }
    self.topLayer = [UIColor jpl_gradientWith:self.topView.bounds fromeColor:[UIColor jpl_colorWithHexString:@"000000" alpha:0.47] toColor:[UIColor jpl_colorWithHexString:@"000000" alpha:0] fromePoint:CGPointMake(0, 0) toPoint:CGPointMake(0, 1)];
    [self.topView.layer addSublayer:self.topLayer];
    
    
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(JPL_STATUS_HEIGHT);
        make.right.mas_equalTo(self.endBt.mas_left).mas_offset(-10);
    }];
    
    [self.liveIDLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(7);
    }];
    
//    [self.personLb mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.liveIDLb.mas_right).mas_offset(10);
//        make.centerY.mas_equalTo(self.liveIDLb.mas_centerY);
//    }];
    
    [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.endBt.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.liveIDLb.mas_centerY);
        make.left.mas_equalTo(self.liveIDLb.mas_right).mas_offset(10);
    }];
    
    [self.locationBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.liveIDLb.mas_left);
        make.top.mas_equalTo(self.liveIDLb.mas_bottom).mas_offset(7);
        make.size.mas_equalTo(CGSizeMake(48, 20));
    }];

    
    
    self.titleLb.font = [UIFont jpl_pingFangWithSize:17 weight:UIFontWeightMedium];
    self.personLb.font = [UIFont jpl_pingFangWithSize:12];
    self.timeLb.font = [UIFont jpl_pingFangWithSize:12];
    self.liveIDLb.font = [UIFont jpl_pingFangWithSize:12];
    self.timeLb.textAlignment = NSTextAlignmentLeft;
}


- (void)addActions{
    
}

- (void)insertBarrages:(NSArray<id<BarrageModelAble>> *)barrages immediatelyShow:(BOOL)flag{
    [self.barrageView insertBarrages:barrages immediatelyShow:flag];
}


- (NSUInteger)numberOfRowsInTableView:(BarrageView *)barrageView{
    return  3;
}

- (BarrageViewCell *)barrageView:(BarrageView *)barrageView cellForModel:(id<BarrageModelAble>)model{
    JPLBarrageCell *cell = [JPLBarrageCell cellWithBarrageView:barrageView];
    cell.model = (JPLBarrageModel *)model;
    return cell;
}






- (void)endBtClicked{
    if (self.endBlock){
        self.endBlock();
    }
}

- (void)timerClicked{
    self.seconds++;
    NSString * time = [NSString stringWithFormat:@"%02d:%02d:%02d",self.seconds / 3600, (self.seconds % 3600) / 60, self.seconds % 60];
    self.time = time;
    self.timeLb.text = [NSString stringWithFormat:@"已用时: %@",time];
}



- (void)startTimer{
    self.seconds = 0;
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerClicked) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)endTimer{
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer invalidate];
    self.timer = nil;
    
}



#pragma mark - set
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = _title;
}

- (void)setPerson:(NSString *)person{
    _person = person;
    self.personLb.text = [NSString stringWithFormat:@"在线人数: %@",person];
}

- (void)setLiveID:(NSString *)liveID{
    _liveID = liveID;
    self.liveIDLb.text = _liveID;
    CGFloat width = [JPLUtil getStringSizeWith:[UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold] andContainerSize:CGSizeMake(CGFLOAT_MAX, 20) andString:_liveID].width;
    if (self.isPortrait) {
        [self.liveIDLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(7);
            make.width.mas_equalTo(ceil(width));
        }];
    }else{
        [self.liveIDLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.endBt.mas_right).mas_offset(26);
            make.centerY.mas_equalTo(self.endBt.mas_centerY);
            make.width.mas_equalTo(ceil(width));
        }];
    }
    
}

- (void)setCity:(NSString *)city{
    _city = city;
    NSString * cityStr = [NSString stringWithFormat:@" %@",_city];
    [self.locationBt setTitle:cityStr forState:UIControlStateDisabled];
    CGFloat width = [JPLUtil getStringSizeWith:[UIFont jpl_pingFangWithSize:12 weight:UIFontWeightSemibold] andContainerSize:CGSizeMake(CGFLOAT_MAX, 20) andString:cityStr].width;
    if (self.isPortrait) {
        [self.locationBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.liveIDLb.mas_left);
            make.top.mas_equalTo(self.liveIDLb.mas_bottom).mas_offset(7);
            make.size.mas_equalTo(CGSizeMake(width + 22, 20));
        }];
    }else{
        [self.locationBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-150);
            make.centerY.mas_equalTo(self.endBt.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(width + 22, 20));
        }];
    }
}


#pragma mark - get

- (UIButton *)endBt{
    if (!_endBt) {
        _endBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endBt setImage:JPLImageWithName(@"live_exc") forState:UIControlStateNormal];
        [_endBt addTarget:self action:@selector(endBtClicked) forControlEvents:UIControlEventTouchUpInside];
        _endBt.frame = CGRectMake(15, 10, 33, 33);
    }
    return  _endBt;
}

- (UILabel *)liveIDLb{
    if (!_liveIDLb) {
        _liveIDLb = [[UILabel alloc]init];
        _liveIDLb.textColor = UIColor.whiteColor;
        _liveIDLb.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold];
        _liveIDLb.textAlignment = NSTextAlignmentLeft;
    }
    return _liveIDLb;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = UIColor.whiteColor;
        _titleLb.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold];
        _titleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLb;
}

- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [[UILabel alloc]init];
        _timeLb.textColor = UIColor.whiteColor;
        _timeLb.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold];
        _timeLb.text = @"已用时: 00:00:00";
        _timeLb.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLb;
}

- (UILabel *)personLb{
    if (!_personLb) {
        _personLb = [[UILabel alloc]init];
        _personLb.textColor = UIColor.whiteColor;
        _personLb.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold];
        _personLb.textAlignment = NSTextAlignmentRight;
    }
    return _personLb;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JPL_SCR_WIDTH, 62)];
        _topView.backgroundColor = UIColor.clearColor;
    }
    return  _topView;
}

- (JPLBatteryView *)batteryView{
    if (!_batteryView) {
        _batteryView = [[JPLBatteryView alloc]initWithFrame:CGRectMake(JPL_SCR_WIDTH - 44, 21, 24, 11)];
    }
    return _batteryView;
}

- (BarrageView *)barrageView{
    if (!_barrageView) {
        _barrageView = [[BarrageView alloc]initWithFrame:CGRectMake(0, 62, JPL_SCR_WIDTH - 48, 96)];
        _barrageView.backgroundColor = UIColor.clearColor;
        _barrageView.speedBaseVlaue = 10;
        _barrageView.cellHeight = 32;
        _barrageView.delegate = self;
        _barrageView.dataSouce = self;
    }
    return _barrageView;
}

- (UIButton *)locationBt{
    if (!_locationBt) {
        _locationBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationBt.backgroundColor = [UIColor jpl_colorWithHexString:@"000000" alpha:0.2];
        [_locationBt setImage:JPLImageWithName(@"jpl_live_location") forState:UIControlStateDisabled];
        [_locationBt setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
        _locationBt.titleLabel.font = [UIFont jpl_pingFangWithSize:12];
        _locationBt.layer.cornerRadius = 10;
        _locationBt.layer.masksToBounds = YES;
        _locationBt.enabled = NO;
    }
    return _locationBt;
}

@end
