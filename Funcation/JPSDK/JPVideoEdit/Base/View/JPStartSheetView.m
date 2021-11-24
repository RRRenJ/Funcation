//
//  JPStartSheetView.m
//  JPSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import "JPStartSheetView.h"
#import "JPNewCameraViewController.h"
#import "JPDraftViewController.h"

@interface JPStartSheetView ()

@property (nonatomic, strong) UIView * grayBackView;

@property (nonatomic, strong) UIView * sheetView;

@property (nonatomic, strong) UIButton * closeBt;

@property (nonatomic, strong) JPStartSheetCell * takeCell;

@property (nonatomic, strong) JPStartSheetCell * draftCell;

@property (nonatomic, strong) UIViewController * viewController;


@end


@implementation JPStartSheetView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self addAction];
    }
    return self;
}


#pragma - mark init view
- (void)setupViews{
    self.frame = CGRectMake(0, 0, JP_SCREEN_WIDTH, JP_SCREEN_HEIGHT);
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.grayBackView];
    [self addSubview:self.sheetView];
    [self.sheetView addSubview:self.takeCell];
    [self.sheetView addSubview:self.draftCell];
    [self.sheetView addSubview:self.closeBt];
    [self.grayBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.takeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(85);
    }];

    [self.draftCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(self.takeCell.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(85);
    }];
    
    [self.closeBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10 - JP_BOTTOM_HEIGHT);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
}

- (void)addAction{
    __weak typeof(self) weakself = self;
    self.takeCell.tapBlock = ^{
        JPNewCameraViewController * vc = [[JPNewCameraViewController alloc]initWithNibName:@"JPNewCameraViewController" bundle:JPResourceBundle];
        UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:vc];
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakself.viewController presentViewController:navi animated:YES completion:nil];
        [weakself hide:^{
            if (weakself.viewHideBlock) {
                weakself.viewHideBlock();
            }
            
        }];
    };
    self.draftCell.tapBlock = ^{
        JPDraftViewController * vc = [[JPDraftViewController alloc]init];
        UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:vc];
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakself.viewController presentViewController:navi animated:YES completion:nil];
        [weakself hide:^{
            if (weakself.viewHideBlock) {
                weakself.viewHideBlock();
            }
        }];
    };
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [self.grayBackView addGestureRecognizer:tap];
    
}

- (void)show:(UIViewController *)viewController{
    self.viewController = viewController;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.lastObject;
    }
    [window addSubview:self];
    self.sheetView.frame = CGRectMake(0, JP_SCREEN_HEIGHT, JP_SCREEN_WIDTH, 290 + JP_BOTTOM_HEIGHT);
    self.grayBackView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = CGRectMake(0, JP_SCREEN_HEIGHT - 290 - JP_BOTTOM_HEIGHT, JP_SCREEN_WIDTH, 290 + JP_BOTTOM_HEIGHT);
        self.grayBackView.alpha = 1;
    } completion:^(BOOL finished) {
            
    }];
     
}

- (void)hide:(void(^)(void))hideBlock{
    self.grayBackView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = CGRectMake(0, JP_SCREEN_HEIGHT, JP_SCREEN_WIDTH, 290 + JP_BOTTOM_HEIGHT);
        self.grayBackView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if (hideBlock) {
                hideBlock();
            }
        }
    }];
}

- (void)closeView{
    [self hide:^{
            
    }];
}

#pragma - mark set


#pragma - mark get
- (UIView *)grayBackView{
    if (!_grayBackView) {
        _grayBackView = [[UIView alloc]init];
        _grayBackView.backgroundColor = [UIColor jp_colorWithHexString:@"000000" alpha:0.5];
    }
    return _grayBackView;
}

- (UIView *)sheetView{
    if (!_sheetView) {
        _sheetView = [[UIView alloc]init];
        _sheetView.frame = CGRectMake(0, JP_SCREEN_HEIGHT, JP_SCREEN_WIDTH, 290 + JP_BOTTOM_HEIGHT);
        _sheetView.backgroundColor = [UIColor jp_colorWithHexString:@"#F4F5F7"];
        
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_sheetView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _sheetView.bounds;
        maskLayer.path = path.CGPath;
        _sheetView.layer.mask = maskLayer;
        
    }
    return _sheetView;
}

