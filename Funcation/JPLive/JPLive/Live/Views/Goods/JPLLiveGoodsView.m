//
//  JPLLiveGoodsView.m
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveGoodsView.h"
#import "JPLLiveAddView.h"
#import "JPLLiveSaleView.h"

@interface JPLLiveGoodsView ()

@property (nonatomic, strong) UIView * tapView;

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) JPLLiveAddView * addView;

@property (nonatomic, strong) JPLLiveSaleView * saleView;

@property (nonatomic, strong) UIButton * saleBt;

@property (nonatomic, strong) UIButton * addBt;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UIView * indicatorView;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) BOOL isSearchEdit;

@property (nonatomic, strong) UIButton * hideBt;

@property (nonatomic, assign) BOOL isPortrait;


@end

@implementation JPLLiveGoodsView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupViews];
        [self addActions];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupViews];
        [self addActions];
    }
    return self;
}

- (void)updateLayoutWithOrientation:(BOOL)isPortrait{
    self.isPortrait = isPortrait;
    if (isPortrait) {
        self.frame = CGRectMake(0, JPL_SCR_HEIGHT, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
        [self layoutWithPortrait];
    }else{
        self.frame = CGRectMake(-JPL_SCR_WIDTH, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
        [self layoutWithLandscape];
    }
    
}


- (void)setupViews{
    self.frame = CGRectMake(-JPL_SCR_WIDTH, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    [self addSubview:self.tapView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.saleBt];
    [self.contentView addSubview:self.addBt];
    [self.contentView addSubview:self.indicatorView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.saleView];
    [self.contentView addSubview:self.addView];
    [self.contentView addSubview:self.hideBt];
    
    self.saleView.hidden = NO;
    self.addView.hidden = YES;
    self.saleBt.selected = YES;
    self.saleBt.titleLabel.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold];
    self.addBt.selected = NO;
    self.addBt.titleLabel.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightRegular];
    self.isSearchEdit = NO;
}

- (void)layoutWithLandscape{
    
    self.contentView.frame = CGRectMake(0, 0, JPL_SCR_WIDTH * 0.62, JPL_SCR_HEIGHT);
    self.tapView.frame = CGRectMake(JPL_SCR_WIDTH * 0.62, 0, JPL_SCR_WIDTH * 0.38, JPL_SCR_HEIGHT);
    
    self.hideBt.hidden = YES;
    
    
    CGFloat left = 0;
    if ((int)(JPL_SCR_WIDTH / JPL_SCR_HEIGHT * 100) == 216) {
         left = 34;
    }
    [self.saleBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    [self.addBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.saleBt.mas_right).mas_offset(24);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.top.mas_equalTo(self.saleBt.mas_bottom).mas_offset(8);
        make.size.mas_equalTo(CGSizeMake(18, 2));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.indicatorView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.saleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(12);
    }];
    [self.addView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(12);
    }];
    
    [self.saleView updateLayoutWithOrientation:NO];
    [self.addView updateLayoutWithOrientation:NO];
    
}


- (void)layoutWithPortrait{
    self.contentView.frame = CGRectMake(0, JPL_SCR_HEIGHT - 472, JPL_SCR_WIDTH, 472);
    self.tapView.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT - 472);
    
    self.hideBt.hidden = NO;
    
    [self.saleBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    [self.addBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.saleBt.mas_right).mas_offset(24);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.hideBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.saleBt.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.top.mas_equalTo(self.saleBt.mas_bottom).mas_offset(8);
        make.size.mas_equalTo(CGSizeMake(18, 2));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.indicatorView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.saleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(12);
    }];
    [self.addView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(12);
    }];
    
    [self.saleView updateLayoutWithOrientation:YES];
    [self.addView updateLayoutWithOrientation:YES];
}

- (void)addActions{
    self.isShow = NO;
    __weak typeof(self) weakself  = self;
    self.saleView.selectBlock = ^(JPLLiveGoodsModel * _Nonnull model) {
        weakself.addView.saleModel = model;
        if (weakself.selectGoodsBlock) {
            weakself.selectGoodsBlock(model);
        }
    };
    
    self.saleView.saleGoodsBlock = ^(NSMutableArray<JPLLiveGoodsModel *> * _Nonnull saleArray) {
        weakself.addView.selectArray = saleArray;
    };
    
    self.addView.beginEditBlock = ^{
        weakself.isSearchEdit = YES;
    };
    self.addView.endEditBlock = ^{
        weakself.isSearchEdit = NO;
    };
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClikced)];
    [self.tapView addGestureRecognizer:tap];
}

- (void)tapGestureClikced{
    if (self.isSearchEdit) {
        [self.addView endSearchEdit];
        return;
    }
    [self hide];
    if(self.tapHideBlock){
        self.tapHideBlock();
    }
}

