//
//  ExportViewController.m
//  JPSDK
//
//  Created by 任敬 on 2021/10/27.
//

#import "ExportViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "JPNewCameraViewController.h"

@interface ExportViewController ()

@property (nonatomic, strong) UIImageView  * videoIV;

@property (nonatomic, strong) UIButton * playBt;

@property (nonatomic, strong) AVPlayer * player;

@property (nonatomic, strong) AVPlayerItem * playerItem;

@property (nonatomic, strong) UIView * playerView;

@property (nonatomic, strong) AVPlayerLayer * playerLayer;

@property (nonatomic, strong) UILabel * remindLb;

@property (nonatomic, strong) UIButton * editBt;

@property (nonatomic, strong) UIButton * homeBt;

@property (nonatomic, assign) BOOL  isPlay;

@property (nonatomic, assign) BOOL  isEnd;

@end

@implementation ExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self addAction];
    [self loadURL];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma - mark init view
- (void)setupViews{
    self.title = @"导出成功";
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.videoIV];
    [self.view addSubview:self.playBt];
    [self.view addSubview:self.remindLb];
    [self.view addSubview:self.editBt];
    [self.view addSubview:self.homeBt];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40 + JP_NAVIGATION_HEIGHT);
        make.left.right.mas_equalTo(0);
        switch (self.compositionManager.aspectRatio) {
            case JPVideoAspectRatio1X1:
                make.height.mas_equalTo(self.playerView.mas_width);
                break;
            case JPVideoAspectRatioCircular:
                make.height.mas_equalTo(self.playerView.mas_width);
                break;

            case JPVideoAspectRatio4X3:
                make.height.mas_equalTo(self.playerView.mas_width).multipliedBy(3/4.0);
                break;
            case JPVideoAspectRatio16X9:
                make.height.mas_equalTo(self.playerView.mas_width).multipliedBy(9/16.0);
                break;
            case JPVideoAspectRatio9X16:
                make.height.mas_equalTo(self.playerView.mas_width).multipliedBy(9/16.0);
                break;
            default:
                break;
        }
    }];
    
    [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.playerView);
    }];
    [self.playBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.playerView);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.remindLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.playerView.mas_bottom).mas_offset(40);
    }];
    
    [self.homeBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(55);
        make.bottom.mas_equalTo(-40 - JP_BOTTOM_HEIGHT);
    }];
    [self.editBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(55);
        make.bottom.mas_equalTo(self.homeBt.mas_top).mas_offset(-20);
    }];

    self.videoIV.image = self.compositionManager.firstThumbImage;
    self.isPlay = NO;
    self.isEnd = NO;
}

- (void)addAction{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPlayBt)];
    [self.playerView addGestureRecognizer:tap];
}

- (void)loadURL{
    self.playerItem = [[AVPlayerItem alloc]initWithURL:self.compositionManager.videoUrl];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
    [self.playerView.layer addSublayer:self.playerLayer];
    self.playerLayer.frame = self.playerView.bounds;
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}


#pragma - mark request

- (void)homeAction{
    [self clearVideo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)editAction{
    [self clearVideo];
    JPNewCameraViewController * vc = [[JPNewCameraViewController alloc]initWithNibName:@"JPNewCameraViewController" bundle:JPResourceBundle];
    self.navigationController.viewControllers = @[vc];
}

- (void)playVideoAction{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePlayBt) object:nil];
    if (self.isPlay) {
        [self.player pause];
        self.playBt.selected = NO;
        self.isPlay = NO;
    }else{
        if (self.isEnd) {
            [self.player seekToTime:kCMTimeZero];
            self.isEnd = NO;
        }
        [self.player play];
        self.playBt.selected = YES;
        self.isPlay = YES;
    }
    [self performSelector:@selector(hidePlayBt) withObject:nil afterDelay:3];
    
}


- (void)hidePlayBt{
    self.playBt.hidden = YES;
}

- (void)showPlayBt{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePlayBt) object:nil];
    self.playBt.hidden = NO;
    [self performSelector:@selector(hidePlayBt) withObject:nil afterDelay:3];
}

- (void)playToEnd{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePlayBt) object:nil];
    self.playBt.hidden = NO;
    self.playBt.selected = NO;
    self.isPlay = NO;
    self.isEnd = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.playerItem.status) {
            case AVPlayerItemStatusReadyToPlay:{
                self.videoIV.hidden = YES;
                [self playVideoAction];
                [self.playerItem removeObserver:self forKeyPath:@"status"];
            }
                break;
            default:
                self.isPlay = NO;
                break;
        }
    }
}


- (void)clearVideo{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.compositionManager.videoUrl.path]) {
        [[NSFileManager defaultManager] removeItemAtURL:self.compositionManager.videoUrl error:nil];
    }
}
#pragma - mark set


#pragma - mark get

- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc]init];
    }
    return _playerView;
}

- (UIImageView *)videoIV{
    if (!_videoIV) {
        _videoIV = [[UIImageView alloc]init];
        _videoIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _videoIV;
}

- (UIButton *)playBt{
    if (!_playBt) {
        _playBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBt setImage:JPImageWithName(@"video_play") forState:UIControlStateNormal];
        [_playBt setImage:JPImageWithName(@"video_stop") forState:UIControlStateSelected];
        [_playBt addTarget:self action:@selector(playVideoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBt;
}

- (UILabel *)remindLb{
    if (!_remindLb) {
        _remindLb = [[UILabel alloc]init];
        _remindLb.text = @"您的视频已经成功导出到本地相册！";
        _remindLb.font = [UIFont jp_pingFangWithSize:17 weight:UIFontWeightMedium];
        _remindLb.textColor = [UIColor whiteColor];
    }
    return _remindLb;
}


- (UIButton *)editBt{
    if (!_editBt) {
        _editBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBt setTitle:@"开始新的视频编辑" forState:UIControlStateNormal];
        [_editBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editBt.backgroundColor = [UIColor jp_colorWithHexString:@"#1D6CFD"];
        _editBt.titleLabel.font = [UIFont jp_pingFangWithSize:16 weight:UIFontWeightMedium];
        _editBt.layer.cornerRadius = 6;
        _editBt.layer.masksToBounds = YES;
        [_editBt addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBt;
}

- (UIButton *)homeBt{
    if (!_homeBt) {
        _homeBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_homeBt setTitle:@"直接返回首页" forState:UIControlStateNormal];
        [_homeBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _homeBt.backgroundColor = [UIColor blackColor];
        _homeBt.titleLabel.font = [UIFont jp_pingFangWithSize:16 weight:UIFontWeightMedium];
        _homeBt.layer.cornerRadius = 6;
        _homeBt.layer.masksToBounds = YES;
        _homeBt.layer.borderColor = UIColor.whiteColor.CGColor;
        _homeBt.layer.borderWidth = 0.5;
        [_homeBt addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _homeBt;
}

@end
