//
//  ViewController.m
//  JPFuncationSDK
//
//  Created by 任敬 on 2021/11/3.
//

#import "ViewController.h"
#import "JPFPopView.h"

#import <JPVideoEdit/JPVideoEdit.h>
#import <JPLManager.h>
#import <JPUMaterialSingleton.h>

#import <JPLLiveSettingModel.h>
#import <MBProgressHUD+JPL.h>
#import <JPLService.h>
#import <NSString+JPL.h>

#define TXLIVE_LICENCE @"http://license.vod2.myqcloud.com/license/v1/1081093d32a86fbec041a2cd78810c34/TXLiveSDK.licence"
#define TXLIVE_KEY @"70bf5ec0dcb77386eb3e7ca27ecf159a"

@interface ViewController ()

@property (nonatomic, strong) UIButton * funcationBt;

@property (nonatomic, strong) UIButton * uploadBt;

@property (nonatomic, strong) UIButton * videoEditBt;

@property (nonatomic, strong) UIButton * liveBt;

@property (nonatomic, strong) UIButton * settingBt;

@property (nonatomic, strong) UIButton * loginBt;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.orangeColor;
    
    [self.view addSubview:self.funcationBt];
//    [self.view addSubview:self.uploadBt];
//    [self.view addSubview:self.videoEditBt];
//    [self.view addSubview:self.liveBt];
//    [self.view addSubview:self.settingBt];
//    [self.view addSubview:self.loginBt];
    
    self.funcationBt.frame = CGRectMake(100, 100, 100, 30);
//    self.uploadBt.frame = CGRectMake(100, 200, 100, 30);
//    self.videoEditBt.frame = CGRectMake(100, 300, 100, 30);
//    self.liveBt.frame = CGRectMake(100, 400, 100, 30);
//    self.settingBt.frame = CGRectMake(100, 450, 100, 30);
//    self.loginBt.frame = CGRectMake(100, 500, 100, 60);
    
    
    [JPManager loadConfige];
    
    [JPLManager setLicenceURL:TXLIVE_LICENCE key:TXLIVE_KEY];
    [JPLManager setUserToken:@"" bundleID:@"com.paike.futurezhisheng"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loginBtClicked];
    });
    
    
}

- (void)funcationBtBlock{
    JPFPopView * view = [[JPFPopView alloc]init];
    [view show:self];
}

- (void)uploadBtClicked{
//    [[JPUMaterialSingleton singleton] jpu_material_selectFootageBacktransmsView];
    [[JPUMaterialSingleton singleton] jpu_material_selectFootageBacktransmsViewUid:@"91578989" verifycode:@"token-a554bac0-fbb2-420f-98c7-68f38c9e9bb4-90AD42A51621A5EEB3F027AD1C5F0B7D-58799446-35eb-45dd-87e1-a3b1c9a1d3d5" cityCode:@"110100" source:@"ysyy" phone:@"18111177127" third_id:@"8208aea025f04c9081771461c448d375"];
}

- (void)videoEditBtClicked{
    [JPManager showVideoEditAlert:self hide:^{
        
    }];
}

- (void)liveBtClicked{
    [JPLManager showAlert:self hide:^{
        
    }];
}

- (void)settingBtClicked{
    self.settingBt.selected = !self.settingBt.selected;
    [JPLLiveSettingModel shareInstance].isPortrait = !self.settingBt.selected;
}

- (void)loginBtClicked{
    [MBProgressHUD jpl_showProgressMessage:@"正在获取直播身份"];
    NSMutableDictionary *dic = @{@"service":@"App.Login.In",
                                 @"user_account":@"17761312657",
                                 @"user_passwd":[@"Aa123456" jpl_aci_encryptWithAES],
                                 @"user_from":@(3),
                                 @"user_from_platform":@"app",
                                 @"device_token":@"grtrgtrgrgrgrgtrgrg",
                                 @"device_type":@1,
                                 @"app_version":@"3.0.0"
                                }.mutableCopy;
    [JPLService requestWithURLString:API_HOST parameters:dic type:JPLHttpRequestTypePost success:^(JPLResultBase * _Nonnull response) {
        [MBProgressHUD jpl_hideHUD];
        NSString * token = ((NSDictionary *)response.data)[@"token"];
        [JPLManager setUserToken:token bundleID:@"com.paike.futurezhisheng"];
        [MBProgressHUD jpl_showMessage:@"获取成功"];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD jpl_hideHUD];
    } withErrorMsg:@"登录失败"];
}

- (UIButton *)funcationBt{
    if (!_funcationBt) {
        _funcationBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_funcationBt setTitle:@"功能集合" forState:UIControlStateNormal];
        [_funcationBt setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _funcationBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [_funcationBt addTarget:self action:@selector(funcationBtBlock) forControlEvents:UIControlEventTouchUpInside];
    }
    return _funcationBt;
}

- (UIButton *)uploadBt{
    if (!_uploadBt) {
        _uploadBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uploadBt setTitle:@"上传" forState:UIControlStateNormal];
        [_uploadBt setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _uploadBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [_uploadBt addTarget:self action:@selector(uploadBtClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBt;
}

- (UIButton *)videoEditBt{
    if (!_videoEditBt) {
        _videoEditBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoEditBt setTitle:@"视频编辑" forState:UIControlStateNormal];
        [_videoEditBt setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _videoEditBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [_videoEditBt addTarget:self action:@selector(videoEditBtClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoEditBt;
}

- (UIButton *)liveBt{
    if (!_liveBt) {
        _liveBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_liveBt setTitle:@"直播" forState:UIControlStateNormal];
        [_liveBt setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _liveBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [_liveBt addTarget:self action:@selector(liveBtClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveBt;
}

- (UIButton *)settingBt{
    if (!_settingBt) {
        _settingBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBt setTitle:@"竖屏" forState:UIControlStateNormal];
        [_settingBt setTitle:@"横屏" forState:UIControlStateSelected];
        [_settingBt setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _settingBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [_settingBt addTarget:self action:@selector(settingBtClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBt;
}

//- (UIButton *)loginBt{
//    if (!_loginBt) {
//        _loginBt = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_loginBt setTitle:@"直播先点击此\n按钮获取身份" forState:UIControlStateNormal];
//        _loginBt.titleLabel.numberOfLines =2;
//        [_loginBt setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
//        _loginBt.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_loginBt addTarget:self action:@selector(loginBtClicked) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _loginBt;
//}

@end
