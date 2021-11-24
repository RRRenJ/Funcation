//
//  JPLLiveBeautyView.m
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveBeautyView.h"


@interface JPLLiveBeautyView ()

@property (nonatomic, strong) UIView * tapView;

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UISlider * beautySlider;

@property (nonatomic, strong) UISlider * whitenessSlider;

@property (nonatomic, strong) UISlider * ruddySlider;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * beautyLb;

@property (nonatomic, strong) UILabel * beautyValueLb;

@property (nonatomic, strong) UILabel * whitenessLb;

@property (nonatomic, strong) UILabel * whitenessValueLb;

@property (nonatomic, strong) UILabel * ruddyLb;

@property (nonatomic, strong) UILabel * ruddyValueLb;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UIButton * hideBt;

@property (nonatomic, assign) BOOL isShow;


@end

@implementation JPLLiveBeautyView

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

- (void)updateLayoutWithOrientation:(BOOL)isPortrait{
    self.frame = CGRectMake(0, JPL_SCR_HEIGHT, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    
    if (isPortrait) {
        [self layoutWithPortrait];
    }else{
        [self layoutWithLandscape];
    }
    
}


- (void)setupViews{
    self.frame = CGRectMake(0, JPL_SCR_HEIGHT, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    [self addSubview:self.tapView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.beautySlider];
    [self.contentView addSubview:self.whitenessSlider];
    [self.contentView addSubview:self.ruddySlider];
    [self.contentView addSubview:self.beautyLb];
    [self.contentView addSubview:self.beautyValueLb];
    [self.contentView addSubview:self.whitenessLb];
    [self.contentView addSubview:self.whitenessValueLb];
    [self.contentView addSubview:self.ruddyLb];
    [self.contentView addSubview:self.ruddyValueLb];
    [self.contentView addSubview:self.hideBt];
    
}

- (void)layoutWithLandscape{
    
    self.contentView.frame = CGRectMake(0, JPL_SCR_HEIGHT - 165, JPL_SCR_WIDTH, 165);
    self.tapView.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT - 165);
    
    self.hideBt.hidden = YES;
    
    CGFloat left = 30;
    if ((int)(JPL_SCR_WIDTH / JPL_SCR_HEIGHT * 100) == 216) {
         left = 40;
    }
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(12);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(11);
    }];
    
    [self.beautySlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.bottom.mas_equalTo(-40);
    }];
    
    [self.beautyLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.beautySlider.mas_left);
        make.bottom.mas_equalTo(self.beautySlider.mas_top).mas_offset(-10);
    }];
    [self.beautyValueLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.beautySlider.mas_right);
        make.bottom.mas_equalTo(self.beautySlider.mas_top).mas_offset(-10);
    }];
    
    [self.whitenessSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.bottom.mas_equalTo(-40);
    }];
    
    [self.whitenessLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.whitenessSlider.mas_left);
        make.bottom.mas_equalTo(self.whitenessSlider.mas_top).mas_offset(-10);
    }];
    [self.whitenessValueLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.whitenessSlider.mas_right);
        make.bottom.mas_equalTo(self.whitenessSlider.mas_top).mas_offset(-10);
    }];
    
    [self.ruddySlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.bottom.mas_equalTo(-40);
    }];
    
    [self.ruddyLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ruddySlider.mas_left);
        make.bottom.mas_equalTo(self.ruddySlider.mas_top).mas_offset(-10);
    }];
    [self.ruddyValueLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ruddySlider.mas_right);
        make.bottom.mas_equalTo(self.ruddySlider.mas_top).mas_offset(-10);
    }];
}

