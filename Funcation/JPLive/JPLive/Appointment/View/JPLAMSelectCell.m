//
//  JPLAMSelectCell.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/28.
//

#import "JPLAMSelectCell.h"

@interface JPLAMSelectCell ()

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * contentLb;

@property (nonatomic, strong) UILabel * defaultLb;

@property (nonatomic, strong) UIImageView * arrow;

@end

@implementation JPLAMSelectCell

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



#pragma - mark init view
- (void)setupViews{
    self.contentView.backgroundColor = [UIColor jpl_colorWithHexString:@"f8f8f8"];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.arrow];
    [self.contentView addSubview:self.contentLb];
    [self.contentView addSubview:self.defaultLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    [self.defaultLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrow.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(45);
    }];
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.defaultLb.mas_left).mas_offset(-2);
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.titleLb.mas_right);
    }];
}

#pragma - mark set
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = _title;
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentLb.text = _content;
}

- (void)setHaveArrow:(BOOL)haveArrow{
    _haveArrow = haveArrow;
    self.arrow.hidden = !_haveArrow;
    if (self.isDefault) {
        [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.defaultLb.mas_left).mas_offset(-2);
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(self.titleLb.mas_right);
        }];
    }else{
        if (_haveArrow) {
            [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.arrow.mas_left).mas_offset(-5);
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(self.titleLb.mas_right);
            }];
        }else{
            [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-18);
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(self.titleLb.mas_right);
            }];
        }
    }
}
- (void)setIsDefault:(BOOL)isDefault{
    _isDefault = isDefault;
    self.defaultLb.hidden = !_isDefault;
    if (_haveArrow) {
        [self.defaultLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.arrow.mas_left).mas_offset(-5);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(45);
        }];
    }else{
        [self.defaultLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(45);
        }];
    }
    [self setHaveArrow:self.haveArrow];
}

#pragma - mark get
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _titleLb.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _titleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLb;
}

- (UILabel *)contentLb{
    if (!_contentLb) {
        _contentLb = [[UILabel alloc]init];
        _contentLb.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _contentLb.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _contentLb.textAlignment = NSTextAlignmentRight;
    }
    return _contentLb;
}

- (UILabel *)defaultLb{
    if (!_defaultLb) {
        _defaultLb = [[UILabel alloc]init];
        _defaultLb.text = @"(默认)";
        _defaultLb.font = [UIFont jpl_pingFangWithSize:16];
        _defaultLb.textColor = [UIColor jpl_colorWithHexString:@"c1c1c1"];
        _defaultLb.textAlignment = NSTextAlignmentRight;
    }
    return _defaultLb;
}

- (UIImageView *)arrow{
    if (!_arrow) {
        _arrow = [[UIImageView alloc]initWithImage:JPLImageWithName(@"jpl_am_arrow")];
    }
    return _arrow;
}

@end
