//
//  JPLLiveListCell.m
//  JPLSDK
//
//  Created by 任敬 on 2021/11/1.
//

#import "JPLLiveListCell.h"

@interface JPLLiveListCell ()

@property (nonatomic, strong) UIView * backView;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * startTimeLb;

@property (nonatomic, strong) UILabel * endTimeLb;

@property (nonatomic, strong) UIButton * liveBt;

@property (nonatomic, strong) UIButton * reAMBt;

@property (nonatomic, strong) UILabel * auditStatusLb;

@property (nonatomic, strong) UIImageView * auditStatusIV;

@property (nonatomic, strong) UIButton * statusBt;

@property (nonatomic, strong) UIButton * modifyBt;

@property (nonatomic, strong) UILabel * failLb;

@end

@implementation JPLLiveListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        self.backView.backgroundColor = [UIColor jpl_colorWithHexString:@"f8f8f8"];
    }else{
        self.backView.backgroundColor = UIColor.whiteColor;
    }
}


#pragma - mark init view


- (void)setupViews{
    
    self.contentView.backgroundColor = [UIColor jpl_colorWithHexString:@"f8f8f8"];
    self.backView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLb];
    [self.backView addSubview:self.startTimeLb];
    [self.backView addSubview:self.endTimeLb];
    [self.backView addSubview:self.failLb];
    [self.backView addSubview:self.auditStatusIV];
    [self.backView addSubview:self.auditStatusLb];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 0, 0, 0));
    }];
    
    [self.auditStatusLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.centerY.mas_equalTo(self.titleLb.mas_centerY);
    }];
    [self.auditStatusIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.auditStatusLb.mas_left).mas_offset(-3);
        make.centerY.mas_equalTo(self.auditStatusLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(self.auditStatusLb.mas_left).mas_offset(-20);
    }];
    
    [self.startTimeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(15);
    }];
    
    [self.endTimeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.startTimeLb.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(15);
    }];
    
    [self.failLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.endTimeLb.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(-112);
        make.height.mas_equalTo(0);
        make.bottom.mas_equalTo(-8);
    }];
    
}

- (void)layoutWithStatus:(NSString *)status{
    [self.liveBt removeFromSuperview];
    [self.reAMBt removeFromSuperview];
    [self.statusBt removeFromSuperview];
    [self.modifyBt removeFromSuperview];
    self.auditStatusIV.hidden = YES;
    if ([status isEqualToString:@"1"]) {
        [self layoutWithAuditSuccessAndCanLive];
    }else if([status isEqualToString:@"2"]){
        [self layoutWithWiteAudit];
    }else if([status isEqualToString:@"3"]){
        [self layoutWithAuditting];
    }else if([status isEqualToString:@"4"]){
        [self layoutWithAuditSuccessAndWaitLive];
    }else if([status isEqualToString:@"5"]){
        self.model.live_reason = @"his给org和我我我很反感我偶尔会如果我偶尔会让给org黑哦人格和日哦 分工会欧冠黑哦人格化个我偶尔会如果我偶尔更黑org黑org黑欧冠";
        [self layoutWithAuditFail];
    }else if([status isEqualToString:@"6"]){
        [self layoutWithOuttime];
    }else{
        [self layoutWithLiveEnd];
    }
    CGSize size = [JPLUtil getStringSizeWith:[UIFont jpl_pingFangWithSize:13 weight:UIFontWeightMedium] andContainerSize:CGSizeMake(CGFLOAT_MAX, 15) andString:self.auditStatusLb.text];
    [self.auditStatusLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.centerY.mas_equalTo(self.titleLb.mas_centerY);
        make.width.mas_equalTo(ceil(size.width));
    }];
}

- (void)layoutWithAuditSuccessAndCanLive{
    self.auditStatusIV.hidden = NO;
    self.auditStatusIV.image = JPLImageWithName(@"am_audit_success");
    self.auditStatusLb.text = @"审核成功";
    self.auditStatusLb.textColor = [UIColor jpl_colorWithHexString:@"#1D6CFD"];
    [self.backView addSubview:self.liveBt];
    [self.liveBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(78, 34));
    }];
}