- (void)layoutWithPortrait{
    self.contentView.frame = CGRectMake(0, JPL_SCR_HEIGHT - 340, JPL_SCR_WIDTH, 340);
    self.tapView.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT - 340);
    
    self.hideBt.hidden = NO;

    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(12);
    }];
    
    [self.hideBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.titleLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(11);
    }];
    
    [self.beautySlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(JPL_SCR_WIDTH - 60, 20));
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(40);
    }];
    
    [self.beautyLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.beautySlider.mas_left);
        make.bottom.mas_equalTo(self.beautySlider.mas_top).mas_offset(-10);
    }];
    [self.beautyValueLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.beautySlider.mas_right);
        make.bottom.mas_equalTo(self.beautySlider.mas_top).mas_offset(-10);
    }];
    
    [self.whitenessSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(JPL_SCR_WIDTH - 60, 20));
        make.top.mas_equalTo(self.beautySlider.mas_bottom).mas_offset(60);
    }];
    
    [self.whitenessLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.whitenessSlider.mas_left);
        make.bottom.mas_equalTo(self.whitenessSlider.mas_top).mas_offset(-10);
    }];
    [self.whitenessValueLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.whitenessSlider.mas_right);
        make.bottom.mas_equalTo(self.whitenessSlider.mas_top).mas_offset(-10);
    }];
    
    [self.ruddySlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(JPL_SCR_WIDTH - 60, 20));
        make.top.mas_equalTo(self.whitenessSlider.mas_bottom).mas_offset(60);
    }];
    
    [self.ruddyLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ruddySlider.mas_left);
        make.bottom.mas_equalTo(self.ruddySlider.mas_top).mas_offset(-10);
    }];
    [self.ruddyValueLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ruddySlider.mas_right);
        make.bottom.mas_equalTo(self.ruddySlider.mas_top).mas_offset(-10);
    }];
    
    
    
    
}



- (void)addActions{
   
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClikced)];
    [self.tapView addGestureRecognizer:tap];
}


- (void)tapGestureClikced{
    [self hide];
    if(self.tapHideBlock){
        self.tapHideBlock();
    }
}

- (void)beautySliderValueChange{
    int value = self.beautySlider.value;
    self.beautyValue = value;
    self.beautyValueLb.text = [NSString stringWithFormat:@"%d",value];
    if (self.beautyBlock) {
        self.beautyBlock((int)(value / 10.0f));
    }
}

- (void)whitenessSliderValueChange{
    int value = self.whitenessSlider.value;
    self.whitenessValue = value;
    self.whitenessValueLb.text = [NSString stringWithFormat:@"%d",value];
    if (self.whitenessBlock) {
        self.whitenessBlock((int)(value / 10.0f));
    }
}

- (void)ruddySliderValueChange{
    int value = self.ruddySlider.value;
    self.ruddyValue = value;
    self.ruddyValueLb.text = [NSString stringWithFormat:@"%d",value];
    if (self.ruddyBlock) {
        self.ruddyBlock( (int)(value / 10.0f));
    }
}

- (void)show{
    [[JPLUtil currentViewController].view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -JPL_SCR_HEIGHT);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
        
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - set
- (void)setBeautyValue:(float)beautyValue{
    _beautyValue = beautyValue;
    self.beautySlider.value = _beautyValue;
    self.beautyValueLb.text =  [NSString stringWithFormat:@"%.0f",_beautyValue];
}

- (void)setWhitenessValue:(float)whitenessValue{
    _whitenessValue = whitenessValue;
    self.whitenessSlider.value = _whitenessValue;
    self.whitenessValueLb.text =  [NSString stringWithFormat:@"%.0f",_whitenessValue];
}

- (void)setRuddyValue:(float)ruddyValue{
    _ruddyValue = ruddyValue;
    self.ruddySlider.value = _ruddyValue;
    self.ruddyValueLb.text =  [NSString stringWithFormat:@"%.0f",_ruddyValue];
}

#pragma mark - get
- (UISlider *)beautySlider{
    if (!_beautySlider) {
        _beautySlider = [[UISlider alloc]init];
        _beautySlider.minimumValue = 0;
        _beautySlider.maximumValue = 100;
        [_beautySlider addTarget:self action:@selector(beautySliderValueChange) forControlEvents:UIControlEventValueChanged];
    }
    return _beautySlider;
}

- (UISlider *)whitenessSlider{
    if (!_whitenessSlider) {
        _whitenessSlider = [[UISlider alloc]init];
        _whitenessSlider.minimumValue = 0;
        _whitenessSlider.maximumValue = 100;
        [_whitenessSlider addTarget:self action:@selector(whitenessSliderValueChange) forControlEvents:UIControlEventValueChanged];
    }
    return _whitenessSlider;
}

- (UISlider *)ruddySlider{
    if (!_ruddySlider) {
        _ruddySlider = [[UISlider alloc]init];
        _ruddySlider.minimumValue = 0;
        _ruddySlider.maximumValue = 100;
        [_ruddySlider addTarget:self action:@selector(ruddySliderValueChange) forControlEvents:UIControlEventValueChanged];
    }
    return _ruddySlider;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = [UIColor colorWithWhite:1 alpha:0.81];
        _titleLb.text = @"调节美颜";
        _titleLb.font = [UIFont jpl_pingFangWithSize:15];
    }
    return _titleLb;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor jpl_colorWithHexString:@"#383838"];
    }
    return _lineView;
}

