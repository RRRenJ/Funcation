//
//  MBProgressHUD+JPL.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import <MBProgressHUD/MBProgressHUD.h>


@interface MBProgressHUD (JPL)

+ (void)jpl_showMessage:(NSString *)message;

+ (void)jpl_showMessage:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)jpl_showProgressMessage:(NSString *)message;

+ (MBProgressHUD *)jpl_showProgressMessage:(NSString *)message toView:(UIView *)view;

+ (void)jpl_hideHUD;

- (void)jpl_hideHUD;


@end


