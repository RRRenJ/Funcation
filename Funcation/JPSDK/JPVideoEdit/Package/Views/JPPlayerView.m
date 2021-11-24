//
//  JPPlayerView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/5/8.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPlayerView.h"
#import "JPPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

static const CGFloat JPPlayerAnimationTimeInterval             = 5.0f;
static const CGFloat JPPlayerControlBarAutoFadeOutTimeInterval = 0.5f;

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};


@interface JPPlayerView () <UIGestureRecognizerDelegate,UIAlertViewDelegate>

/** 播放属性 */
@property (nonatomic, strong) AVPlayer            *player;
/** 播放属性 */
@property (nonatomic, strong) AVPlayerItem        *playerItem;
/** playerLayer */
@property (nonatomic, strong) AVPlayerLayer       *playerLayer;
/** 滑杆 */
@property (nonatomic, strong) UISlider            *volumeViewSlider;
/** 计时器 */
@property (nonatomic, strong) NSTimer             *timer;
/** 控制层View */
@property (nonatomic, strong) JPPlayerControlView *controlView;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat             sumTime;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection        panDirection;
/** 播放器的几种状态 */
@property (nonatomic, assign) JPPlayerState       state;
/** 是否为全屏 */
//@property (nonatomic, assign) BOOL                isFullScreen;
/** 是否锁定屏幕方向 */
@property (nonatomic, assign) BOOL                isLocked;
/** 是否在调节音量*/
@property (nonatomic, assign) BOOL                isVolume;
/** 是否显示controlView*/
@property (nonatomic, assign) BOOL                isMaskShowing;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL                isPauseByUser;
/** 是否播放本地文件 */
@property (nonatomic, assign) BOOL                isLocalVideo;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat             sliderLastValue;
/** 是否再次设置URL播放视频 */
@property (nonatomic, assign) BOOL                repeatToPlay;
/** 播放完了*/
@property (nonatomic, assign) BOOL                playDidEnd;
/** 进入后台*/
@property (nonatomic, assign) BOOL                didEnterBackground;
/** 是否自动播放 */
@property (nonatomic, assign) BOOL                isAutoPlay;

#pragma mark - UITableViewCell PlayerView

/** ViewController中页面是否消失 */
@property (nonatomic, assign) BOOL                viewDisappear;

/** 是否切换分辨率*/
@property (nonatomic, assign) BOOL                isChangeResolution;

@end

@implementation JPPlayerView

/**
 *  带初始化调用此方法
 */
- (instancetype)init
{
    self = [super init];
    if (self) { [self initializeThePlayer]; }
    return self;
}

/**
 *  初始化player
 */
- (void)initializeThePlayer
{
    // 每次播放视频都解锁屏幕锁定
    [self unLockTheScreen];
}

