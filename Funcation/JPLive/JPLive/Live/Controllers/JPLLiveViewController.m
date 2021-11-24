//
//  JPLLiveViewController.m
//  jper
//
//  Created by RRRenJ on 2020/5/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveViewController.h"
#import "JPLInitLiveView.h"
#import "JPLLiveMenuView.h"
#import "JPLLivePushView.h"
#import "JPLLiveAlertView.h"
#import "JPLBarrageModel.h"
#import "JPLLiveGoodsView.h"
#import "JPLLiveBeautyView.h"
#import "JPLLiveFilterView.h"
#import <TXLiteAVSDK_Smart/TXLiteAVSDK.h>
#import "JPLAlertView.h"
#import "JPLLiveWSResponse.h"
#import <sys/utsname.h>



#define JPLLiveWatermarkPath [NSString stringWithFormat:@"%@/%@/%@/LiveWatermark.png", NSHomeDirectory(), @"Documents", @"paike"]

@interface JPLLiveViewController ()<V2TXLivePusherObserver>

//垫片图
@property (nonatomic, strong) UIImageView * backIV;

@property (nonatomic, strong) UIImageView * watermarkIV;

@property (nonatomic, strong) JPLLivePushView * pushView;

@property (nonatomic, strong) JPLInitLiveView * beginView;

@property (nonatomic, strong) JPLLiveMenuView * menuView;

//@property (nonatomic, strong) JPLLiveGoodsView * goodsView;

@property (nonatomic, strong) JPLLiveBeautyView * beautyView;

@property (nonatomic, strong) JPLLiveFilterView * filterView;

@property (nonatomic, strong) UIView * menuBackView;

@property (nonatomic, strong) V2TXLivePusher * livePush;

@property (nonatomic, strong) V2TXLiveVideoEncoderParam * videoParam;

@property (nonatomic, strong) TXDeviceManager * deviceManager;

@property (nonatomic, strong) TXBeautyManager * beautyManager;

@property (nonatomic, assign) BOOL appIsBackground;

@property (nonatomic, strong) UIImage * watermark;

//@property (nonatomic, strong) JPLLiveWatermarkModel * watermarkModel;

@property (nonatomic, copy) NSString *  liveURL;

@property (nonatomic, strong) JPLAlertView *  avAuthorizationAlertView;

@property (nonatomic, strong) JPLLiveGoodsModel * saleGoods;

@property (nonatomic, strong) UIImage * saleGoodsImage;

@property (nonatomic, copy) NSString *  onlineNumber;

@property (nonatomic, assign) BOOL showWSAlter;

@property (nonatomic, strong) NSDate * lastGoodsSaleDate;

@property (nonatomic, strong) CAGradientLayer * menuBackViewLayer;

@end

