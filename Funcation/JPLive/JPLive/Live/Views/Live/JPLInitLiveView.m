//
//  JPLInitLiveView.m
//  jper
//
//  Created by RRRenJ on 2020/5/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLInitLiveView.h"

@interface JPLInitLiveView()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton * backBt;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UITextField * titleTF;

@property (nonatomic, strong) UIButton * startBt;

@property (nonatomic, strong) UIView * topView;

@property (nonatomic, strong) UIButton * settingBt;

@property (nonatomic, assign) BOOL close;

@property (nonatomic, strong) CAGradientLayer * topLayer;

@property (nonatomic, assign) BOOL isPortrait;


@end

@implementation JPLInitLiveView


- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupViews];
        [self addNotfi];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


- (void)updateLayoutWithOrientation:(BOOL)isPortrait{
    self.isPortrait = isPortrait;
    self.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    if (isPortrait) {
        [self layoutWithPortrait];
    }else{
        [self layoutWithLandscape];
    }
}

- (void)setupViews{
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.topView];
    [self addSubview:self.settingBt];
    [self addSubview:self.backBt];
    [self addSubview:self.titleLb];
    [self addSubview:self.titleTF];
    [self addSubview:self.startBt];
    self.close = NO;
}

- (void)layoutWithLandscape{
    
    self.topView.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, 62);
    self.settingBt.frame = CGRectMake(JPL_SCR_WIDTH - 48,10, 33, 33);
    self.backBt.frame = CGRectMake(15, 10, 33, 33);
    self.titleLb.frame = CGRectMake(JPL_SCR_WIDTH/2 - 50, 16, 100, 22);
    [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(344, 46));
        make.centerX.mas_equalTo(0);
    }];
    
    [self.startBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(166, 40));
        make.centerX.mas_equalTo(0);
    }];
    
    if (self.topLayer) {
        [self.topLayer removeFromSuperlayer];
    }
    self.topLayer = [UIColor jpl_gradientWith:self.topView.bounds fromeColor:[UIColor jpl_colorWithHexString:@"000000" alpha:0.47] toColor:[UIColor jpl_colorWithHexString:@"000000" alpha:0] fromePoint:CGPointMake(0, 0) toPoint:CGPointMake(0, 1)];
    [self.topView.layer addSublayer:self.topLayer];

}

- (void)layoutWithPortrait{
    
    self.topView.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_STATUS_HEIGHT + 44);
    self.settingBt.frame = CGRectMake(JPL_SCR_WIDTH - 54,JPL_STATUS_HEIGHT, 44, 44);
    self.backBt.frame = CGRectMake(10, JPL_STATUS_HEIGHT, 44, 44);
    self.titleLb.frame = CGRectMake(JPL_SCR_WIDTH/2 - 50, JPL_STATUS_HEIGHT, 100, 44);
    [self.titleTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_centerY).mas_offset(-50);;
        make.size.mas_equalTo(CGSizeMake(344, 46));
        make.centerX.mas_equalTo(0);
    }];
    
    [self.startBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-50 - JPL_STATUS_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(166, 40));
        make.centerX.mas_equalTo(0);
    }];
    
    if (self.topLayer) {
        [self.topLayer removeFromSuperlayer];
    }
    self.topLayer = [UIColor jpl_gradientWith:self.topView.bounds fromeColor:[UIColor jpl_colorWithHexString:@"000000" alpha:0.47] toColor:[UIColor jpl_colorWithHexString:@"000000" alpha:0] fromePoint:CGPointMake(0, 0) toPoint:CGPointMake(0, 1)];
    [self.topView.layer addSublayer:self.topLayer];

}


- (void)addNotfi{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}


- (void)liveBackBtClicked{
    self.close = YES;
    if (self.liveBackBlock) {
        self.liveBackBlock();
    }
}

- (void)liveStartBtClicked{
    if (self.liveStartBlock){
        self.liveStartBlock(self.titleTF.text);
    }
}

- (void)settingBtClicked{
    if (self.liveSettingBlock){
        self.liveSettingBlock();
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.tfWillEditBlock) {
        return self.tfWillEditBlock();
    }else{
        return NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.titleTF endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.close) {
        return;
    }
    if (self.tfEndEditBlock) {
        self.tfEndEditBlock(self.titleTF.text);
    }
}


- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.size.height / 2.0 < frame.size.height + 20) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.titleTF mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(- frame.size.height - 20);
                make.size.mas_equalTo(CGSizeMake(344, 46));
                make.centerX.mas_equalTo(0);
            }];
            [self layoutIfNeeded];
        }];
        
    }
}

- (void)keyboardWillHide{
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.titleTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.isPortrait) {
                make.bottom.mas_equalTo(self.mas_centerY).mas_offset(-50);
            }else{
                make.bottom.mas_equalTo(self.mas_centerY);
            }
            make.size.mas_equalTo(CGSizeMake(344, 46));
            make.centerX.mas_equalTo(0);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)setLiveTitle:(NSString *)liveTitle{
    _liveTitle = liveTitle;
    self.titleTF.text = _liveTitle;
}


- (UIButton *)backBt{
    if (!_backBt) {
        _backBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBt setImage:JPLImageWithName(@"live_back") forState:UIControlStateNormal];
        [_backBt addTarget:self action:@selector(liveBackBtClicked) forControlEvents:UIControlEventTouchUpInside];
        _backBt.frame = CGRectMake(15, 10, 33, 33);
    }
    return _backBt;
}

- (UIButton *)settingBt{
    if (!_settingBt) {
        _settingBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBt setImage:JPLImageWithName(@"live_setting") forState:UIControlStateNormal];
        [_settingBt addTarget:self action:@selector(settingBtClicked) forControlEvents:UIControlEventTouchUpInside];
        _settingBt.frame = CGRectMake(JPL_SCR_WIDTH - 48,10, 33, 33);
    }
    return _settingBt;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(JPL_SCR_WIDTH/2 - 50, 16, 100, 22)];
        _titleLb.text = @"发起直播";
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = UIColor.whiteColor;
        _titleLb.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    }
    return _titleLb;
}

- (UITextField *)titleTF{
    if (!_titleTF) {
        _titleTF = [[UITextField alloc]init];
        _titleTF.borderStyle = UITextBorderStyleNone;
        _titleTF.font = [UIFont systemFontOfSize:16 ];
        _titleTF.textColor = UIColor.whiteColor;
        _titleTF.layer.cornerRadius = 23;
        _titleTF.layer.masksToBounds = YES;
        _titleTF.delegate = self;
        _titleTF.textAlignment = NSTextAlignmentCenter;
        _titleTF.returnKeyType = UIReturnKeyDone;
        _titleTF.backgroundColor = [UIColor jpl_colorWithHexString:@"000000" alpha:0.85];
        _titleTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请填写直播标题..." attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName :UIColor.whiteColor }];
       
    }
    return _titleTF;
}

- (UIButton *)startBt{
    if (!_startBt) {
        _startBt = [UIButton buttonWithType:UIButtonTypeSystem];
        [_startBt setTitle:@"开始直播" forState:UIControlStateNormal];
        [_startBt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _startBt.titleLabel.font = [UIFont systemFontOfSize:14];
        _startBt.backgroundColor = [UIColor jpl_colorWithHexString:@"0091FF"];
        _startBt.layer.cornerRadius = 20;
        _startBt.layer.masksToBounds = YES;
        [_startBt addTarget:self action:@selector(liveStartBtClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _startBt;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JPL_SCR_WIDTH, 62)];
        _topView.backgroundColor = UIColor.clearColor;
    }
    return  _topView;
}

@end