- (void)dealloc
{
    self.playerItem = nil;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  重置player
 */
- (void)resetPlayer
{
    // 改为未播放完
    self.playDidEnd         = NO;
    self.playerItem         = nil;
    self.didEnterBackground = NO;
    // 视频跳转秒数置0
    self.seekTime           = 0;
    self.isAutoPlay         = NO;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 关闭定时器
    [self.timer invalidate];
    // 暂停
    [self pause];
    // 移除原来的layer
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 把player置为nil
    self.player = nil;
    if (self.isChangeResolution) { // 切换分辨率
        [self.controlView resetControlViewForResolution];
        self.isChangeResolution = NO;
    }else { // 重置控制层View
        [self.controlView resetControlView];
    }
    // 非重播时，移除当前playerView
    if (!self.repeatToPlay) { [self removeFromSuperview]; }
}

/**
 *  在当前页面，设置新的Player的URL调用此方法
 */
- (void)resetToPlayNewURL
{
    self.repeatToPlay = YES;
    [self resetPlayer];
}

#pragma mark - 观察者、通知

/**
 *  添加观察者、通知
 */
- (void)addNotifications
{
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // slider开始滑动事件
    [self.controlView.videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.controlView.videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.controlView.videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    // 播放按钮点击事件
    [self.controlView.startBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.controlView.backBtn setImage:[UIImage imageNamed:(@"JPPlayer_back_full")] forState:UIControlStateNormal];
    
    // 返回按钮点击事件
    [self.controlView.backBtn addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    // 全屏按钮点击事件
    [self.controlView.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    // 锁定屏幕方向点击事件
    [self.controlView.lockBtn addTarget:self action:@selector(lockScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    // 重播
    [self.controlView.repeatBtn addTarget:self action:@selector(repeatPlay:) forControlEvents:UIControlEventTouchUpInside];
    // 重新加载
    [self.controlView.reloadBtn addTarget:self action:@selector(reloadVideo:) forControlEvents:UIControlEventTouchUpInside];
    // 中间按钮播放
    [self.controlView.playeBtn addTarget:self action:@selector(configJPPlayer) forControlEvents:UIControlEventTouchUpInside];
    
    
    __weak typeof(self) weakSelf = self;
    // 切换分辨率
    self.controlView.resolutionBlock = ^(UIButton *button) {
        // 记录切换分辨率的时刻
        NSInteger currentTime = (NSInteger)CMTimeGetSeconds([weakSelf.player currentTime]);
        
        NSString *videoStr = weakSelf.videoURLArray[button.tag-200];
        NSURL *videoURL = [NSURL URLWithString:videoStr];
        if ([videoURL isEqual:weakSelf.videoURL]) { return ;}
        weakSelf.isChangeResolution = YES;
        // reset player
        [weakSelf resetToPlayNewURL];
        weakSelf.videoURL = videoURL;
        // 从xx秒播放
        weakSelf.seekTime = currentTime;
        
    };
    // 点击slider快进
    self.controlView.tapBlock = ^(CGFloat value) {
        [weakSelf pause];
        // 视频总时间长度
        CGFloat total           = (CGFloat)weakSelf.playerItem.duration.value / weakSelf.playerItem.duration.timescale;//value/timescale = seconds.
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * value);
        [weakSelf seekToTime:dragedSeconds completionHandler:^(BOOL finished) {
            if (finished) {
                // 只要点击进度条就跳转播放
                weakSelf.controlView.startBtn.selected = !finished;
                [weakSelf startAction:weakSelf.controlView.startBtn];
            }
        }];
        
    };
    // 监测设备方向
    [self listeningRotating];
}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

#pragma mark - layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    if (!self.isPauseByUser) {
        // 只要屏幕旋转就显示控制层
        self.isMaskShowing = NO;
        // 延迟隐藏controlView
        [self animateShow];
    }
    if (iPhone4s) {
    // 4s，屏幕宽高比不是16：9的问题,player加到控制器上时候
        self.sd_resetLayout.heightIs(JP_SCREEN_WIDTH*2/3);
    }
    // fix iOS7 crash bug
    [self layoutIfNeeded];
}

#pragma mark - 设置视频URL

/**
 *  videoURL的setter方法
 *
 *  @param videoURL videoURL
 */
- (void)setVideoURL:(NSURL *)videoURL
{
    _videoURL = videoURL;
    
    // 播放开始之前（加载中）设置站位图
    UIImage *image = [UIImage imageNamed:(@"JPPlayer_loading_bgView")];
    self.layer.contents = (id) image.CGImage;
    
    // 每次加载视频URL都设置重播为NO
    self.repeatToPlay = NO;
    self.playDidEnd   = NO;
    
    // 添加通知
    [self addNotifications];
    // 根据屏幕的方向设置相关UI
    [self onDeviceOrientationChange];
    
    self.isPauseByUser = YES;
    self.controlView.playeBtn.hidden = NO;
    [self.controlView hideControlView];
    // 设置Player相关参数
    //    [self configJPPlayer];
}

/**
 *  设置Player相关参数
 */
- (void)configJPPlayer
{
    self.playerItem  = [AVPlayerItem playerItemWithURL:self.videoURL];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    
    // 初始化显示controlView为YES
    self.isMaskShowing = YES;
    // 延迟隐藏controlView
    [self autoFadeOutControlBar];
    
    // 计时器
    [self createTimer];
    
    // 添加手势
    [self createGesture];
    
    // 获取系统音量
    [self configureVolume];
    
    // 本地文件不设置JPPlayerStateBuffering状态
    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        self.state = JPPlayerStatePlaying;
        self.isLocalVideo = YES;
        self.controlView.downLoadBtn.enabled = NO;
    } else {
        self.state = JPPlayerStateBuffering;
        self.isLocalVideo = NO;
    }
    // 开始播放
//    [self play];
    self.controlView.startBtn.selected = YES;
    self.isPauseByUser                 = YES;
    self.controlView.playeBtn.hidden   = YES;
    
    // 强制让系统调用layoutSubviews 两个方法必须同时写
    [self setNeedsLayout]; //是标记 异步刷新 会调但是慢
    [self layoutIfNeeded]; //加上此代码立刻刷新
}

/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo
{
    self.isAutoPlay = NO;
    // 设置Player相关参数
    [self configJPPlayer];
}

/**
 *  创建手势
 */
- (void)createGesture
{
    // 单击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

/**
 *  创建timer
 */
- (void)createTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playerTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  获取系统音量
 */
- (void)configureVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}

/**
 *  耳机插入、拔出事件
 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            // 拔掉耳机继续播放
            [self play];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark - ShowOrHideControlView

- (void)autoFadeOutControlBar
{
    if (!self.isMaskShowing) { return; }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
    [self performSelector:@selector(hideControlView) withObject:nil afterDelay:JPPlayerAnimationTimeInterval];
    
}

/**
 *  取消延时隐藏controlView的方法
 */
- (void)cancelAutoFadeOutControlBar
{
    [self.timer invalidate];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/**
 *  隐藏控制层
 */
- (void)hideControlView
{
    if (!self.isMaskShowing) { return; }
    [UIView animateWithDuration:JPPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self.controlView hideControlView];
        if (self.isFullScreen) { //全屏状态
            self.controlView.backBtn.alpha = 0;
        }else {
            self.controlView.backBtn.alpha = 0;
        }
    }completion:^(BOOL finished) {
        self.isMaskShowing = NO;
    }];
}

/**
 *  显示控制层
 */
- (void)animateShow
{
    if (self.isMaskShowing) { return; }
    [UIView animateWithDuration:JPPlayerControlBarAutoFadeOutTimeInterval animations:^{
        if (self.isFullScreen)
        {
            self.controlView.backBtn.alpha = 1;
            if (self.playDidEnd) {
                [self.controlView hideControlView];
            } // 播放完了
            else {
                [self.controlView showControlView];
            }
        }
        else
        {
            self.controlView.backBtn.alpha = 0;
            if (self.playDidEnd) {
                [self.controlView hideControlView];
            } // 播放完了
            else {
                [self.controlView showControlViewWhenPortrait];
            }
        }
    } completion:^(BOOL finished) {
        self.isMaskShowing = YES;
        [self autoFadeOutControlBar];
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                
                if (_playerItem.duration.timescale == 0)
                {
                    self.controlView.startBtn.hidden = NO;
                    self.controlView.currentTimeLabel.hidden = YES;
                    self.controlView.totalTimeLabel.hidden = YES;
                    self.controlView.progressView.hidden = YES;
                    self.controlView.videoSlider.hidden = YES;
                }else
                {
                    self.controlView.startBtn.hidden = NO;
                    self.controlView.currentTimeLabel.hidden = NO;
                    self.controlView.totalTimeLabel.hidden = NO;
                    self.controlView.progressView.hidden = NO;
                    self.controlView.videoSlider.hidden = NO;
                }
                
                
                self.state = JPPlayerStatePlaying;
                // 加载完成后，再添加平移手势
                // 添加平移手势，用来控制音量、亮度、快进快退
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
                pan.delegate                = self;
                [self addGestureRecognizer:pan];
                
                // 跳到xx秒播放视频
                if (self.seekTime) {
                    [self seekToTime:self.seekTime completionHandler:nil];
                }
                
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed){
                
                self.state = JPPlayerStateFailed;
                //NSError *error = [self.player.currentItem error];
                //NSLog(@"视频加载失败===%@",error.description);
                self.controlView.reloadBtn.hidden = NO;
                self.controlView.horizontalLabel.hidden = NO;
                self.controlView.horizontalLabel.text = @"视频加载失败";
                [self performSelector:@selector(hideTishi) withObject:nil afterDelay:2];
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
            //计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration             = self.playerItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            
            if (totalDuration != 0) {
                [self.controlView.progressView setProgress:timeInterval / totalDuration animated:NO];
            }
            // 如果缓冲和当前slider的差值超过0.1,自动播放，解决弱网情况下不会自动播放问题
            if (!self.isPauseByUser && !self.didEnterBackground ) {
                [self play];
            }
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            // 当缓冲是空的时候
            if (self.playerItem.playbackBufferEmpty) {
                NSLog(@"缓冲区空了");
                self.state = JPPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
            
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            // 当缓冲好的时候   缓冲持续进行   还有一个状态是bufferFull
            NSLog(@"缓冲好了，继续播放");
            if (self.playerItem.playbackLikelyToKeepUp && self.state == JPPlayerStateBuffering){
                self.state = JPPlayerStatePlaying;
            }
            
        }
    }
}

- (void) hideTishi{
    self.controlView.horizontalLabel.hidden = YES;
}
#pragma mark 屏幕转屏相关

/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

/**
 *  全屏按钮事件
 *
 *  @param sender 全屏Button
 */
- (void)fullScreenAction:(UIButton *)sender
{
    if (self.isLocked) {
        [self unLockTheScreen];
        return;
    }
    
    
    UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationPortraitUpsideDown:{
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationPortrait:{
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
            
        }
            break;
            
        default: {
            
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
            
        }
            break;
    }
    
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange
{
    if (self.isLocked) {
        self.isFullScreen = YES;
        return;
    }
    UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            self.controlView.fullScreenBtn.selected = YES;
            
            // 设置返回按钮的约束
            self.controlView.backBtn.sd_resetLayout.topSpaceToView(self.controlView, 20).leftSpaceToView(self, 7).widthIs(40).heightEqualToWidth();
            self.isFullScreen = YES;
            
        }
            break;
        case UIInterfaceOrientationPortrait:{
            self.isFullScreen = !self.isFullScreen;
            self.controlView.fullScreenBtn.selected = NO;
            
            self.controlView.backBtn.sd_resetLayout.topSpaceToView(self.controlView, 5).leftSpaceToView(self, 7).widthIs(40).heightEqualToWidth();
            self.isFullScreen = NO;
            
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            self.controlView.fullScreenBtn.selected = YES;
            self.controlView.backBtn.sd_resetLayout.topSpaceToView(self.controlView, 20).leftSpaceToView(self, 7).widthIs(40).heightEqualToWidth();
            self.isFullScreen = YES;
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            self.controlView.fullScreenBtn.selected = YES;
            self.controlView.backBtn.sd_resetLayout.topSpaceToView(self.controlView, 20).leftSpaceToView(self, 7).widthIs(40).heightEqualToWidth();
            self.isFullScreen = YES;
        }
            break;
            
        default:
            break;
    }
    // 设置显示or不显示锁定屏幕方向按钮
    //    self.controlView.lockBtn.hidden = !self.isFullScreen;
    self.controlView.lockBtn.hidden = YES;
    self.controlView.topImageView.alpha = self.isFullScreen;
    self.controlView.backBtn.alpha = self.isFullScreen;
    if (self.isFullScreen) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

/**
 *  锁定屏幕方向按钮
 *
 *  @param sender UIButton
 */
- (void)lockScreenAction:(UIButton *)sender
{
    sender.selected             = !sender.selected;
    self.isLocked               = sender.selected;
}

/**
 *  解锁屏幕方向锁定
 */
- (void)unLockTheScreen
{
    self.controlView.lockBtn.selected = NO;
    self.isLocked = NO;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}


#pragma mark - 缓冲较差时候

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond
{
    self.state = JPPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self pause2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) { [self bufferingSomeSecond]; }
        
    });
}