- (JPStartSheetCell *)draftCell{
    if (!_draftCell) {
        _draftCell = [[JPStartSheetCell alloc]init];
        _draftCell.title = @"从草稿箱选择";
        _draftCell.subTitle = @"编辑你之前拍摄的视频";
        _draftCell.iconName = @"JPDraft";
        _draftCell.bagdeNumber = 0;
    }
    return _draftCell;
}
- (JPStartSheetCell *)takeCell{
    if (!_takeCell) {
        _takeCell = [[JPStartSheetCell alloc]init];
        _takeCell.title = @"立即拍摄";
        _takeCell.subTitle = @"拍摄视频进行编辑";
        _takeCell.iconName = @"JPTake";
        _takeCell.bagdeNumber = 0;
    }
    return _takeCell;
}

- (UIButton *)closeBt{
    if (!_closeBt) {
        _closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBt setTitle:@" 取消" forState:UIControlStateNormal];
        [_closeBt setImage:JPImageWithName(@"JP_sheet_close") forState:UIControlStateNormal];
        [_closeBt setTitleColor:[UIColor jp_colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _closeBt.titleLabel.font = [UIFont jp_pingFangWithSize:15 weight:UIFontWeightMedium];
        [_closeBt addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBt;
}

@end


@interface JPStartSheetCell ()

@property (nonatomic, strong) UIView * backView;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * subTitleLb;

@property (nonatomic, strong) UIImageView * iconView;

@property (nonatomic, strong) UILabel * badgeLb;



@end


@implementation JPStartSheetCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self addAction];
    }
    return self;
}


#pragma - mark init view
- (void)setupViews{
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLb];
    [self.backView addSubview:self.subTitleLb];
    [self.backView addSubview:self.iconView];
    [self.backView addSubview:self.badgeLb];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(22);
    }];
    [self.subTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(10);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-26);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.badgeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right);
        make.centerY.mas_equalTo(self.iconView.mas_top);
        make.height.mas_equalTo(16);
    }];

}

- (void)addAction{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.backView addGestureRecognizer:tap];
}

- (void)tapAction{
    if (self.tapBlock) {
        self.tapBlock();
    }
}


#pragma - mark set
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = _title;
}

- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    self.subTitleLb.text = _subTitle;
}

- (void)setIconName:(NSString *)iconName{
    _iconName = iconName;
    self.iconView.image = JPImageWithName(_iconName);
}

- (void)setBagdeNumber:(NSInteger)bagdeNumber{
    _bagdeNumber = bagdeNumber;
    self.badgeLb.hidden = _bagdeNumber == 0;
    self.badgeLb.text = [NSString stringWithFormat:@"%ld",(long)_bagdeNumber];
}

#pragma - mark get

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = UIColor.whiteColor;
        _backView.layer.cornerRadius = 9;
        _backView.layer.masksToBounds = YES;
        _backView.userInteractionEnabled = YES;
    }
    return _backView;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = [UIColor jp_colorWithHexString:@"333333"];
        _titleLb.font = [UIFont jp_pingFangWithSize:18 weight:UIFontWeightMedium];
    }
    return _titleLb;
}

- (UILabel *)subTitleLb{
    if (!_subTitleLb) {
        _subTitleLb = [[UILabel alloc]init];
        _subTitleLb.textColor = [UIColor jp_colorWithHexString:@"999999"];
        _subTitleLb.font = [UIFont jp_pingFangWithSize:12];
    }
    return _subTitleLb;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}

- (UILabel *)badgeLb{
    if (!_badgeLb) {
        _badgeLb = [[UILabel alloc]init];
        _badgeLb.backgroundColor = [UIColor jp_colorWithHexString:@"#FF5151"];
        _badgeLb.textColor = [UIColor whiteColor];
        _badgeLb.font = [UIFont jp_pingFangWithSize:8];
        _badgeLb.textAlignment = NSTextAlignmentCenter;
        _badgeLb.layer.cornerRadius = 8;
        _badgeLb.layer.masksToBounds = YES;
    }
    return _badgeLb;
}

@end
