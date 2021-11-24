//
//  JPLBaseViewController.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JPLLocationBlock) (NSString * city);


@interface JPLBaseViewController : UIViewController

@property (nonatomic, assign) BOOL hasRegistAppStatusNotifacation;
//是否隐藏导航栏
@property (nonatomic, assign) BOOL isHiddenNavgationBar;

@property (nonatomic, assign) BOOL  navigationBarTranslucent;

@property (nonatomic, strong) UINavigationController *strongNavController;

@property (nonatomic, strong) UINavigationController *tabNavigationController;

//导航栏左侧按钮 通常为返回按钮
@property (nonatomic, strong) UIBarButtonItem *customLeftBarButtonItem;

//没有导航栏情况下，自己添加的返回按钮
@property (nonatomic, strong) UIButton *customBackButton;

@property (nonatomic, copy) JPLLocationBlock locationBlock;

//返回上一级
- (void)popToLastVC;

//添加一个返回按钮到self.view 一般用于隐藏了系统导航栏 需要一个返回按钮
- (void)addCustomBackButtonIsWhite:(BOOL)isWhite;

//重制导航栏
- (void)resetNavgationBar;

- (void)appBecomeBackground;

- (void)appBecomeActive;

- (BOOL)__shouldAutorotate;

- (NSUInteger)__supportedInterfaceOrientations;

- (void)getCameraAndAudioAuthorized:(void (^)(BOOL successful))completion andTips:(BOOL)tips;

- (void)getPhotoLibrary:(void(^)(BOOL successful))completion;

- (void)getLocationCity;


@end

NS_ASSUME_NONNULL_END
