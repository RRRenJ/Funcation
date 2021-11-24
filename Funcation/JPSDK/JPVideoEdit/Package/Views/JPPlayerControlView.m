//
//  JPPlayerControlView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/5/8.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPlayerControlView.h"

@interface JPPlayerControlView ()

@property (nonatomic, strong) UIButton                *startBtn;
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
@property (nonatomic, strong) UIProgressView          *progressView;
@property (nonatomic, strong) UISlider                *videoSlider;
@property (nonatomic, strong) UIButton                *fullScreenBtn;
@property (nonatomic, strong) UIButton                *lockBtn;
@property (nonatomic, strong) UILabel                 *horizontalLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UIButton                *backBtn;
@property (nonatomic, strong) UIButton                *repeatBtn;
@property (nonatomic, strong) UIButton                *reloadBtn;
@property (nonatomic, strong) UIImageView             *bottomImageView;
@property (nonatomic, strong) UIImageView             *topImageView;
@property (nonatomic, strong) UIButton                *downLoadBtn;
@property (nonatomic, strong) UIButton                *resolutionBtn;
@property (nonatomic, strong) UIView                  *resolutionView;
@property (nonatomic, strong) UIButton                *playeBtn;

@end

@implementation JPPlayerControlView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self addSubview:self.topImageView];
        self.topImageView.sd_layout.leftEqualToView(self).topEqualToView(self).rightEqualToView(self).heightIs(80);
        
        [self.topImageView addSubview:self.downLoadBtn];
        self.downLoadBtn.sd_layout.centerYEqualToView(self.backBtn).rightSpaceToView(self.topImageView, -10).widthIs(40).heightIs(49);

        [self.topImageView addSubview:self.resolutionBtn];
        self.resolutionBtn.sd_layout.centerYEqualToView(self.backBtn).rightSpaceToView(self.downLoadBtn, -10).widthIs(40).heightIs(30);
        

        [self addSubview:self.bottomImageView];
        self.bottomImageView.sd_layout.bottomEqualToView(self).rightEqualToView(self).leftEqualToView(self).heightIs(50);

        [self.bottomImageView addSubview:self.startBtn];
        self.startBtn.sd_layout.bottomSpaceToView(self.bottomImageView, 5).leftSpaceToView(self.bottomImageView, 5).widthIs(30).heightEqualToWidth();

        [self.bottomImageView addSubview:self.currentTimeLabel];
        self.currentTimeLabel.sd_layout.leftSpaceToView(self.startBtn, 3).centerYEqualToView(self.startBtn).widthIs(43).heightIs(13);
        
        [self.bottomImageView addSubview:self.fullScreenBtn];
        self.fullScreenBtn.sd_layout.rightSpaceToView(self.bottomImageView, 5).centerYEqualToView(self.startBtn).widthIs(30).heightEqualToWidth();
        
        [self.bottomImageView addSubview:self.totalTimeLabel];
        self.totalTimeLabel.sd_layout.rightSpaceToView(self.fullScreenBtn, 3).centerYEqualToView(self.startBtn).widthIs(43).heightIs(13);

        [self.bottomImageView addSubview:self.videoSlider];
        self.videoSlider.sd_layout.leftSpaceToView(self.currentTimeLabel, 3).rightSpaceToView(self.totalTimeLabel, 3).centerYEqualToView(self.currentTimeLabel).heightIs(30);
        
        [self.bottomImageView addSubview:self.progressView];
        self.progressView.sd_layout.leftSpaceToView(self.currentTimeLabel, 4).rightSpaceToView(self.totalTimeLabel, 4).centerYEqualToView(self.startBtn);

        [self addSubview:self.lockBtn];
        self.lockBtn.sd_layout.leftSpaceToView(self, 15).centerYEqualToView(self).widthIs(40).heightEqualToWidth();

        [self addSubview:self.backBtn];
        self.backBtn.sd_layout.leftSpaceToView(self, 7).topSpaceToView(self, 5).widthIs(40).heightEqualToWidth();

        [self addSubview:self.activity];
        self.activity.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(30).heightEqualToWidth();

        [self addSubview:self.repeatBtn];
        self.repeatBtn.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(38).heightIs(58);

        [self addSubview:self.reloadBtn];
        self.reloadBtn.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(38).heightIs(58);

        [self addSubview:self.horizontalLabel];
        self.horizontalLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.reloadBtn, 3).widthIs(150).heightIs(33);

        [self addSubview:self.playeBtn];
        self.playeBtn.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(40).heightIs(40);
        
        // 分辨率btn点击
        [self.resolutionBtn addTarget:self action:@selector(resolutionAction:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [self.videoSlider addGestureRecognizer:sliderTap];
        
        [self.activity stopAnimating];
        self.downLoadBtn.hidden     = YES;
        self.resolutionBtn.hidden   = YES;
        // 初始化时重置controlView
        [self resetControlView];
    }
    return self;
}

#pragma mark - Action

- (void)resolutionAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    // 显示隐藏分辨率View
    self.resolutionView.hidden = !sender.isSelected;
}