@implementation JPLLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavgationBar = YES;
    [self setupViews];
    [self addActions];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([self.ammodel.live_ratio isEqualToString:@"480p"]) {
        [self.videoParam setVideoResolution:V2TXLiveVideoResolution640x480];
    }else if ([self.ammodel.live_ratio isEqualToString:@"1080p"]){
        [self.videoParam setVideoResolution:V2TXLiveVideoResolution1920x1080];
    }else{
        [self.videoParam setVideoResolution:V2TXLiveVideoResolution1280x720];
    }
    if (self.__supportedInterfaceOrientations == UIInterfaceOrientationMaskPortrait) {
        [self updateLayoutWithOrientation:YES];
        [self.videoParam setVideoResolutionMode:V2TXLiveVideoResolutionModePortrait];
        [self.livePush setVideoQuality:self.videoParam];
        [self.livePush setRenderRotation:V2TXLiveRotation0];
        
    }else{
        [self updateLayoutWithOrientation:NO];
        [self.videoParam setVideoResolutionMode:V2TXLiveVideoResolutionModeLandscape];
        [self.livePush setVideoQuality:self.videoParam];
        [self.livePush setRenderRotation:V2TXLiveRotation180];
        
    }

    [JPLUtil showVideoAuthorizationAlertWithCompletionHandler:^(BOOL grant){
        [JPLUtil showAudioAuthorizationAlertWithCompletionHandler:^(BOOL agree){
           dispatch_async(dispatch_get_main_queue(), ^{
               if (grant && agree){
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [self.livePush setRenderView:self.backIV];
                       [self.livePush startCamera:self.deviceManager.isFrontCamera];
                       [self.livePush startMicrophone];
                   });
               }
           });
       }];
    }];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self hiddenAVAuthorizationAlert];
    [JPLUtil showVideoAuthorizationAlertWithCompletionHandler:^(BOOL grant){
        [JPLUtil showAudioAuthorizationAlertWithCompletionHandler:^(BOOL agree){
           dispatch_async(dispatch_get_main_queue(), ^{
               if (!agree && !grant) {
                   NSString *str = @"直播需要访问摄像头和麦克风权限\n请前去设置";
                   [self showAVAuthorizationAlertWithTittle:str];
               } else if(!grant){
                   NSString *str = @"直播需要访问摄像头权限\n请前去设置";
                   [self showAVAuthorizationAlertWithTittle:str];
               } else if (!agree){
                   NSString *str = @"直播需要访问麦克风权限\n请前去设置";
                   [self showAVAuthorizationAlertWithTittle:str];
               }
           });
       }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.livePush stopCamera];
    [self.livePush stopMicrophone];
}

- (BOOL)__shouldAutorotate{
    return  NO;
}

- (NSUInteger)__supportedInterfaceOrientations{
    if (self.ammodel.isPortrait) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskLandscapeRight;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

}


- (void)updateLayoutWithOrientation:(BOOL)isPortrait{
    [self.menuView updateLayoutWithOrientation:isPortrait];
    [self.pushView updateLayoutWithOrientation:isPortrait];
    [self.beautyView updateLayoutWithOrientation:isPortrait];
    [self.filterView updateLayoutWithOrientation:isPortrait];
    self.backIV.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    self.watermarkIV.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    self.pushView.title = self.ammodel.live_name;
    self.pushView.liveID = [NSString stringWithFormat:@"ID: %@",self.ammodel.live_id];
    self.pushView.city = @"成都";
    
    if (self.menuBackViewLayer) {
        [self.menuBackViewLayer removeFromSuperlayer];
    }
    
    if (isPortrait) {
        self.backIV.image = JPLImageWithName(@"live_bg_p");
        self.menuBackView.frame = CGRectMake(JPL_SCR_WIDTH - 87, JPL_SCR_HEIGHT / 2 , 87, JPL_SCR_HEIGHT / 2);
    }else{
        self.backIV.image = JPLImageWithName(@"live_bg_l");
        self.menuBackView.frame = CGRectMake(JPL_SCR_WIDTH - 87, 0 , 87, JPL_SCR_HEIGHT);
        
        self.menuBackViewLayer = [UIColor jpl_gradientWith:self.menuBackView.bounds fromeColor:[UIColor jpl_colorWithHexString:@"000000" alpha:0] toColor:[UIColor jpl_colorWithHexString:@"000000" alpha:0.47] fromePoint:CGPointMake(0, 0) toPoint:CGPointMake(1, 0)];
        [self.menuBackView.layer addSublayer:self.menuBackViewLayer];
    }
    
}


- (void)setupViews{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.watermarkIV];
    self.backIV.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.menuBackView];
//    [self.view addSubview:self.beginView];
    [self.view addSubview:self.menuView];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.pushView];
    [self.view bringSubviewToFront:self.menuBackView];
    [self.view bringSubviewToFront:self.menuView];
    
    [self hiddenAVAuthorizationAlert];
    

//   self.beginView.liveTitle = self.ammodel.live_name;
//   self.goodsView.live_id = self.ammodel.live_id;

    [self getCameraAndAudioAuthorized:^(BOOL successful) {
        if (successful) {
            [self requestLiveStart];
        }
    } andTips:YES];
    
}

