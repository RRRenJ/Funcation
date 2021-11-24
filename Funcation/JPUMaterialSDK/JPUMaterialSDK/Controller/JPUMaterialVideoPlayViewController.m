//
//  JPUMaterialVideoPlayViewController.m
//  EditVideoText
//
//  Created by foundao on 2021/9/16.
//

#import "JPUMaterialVideoPlayViewController.h"
#import "ZFPlayer/ZFPlayer.h"
#import "ZFPlayer/ZFAVPlayerManager.h"
#import "ZFPlayer/ZFPlayerControlView.h"
#import "ZFPlayer/ZFPlayerConst.h"
#import "JPUMaterialPlayCustomView.h"
#import "JPUMaterialSingleton.h"

@interface JPUMaterialVideoPlayViewController ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) JPUMaterialPlayCustomView *controlView;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutNavHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@end

@implementation JPUMaterialVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layoutNavHeight.constant = JPU_NavHeight;
    [self.view insertSubview:self.containerView atIndex:0];
    [self setupPlayer];
    self.btnSure.hidden = self.isPlay;
    
}
- (IBAction)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sureClick {
    !self.selectVideoBlock?:self.selectVideoBlock();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.player.viewControllerDisappear = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = CGRectGetHeight(self.view.frame) ;
    self.containerView.frame = CGRectMake(x, y, w, h);

}

- (void)setupPlayer {
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    playerManager.shouldAutoPlay = YES;
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    self.player.resumePlayRecord = YES;
    @zf_weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @zf_strongify(self)
        [self.player.currentPlayerManager replay];
        [self.player playTheNext];
    };
    
    self.player.assetURLs = @[[NSURL fileURLWithPath:self.model.filePath]];
    [self.player playTheIndex:0];
    
}

- (JPUMaterialPlayCustomView *)controlView
{
    if(!_controlView){
        _controlView = [JPUMaterialPlayCustomView new];
        _controlView.backgroundColor = UIColor.clearColor;
    }
    return _controlView;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
    }
    return _containerView;
}
@end
