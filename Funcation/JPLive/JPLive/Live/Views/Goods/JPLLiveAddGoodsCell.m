//
//  JPLLiveAddGoodsCell.m
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveAddGoodsCell.h"

@interface JPLLiveAddGoodsCell ()

@property (nonatomic, strong) UILabel * IDLb;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UIButton * selectBt;

@property (nonatomic, strong) UIView * lineView;

@end

@implementation JPLLiveAddGoodsCell

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
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.IDLb];
    [self.contentView addSubview:self.selectBt];
    [self.contentView addSubview:self.lineView];
    [self.selectBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-39);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.IDLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.selectBt.mas_left).mas_offset(-10);
        make.bottom.mas_equalTo(self.mas_centerY).mas_offset(-3);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.selectBt.mas_left).mas_offset(-10);
        make.top.mas_equalTo(self.mas_centerY).mas_offset(3);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)addActions{
    
}


- (void)selectBtClicked:(UIButton *)sender{
    if (self.selectBlock) {
        BOOL canChange =  self.selectBlock(!self.selectBt.isSelected);
        if (canChange) {
            self.selectBt.selected = !sender.selected;
            self.model.isSelect = sender.isSelected;
        }
    }
}


#pragma mark - set
- (void)setModel:(JPLLiveGoodsModel *)model{
    _model = model;
    self.IDLb.text =  [NSString stringWithFormat:@"ID %@",_model.goods_id];
    self.titleLb.text = _model.goods_name;
    self.selectBt.selected = _model.isSelect;
}


#pragma mark - get
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = UIColor.whiteColor;
        _titleLb.font = [UIFont jpl_pingFangWithSize:16];
        _titleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLb;
}

- (UILabel *)IDLb{
    if (!_IDLb) {
        _IDLb = [[UILabel alloc]init];
        _IDLb.textColor = [UIColor jpl_colorWithHexString:@"#828282"];
        _IDLb.font = [UIFont jpl_pingFangWithSize:14];
        _IDLb.textAlignment = NSTextAlignmentLeft;
    }
    return _IDLb;
}

- (UIButton *)selectBt{
    if (!_selectBt) {
        _selectBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBt setImage:JPLImageWithName(@"live_choose_add_nm") forState:UIControlStateNormal];
        [_selectBt addTarget:self action:@selector(selectBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBt setImage:JPLImageWithName(@"live_choose_add_hl") forState:UIControlStateSelected];
        [_selectBt setImage:JPLImageWithName(@"live_choose_add_hl") forState:UIControlStateHighlighted];
    }
    return _selectBt;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor jpl_colorWithHexString:@"#6F6F6F"];
    }
    return _lineView;
}

@end
