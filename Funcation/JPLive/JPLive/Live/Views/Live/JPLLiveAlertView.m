//
//  JPLLiveAlertView.m
//  jper
//
//  Created by RRRenJ on 2020/5/28.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveAlertView.h"
#import "LewPopupViewController.h"



@interface JPLLiveAlertView ()

@property (nonatomic, assign) JPLLiveAlertType type;

@property (nonatomic, strong) UIButton * comfirmBt;

@property (nonatomic, strong) UIButton * cancelBt;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * messageLb;

@property (nonatomic, strong) UILabel * remindLb;

@property (nonatomic, strong) UIImageView * warningIV;

@end

@implementation JPLLiveAlertView

- (instancetype)initWithType:(JPLLiveAlertType)type title:(NSString *)title{
    self = [super init];
    if (self) {
        self.type = type;
        self.titleLb.text = title;
        [self setupViews];
        [self addActions];
    }
    return self;
}



- (void)setupViews{
    self.bounds = CGRectMake(0, 0, 282, 220);
    self.backgroundColor = [UIColor jpl_colorWithHexString:@"#262626"];
    self.layer.cornerRadius = 7;
    self.layer.masksToBounds = YES;
    if (self.type == JPLLiveAlertTypeAsk) {
        [self setupViewsAsk];
    }else if (self.type == JPLLiveAlertTypeRemind){
        [self setupViewsRemind];
    }else if (self.type == JPLLiveAlertTypeWarning){
        [self setupViewsWarning];
    }
    
}

- (void)addActions{
    
}


- (void)setAskBtView{
    self.cancelBt.backgroundColor = [UIColor jpl_colorWithHexString:@"#0091FF"];
    self.cancelBt.layer.borderWidth = 0;
    [self.cancelBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.comfirmBt.backgroundColor = [UIColor clearColor];
    self.comfirmBt.layer.borderColor = [UIColor jpl_colorWithHexString:@"#0091FF"].CGColor;
    [self.comfirmBt setTitleColor:[UIColor jpl_colorWithHexString:@"#0091FF"] forState:UIControlStateNormal];
    self.comfirmBt.layer.borderWidth = 1;
   
}

- (void)resetBtView{
    self.cancelBt.backgroundColor = [UIColor clearColor];
    [self.cancelBt setTitleColor:[UIColor jpl_colorWithHexString:@"#0091FF"] forState:UIControlStateNormal];
    self.cancelBt.layer.borderWidth = 1;
    self.comfirmBt.backgroundColor = [UIColor jpl_colorWithHexString:@"#0091FF"];
    self.comfirmBt.layer.borderColor = [UIColor jpl_colorWithHexString:@"#0091FF"].CGColor;
    [self.comfirmBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.comfirmBt.layer.borderWidth = 0;
}

- (void)setupViewsAsk{
    [self setAskBtView];
    [self addSubview:self.titleLb];
    [self addSubview:self.messageLb];
    [self addSubview:self.cancelBt];
    [self addSubview:self.comfirmBt];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.comfirmBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_centerX).mas_offset(-9);
        make.size.mas_equalTo(CGSizeMake(108, 30));
        make.bottom.mas_equalTo(-30);
    }];
    
    [self.cancelBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).mas_offset(9);
        make.size.mas_equalTo(CGSizeMake(108, 30));
        make.bottom.mas_equalTo(-30);
    }];
    
}

- (void)setupViewsRemind{
    [self resetBtView];
    [self addSubview:self.titleLb];
    [self addSubview:self.messageLb];
    [self addSubview:self.remindLb];
    [self addSubview:self.comfirmBt];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.remindLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageLb.mas_bottom).mas_offset(22);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];

    [self.comfirmBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(108, 30));
        make.bottom.mas_equalTo(-30);
    }];
}

- (void)setupViewsWarning{
    [self resetBtView];
    [self addSubview:self.warningIV];
    [self addSubview:self.titleLb];
    [self addSubview:self.comfirmBt];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.centerX.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(-10);
    }];
    
    [self.warningIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleLb.mas_left).mas_offset(-8);
        make.centerY.mas_equalTo(self.titleLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    
    [self.comfirmBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(108, 30));
        make.bottom.mas_equalTo(-30);
    }];
}

