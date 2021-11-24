//
//  JPLLiveSaleGoodsCell.m
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveSaleGoodsCell.h"

@interface JPLLiveSaleGoodsCell ()

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UIButton * selectBt;

@end

@implementation JPLLiveSaleGoodsCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self addActions];
    }
    return self;
}

- (void)setupViews{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
    self.contentView.backgroundColor = [UIColor jpl_colorWithHexString:@"ffffff" alpha:0.24];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.selectBt];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-7);
    }];
    [self.selectBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-8);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
}

- (void)addActions{
    
}

- (void)selectBtClicked:(UIButton *)sender{
    if (self.selectBlock) {
        self.selectBt.selected = !sender.selected;
        self.model.isSelect = sender.isSelected;
        self.selectBlock(self.selectBt.isSelected);
    }
}

#pragma mark - set
- (void)setModel:(JPLLiveGoodsModel *)model{
    _model = model;
    self.titleLb.text = model.goods_name;
    self.selectBt.selected = _model.isSelect;
}


#pragma mark - get
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = UIColor.whiteColor;
        _titleLb.font = [UIFont jpl_pingFangWithSize:13];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

- (UIButton *)selectBt{
    if (!_selectBt) {
        _selectBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBt setImage: JPLImageWithName(@"live_choose_buy_nm") forState:UIControlStateNormal];
        [_selectBt addTarget:self action:@selector(selectBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBt setImage:JPLImageWithName(@"live_choose_buy_hl") forState:UIControlStateSelected];
        [_selectBt setImage:JPLImageWithName(@"live_choose_buy_hl") forState:UIControlStateHighlighted];
    }
    return _selectBt;
}


@end