- (UILabel *)beautyLb{
    if (!_beautyLb) {
        _beautyLb = [[UILabel alloc]init];
        _beautyLb.textColor = [UIColor whiteColor];
        _beautyLb.text = @"美颜";
        _beautyLb.font = [UIFont jpl_pingFangWithSize:12];
        _beautyLb.textAlignment = NSTextAlignmentLeft;
    }
    return _beautyLb;
}

- (UILabel *)beautyValueLb{
    if (!_beautyValueLb) {
        _beautyValueLb = [[UILabel alloc]init];
        _beautyValueLb.textColor = [UIColor whiteColor];
        _beautyValueLb.text = @"0";
        _beautyValueLb.font = [UIFont jpl_pingFangWithSize:12];
        _beautyValueLb.textAlignment = NSTextAlignmentRight;
    }
    return _beautyValueLb;
}

- (UILabel *)whitenessLb{
    if (!_whitenessLb) {
        _whitenessLb = [[UILabel alloc]init];
        _whitenessLb.textColor = [UIColor whiteColor];
        _whitenessLb.text = @"美白";
        _whitenessLb.font = [UIFont jpl_pingFangWithSize:12];
        _whitenessLb.textAlignment = NSTextAlignmentLeft;
    }
    return _whitenessLb;
}

- (UILabel *)whitenessValueLb{
    if (!_whitenessValueLb) {
        _whitenessValueLb = [[UILabel alloc]init];
        _whitenessValueLb.textColor = [UIColor whiteColor];
        _whitenessValueLb.text = @"0";
        _whitenessValueLb.font = [UIFont jpl_pingFangWithSize:12];
        _whitenessValueLb.textAlignment = NSTextAlignmentRight;
    }
    return _whitenessValueLb;
}

- (UILabel *)ruddyLb{
    if (!_ruddyLb) {
        _ruddyLb = [[UILabel alloc]init];
        _ruddyLb.textColor = [UIColor whiteColor];
        _ruddyLb.text = @"红润";
        _ruddyLb.font = [UIFont jpl_pingFangWithSize:12];
        _ruddyLb.textAlignment = NSTextAlignmentLeft;
    }
    return _ruddyLb;
}

- (UILabel *)ruddyValueLb{
    if (!_ruddyValueLb) {
        _ruddyValueLb = [[UILabel alloc]init];
        _ruddyValueLb.textColor = [UIColor whiteColor];
        _ruddyValueLb.text = @"0";
        _ruddyValueLb.font = [UIFont jpl_pingFangWithSize:12];
        _ruddyValueLb.textAlignment = NSTextAlignmentRight;
    }
    return _ruddyValueLb;
}

- (UIView *)tapView{
    if (!_tapView) {
        _tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT - 165)];
        _tapView.userInteractionEnabled = YES;
        _tapView.backgroundColor = UIColor.clearColor;
    }
    return _tapView;;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, JPL_SCR_HEIGHT - 165, JPL_SCR_WIDTH, 165)];
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor jpl_colorWithHexString:@"#262626" alpha:0.8];
    }
    return _contentView;;
}

- (UIButton *)hideBt{
    if (!_hideBt) {
        _hideBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hideBt setImage:JPLImageWithName(@"live_pop_hide") forState:UIControlStateNormal];
        [_hideBt addTarget:self action:@selector(tapGestureClikced) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideBt;
}

@end
