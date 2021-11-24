//
//  UIViewController+JPL.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (JPL)

// navigation
@property (nonatomic, assign, readwrite) BOOL jpl_cancelGesturesReturn;
@property (nonatomic, assign, readwrite) BOOL jpl_cancelReturnButton;
@property(nonatomic,strong,readonly)UINavigationController * jpl_myNavigationController;

//hud
- (void)jpl_showHUD;
- (void)jpl_hideHUD;

@end

NS_ASSUME_NONNULL_END