#pragma mark - 计时器事件
/**
 *  计时器事件
 */
- (void)playerTimerAction
{
    if (_playerItem.duration.timescale != 0) {
        self.controlView.videoSlider.value     = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);//当前进度
        
        //当前时长进度progress
        NSInteger proMin                       = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec                       = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
        
        //duration 总时长
        NSInteger durMin                       = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec                       = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        
        self.controlView.currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        self.controlView.totalTimeLabel.text   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        
        
    }
}

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    // NSLog(@"缓冲区大小 = %f",durationSeconds);
    return result;
}

#pragma mark - Action

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        self.isMaskShowing ? ([self hideControlView]) : ([self animateShow]);
    }
}


/**
 *  播放、暂停按钮事件
 *
 *  @param button UIButton
 */
- (void)startAction:(UIButton *)button
{
    button.selected    = !button.selected;
    self.isPauseByUser = !self.isPauseByUser;
    if (button.selected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(willPlayVideo)]) {
            [self.delegate willPlayVideo];
        }
        [self play];
        if (self.state == JPPlayerStatePause) { self.state = JPPlayerStatePlaying; }
    } else {
        [self pause];
        if (self.state == JPPlayerStatePlaying) { self.state = JPPlayerStatePause;}
    }
}

- (void)pauseAction {
    self.controlView.startBtn.selected    = !self.controlView.startBtn.selected;
    self.isPauseByUser = !self.isPauseByUser;
    if (self.controlView.startBtn.selected) {
        [self play];
        if (self.state == JPPlayerStatePause) { self.state = JPPlayerStatePlaying; }
    } else {
        [self pause];
        if (self.state == JPPlayerStatePlaying) { self.state = JPPlayerStatePause;}
    }
}

