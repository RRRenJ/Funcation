//
//  JPLManager.h
//  JPLSDK
//
//  Created by 任敬 on 2021/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLManager : NSObject

/// 设置腾讯移动直播
/// @param licence 腾讯licence
/// @param key 腾讯key
+ (void)setLicenceURL:(NSString *)licence key:(NSString *)key;

/// 设置用户身份token
/// @param token 身份
+ (void)setUserToken:(NSString *)token bundleID:(NSString *)bundleID;


/// 展示直播alert
+ (void)showAlert:(UIViewController *)vc hide:(void(^)(void))hideBlock;

@end

NS_ASSUME_NONNULL_END
