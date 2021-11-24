//
//  JPLLiveSettingTitleCell.m
//  jper
//
//  Created by RRRenJ on 2020/5/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveSettingTitleCell.h"

@interface JPLLiveSettingTitleCell ()

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * detailLb;

@property (nonatomic, strong) UIImageView * arrowIV;

@end

@implementation JPLLiveSettingTitleCell

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
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.arrowIV];
    [self.contentView addSubview:self.lineView];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(9, 15));
    }];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowIV.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)addActions{
    
}


#pragma mark - set
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = _title;
}

- (void)setDetailTitle:(NSString *)detailTitle{
    _detailTitle = detailTitle;
    self.detailLb.text = _detailTitle;
}


- (void)setHaveArrow:(BOOL)haveArrow{
    _haveArrow = haveArrow;
    self.arrowIV.hidden = !_haveArrow;
    if (_haveArrow) {
        [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(9, 15));
        }];
        
        [self.detailLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.arrowIV.mas_left).mas_offset(-5);
            make.centerY.mas_equalTo(0);
        }];
    }else{
        [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeZero);
        }];
        
        [self.detailLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
    }
}

#pragma mark - get
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor jpl_colorWithHexString:@"e7e7e7"];
    }
    return  _lineView;
}

- (UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [[UILabel alloc]init];
        _detailLb.font = [UIFont systemFontOfSize:15];
        _detailLb.textColor = [UIColor jpl_colorWithHexString:@"#ADADAD"];
        _detailLb.textAlignment = NSTextAlignmentRight;
    }
    return _detailLb;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:16];
        _titleLb.textColor = [UIColor jpl_colorWithHexString:@"#353535"];
        _titleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLb;
}

- (UIImageView *)arrowIV{
    if (!_arrowIV) {
        _arrowIV = [[UIImageView alloc]initWithImage:JPLImageWithName(@"5_more")];
    }
    return _arrowIV;
}


@end