/**
 *  播放
 */
- (void)play
{
    self.isPauseByUser = NO;
    [_player play];
    _isPlay = YES;
}

/**
 * 暂停
 */
- (void)pause
{
    self.isPauseByUser = YES;
    [_player pause];
    _isPlay = NO;
}

- (void)pause2
{
    //self.isPauseByUser = YES;
    [_player pause];
    _isPlay = NO;
}

/**
 *  返回按钮事件
 */
- (void)backButtonAction
{
    if (self.isLocked) {
        [self unLockTheScreen];
        return;
    }else {
        if (!self.isFullScreen) {
            // player加到控制器上，只有一个player时候
            [self.timer invalidate];
            [self pause];
            if (self.goBackBlock) {
                self.goBackBlock();
            }
        }else {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
    }
}

/**
 *  重播点击事件
 *
 *  @param sender sender
 */
- (void)repeatPlay:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willPlayVideo)]) {
        [self.delegate willPlayVideo];
    }
    // 没有播放完
    self.playDidEnd    = NO;
    // 重播改为NO
    self.repeatToPlay  = NO;
    // 准备显示控制层
    self.isMaskShowing = NO;
    [self animateShow];
    // 重置控制层View
    [self.controlView resetControlView];
    [self seekToTime:0 completionHandler:nil];
}
/**
 *  重新加载点击事件
 *
 *  @param sender sender
 */
