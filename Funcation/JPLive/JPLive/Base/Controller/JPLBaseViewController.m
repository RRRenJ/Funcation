//
//  JPLBaseViewController.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import "JPLBaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>


@interface JPLBaseViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;

@end

@implementation JPLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 11.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_hasRegistAppStatusNotifacation) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    if (self.navigationBarTranslucent) {
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    //控制显示还是隐藏导航栏
    [self.navigationController setNavigationBarHidden:self.isHiddenNavgationBar animated:animated];
    //设置自定义返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = self.customLeftBarButtonItem;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_hasRegistAppStatusNotifacation) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}


- (void)addCustomBackButtonIsWhite:(BOOL)isWhite {
    [self.view addSubview:self.customBackButton];
    if (isWhite) {
        //白色的返回按钮
        [self.customBackButton setImage:JPLImageWithName(@"4_more") forState:UIControlStateNormal];
    }
}

- (void)popToLastVC {
    if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.navigationController.childViewControllers.count == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)appBecomeActive {
    NSLog(@"进入前台");
}

- (void)appBecomeBackground {
    NSLog(@"进入后台");
}

- (void)resetNavgationBar {
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (BOOL)__shouldAutorotate{
    return NO;
}

- (NSUInteger)__supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UINavigationController *)navigationController
{
    if (_tabNavigationController != nil) {
        return _tabNavigationController;
    }else{
        return [super navigationController];
    }
}

- (UIBarButtonItem *)customLeftBarButtonItem {
    if (!_customLeftBarButtonItem) {
        _customLeftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:JPLImageWithName(@"1_more") style:UIBarButtonItemStylePlain target:self action:@selector(popToLastVC)];
    }
    return _customLeftBarButtonItem;
}

- (UIButton *)customBackButton {
    if (!_customBackButton) {
        _customBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_customBackButton setImage:JPLImageWithName(@"1_more") forState:UIControlStateNormal];
        
        _customBackButton.frame = CGRectMake(0, 20 + (JPL_IS_BANGSCREEN ? 20 : 0), 80, 40);
        _customBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 35);
        [_customBackButton addTarget:self action:@selector(popToLastVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customBackButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //[[SDImageCache sharedImageCache] clearMemory];
}

- (void)getCameraAndAudioAuthorized:(void (^)(BOOL successful))completion andTips:(BOOL)tips {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusAuthorized){
        AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if(auth == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(granted);
                });
                if (!granted && tips) {
                    [self alertTitle:@"权限提醒" andMessage:@"需要您开启麦克风权限进行直播" comfireTitle:@"设置" cancelTitle:@"取消" comfireCompltion:^{
                        [self updateAppAuthorized];
                    } cancelCompletion:nil];
                }
            }];
        } else if(AVAuthorizationStatusAuthorized != auth){
            if (tips) {
                [self alertTitle:@"权限提醒" andMessage:@"需要您开启麦克风权限进行直播" comfireTitle:@"设置" cancelTitle:@"取消" comfireCompltion:^{
                    [self updateAppAuthorized];
                } cancelCompletion:nil];
            }
        } else {
            completion(YES);
        }
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted && tips) {
                completion(NO);
                [self alertTitle:@"权限提醒" andMessage:@"需要您开启摄像头权限进行直播" comfireTitle:@"设置" cancelTitle:@"取消" comfireCompltion:^{
                    [self updateAppAuthorized];
                } cancelCompletion:nil];
            }else {
                NSLog(@"！！！特殊情况");
            }
        }];
    }else{
        completion(NO);
        if (tips) {
            [self alertTitle:@"权限提醒" andMessage:@"需要您开启摄像头权限进行直播" comfireTitle:@"设置" cancelTitle:@"取消" comfireCompltion:^{
                [self updateAppAuthorized];
            } cancelCompletion:nil];
        }
    }
}

- (void)getPhotoLibrary:(void(^)(BOOL successful))completion{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusNotDetermined) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(YES);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO);
            });
        }
    }];
}


- (void)getLocationCity{
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"系统定位尚未打开，请到【设定-隐私】中手动打开" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * tipsAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:tipsAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }else{
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100.f;
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
        
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusRestricted) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation * newLocation = [locations lastObject];
    if (newLocation.horizontalAccuracy < 0) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位错误，请检查手机网络以及定位" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * tipsAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:tipsAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placeMark in placemarks) {
            if (self.locationBlock) {
                self.locationBlock(placeMark.locality);
            }
        }
    }];
}


- (void)alertTitle:(NSString *)title andMessage:(NSString *)msg comfireTitle:(NSString *)comfireTitle cancelTitle:(NSString *)cancelTitle comfireCompltion:(void (^)(void))comfireAction cancelCompletion:(void (^)(void))cancelCompletion {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelCompletion) {
                cancelCompletion();
            }
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:comfireTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (comfireAction) {
                comfireAction();
            }
        }];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)updateAppAuthorized {
    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
       [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:^(BOOL success) {
           
       }];
}

@end
