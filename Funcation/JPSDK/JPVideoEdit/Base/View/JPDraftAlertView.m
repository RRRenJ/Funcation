//
//  JPDraftAlertView.m
//  JPSDK
//
//  Created by 任敬 on 2021/10/25.
//

#import "JPDraftAlertView.h"


@interface JPDraftAlertView ()

@property (nonatomic, strong) UIView * backView;

@property (nonatomic, strong) UIView * alertView;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel  * subTitleLb;

@property (nonatomic, strong) UIButton * cancelBt;

@property (nonatomic, strong) UIButton * confirmBt;

@property (nonatomic, strong) UIViewController * vc;

@end


@implementation JPDraftAlertView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}


#pragma - mark init view
- (void)setupViews{
    self.frame = CGRectMake(0, 0, JP_SCREEN_WIDTH, JP_SCREEN_HEIGHT);
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.backView];
    [self addSubview:self.alertView];
    [self.alertView addSubview:self.titleLb];
    [self.alertView addSubview:self.subTitleLb];
    [self.alertView addSubview:self.cancelBt];
    [self.alertView addSubview:self.confirmBt];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(282, 150));
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.subTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(3);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.cancelBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.bottom.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(108, 30));
    }];
    [self.confirmBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-26);
        make.bottom.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(108, 30));
    }];
}


- (void)confirmAction{
    if (self.confirmBlock) {
        self.confirmBlock();
        [self hide];
    }
}

- (void)cancelAction{
    [self hide];
}

- (void)show:(UIViewController *)vc{
    self.vc = vc;
    [self.vc.view addSubview:self];
    self.alertView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.alpha = 1;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


#pragma - mark set


#pragma - mark get

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = UIColor.clearColor;
    }
    return _backView;
}

- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc]init];
        _alertView.backgroundColor = [UIColor jp_colorWithHexString:@"#262626"];
        _alertView.layer.cornerRadius = 7;
        _alertView.layer.masksToBounds = YES;
    }
    return _alertView;
}


- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont jp_pingFangWithSize:14 weight:UIFontWeightSemibold];
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.text = @"确认删除吗？";
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

- (UILabel *)subTitleLb{
    if (!_subTitleLb) {
        _subTitleLb = [[UILabel alloc]init];
        _subTitleLb.font = [UIFont jp_pingFangWithSize:12 ];
        _subTitleLb.textColor = [UIColor jp_colorWithHexString:@"ffffff" alpha:0.82];
        _subTitleLb.text = @"删除后不可恢复";
        _subTitleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLb;
}

- (UIButton *)cancelBt{
    if (!_cancelBt) {
        _cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBt setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBt setTitleColor:[UIColor jp_colorWithHexString:@"#1D6CFD"] forState:UIControlStateNormal];
        _cancelBt.backgroundColor = [UIColor jp_colorWithHexString:@"262626"];
        _cancelBt.titleLabel.font = [UIFont jp_pingFangWithSize:12];
        _cancelBt.layer.borderWidth = 1;
        _cancelBt.layer.borderColor = [UIColor jp_colorWithHexString:@"#1D6CFD"].CGColor;
        _cancelBt.layer.cornerRadius = 15;
        _cancelBt.layer.masksToBounds = YES;
        [_cancelBt addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBt;
}

- (UIButton *)confirmBt{
    if (!_confirmBt) {
        _confirmBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBt setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBt.backgroundColor = [UIColor jp_colorWithHexString:@"#1D6CFD"];
        _confirmBt.titleLabel.font = [UIFont jp_pingFangWithSize:12];
        _confirmBt.layer.cornerRadius = 15;
        _confirmBt.layer.masksToBounds = YES;
        [_confirmBt addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBt;
}


@end
