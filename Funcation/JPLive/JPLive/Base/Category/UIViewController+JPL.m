//
//  UIViewController+JPL.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import "UIViewController+JPL.h"
#import <objc/runtime.h>
#import "MBProgressHUD+JPL.h"

static char const * const JPUIViewControllerHUDKey = "JPLUIViewControllerHUDKey";
static char const * const jpl_cancelGesturesReturnKey = "jplsupportGesturesReturnKey";
static char const * const jpl_cancelReturnButtonKey = "jplcancelReturnButtonKey";


@interface UIViewController ()

@property (nonatomic, strong) MBProgressHUD * hudView;

@end

@implementation UIViewController (JPL)


- (BOOL)jpl_cancelGesturesReturn{
    return [objc_getAssociatedObject(self, jpl_cancelGesturesReturnKey) boolValue];
}

- (void)setJpl_cancelGesturesReturn:(BOOL)jpl_cancelGesturesReturn{
    objc_setAssociatedObject(self, jpl_cancelGesturesReturnKey,@(jpl_cancelGesturesReturn), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)jpl_cancelReturnButton{
    return [objc_getAssociatedObject(self, jpl_cancelReturnButtonKey) boolValue];
}

- (void)setJpl_cancelReturnButton:(BOOL)jpl_cancelReturnButton{
    objc_setAssociatedObject(self, jpl_cancelReturnButtonKey,@(jpl_cancelReturnButton), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationController*)jpl_myNavigationController{
    UINavigationController* nav = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (id)self;
    }
    else {
        if ([self isKindOfClass:[UITabBarController class]]) {
            nav = ((UITabBarController*)self).selectedViewController.jpl_myNavigationController;
        }
        else {
            nav = self.navigationController;
        }
    }
    return nav;
}



- (MBProgressHUD *)hudView{
    return objc_getAssociatedObject(self, JPUIViewControllerHUDKey);
}

- (void)setHudView:(MBProgressHUD *)hudView{
    objc_setAssociatedObject(self, JPUIViewControllerHUDKey, hudView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)jpl_showHUD{

    if (!self.hudView) {
        self.hudView = [MBProgressHUD jpl_showProgressMessage:nil];
    }
    
}

- (void)jpl_hideHUD{
    if (self.hudView) {
        [self.hudView jpl_hideHUD];
    }
}

@end