- (void)reloadVideo:(UIButton *)sender
{
    //[self resetPlayer];
    self.controlView.reloadBtn.hidden = YES;
    [self autoPlayTheVideo];
    //    self.state = JPPlayerStateBuffering;
    //    // 没有播放完
    //    self.playDidEnd    = NO;
    //    // 重播改为NO
    //    self.repeatToPlay  = NO;
    //    // 准备显示控制层
    //    self.isMaskShowing = NO;
    //    [self animateShow];
    //    // 重置控制层View
    //    [self.controlView resetControlView];
    //    [self seekToTime:0 completionHandler:nil];
    //    [self play];
    
}

#pragma mark - NSNotification Action

/**
 *  播放完了
 *
 *  @param notification 通知
 */
- (void)moviePlayDidEnd:(NSNotification *)notification
{
    self.state            = JPPlayerStateStopped;
    
    self.controlView.backgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    self.playDidEnd                   = YES;
    self.controlView.repeatBtn.hidden = NO;
    // 初始化显示controlView为YES
    self.isMaskShowing                = NO;
    // 延迟隐藏controlView
    [self animateShow];
    
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground
{
    self.didEnterBackground = YES;
    [self.player pause];
    self.state = JPPlayerStatePause;
    [self cancelAutoFadeOutControlBar];
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayGround
{
    self.didEnterBackground = NO;
    self.isMaskShowing = NO;
    // 延迟隐藏controlView
    [self animateShow];
    [self createTimer];
    if (!self.isPauseByUser) {
        self.state                         = JPPlayerStatePlaying;
        self.controlView.startBtn.selected = YES;
        self.isPauseByUser                 = NO;
        [self play];
    }
}

#pragma mark - slider事件

/**
 *  slider开始滑动事件
 *
 *  @param slider UISlider
 */
- (void)progressSliderTouchBegan:(UISlider *)slider
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // 暂停timer
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

/**
 *  slider滑动中事件
 *
 *  @param slider UISlider
 */
- (void)progressSliderValueChanged:(UISlider *)slider
{
    //拖动改变视频播放进度
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        NSString *style = @"";
        CGFloat value   = slider.value - self.sliderLastValue;
        if (value > 0) { style = @">>"; }
        if (value < 0) { style = @"<<"; }
        
        self.sliderLastValue    = slider.value;
        // 暂停
        [self pause];
        
        CGFloat total           = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        //转换成CMTime才能给player来控制播放进度
        
        CMTime dragedCMTime     = CMTimeMake(dragedSeconds, 1);
        // 拖拽的时长
        NSInteger proMin        = (NSInteger)CMTimeGetSeconds(dragedCMTime) / 60;//当前秒
        NSInteger proSec        = (NSInteger)CMTimeGetSeconds(dragedCMTime) % 60;//当前分钟
        
        //duration 总时长
        NSInteger durMin        = (NSInteger)total / 60;//总秒
        NSInteger durSec        = (NSInteger)total % 60;//总分钟
        
        NSString *currentTime   = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        NSString *totalTime     = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        
        if (total > 0) {
            // 当总时长 > 0时候才能拖动slider
            self.controlView.currentTimeLabel.text  = currentTime;
            self.controlView.horizontalLabel.hidden = NO;
            self.controlView.horizontalLabel.text   = [NSString stringWithFormat:@"%@ %@ / %@",style, currentTime, totalTime];
        }else {
            // 此时设置slider值为0
            slider.value = 0;
        }
        
    }else { // player状态加载失败
        // 此时设置slider值为0
        slider.value = 0;
    }
}


- (void)progressSliderTouchEnded:(UISlider *)slider
{
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        
        // 继续开启timer
        [self.timer setFireDate:[NSDate date]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.controlView.horizontalLabel.hidden = YES;
        });
        // 结束滑动时候把开始播放按钮改为播放状态
        self.controlView.startBtn.selected = YES;
        self.isPauseByUser                 = NO;
        
        // 滑动结束延时隐藏controlView
        [self autoFadeOutControlBar];
        // 视频总时间长度
        CGFloat total           = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        [self seekToTime:dragedSeconds completionHandler:nil];
    }
}

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler
{
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            // 视频跳转回调
            if (completionHandler) { completionHandler(finished); }
            // 如果点击了暂停按钮
            if (self.isPauseByUser) return ;
            [self play];
            self.seekTime = 0;
            if (!self.playerItem.isPlaybackLikelyToKeepUp && !self.isLocalVideo) {
                self.state = JPPlayerStateBuffering;
            }
            
        }];
    }
}

