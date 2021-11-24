//
//  JPLLiveVideoAPMFooterView.m
//  jper
//
//  Created by RRRenJ on 2020/9/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveVideoAPMFooterView.h"

@interface JPLLiveVideoAPMFooterView ()

@property (nonatomic, strong) UIImageView * backView;

@property (nonatomic, strong) UIButton * appointmentBt;

@end

@implementation JPLLiveVideoAPMFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self addActions];
    }
    return self;
}

- (void)setupViews{
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.appointmentBt];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.appointmentBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.bottom.mas_equalTo(-30);
        make.top.mas_equalTo(7);
    }];

}

- (void)addActions{
    
}

- (void)appointmentBtClicked{
    if (self.appointmentBlock) {
        self.appointmentBlock();
    }
}

#pragma mark - set


#pragma mark - get
- (UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc]init];
        _backView.userInteractionEnabled = YES;
        _backView.image = [JPLImageWithName(@"liveVideoAPMBottom") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
    }
    return _backView;
}

- (UIButton *)appointmentBt{
    if (!_appointmentBt) {
        _appointmentBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_appointmentBt setTitle:@"继续预约" forState:UIControlStateNormal];
        [_appointmentBt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _appointmentBt.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _appointmentBt.backgroundColor = [UIColor jpl_colorWithHexString:@"#0091FF"];
        _appointmentBt.layer.cornerRadius = 20;
        _appointmentBt.layer.shadowColor = [UIColor jpl_colorWithHexString:@"#0091FF" alpha:0.18].CGColor;
        _appointmentBt.layer.shadowOffset = CGSizeMake(0, 4);
        _appointmentBt.layer.shadowOpacity = 1;
        _appointmentBt.layer.shadowRadius = 5;
        [_appointmentBt addTarget:self action:@selector(appointmentBtClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appointmentBt;
}

@end