- (void)comfirmBtClicked{
    if (self.comfirmBlock) {
        self.comfirmBlock();
    }
}

- (void)cancelBtClicked{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self hide];
}

- (void)show{
    [self layoutIfNeeded];
    [self setNeedsLayout];
    CGFloat height = 0;
    if (self.type == JPLLiveAlertTypeAsk){
        height = self.titleLb.height + self.messageLb.height + self.comfirmBt.height + 52 + 5 + 28 ;
    }else if(self.type == JPLLiveAlertTypeRemind){
        height = self.titleLb.height + self.messageLb.height + self.comfirmBt.height + self.remindLb.height + 52 + 5 + 22 + 30;
    }else if(self.type == JPLLiveAlertTypeWarning){
        height = self.titleLb.height + self.comfirmBt.height + 52 + 38;
    }
    self.bounds = CGRectMake(0, 0, 282, height);
    LewPopupViewAnimationFade * animation = [[LewPopupViewAnimationFade alloc]init];
    [JPLUtil.currentViewController lew_presentPopupView:self animation:animation backgroundClickable:NO];
}

- (void)hide{
    [JPLUtil.currentViewController lew_dismissPopupView];
}



#pragma mark - set
- (void)setRemind:(NSString *)remind{
    _remind = remind;
    self.remindLb.text = _remind;
}

- (void)setMessage:(NSString *)message{
    _message = message;
    self.messageLb.text = _message;
    [self.messageLb changeLineSpace:5];
}

#pragma mark - get
- (UIButton *)comfirmBt{
    if (!_comfirmBt) {
        _comfirmBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comfirmBt setTitle:@"确定" forState:UIControlStateNormal];
        [_comfirmBt addTarget:self action:@selector(comfirmBtClicked) forControlEvents:UIControlEventTouchUpInside];
        _comfirmBt.bounds = CGRectMake(0, 0, 108, 30);
        _comfirmBt.backgroundColor = [UIColor jpl_colorWithHexString:@"#0091FF"];
        _comfirmBt.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        _comfirmBt.layer.cornerRadius = 15;
        _comfirmBt.layer.masksToBounds = YES;
    }
    return _comfirmBt;
}

- (UIButton *)cancelBt{
    if (!_cancelBt) {
        _cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBt setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBt addTarget:self action:@selector(cancelBtClicked) forControlEvents:UIControlEventTouchUpInside];
    
        [_cancelBt setTitleColor:[UIColor jpl_colorWithHexString:@"#0091FF"] forState:UIControlStateNormal];
        _cancelBt.bounds = CGRectMake(0, 0, 108, 30);
        _cancelBt.backgroundColor = [UIColor clearColor];
        _cancelBt.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        _cancelBt.layer.cornerRadius = 15;
        _cancelBt.layer.masksToBounds = YES;
        _cancelBt.layer.borderColor = [UIColor jpl_colorWithHexString:@"#0091FF"].CGColor;
        _cancelBt.layer.borderWidth = 1;
    }
    return _cancelBt;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = UIColor.whiteColor;
        _titleLb.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;;
}

- (UILabel *)messageLb{
    if (!_messageLb) {
        _messageLb = [[UILabel alloc]init];
        _messageLb.textColor = [UIColor jpl_colorWithHexString:@"ffffff" alpha:0.50];
        _messageLb.font = [UIFont systemFontOfSize:12 ];
        _messageLb.textAlignment = NSTextAlignmentCenter;
        _messageLb.numberOfLines = 0;
    }
    return _messageLb;;
}

- (UILabel *)remindLb{
    if (!_remindLb) {
        _remindLb = [[UILabel alloc]init];
        _remindLb.textColor = [UIColor jpl_colorWithHexString:@"#F4605C"];
        _remindLb.font = [UIFont systemFontOfSize:12];
        _remindLb.textAlignment = NSTextAlignmentCenter;
    }
    return _remindLb;
}

- (UIImageView *)warningIV{
    if (!_warningIV) {
        _warningIV = [[UIImageView alloc]initWithImage:JPLImageWithName(@"live_zhuyi")];
    }
    return _warningIV;
}

@end
