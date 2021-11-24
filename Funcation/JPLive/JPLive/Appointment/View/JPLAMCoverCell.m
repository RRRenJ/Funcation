//
//  JPLAMCoverCell.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/28.
//

#import "JPLAMCoverCell.h"

@interface JPLAMCoverCell ()

@property (nonatomic, strong) UIView * backView;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UIImageView * coverIV;

@property (nonatomic, strong) UITapGestureRecognizer * tap;

@end

@implementation JPLAMCoverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self addAction];
    }
    return  self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}



#pragma - mark init view
- (void)setupViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor jpl_colorWithHexString:@"f8f8f8"];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLb];
    [self.backView addSubview:self.coverIV];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 18, 0, 18));
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
}

- (void)addAction{
    [self.coverIV addGestureRecognizer:self.tap];
}

- (void)tapAction{
    if (self.selectBlock) {
        self.selectBlock();
    }
}

#pragma - mark set
- (void)setCoverImage:(UIImage *)coverImage{
    _coverImage = coverImage;
    self.coverIV.image = _coverImage;
}
#pragma - mark get
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
        _titleLb.text = @"直播封面：";
        _titleLb.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _titleLb.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _titleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLb;
}

- (UIImageView *)coverIV{
    if (!_coverIV) {
        _coverIV = [[UIImageView alloc]init];
        _coverIV.image = JPLImageWithName(@"jpl_am_cover");
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.clipsToBounds = YES;
        _coverIV.userInteractionEnabled = YES;
    }
    return _coverIV;
}

- (UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    }
    return _tap;
}


@end