- (void)layoutWithWiteAudit{
    self.auditStatusIV.hidden = YES;
    self.auditStatusLb.text = @"待审核";
    self.auditStatusLb.textColor = [UIColor jpl_colorWithHexString:@"#FF9C4D"];
    [self.backView addSubview:self.liveBt];
    [self.liveBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(78, 34));
    }];
}

- (void)layoutWithAuditting{
    self.auditStatusIV.hidden = YES;
    self.auditStatusLb.text = @"审核中";
    self.auditStatusLb.textColor = [UIColor jpl_colorWithHexString:@"#7000FF"];
}

- (void)layoutWithAuditSuccessAndWaitLive{
    self.auditStatusIV.hidden = NO;
    self.auditStatusIV.image = JPLImageWithName(@"am_audit_success");
    self.auditStatusLb.text = @"审核成功";
    self.auditStatusLb.textColor = [UIColor jpl_colorWithHexString:@"#1D6CFD"];
    [self.statusBt setTitle:@"未到直播时间" forState:UIControlStateDisabled];
    [self.backView addSubview:self.statusBt];
    [self.statusBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(95, 34));
    }];
}

- (void)layoutWithAuditFail{
    self.auditStatusIV.hidden = NO;
    self.auditStatusIV.image = JPLImageWithName(@"am_audit_fail");
    self.auditStatusLb.text = @"审核失败";
    self.auditStatusLb.textColor = [UIColor jpl_colorWithHexString:@"#FF4D4D"];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:@"失败原因：" attributes:@{NSForegroundColorAttributeName : [UIColor jpl_colorWithHexString:@"#333333"], NSFontAttributeName : [UIFont jpl_pingFangWithSize:12]}];
    NSAttributedString * attr1 = [[NSAttributedString alloc]initWithString:self.model.live_reason attributes:@{NSForegroundColorAttributeName : [UIColor jpl_colorWithHexString:@"#FF4D4D"], NSFontAttributeName : [UIFont jpl_pingFangWithSize:12]}];
    [attr appendAttributedString:attr1];
    self.failLb.attributedText = attr;
    
    [self.backView addSubview:self.reAMBt];
    [self.reAMBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.bottom.mas_equalTo(self.endTimeLb.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(78, 34));
    }];
    
}

- (void)layoutWithOuttime{
    self.auditStatusIV.hidden = YES;
    self.auditStatusLb.text = @"过期未直播";
    self.auditStatusLb.textColor = [UIColor jpl_colorWithHexString:@"#999999"];
    [self.backView addSubview:self.reAMBt];
    [self.reAMBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(78, 34));
    }];
}

- (void)layoutWithLiveEnd{
    self.auditStatusIV.hidden = YES;
    self.auditStatusLb.text = @"直播结束";
    self.auditStatusLb.textColor = [UIColor jpl_colorWithHexString:@"#999999"];
}


- (void)enterLiveAction{
    if (self.enterLiveBlock) {
        self.enterLiveBlock();
    }
}

- (void)reAMLiveAction{
    if (self.modifyLiveBlock) {
        self.modifyLiveBlock();
    }
}

- (void)modifyLiveAction{
    if (self.modifyLiveBlock) {
        self.modifyLiveBlock();
    }
}




#pragma - mark set
- (void)setModel:(JPLLiveAMModel *)model{
    _model = model;
    self.titleLb.text = _model.live_name;
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(model.liveListCellTitleOfHeight);
        make.right.mas_equalTo(self.auditStatusLb.mas_left).mas_offset(-20);
    }];
    
    self.startTimeLb.text = [NSString stringWithFormat:@"开始时间：%@",_model.live_reserve_startime];
    self.endTimeLb.text = [NSString stringWithFormat:@"结束时间：%@",_model.live_reserve_endtime];
    if ([_model.live_status isEqualToString:@"1"]) {
        [self layoutWithStatus:_model.live_status];
    }else{
        int i = arc4random() % 7;
        if (i == 1) {
            i = 2;
        }
        NSString * str = [NSString stringWithFormat:@"%d",i];
        [self layoutWithStatus:str];
    }
    [self.failLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.endTimeLb.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(-112);
        make.height.mas_equalTo(model.liveListCellFailOfHeight);
    }];
}

#pragma - mark get
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
}

- (UILabel *)titleLb{
    if(!_titleLb){
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _titleLb.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.numberOfLines = 2;
    }
    return _titleLb;
}