- (void)saleBtClicked:(UIButton *)sender{
    if(sender.isSelected){
        return;
    }
    [self.saleView refreshRequestData];
    self.addBt.enabled = NO;
    self.addBt.selected = NO;
    self.addBt.titleLabel.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightRegular];
    self.saleView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(36);
            make.top.mas_equalTo(self.saleBt.mas_bottom).mas_offset(8);
            make.size.mas_equalTo(CGSizeMake(18, 2));
        }];
        self.saleView.alpha = 1;
        self.addView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.addBt.enabled = YES;
            self.addView.hidden = YES;
            sender.selected = YES;
            sender.titleLabel.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold];
        }
    }];
     
}

- (void)addBtClicked:(UIButton *)sender{
    if(sender.isSelected){
        return;
    }
    self.saleBt.enabled = NO;
    self.saleBt.selected = NO;
    self.saleBt.titleLabel.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightRegular];
    self.addView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(120);
            make.top.mas_equalTo(self.saleBt.mas_bottom).mas_offset(8);
            make.size.mas_equalTo(CGSizeMake(18, 2));
        }];
        self.saleView.alpha = 0;
        self.addView.alpha = 1;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.saleBt.enabled = YES;
            self.saleView.hidden = YES;
            sender.selected = YES;
            sender.titleLabel.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightSemibold];
        }
    }];
    
}

- (void)show{
    self.isShow = YES;
    [self.saleView refreshRequestData];
    [self.addView refreshRequestData];
    [[JPLUtil currentViewController].view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        if (self.isPortrait) {
            self.transform = CGAffineTransformMakeTranslation(0, -self.height);
        }else{
            self.transform = CGAffineTransformMakeTranslation(self.width, 0);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            self.isShow = NO;
            [self removeFromSuperview];
        }
        
    }];
}



#pragma mark - request



- (void)requestAddGoods{
    
}

#pragma mark - set
- (void)setLive_id:(NSString *)live_id{
    _live_id = live_id;
    self.saleView.live_id = self.live_id;
    self.addView.live_id = self.live_id;
}


#pragma mark - get
- (JPLLiveSaleView *)saleView{
    if (!_saleView){
        _saleView = [[JPLLiveSaleView alloc]init];
    }
    return _saleView;
}

- (JPLLiveAddView *)addView{
    if (!_addView){
        _addView = [[JPLLiveAddView alloc]init];
    }
    return _addView;
}

- (UIButton *)saleBt{
    if (!_saleBt) {
        _saleBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saleBt setTitle:@"售卖商品" forState:UIControlStateNormal];
        [_saleBt addTarget:self action:@selector(saleBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_saleBt setTitleColor:[UIColor colorWithWhite:1 alpha:0.82] forState:UIControlStateNormal];
        [_saleBt setTitleColor:[UIColor jpl_colorWithHexString:@"#39AAFF"] forState:UIControlStateSelected];
        _saleBt.titleLabel.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightRegular];
    }
    return _saleBt;
}

- (UIButton *)addBt{
    if (!_addBt) {
        _addBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBt setTitle:@"添加商品" forState:UIControlStateNormal];
        [_addBt addTarget:self action:@selector(addBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_addBt setTitleColor:[UIColor colorWithWhite:1 alpha:0.82] forState:UIControlStateNormal];
        [_addBt setTitleColor:[UIColor jpl_colorWithHexString:@"#39AAFF"] forState:UIControlStateSelected];
        _addBt.titleLabel.font = [UIFont jpl_pingFangWithSize:14 weight:UIFontWeightRegular];
    }
    return _addBt;
}

- (UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]init];
        _indicatorView.backgroundColor = [UIColor jpl_colorWithHexString:@"#39AAFF"];
    }
    return _indicatorView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor jpl_colorWithHexString:@"#383838"];
    }
    return _lineView;
}

- (UIView *)tapView{
    if (!_tapView) {
        _tapView = [[UIView alloc] initWithFrame:CGRectMake(JPL_SCR_WIDTH * 0.62, 0, JPL_SCR_WIDTH * 0.38, JPL_SCR_HEIGHT )];
        _tapView.userInteractionEnabled = YES;
        _tapView.backgroundColor = UIColor.clearColor;
    }
    return _tapView;;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JPL_SCR_WIDTH * 0.62, JPL_SCR_HEIGHT)];
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor jpl_colorWithHexString:@"#262626" alpha:0.8];
    }
    return _contentView;;
}


- (UIButton *)hideBt{
    if (!_hideBt) {
        _hideBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hideBt setImage:JPLImageWithName(@"live_pop_hide") forState:UIControlStateNormal];
        [_hideBt addTarget:self action:@selector(tapGestureClikced) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideBt;
}


@end
