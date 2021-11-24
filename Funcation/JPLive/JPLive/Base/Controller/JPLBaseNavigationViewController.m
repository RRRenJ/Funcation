//
//  JPLBaseNavigationViewController.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/26.
//

#import "JPLBaseNavigationViewController.h"

@interface JPLBaseNavigationViewController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation JPLBaseNavigationViewController


+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.tintColor = [UIColor jpl_colorWithHexString:@"#353535"];
    navBar.barTintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{
        NSForegroundColorAttributeName : [UIColor jpl_colorWithHexString:@"#333333"],
        NSFontAttributeName : [UIFont jpl_pingFangWithSize:17 weight:UIFontWeightMedium]};
    //设置透明的背景图，便于识别底部线条有没有被隐藏
    [navBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    //此处使底部线条失效
    [navBar setShadowImage:[UIImage new]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationControllerdidRotate:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [self setupViews];
    
}

- (void)navigationControllerdidRotate:(NSNotification *)noti {
    
    if (self.navigationBarHidden) {
        return;
    }
    UIInterfaceOrientation stateBarcurrentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (stateBarcurrentOrientation != UIInterfaceOrientationLandscapeLeft && stateBarcurrentOrientation != UIInterfaceOrientationLandscapeRight) {
        //如果屏幕方向 变为竖屏了 重置下导航栏的frame
        CGRect windowFrame = UIScreen.mainScreen.bounds;
        self.navigationBar.frame = CGRectMake(0, 20, windowFrame.size.width, JPL_NAVIGATION_HEIGHT - 20);
    }
}


- (BOOL)shouldAutorotate {

    JPLBaseViewController * topVC = (JPLBaseViewController *)self.topViewController;
    
    return [topVC __shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    JPLBaseViewController * topVC = (JPLBaseViewController *)self.topViewController;
    UIInterfaceOrientationMask ori = [topVC __supportedInterfaceOrientations];
    
    return ori;
}


#pragma - mark init view
- (void)setupViews{
    //设置导航栏透明度
    self.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma - mark request


#pragma - mark set


#pragma - mark get

@end