- (UILabel *)startTimeLb{
    if (!_startTimeLb) {
        _startTimeLb = [[UILabel alloc]init];
        _startTimeLb.font = [UIFont jpl_pingFangWithSize:13];
        _startTimeLb.textColor = [UIColor jpl_colorWithHexString:@"999999"];
        _startTimeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _startTimeLb;
}

- (UILabel *)endTimeLb{
    if (!_endTimeLb) {
        _endTimeLb = [[UILabel alloc]init];
        _endTimeLb.font = [UIFont jpl_pingFangWithSize:13];
        _endTimeLb.textColor = [UIColor jpl_colorWithHexString:@"999999"];
        _endTimeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _endTimeLb;
}

- (UIButton *)liveBt{
    if (!_liveBt) {
        _liveBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_liveBt setTitle:@"开始直播" forState:UIControlStateNormal];
        [_liveBt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _liveBt.titleLabel.font = [UIFont jpl_pingFangWithSize:12];
        _liveBt.backgroundColor = [UIColor jpl_colorWithHexString:@"#1D6CFD"];
        _liveBt.layer.cornerRadius = 17;
        _liveBt.layer.masksToBounds = YES;
        [_liveBt addTarget:self action:@selector(enterLiveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveBt;
}

- (UIButton *)reAMBt{
    if (!_reAMBt) {
        _reAMBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reAMBt setTitle:@"重新预约" forState:UIControlStateNormal];
        [_reAMBt setTitleColor:[UIColor jpl_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _reAMBt.titleLabel.font = [UIFont jpl_pingFangWithSize:12 weight:UIFontWeightMedium];
        _reAMBt.backgroundColor = UIColor.whiteColor;
        _reAMBt.layer.cornerRadius = 17;
        _reAMBt.layer.masksToBounds = YES;
        _reAMBt.layer.borderWidth = 1;
        _reAMBt.layer.borderColor = [UIColor jpl_colorWithHexString:@"#333333"].CGColor;
        [_reAMBt addTarget:self action:@selector(reAMLiveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reAMBt;
}

- (UIButton *)statusBt{
    if (!_statusBt) {
        _statusBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusBt setTitle:@"未到直播时间" forState:UIControlStateDisabled];
        [_statusBt setTitleColor:[UIColor jpl_colorWithHexString:@"#999999"] forState:UIControlStateDisabled];
        _statusBt.titleLabel.font = [UIFont jpl_pingFangWithSize:12];
        _statusBt.backgroundColor = [UIColor jpl_colorWithHexString:@"#ECECEC"];
        _statusBt.layer.cornerRadius = 17;
        _statusBt.layer.masksToBounds = YES;
        _statusBt.enabled = NO;
    }
    return _statusBt;
}

- (UIButton *)modifyBt{
    if (!_modifyBt) {
        _modifyBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modifyBt setTitle:@"修改内容" forState:UIControlStateNormal];
        [_modifyBt setTitleColor:[UIColor jpl_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _modifyBt.titleLabel.font = [UIFont jpl_pingFangWithSize:12 weight:UIFontWeightMedium];
        _modifyBt.backgroundColor = UIColor.whiteColor;
        _modifyBt.layer.cornerRadius = 17;
        _modifyBt.layer.masksToBounds = YES;
        _modifyBt.layer.borderWidth = 1;
        _modifyBt.layer.borderColor = [UIColor jpl_colorWithHexString:@"#333333"].CGColor;
        [_modifyBt addTarget:self action:@selector(modifyLiveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyBt;
}

- (UILabel *)auditStatusLb{
    if (!_auditStatusLb) {
        _auditStatusLb = [[UILabel alloc]init];
        _auditStatusLb.font = [UIFont jpl_pingFangWithSize:13 weight:UIFontWeightMedium];
        _auditStatusLb.textColor = [UIColor jpl_colorWithHexString:@"999999"];
        _auditStatusLb.textAlignment = NSTextAlignmentRight;
    }
    return _auditStatusLb;
}

- (UIImageView *)auditStatusIV{
    if (!_auditStatusIV) {
        _auditStatusIV = [[UIImageView alloc]init];
    }
    return _auditStatusIV;
}

- (UILabel *)failLb{
    if (!_failLb) {
        _failLb = [[UILabel alloc]init];
        _failLb.numberOfLines = 0;
    }
    return _failLb;
}


@end
