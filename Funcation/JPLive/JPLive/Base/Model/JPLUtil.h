//
//  JPLUtil.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define JPLResourceBundle [JPLUtil bundleWithName:@"JPLResource"]

#define JPLResourceBundlePath JPLResourceBundle.bundlePath

#define JPLImageWithName(file)                 [JPLUtil imageNamed:file withBundle:JPLResourceBundle]

NS_ASSUME_NONNULL_BEGIN

@interface JPLUtil : NSObject

+ (NSBundle *)bundleWithName:(NSString *)name;

+ (UIImage *)imageNamed:(NSString *)name withBundle:(NSBundle *)bundle;

+ (UIViewController *)currentViewController;

+ (void)showVideoAuthorizationAlertWithCompletionHandler:(void (^)(BOOL granted))completionHandler;
+ (void)showAudioAuthorizationAlertWithCompletionHandler:(void (^)(BOOL granted))completionHandler;

+ (CGSize)getStringSizeWith:(UIFont *)font andContainerSize:(CGSize)size andString:(NSString *)str;

+ (NSString *)signStringWithDictionary:(NSDictionary *)dic;

+ (NSString *)getTotalMemorySize;
+ (NSString *)getAvailableMemorySize;
+ (NSInteger)getTotalDiskSize;
+ (NSInteger)getAvailableDiskSize;

@end

NS_ASSUME_NONNULL_END