- (void)addActions{
    [self addNotification];
    __weak typeof(self) weakself  = self;
    self.beginView.liveStartBlock = ^(NSString * _Nonnull title) {
        NSLog(@"%@",title);
        if (!title || title.length == 0){
            [MBProgressHUD jpl_showMessage:@"请填写直播标题"];
        }else{

            [weakself getCameraAndAudioAuthorized:^(BOOL successful) {
                if (successful) {
                    [weakself requestLiveStart];
                }
            } andTips:YES];
        }
    };
    

   self.pushView.endBlock = ^{
       JPLLiveAlertView * alert = [[JPLLiveAlertView alloc] initWithType:JPLLiveAlertTypeAsk title:@"是否退出？"];
       alert.message = @"退出后直播结束";
       __weak typeof(alert) weakalert  = alert;
       alert.comfirmBlock = ^{
           [weakalert hide];
           [weakself requestLiveEnd:^(BOOL isSucess) {
               [weakself dismissViewControllerAnimated:YES completion:nil];
           }];
           
       };
       [alert show];
   };
    
    self.menuView.menuClicedBlock = ^BOOL(JPLLiveMenuType type, BOOL isSelected) {

        if (type == JPLLiveMenuTypeGoods) {
//            if (isSelected){
//                [weakself.goodsView show];
//            }else{
//                [weakself.goodsView hide];
//            }
            return YES;
        }else if (type == JPLLiveMenuTypeBeauty){
            if (isSelected){
                [weakself.beautyView show];
            }else{
                [weakself.beautyView hide];
            }
        }else if (type == JPLLiveMenuTypeFilter){
            if (isSelected){
                [weakself.filterView show];
            }else{
                [weakself.filterView hide];
            }
        }else if (type == JPLLiveMenuTypeSoundOff){
            if (isSelected) {
                [weakself.livePush pauseAudio];
            }else{
                [weakself.livePush resumeAudio];
            }
        }else if (type == JPLLiveMenuTypeCamera){
            [weakself.deviceManager switchCamera:!weakself.deviceManager.isFrontCamera];
            if (weakself.deviceManager.isFrontCamera) {
                [weakself.menuView cancelSelect:JPLLiveMenuTypeLight];
            }
        }else if (type == JPLLiveMenuTypeLight){
            if ([weakself.deviceManager isCameraTorchSupported]) {
                [weakself.deviceManager enableCameraTorch:isSelected];
            }
        }
        return YES;
    };

#pragma mark - 美颜滤镜设置
    self.beautyView.beautyBlock = ^(float value) {
        NSLog(@"美颜%f",value);
        if (value > 9) {
            value = 9;
        }
        [weakself.beautyManager setBeautyLevel:value];
    };
    
    self.beautyView.whitenessBlock = ^(float value) {
        NSLog(@"美白%f",value);
        if (value > 9) {
            value = 9;
        }
        [weakself.beautyManager setWhitenessLevel:value];
    };
    
    self.beautyView.ruddyBlock = ^(float value) {
        NSLog(@"红润%f",value);
        if (value > 9) {
            value = 9;
        }
        [weakself.beautyManager setRuddyLevel:value];
    };
    
    
    self.beautyView.tapHideBlock = ^{
        [weakself.menuView cancelSelect:JPLLiveMenuTypeBeauty];
    };
    
    self.filterView.filterBlock = ^(JPLLiveFilterModel * _Nonnull model) {
        NSLog(@"%@",model.name);
        [weakself.beautyManager setFilter: JPLImageWithName(model.filterName)];
    };
    
    self.filterView.tapHideBlock = ^{
        [weakself.menuView cancelSelect:JPLLiveMenuTypeFilter];
    };

    
}



#pragma mark - 水印
- (void)setWatermark{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGSize liveSize = CGSizeMake(1920, 1080);
        if (self.__supportedInterfaceOrientations == UIInterfaceOrientationPortrait) {
            liveSize = CGSizeMake(1080, 1920);
        }else{
            liveSize = CGSizeMake(1920, 1080);
        }

        UIImage * newWatermark = nil;
        CGRect newFrame = CGRectZero;
        CGSize goodsSize = liveSize;
        CGRect goodsFrame = CGRectMake(0 , 0, goodsSize.width, goodsSize.height);
        CGSize waterSize = CGSizeMake( 0.1 * liveSize.width,  0.1 * liveSize.width / self.watermark.size.height * self.watermark.size.width);
        CGRect waterFrame = CGRectMake(0.05 * liveSize.width , 0.05 * liveSize.height, waterSize.width, waterSize.height);
        if (self.watermark && self.saleGoodsImage) {
            UIImage * comImage = [self compositionFirstImage:self.saleGoodsImage firstFrame:goodsFrame secondImage:self.watermark secondFrame:waterFrame andSuperSize:liveSize];
            NSData * comImageData = UIImagePNGRepresentation(comImage);
            UIImage * comPNGImage = [UIImage imageWithData:comImageData];
            newWatermark = comPNGImage;
            newFrame = CGRectMake(0, 0, 1, 0);
        }else if (self.watermark && !self.saleGoodsImage){
            newWatermark = self.watermark;
            newFrame = CGRectMake(waterFrame.origin.x / liveSize.width, waterFrame.origin.y / liveSize.height, waterFrame.size.width / liveSize.width, 0);
            
        }else if (!self.watermark && self.saleGoodsImage){
            newWatermark = self.saleGoodsImage;
            newFrame = CGRectMake(0, 0, 1, 0);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.watermarkIV.image = newWatermark;
            [self.livePush setWatermark:newWatermark x:newFrame.origin.x y:newFrame.origin.y scale:newFrame.size.width];
        });
    });
}

