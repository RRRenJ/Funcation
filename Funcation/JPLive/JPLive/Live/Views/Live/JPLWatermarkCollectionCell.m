//
//  JPLWatermarkCollectionCell.m
//  jper
//
//  Created by RRRenJ on 2020/6/8.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLWatermarkCollectionCell.h"

@interface JPLWatermarkCollectionCell ()

@property (nonatomic, strong) UIImageView * waterIV;

@property (nonatomic, strong) UIView * selectView;

@property (nonatomic, strong) UIButton * selectBt;

@property (nonatomic, strong) UILabel * contentLb;


@end

@implementation JPLWatermarkCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.waterIV];
    [self.contentView addSubview:self.selectView];
    [self.contentView addSubview:self.contentLb];
    [self.contentView addSubview:self.selectBt];
}

- (void)addActions{
    
}

- (void)selectBtClicked:(UIButton *)sender{
    sender.selected = YES;
    self.isSelect = YES;
    if (self.selectBlock){
        self.selectBlock();
    }
}

#pragma mark - set
- (void)setIsSelect:(BOOL )isSelect{
    _isSelect = isSelect;
    self.selectBt.selected = isSelect;
    if (isSelect){
        self.selectView.layer.borderColor = [UIColor jpl_colorWithHexString:@"0091FF"].CGColor;
        self.selectView.layer.borderWidth = 1;
        self.selectView.backgroundColor = [UIColor jpl_colorWithHexString:@"#0091FF" alpha:0.19];
    }else{
        self.selectView.layer.borderWidth = 0;
        self.selectView.backgroundColor = UIColor.clearColor;
    }
}

- (void)setImageURL:(NSString *)imageURL{
    _imageURL = imageURL;
    [self.waterIV sd_setImageWithURL:[NSURL URLWithString:_imageURL]];
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentLb.text = _content;
}

#pragma mark - get
- (UIButton *)selectBt{
    if (!_selectBt) {
        _selectBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBt setImage:JPLImageWithName(@"live_choose_add_nm") forState:UIControlStateNormal];
        _selectBt.frame = CGRectMake(self.frame.size.width - 28, self.frame.size.height - 28, 19, 19);
        [_selectBt addTarget:self action:@selector(selectBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBt setImage:JPLImageWithName(@"live_choose_add_hl") forState:UIControlStateSelected];
    }
    return _selectBt;
}
- (UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc]initWithFrame:self.bounds];
        _selectView.layer.cornerRadius = 3;
        _selectView.layer.masksToBounds = YES;
    }
    return  _selectView;
}

- (UIImageView *)waterIV{
    if (!_waterIV) {
        _waterIV = [[UIImageView alloc]initWithFrame:self.bounds];
        _waterIV.layer.cornerRadius = 3;
        _waterIV.layer.masksToBounds = YES;
        _waterIV.backgroundColor = UIColor.grayColor;
    }
    return  _waterIV;
}

- (UILabel *)contentLb{
    if (!_contentLb) {
        _contentLb = [[UILabel alloc]initWithFrame:self.bounds];
        _contentLb.textColor = [UIColor jpl_colorWithHexString:@"#353535"];
        _contentLb.font = [UIFont systemFontOfSize:14];
        _contentLb.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLb;
}

@end
