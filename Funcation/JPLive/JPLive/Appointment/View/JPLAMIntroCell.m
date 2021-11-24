//
//  JPLAMIntroCell.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/28.
//

#import "JPLAMIntroCell.h"
#import "YYText/YYTextView.h"

@interface JPLAMIntroCell ()

@property (nonatomic, strong) UIView * backView;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) YYTextView * textView;

@end

@implementation JPLAMIntroCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        
    }
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma - mark init view
- (void)setupViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor jpl_colorWithHexString:@"f8f8f8"];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLb];
    [self.backView addSubview:self.textView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 18, 10, 18));
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(50, 16));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLb.mas_right).mas_offset(5);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
}

#pragma - mark set
- (void)setIntro:(NSString *)intro{
    self.textView.text = intro;
}

#pragma - mark get
- (NSString *)intro{
    return self.textView.text;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = UIColor.whiteColor;
        _backView.layer.cornerRadius = 6;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb  = [[UILabel alloc]init];
        _titleLb.text = @"简介：";
        _titleLb.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _titleLb.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _titleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLb;
}

- (YYTextView *)textView{
    if (!_textView) {
        _textView = [[YYTextView alloc]init];
        _textView.placeholderFont = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _textView.placeholderTextColor = [UIColor jpl_colorWithHexString:@"999999"];
        _textView.placeholderText = @"请输入直播简介";
        _textView.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _textView.textColor = [UIColor jpl_colorWithHexString:@"999999"];
        _textView.contentInset = UIEdgeInsetsZero;
    }
    return _textView;
}

@end
