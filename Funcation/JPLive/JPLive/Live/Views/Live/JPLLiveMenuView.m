//
//  JPLLiveMenuView.m
//  jper
//
//  Created by RRRenJ on 2020/5/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveMenuView.h"

@interface  JPLLiveMenuView()

@property (nonatomic, strong) UIButton * goodsBt;

@property (nonatomic, strong) UIButton * beautyBt;

@property (nonatomic, strong) UIButton * filterBt;

@property (nonatomic, strong) UIButton * soundOffBt;

@property (nonatomic, strong) UIButton * cameraBt;

@property (nonatomic, strong) UIButton * lightBt;

@end




@implementation JPLLiveMenuView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.frame = CGRectMake(JPL_SCR_WIDTH - 84, 43, 84, JPL_SCR_HEIGHT - 43);
    self.backgroundColor = UIColor.clearColor;
//    [self addSubview:self.goodsBt];
    [self addSubview:self.beautyBt];
//    [self addSubview:self.filterBt];
    [self addSubview:self.soundOffBt];
    [self addSubview:self.cameraBt];
    [self addSubview:self.lightBt];
//    [self.goodsBt mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
//        make.top.mas_equalTo(10);
//    }];
    
    [self.beautyBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(40);
    }];
    
    [self.lightBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.beautyBt.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(self.beautyBt.mas_height);
    }];
    
//    [self.filterBt mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
//        make.top.mas_equalTo(self.beautyBt.mas_bottom).mas_offset(10);
//        make.height.mas_equalTo(self.goodsBt.mas_height);
//    }];
    
    [self.soundOffBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.lightBt.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(self.beautyBt.mas_height);
    }];

    [self.cameraBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.soundOffBt.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(self.beautyBt.mas_height);
        make.bottom.mas_equalTo(-40);
    }];
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
//    [self.goodsBt jpl_layoutButtonWithEdgeInsetsStyle:JPLButtonEdgeInsetsStyleTop imageTitleSpace:3];
    [self.beautyBt jpl_layoutButtonWithEdgeInsetsStyle:JPLButtonEdgeInsetsStyleTop imageTitleSpace:3];
//    [self.filterBt jpl_layoutButtonWithEdgeInsetsStyle:JPLButtonEdgeInsetsStyleTop imageTitleSpace:3];
    [self.soundOffBt jpl_layoutButtonWithEdgeInsetsStyle:JPLButtonEdgeInsetsStyleTop imageTitleSpace:3];
    [self.cameraBt jpl_layoutButtonWithEdgeInsetsStyle:JPLButtonEdgeInsetsStyleTop imageTitleSpace:3];
    [self.lightBt jpl_layoutButtonWithEdgeInsetsStyle:JPLButtonEdgeInsetsStyleTop imageTitleSpace:3];
}


- (void)updateLayoutWithOrientation:(BOOL)isPortrait{
    if (isPortrait) {
        self.frame = CGRectMake(JPL_SCR_WIDTH - 64, JPL_SCR_HEIGHT - 330, 64, 55 * 4 + 30 + 80);
    }else{
        self.frame = CGRectMake(JPL_SCR_WIDTH - 84, 43, 84, JPL_SCR_HEIGHT - 43);
    }
}

- (void)goodsBtClicked{
    if (self.menuClicedBlock) {

        BOOL isChange = self.menuClicedBlock(JPLLiveMenuTypeGoods, !self.goodsBt.isSelected);
        if (isChange) {
            self.goodsBt.selected = !self.goodsBt.selected;
        }
    }
}

- (void)beautyBtClicked{
    if (self.menuClicedBlock) {
        BOOL isChange = self.menuClicedBlock(JPLLiveMenuTypeBeauty, !self.beautyBt.isSelected);
        if (isChange) {
            self.beautyBt.selected = !self.beautyBt.selected;
        }
    }
}

- (void)filterBtClicked{
    if (self.menuClicedBlock) {
        BOOL isChange =  self.menuClicedBlock(JPLLiveMenuTypeFilter, !self.filterBt.isSelected);
        if (isChange) {
            self.filterBt.selected = !self.filterBt.selected;
        }
    }
}

- (void)soundOffBtClicked{
    if (self.menuClicedBlock) {
        BOOL isChange = self.menuClicedBlock(JPLLiveMenuTypeSoundOff, !self.soundOffBt.isSelected);
        if (isChange) {
            self.soundOffBt.selected = !self.soundOffBt.selected;
        }
    }
}

- (void)cameraBtClicked{
    if (self.menuClicedBlock) {
        
        BOOL isChange = self.menuClicedBlock(JPLLiveMenuTypeCamera, !self.cameraBt.isSelected);
        if (isChange) {
            self.cameraBt.selected = !self.cameraBt.selected;
        }
        
    }
}

