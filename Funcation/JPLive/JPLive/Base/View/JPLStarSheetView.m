//
//  JPLStarSheetView.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/28.
//

#import "JPLStarSheetView.h"
#import "JPLAMViewController.h"
#import "JPLLiveListViewController.h"

@interface JPLStarSheetView ()

@property (nonatomic, strong) UIView * grayBackView;

@property (nonatomic, strong) UIView * sheetView;

@property (nonatomic, strong) UIButton * closeBt;

@property (nonatomic, strong) JPLStarSheetCell * AMCell;

@property (nonatomic, strong) JPLStarSheetCell * myAMCell;

@property (nonatomic, strong) UIViewController * viewController;


@end


@implementation JPLStarSheetView


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
    self.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.grayBackView];
    [self addSubview:self.sheetView];
    [self.sheetView addSubview:self.AMCell];
    [self.sheetView addSubview:self.myAMCell];
    [self.sheetView addSubview:self.closeBt];
    [self.grayBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.AMCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(85);
    }];

    [self.myAMCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(self.AMCell.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(85);
    }];
    
    [self.closeBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10 - JPL_BOTTOM_HEIGHT);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
}

- (void)addAction{
    __weak typeof(self) weakself = self;
    self.AMCell.tapBlock = ^{
        JPLAMViewController * vc = [[JPLAMViewController alloc]init];
        JPLBaseNavigationViewController * navi = [[JPLBaseNavigationViewController alloc]initWithRootViewController:vc];
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakself.viewController presentViewController:navi animated:YES completion:nil];
        [weakself hide];
    };
    self.myAMCell.tapBlock = ^{
        JPLLiveListViewController * vc = [[JPLLiveListViewController alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakself.viewController presentViewController:vc animated:YES completion:nil];
        [weakself hide];
    };
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHide)];
    [self.grayBackView addGestureRecognizer:tap];
    
}

- (void)show:(UIViewController *)viewController{
    self.viewController = viewController;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.lastObject;
    }
    [window addSubview:self];
    self.sheetView.frame = CGRectMake(0, JPL_SCR_HEIGHT, JPL_SCR_WIDTH, 290 + JPL_BOTTOM_HEIGHT);
    self.grayBackView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = CGRectMake(0, JPL_SCR_HEIGHT - 290 - JPL_BOTTOM_HEIGHT, JPL_SCR_WIDTH, 290 + JPL_BOTTOM_HEIGHT);
        self.grayBackView.alpha = 1;
    } completion:^(BOOL finished) {
            
    }];
     
}

- (void)hide{
    self.grayBackView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = CGRectMake(0, JPL_SCR_HEIGHT, JPL_SCR_WIDTH, 290 + JPL_BOTTOM_HEIGHT);
        self.grayBackView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if (self.viewHideBlock) {
                self.viewHideBlock();
            }
        }
    }];
}

- (void)tapHide{
    self.grayBackView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = CGRectMake(0, JPL_SCR_HEIGHT, JPL_SCR_WIDTH, 290 + JPL_BOTTOM_HEIGHT);
        self.grayBackView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


#pragma - mark set


#pragma - mark get

- (UIView *)grayBackView{
    if (!_grayBackView) {
        _grayBackView = [[UIView alloc]init];
        _grayBackView.backgroundColor = [UIColor jpl_colorWithHexString:@"000000" alpha:0.5];
    }
    return _grayBackView;
}

- (UIView *)sheetView{
    if (!_sheetView) {
        _sheetView = [[UIView alloc]init];
        _sheetView.frame = CGRectMake(0, JPL_SCR_HEIGHT, JPL_SCR_WIDTH, 290 + JPL_SCR_HEIGHT);
        _sheetView.backgroundColor = [UIColor jpl_colorWithHexString:@"#F4F5F7"];
        
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_sheetView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _sheetView.bounds;
        maskLayer.path = path.CGPath;
        _sheetView.layer.mask = maskLayer;
        
    }
    return _sheetView;
}

- (JPLStarSheetCell *)AMCell{
    if (!_AMCell) {
        _AMCell = [[JPLStarSheetCell alloc]init];
        _AMCell.title = @"预约直播";
        _AMCell.subTitle = @"进行新的直播预约";
        _AMCell.iconName = @"JPL_AM_LIve";
        _AMCell.bagdeNumber = 0;
    }
    return _AMCell;
}
- (JPLStarSheetCell *)myAMCell{
    if (!_myAMCell) {
        _myAMCell = [[JPLStarSheetCell alloc]init];
        _myAMCell.title = @"我的预约";
        _myAMCell.subTitle = @"查看我的预约记录";
        _myAMCell.iconName = @"JPL_My_AM";
        _myAMCell.bagdeNumber = 0;
    }
    return _myAMCell;
}

- (UIButton *)closeBt{
    if (!_closeBt) {
        _closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBt setTitle:@" 取消" forState:UIControlStateNormal];
        [_closeBt setImage:JPLImageWithName(@"JPL_sheet_close") forState:UIControlStateNormal];
        [_closeBt setTitleColor:[UIColor jpl_colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _closeBt.titleLabel.font = [UIFont jpl_pingFangWithSize:15 weight:UIFontWeightMedium];
        [_closeBt addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBt;
}

@end



@interface JPLStarSheetCell ()

@property (nonatomic, strong) UIView * backView;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * subTitleLb;

@property (nonatomic, strong) UIImageView * iconView;

@property (nonatomic, strong) UILabel * badgeLb;



@end


@implementation JPLStarSheetCell

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
    self.iconView.image = JPLImageWithName(_iconName);
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
        _titleLb.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _titleLb.font = [UIFont jpl_pingFangWithSize:18 weight:UIFontWeightMedium];
    }
    return _titleLb;
}

- (UILabel *)subTitleLb{
    if (!_subTitleLb) {
        _subTitleLb = [[UILabel alloc]init];
        _subTitleLb.textColor = [UIColor jpl_colorWithHexString:@"999999"];
        _subTitleLb.font = [UIFont jpl_pingFangWithSize:12];
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
        _badgeLb.backgroundColor = [UIColor jpl_colorWithHexString:@"#FF5151"];
        _badgeLb.textColor = [UIColor whiteColor];
        _badgeLb.font = [UIFont jpl_pingFangWithSize:8];
        _badgeLb.textAlignment = NSTextAlignmentCenter;
        _badgeLb.layer.cornerRadius = 8;
        _badgeLb.layer.masksToBounds = YES;
    }
    return _badgeLb;
}

@end
