//
//  JPLLiveVideoCell.m
//  jper
//
//  Created by RRRenJ on 2020/6/4.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveVideoCell.h"


@interface JPLLiveVideoCell ()

@property (nonatomic, strong) UIImageView * backView;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * timeLb;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UIButton * functionBt;

@end

@implementation JPLLiveVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self addActions];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

- (void)setupViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLb];
    [self.backView addSubview:self.timeLb];
    [self.backView addSubview:self.functionBt];
    [self.backView addSubview:self.lineView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.functionBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(88, 30));
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(self.functionBt.mas_left).mas_offset(-20);
        make.bottom.mas_equalTo(self.timeLb.mas_top).mas_offset(-6);
    }];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(self.functionBt.mas_left).mas_offset(-20);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-13);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(0.5);
    }];

}

- (void)addActions{
    
}

- (void)functionBtClicked{
    if (self.functionBlock) {
        self.functionBlock();
    }
}

#pragma mark - set


- (void)setModel:(JPLLiveAMModel *)model{
    _model = model;
    self.titleLb.text = _model.live_name;

    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter1.dateFormat = @"MM-dd HH:mm";
    self.timeLb.text = [NSString stringWithFormat:@"%@ ~ %@",[formatter1 stringFromDate:[formatter dateFromString:_model.live_reserve_startime ]] ,[formatter1 stringFromDate:[formatter dateFromString:_model.live_reserve_endtime ]]];
//    if ([_model.live_status isEqualToString:@"1"]) {
//        self.functionBt.enabled = YES;
//        [self.functionBt setTitle:@"进入直播" forState:UIControlStateNormal];
//        self.functionBt.layer.borderColor = [UIColor jpl_colorWithHexString:@"#0091FF"].CGColor;
//    }else if ([_model.live_status isEqualToString:@"2"]){
//        self.functionBt.enabled = YES;
//        [self.functionBt setTitle:@"取消预约" forState:UIControlStateNormal];
//        self.functionBt.layer.borderColor = [UIColor jpl_colorWithHexString:@"#0091FF"].CGColor;
//    }else if ([_model.live_status isEqualToString:@"3"]){
//        self.functionBt.enabled = NO;
//        [self.functionBt setTitle:@"直播结束" forState:UIControlStateDisabled];
//        self.functionBt.layer.borderColor = [UIColor jpl_colorWithHexString:@"#adadad"].CGColor;
//    }else if ([_model.live_status isEqualToString:@"4"]){
//        self.functionBt.enabled = NO;
//        [self.functionBt setTitle:@"过期未直播" forState:UIControlStateDisabled];
//        self.functionBt.layer.borderColor = [UIColor jpl_colorWithHexString:@"#adadad"].CGColor;
//    }else if ([_model.live_status isEqualToString:@"5"]){
//        self.functionBt.enabled = NO;
//        [self.functionBt setTitle:@"直播已取消" forState:UIControlStateDisabled];
//        self.functionBt.layer.borderColor = [UIColor jpl_colorWithHexString:@"#adadad"].CGColor;
//    }
}

- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    self.lineView.hidden = _isLast;
}

#pragma mark - get

- (UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc]init];
        _backView.userInteractionEnabled = YES;
        _backView.image = [JPLImageWithName(@"liveVideoCell") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
    }
    return _backView;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = [UIColor jpl_colorWithHexString:@"#353535"];
        _titleLb.font = [UIFont systemFontOfSize:16];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.numberOfLines = 2;
    }
    return _titleLb;
}

- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [[UILabel alloc]init];
        _timeLb.textColor = [UIColor jpl_colorWithHexString:@"#ADADAD"];
        _timeLb.font = [UIFont systemFontOfSize:14];
        _timeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLb;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor jpl_colorWithHexString:@"#E7E7E7"];
    }
    return _lineView;
}

- (UIButton *)functionBt{
    if (!_functionBt) {
        _functionBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_functionBt setTitle:@"" forState:UIControlStateNormal];
        [_functionBt addTarget:self action:@selector(functionBtClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_functionBt setTitle:@"" forState:UIControlStateDisabled];
        [_functionBt setTitleColor:[UIColor jpl_colorWithHexString:@"#0091FF"] forState:UIControlStateNormal];
        [_functionBt setTitleColor:[UIColor jpl_colorWithHexString:@"#ADADAD"] forState:UIControlStateDisabled];
        _functionBt.titleLabel.font = [UIFont systemFontOfSize:12];
        _functionBt.titleLabel.adjustsFontSizeToFitWidth = YES;
        _functionBt.titleLabel.minimumScaleFactor = 0.5;
        _functionBt.layer.cornerRadius = 15;
        _functionBt.layer.masksToBounds = YES;
        _functionBt.layer.borderWidth = 1;
//        _functionBt.layer.borderColor = [UIColor jpl_colorWithHexString:@"#0091FF"].CGColor;
    }
    return _functionBt;
}

@end