#pragma mark - UIPanGestureRecognizer手势方法

/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan
{
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                //                // 取消隐藏
                //                self.controlView.horizontalLabel.hidden = NO;
                //                self.panDirection = PanDirectionHorizontalMoved;
                //                // 给sumTime初值
                //                CMTime time       = self.player.currentTime;
                //                self.sumTime      = time.value/time.timescale;
                //
                //                // 暂停视频播放
                //                [self pause];
                //                // 暂停timer
                //                [self.timer setFireDate:[NSDate distantFuture]];
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    
                    //                    // 继续播放
                    //                    [self play];
                    //                    [self.timer setFireDate:[NSDate date]];
                    //
                    //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //                        // 隐藏视图
                    //                        self.controlView.horizontalLabel.hidden = YES;
                    //                    });
                    //                    // 快进、快退时候把开始播放按钮改为播放状态
                    //                    self.controlView.startBtn.selected = YES;
                    //                    self.isPauseByUser                 = NO;
                    //
                    //                    [self seekToTime:self.sumTime completionHandler:nil];
                    //                    // 把sumTime滞空，不然会越加越多
                    //                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.controlView.horizontalLabel.hidden = YES;
                    });
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


- (void)verticalMoved:(CGFloat)value
{
    self.isVolume ? (self.volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}


- (void)horizontalMoved:(CGFloat)value
{
    // 快进快退的方法
    NSString *style = @"";
    if (value < 0) { style = @"<<"; }
    if (value > 0) { style = @">>"; }
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    
    // 需要限定sumTime的范围
    CMTime totalTime           = self.playerItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0){ self.sumTime = 0; }
    
    // 当前快进的时间
    NSString *nowTime         = [self durationStringWithTime:(int)self.sumTime];
    // 总时间
    NSString *durationTime    = [self durationStringWithTime:(int)totalMovieDuration];
    // 给label赋值
    self.controlView.horizontalLabel.text = [NSString stringWithFormat:@"%@ %@ / %@",style, nowTime, durationTime];
}