#pragma mark - AppActions

-(void)onAppDidEnterBackground:(NSNotification *)notification {
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{}];
    self.appIsBackground = YES;
    [self.livePush startVirtualCamera:self.backIV.image];
}
// App 被切回前台的处理函数
-(void)onAppWillEnterForeground:(NSNotification *)notification {
    if (self.appIsBackground ){
        [self.livePush stopVirtualCamera];
    }
}

#pragma mark - request



- (void)requestLiveStart{
    [self jpl_showHUD];
    NSMutableDictionary *dic1 = @{@"service":@"App.Live_Stream.Start",
                                  @"token":[JPLServiceInfo share].token,
                                  @"live_id":@([self.ammodel.live_id integerValue]),
                               }.mutableCopy;
   [JPLService requestWithURLString:API_HOST parameters:dic1 type:JPLHttpRequestTypePost success:^(JPLResultBase *response) {
       [self jpl_hideHUD];
       if ([response.ret integerValue] == 200) {
           NSDictionary <NSString *, id>* dict = response.data;
           if ([dict.allKeys containsObject:@"stream_push_rtmp"]) {
               
               [self.pushView startTimer];
               self.liveURL = dict[@"stream_push_rtmp"];
               [self.livePush startPush:self.liveURL];
           }else{
               [MBProgressHUD jpl_showMessage:@"没有推流地址"];
           }

       }else {
           [MBProgressHUD jpl_showMessage:response.msg];
       }
   } failure:^(NSError *error) {
      [self jpl_hideHUD];
   } withErrorMsg:@"网络出错，请稍后重试"];
}

- (void)requestLiveEnd:(void(^)(BOOL isSucess))complet{
    [self jpl_showHUD];
    NSMutableDictionary *dic = @{@"service":@"App.Live_Stream.End",
                                 @"token":[JPLServiceInfo share].token,
                                 @"live_id":@([self.ammodel.live_id integerValue]),
                                }.mutableCopy;
    [JPLService requestWithURLString:API_HOST parameters:dic type:JPLHttpRequestTypePost success:^(JPLResultBase *response) {
        [self jpl_hideHUD];
        [self.livePush stopPush];
        [self.livePush stopCamera];
        [self.livePush stopMicrophone];
        if ([response.ret integerValue] == 200) {
            
            complet(YES);
        }else{
            complet(NO);
            [MBProgressHUD jpl_showMessage:response.msg];
        }
    } failure:^(NSError *error) {
        complet(NO);
        [self jpl_hideHUD];
    } withErrorMsg:@"网络出错，请稍后重试"];
}

#pragma mark - TXLivePushListener


- (void)onNetStatus:(NSDictionary *)param{
 
}


#pragma mark V2TXLivePusherObserver
/**
 * 直播推流器错误通知，推流器出现错误时，会回调该通知
 **/

- (void)onError:(V2TXLiveCode)code message:(NSString *)msg extraInfo:(NSDictionary *)extraInfo{
    
}
/**
 * 直播推流器警告通知
 */
- (void)onWarning:(V2TXLiveCode)code message:(NSString *)msg extraInfo:(NSDictionary *)extraInfo{
    
}

/**
 * 推流器连接状态回调通知
 */
- (void)onPushStatusUpdate:(V2TXLivePushStatus)status message:(NSString *)msg extraInfo:(NSDictionary *)extraInfo{
    switch (status) {
        case V2TXLivePushStatusDisconnected:// 与服务器断开连接
            {
                [self jpl_hideHUD];
                [self.livePush stopPush];
                
                JPLLiveAlertView * alert = [[JPLLiveAlertView alloc] initWithType:JPLLiveAlertTypeAsk title:@"网络断连,推流失败"];
                alert.message = @"是否重新推流";
                __weak typeof(alert) weakalert = alert;
                alert.comfirmBlock = ^{
                    [weakalert hide];
                    [JPLService monitorNetworking:^(AFNetworkReachabilityStatus status) {
                        if (status <= 0) {
                            [MBProgressHUD jpl_showMessage:@"网络断连，请稍后重试"];
                        }else{
                            [self.livePush startPush:self.liveURL];
                        }
                    }];
                };
                alert.cancelBlock = ^{
                    
                };
                [alert show];
            }
            break;
        case V2TXLivePushStatusConnecting:// 正在连接服务器
            break;
        case V2TXLivePushStatusConnectSuccess:// 连接服务器成功
            [self jpl_hideHUD];
            break;
        case V2TXLivePushStatusReconnecting:// 重连服务器中
            [self jpl_showHUD];
            break;
    }
}