- (void)lightBtClicked{
    if (self.menuClicedBlock) {
        BOOL isChange = self.menuClicedBlock(JPLLiveMenuTypeLight, !self.lightBt.isSelected);
        if (isChange) {
            self.lightBt.selected = !self.lightBt.selected;
        }
    }
}

- (void)select:(JPLLiveMenuType)type{
    if (type == JPLLiveMenuTypeCamera){
        self.cameraBt.selected = YES;
    }
}

- (void)cancelSelect:(JPLLiveMenuType)type{
    if (type == JPLLiveMenuTypeBeauty) {
        self.beautyBt.selected = NO;
    }else if (type == JPLLiveMenuTypeFilter){
        self.filterBt.selected = NO;
    }else if (type == JPLLiveMenuTypeCamera){
        self.cameraBt.selected = NO;
    }else if (type == JPLLiveMenuTypeGoods){
        self.goodsBt.selected = NO;
    }else if (type == JPLLiveMenuTypeLight){
        self.lightBt.selected = NO;
    }
}

- (void)toggleMenuBt:(JPLLiveMenuType)type{
    if (type == JPLLiveMenuTypeCamera){
        self.cameraBt.selected = !self.cameraBt.selected;
    }
}


- (UIButton *)goodsBt{
    if (!_goodsBt) {
        _goodsBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goodsBt setTitle:@"商品" forState:UIControlStateNormal];
        [_goodsBt setImage:JPLImageWithName(@"live_buy_nm") forState:UIControlStateNormal];
        [_goodsBt addTarget:self action:@selector(goodsBtClicked) forControlEvents:UIControlEventTouchUpInside];
        [_goodsBt setImage:JPLImageWithName(@"live_buy_hl") forState:UIControlStateSelected];
        _goodsBt.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _goodsBt;
}

- (UIButton *)beautyBt{
    if (!_beautyBt) {
        _beautyBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beautyBt setTitle:@"美颜" forState:UIControlStateNormal];
        [_beautyBt setImage:JPLImageWithName(@"jpl_live_beauty_unselect") forState:UIControlStateNormal];
        [_beautyBt addTarget:self action:@selector(beautyBtClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_beautyBt setImage:JPLImageWithName(@"jpl_live_beauty_select") forState:UIControlStateSelected];
        _beautyBt.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _beautyBt;
}

- (UIButton *)filterBt{
    if (!_filterBt) {
        _filterBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterBt setTitle:@"滤镜" forState:UIControlStateNormal];
        [_filterBt setImage:JPLImageWithName(@"live_lvjing_nm") forState:UIControlStateNormal];
        [_filterBt addTarget:self action:@selector(filterBtClicked) forControlEvents:UIControlEventTouchUpInside];
    
        [_filterBt setImage:JPLImageWithName(@"live_lvjing_hl") forState:UIControlStateSelected];
        _filterBt.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _filterBt;
}

- (UIButton *)soundOffBt{
    if (!_soundOffBt) {
        _soundOffBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_soundOffBt setTitle:@"闭麦" forState:UIControlStateNormal];
        [_soundOffBt setImage:JPLImageWithName(@"jpl_live_voice_unselect") forState:UIControlStateNormal];
        [_soundOffBt addTarget:self action:@selector(soundOffBtClicked) forControlEvents:UIControlEventTouchUpInside];
        [_soundOffBt setImage:JPLImageWithName(@"jpl_live_voice_select") forState:UIControlStateSelected];
        _soundOffBt.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _soundOffBt;
}

- (UIButton *)cameraBt{
    if (!_cameraBt) {
        _cameraBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBt setTitle:@"翻转" forState:UIControlStateNormal];
        [_cameraBt setImage:JPLImageWithName(@"jpl_live_camera_unselect") forState:UIControlStateNormal];
        [_cameraBt addTarget:self action:@selector(cameraBtClicked) forControlEvents:UIControlEventTouchUpInside];
        [_cameraBt setImage:JPLImageWithName(@"jpl_live_camera_select") forState:UIControlStateSelected];
        _cameraBt.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _cameraBt;
}

- (UIButton *)lightBt{
    if (!_lightBt) {
        _lightBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lightBt setTitle:@"补光灯" forState:UIControlStateNormal];
        [_lightBt setImage:JPLImageWithName(@"jpl_live_light_unselect") forState:UIControlStateNormal];
        [_lightBt addTarget:self action:@selector(lightBtClicked) forControlEvents:UIControlEventTouchUpInside];
        [_lightBt setImage:JPLImageWithName(@"jpl_live_light_select") forState:UIControlStateSelected];
        _lightBt.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _lightBt;
}

@end