- (NSString *)durationStringWithTime:(int)time
{
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",time / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.controlView];
    
    if ((point.y > self.bounds.size.height-40) || self.playDidEnd) { return NO; }
    return YES;
}

#pragma mark - Others

/**
 *  通过颜色来生成一个纯色图片
 */
- (UIImage *)buttonImageFromColor:(UIColor *)color
{
    CGRect rect = self.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

#pragma mark - Setter

/**
 *  设置播放的状态
 *
 *  @param state JPPlayerState
 */
- (void)setState:(JPPlayerState)state
{
    _state = state;
    if (state == JPPlayerStatePlaying) {
        UIImage *image = [self buttonImageFromColor:[UIColor blackColor]];
        self.layer.contents = (id) image.CGImage;
    } else if (state == JPPlayerStateFailed) {
        self.controlView.downLoadBtn.enabled = NO;
        NSLog(@"播放失败");
    }
    // 控制菊花显示、隐藏
    state == JPPlayerStateBuffering ? ([self.controlView.activity startAnimating]) : ([self.controlView.activity stopAnimating]);
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (_playerItem == playerItem) {return;}
    
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}

/**
 *  设置playerLayer的填充模式
 *
 *  @param playerLayerGravity playerLayerGravity
 */
- (void)setPlayerLayerGravity:(JPPlayerLayerGravity)playerLayerGravity
{
    _playerLayerGravity = playerLayerGravity;
    switch (playerLayerGravity) {
        case JPPlayerLayerGravityResize:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case JPPlayerLayerGravityResizeAspect:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case JPPlayerLayerGravityResizeAspectFill:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            break;
    }
}

- (void)setResolutionDic:(NSDictionary *)resolutionDic
{
    _resolutionDic = resolutionDic;
    self.controlView.resolutionBtn.hidden = NO;
    self.videoURLArray = [resolutionDic allValues];
    self.controlView.resolutionArray = [resolutionDic allKeys];
}

#pragma mark - Getter

/**
 * 懒加载 控制层View
 *
 *  @return JPPlayerControlView
 */
- (JPPlayerControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[JPPlayerControlView alloc] init];
        [self addSubview:_controlView];
        _controlView.sd_layout.topEqualToView(self).leftEqualToView(self).rightEqualToView(self).bottomEqualToView(self);
    }
    return _controlView;
}

@end