- (void)changeResolution:(UIButton *)sender
{
    // 隐藏分辨率View
    self.resolutionView.hidden  = YES;
    // 分辨率Btn改为normal状态
    self.resolutionBtn.selected = NO;
    // topImageView上的按钮的文字
    [self.resolutionBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    if (self.resolutionBlock) { self.resolutionBlock(sender); }
}

/**
 *  UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UISlider class]] && self.tapBlock) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        self.tapBlock(tapValue);
    }
}

#pragma mark - Public Method

/** 重置ControlView */
- (void)resetControlView
{
    self.videoSlider.value      = 0;
    self.progressView.progress  = 0;
    self.currentTimeLabel.text  = @"00:00";
    self.totalTimeLabel.text    = @"00:00";
    self.horizontalLabel.hidden = YES;
    self.repeatBtn.hidden       = YES;
    self.reloadBtn.hidden       = YES;
    self.playeBtn.hidden        = YES;
    self.resolutionView.hidden  = YES;
    self.backgroundColor        = [UIColor clearColor];
    self.downLoadBtn.enabled    = YES;
}

- (void)resetControlViewForResolution
{
    self.horizontalLabel.hidden = YES;
    self.repeatBtn.hidden       = YES;
    self.reloadBtn.hidden       = YES;
    self.resolutionView.hidden  = YES;
    self.playeBtn.hidden        = YES;
    self.downLoadBtn.enabled    = YES;
    self.backgroundColor        = [UIColor clearColor];
}

- (void)showControlViewWhenPortrait
{
    self.topImageView.alpha    = 0;
    self.bottomImageView.alpha = 1;
    self.lockBtn.alpha         = 1;
}

- (void)showControlView
{
    self.topImageView.alpha    = 1;
    self.bottomImageView.alpha = 1;
    self.lockBtn.alpha         = 1;
}

- (void)hideControlView
{
    self.topImageView.alpha    = 0;
    self.bottomImageView.alpha = 0;
    self.lockBtn.alpha         = 0;
    // 隐藏resolutionView
    self.resolutionBtn.selected = YES;
    [self resolutionAction:self.resolutionBtn];
}

#pragma mark - setter

- (void)setResolutionArray:(NSArray *)resolutionArray
{
    _resolutionArray = resolutionArray;
    
    [_resolutionBtn setTitle:resolutionArray.firstObject forState:UIControlStateNormal];
    // 添加分辨率按钮和分辨率下拉列表
    self.resolutionView = [[UIView alloc] init];
    self.resolutionView.hidden = YES;
    self.resolutionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:self.resolutionView];
    
    self.resolutionView.sd_layout.leftEqualToView(self.resolutionBtn).topEqualToView(self.resolutionBtn).widthIs(40).heightIs(30*resolutionArray.count);
    // 分辨率View上边的Btn
    for (int i = 0 ; i < resolutionArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 200+i;
        [self.resolutionView addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.frame = CGRectMake(0, 30*i, 40, 30);
        [btn setTitle:resolutionArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
#pragma mark - getter

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:(@"JPPlayer_back_full")] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.image                  = [UIImage imageNamed:(@"JPPlayer_top_shadow")];
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image                  = [UIImage imageNamed:(@"JPPlayer_bottom_shadow")];
    }
    return _bottomImageView;
}

- (UIButton *)lockBtn
{
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:[UIImage imageNamed:(@"JPPlayer_unlock-nor")] forState:UIControlStateNormal];
        [_lockBtn setImage:[UIImage imageNamed:(@"JPPlayer_lock-nor")] forState:UIControlStateSelected];
    }
    return _lockBtn;
}

- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:[UIImage imageNamed:(@"JPPlayer_play")] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:(@"JPPlayer_pause")] forState:UIControlStateSelected];
        _startBtn.hidden = YES;
    }
    return _startBtn;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.hidden = YES;
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor clearColor];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (UISlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider                       = [[UISlider alloc] init];
        // 设置slider
        [_videoSlider setThumbImage:[UIImage imageNamed:(@"JPPlayer_slider")] forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        _videoSlider.hidden = YES;
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.hidden = YES;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:(@"JPPlayer_fullscreen")] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:(@"JPPlayer_shrinkscreen")] forState:UIControlStateSelected];
    }
    return _fullScreenBtn;
}

- (UILabel *)horizontalLabel
{
    if (!_horizontalLabel) {
        _horizontalLabel                 = [[UILabel alloc] init];
        _horizontalLabel.textColor       = [UIColor whiteColor];
        _horizontalLabel.textAlignment   = NSTextAlignmentCenter;
        _horizontalLabel.font            = [UIFont systemFontOfSize:15.0];
        _horizontalLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:(@"JPPlayer_management_mask")]];
    }
    return _horizontalLabel;
}

- (UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activity;
}

- (UIButton *)repeatBtn
{
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:[UIImage imageNamed:(@"JPPlayer_repeat_video")] forState:UIControlStateNormal];
    }
    return _repeatBtn;
}

- (UIButton *)reloadBtn
{
    if (!_reloadBtn) {
        _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadBtn setImage:[UIImage imageNamed:(@"JPPlayer_reload_video")] forState:UIControlStateNormal];
    }
    return _reloadBtn;
}

- (UIButton *)downLoadBtn
{
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downLoadBtn setImage:[UIImage imageNamed:(@"JPPlayer_download")] forState:UIControlStateNormal];
        [_downLoadBtn setImage:[UIImage imageNamed:(@"JPPlayer_not_download")] forState:UIControlStateDisabled];
    }
    return _downLoadBtn;
}

- (UIButton *)resolutionBtn
{
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _resolutionBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _resolutionBtn;
}

- (UIButton *)playeBtn
{
    if (!_playeBtn) {
        _playeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playeBtn setImage:[UIImage imageNamed:(@"play")] forState:UIControlStateNormal];
    }
    return _playeBtn;
}

@end
