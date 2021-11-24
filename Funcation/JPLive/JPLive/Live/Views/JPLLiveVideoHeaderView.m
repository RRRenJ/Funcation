//
//  JPLLiveVideoHeaderView.m
//  jper
//
//  Created by RRRenJ on 2020/9/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveVideoHeaderView.h"


@interface JPLLiveVideoHeaderView ()

@property (nonatomic, strong) UIImageView * backView;

@property (nonatomic, strong) UILabel * titleLb;

@end

@implementation JPLLiveVideoHeaderView

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
    [self.backView addSubview:self.titleLb];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(30);
    }];


}

- (void)addActions{
    
}


#pragma mark - set
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = _title;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.titleLb.textColor = _titleColor;
}


#pragma mark - get
- (UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc]init];
        _backView.image = [JPLImageWithName(@"liveVideoTop") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
    }
    return _backView;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.textColor = [UIColor jpl_colorWithHexString:@"#0091FF"];
    }
    return _titleLb;
}

@end
