//
//  JPLLiveFilterCell.m
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveFilterCell.h"

@interface JPLLiveFilterCell ()

@property (nonatomic, strong) UIImageView * filterIV;

@property (nonatomic, strong) UILabel * nameLb;

@property (nonatomic, strong) UIImageView * selectIV;

@property (nonatomic, strong) UIView * selectView;

@end

@implementation JPLLiveFilterCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self addActions];
    }
    return self;
}



- (void)setupViews{
    self.contentView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.filterIV];
    [self.contentView addSubview:self.selectView];
    [self.selectView addSubview:self.selectIV];
    [self.contentView addSubview:self.nameLb];
    
    [self.filterIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.filterIV.mas_width);
    }];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.selectView.mas_width);
    }];
    
    [self.selectIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)addActions{
    
}

#pragma mark - set
- (void)setModel:(JPLLiveFilterModel *)model{
    _model = model;
    self.nameLb.text = _model.name;
    self.filterIV.image = JPLImageWithName(_model.imageName);
    self.selectView.hidden = !_model.isSelect;
    if (_model.isSelect){
        self.nameLb.textColor = [UIColor jpl_colorWithHexString:@"#39AAFF"];
    }else{
        self.nameLb.textColor = [UIColor jpl_colorWithHexString:@"#828282"];
    }
}


#pragma mark - get
- (UIImageView *)filterIV{
    if (!_filterIV) {
        _filterIV = [[UIImageView alloc]init];
        _filterIV.layer.cornerRadius = 22.5;
        _filterIV.layer.masksToBounds = YES;
    }
    return _filterIV;
}

- (UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.textColor = [UIColor jpl_colorWithHexString:@"#828282"];
        _nameLb.font = [UIFont systemFontOfSize:12];
        _nameLb.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLb;
}

- (UIImageView *)selectIV{
    if (!_selectIV) {
        _selectIV = [[UIImageView alloc]initWithImage:JPLImageWithName(@"live_lvjing_choose_hl")];
    }
    return _selectIV;
}

- (UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc]init];
        _selectView.backgroundColor = UIColor.blackColor;
        _selectView.layer.cornerRadius = 22.5;
        _selectView.layer.masksToBounds = YES;
    }
    return _selectView;
}


@end