- (void)showAVAuthorizationAlertWithTittle:(NSString *)tittle {
    
    self.avAuthorizationAlertView = [[JPLAlertView alloc] initWithTitle:tittle
                                                         andFrame:CGRectMake(0, JPL_NAVIGATION_HEIGHT, JPL_SCR_WIDTH, JPL_SCR_HEIGHT)];
    [self.view addSubview:self.avAuthorizationAlertView];
    self.avAuthorizationAlertView.sd_layout.topSpaceToView(self.view, 44).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(JPL_SCR_HEIGHT);
}

- (void)hiddenAVAuthorizationAlert {
    [self.avAuthorizationAlertView removeFromSuperviewAndClearAutoLayoutSettings];
    self.avAuthorizationAlertView = nil;
}


///合成水印和商品图片
- (UIImage *)compositionFirstImage:(UIImage *)firstImage firstFrame:(CGRect)firstFrame secondImage:(UIImage *)secondImage secondFrame:(CGRect)secondFrame andSuperSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [firstImage drawInRect:firstFrame];
    [secondImage drawInRect:secondFrame];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


#pragma mark - set

#pragma mark - get
- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backIV.image = JPLImageWithName(@"live_bg_l");
        _backIV.contentMode = UIViewContentModeScaleAspectFill;
        _backIV.userInteractionEnabled = YES;
    }
    return  _backIV;
}

- (UIImageView *)watermarkIV{
    if (!_watermarkIV) {
        _watermarkIV = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _watermarkIV.userInteractionEnabled = YES;
    }
    return  _watermarkIV;
}

- (JPLInitLiveView *)beginView{
    if (!_beginView) {
        _beginView = [[JPLInitLiveView alloc]init];
    }
    return _beginView;
}

- (JPLLivePushView *)pushView{
    if (!_pushView) {
        _pushView = [[JPLLivePushView alloc]init];
    }
    return _pushView;
}

- (JPLLiveMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[JPLLiveMenuView alloc]init];
    }
    return _menuView;
}


- (JPLLiveBeautyView *)beautyView{
    if (!_beautyView) {
        _beautyView = [[JPLLiveBeautyView alloc]init];
    }
    return _beautyView;
}

- (JPLLiveFilterView *)filterView{
    if (!_filterView ){
        _filterView = [[JPLLiveFilterView alloc]init];
    }
    return _filterView;
}


- (V2TXLivePusher *)livePush{
    if (!_livePush) {
        _livePush = [[V2TXLivePusher alloc] initWithLiveMode:V2TXLiveMode_RTMP];
        [_livePush setObserver:self];
        [_livePush setVideoQuality:self.videoParam];
        [_livePush setAudioQuality:V2TXLiveAudioQualityMusic];
    }
    return _livePush;
}

- (V2TXLiveVideoEncoderParam *)videoParam{
    if (!_videoParam) {
        _videoParam = [[V2TXLiveVideoEncoderParam alloc]initWith:V2TXLiveVideoResolution1920x1080];
        _videoParam.videoResolutionMode = V2TXLiveVideoResolutionModeLandscape;
        _videoParam.videoFps = 25;
        _videoParam.videoBitrate = 3000;
    }
    return _videoParam;
}



- (TXDeviceManager *)deviceManager{
    if (!_deviceManager) {
        _deviceManager = [self.livePush getDeviceManager];
        [_deviceManager switchCamera:!_deviceManager.isFrontCamera];
        [_deviceManager enableCameraAutoFocus:YES];
    }
    return _deviceManager;
}

- (TXBeautyManager *)beautyManager{
    if (!_beautyManager) {
        _beautyManager = [self.livePush getBeautyManager];
        [_beautyManager setBeautyStyle:TXBeautyStyleNature];
        [_beautyManager enableSharpnessEnhancement:YES];
        [_beautyManager setFilterStrength:1];
    }
    return _beautyManager;
}


- (UIView *)menuBackView{
    if (!_menuBackView) {
        _menuBackView = [[UIView alloc]initWithFrame:CGRectMake(JPL_SCR_WIDTH - 87, 0 , 87, JPL_SCR_HEIGHT)];
        _menuBackView.backgroundColor = UIColor.clearColor;
    }
    return _menuBackView;
}

@end
