//
//  JPUMaterialProgressHUD.h
//  EditVideoText
//
//  Created by foundao on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialProgressHUD : NSObject
+(instancetype)sharedHUD;

/**
 转圈 wait...
 */
- (void)show;

- (void)showProgress:(NSString *)str;

/**
 消失
 */
- (void)hide;

/**
 提示
 */
- (void)showHint:(NSString *)hintStr;

@end

NS_ASSUME_NONNULL_END
