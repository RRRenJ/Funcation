//
//  JPFUtil.h
//  JPFuncationSDK
//
//  Created by 任敬 on 2021/11/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define JPFResourceBundle [JPFUtil bundleWithName:@"JPFResource"]

#define JPFResourceBundlePath JPFResourceBundle.bundlePath

#define JPFImageWithName(file)                 [JPFUtil imageNamed:file withBundle:JPFResourceBundle]

NS_ASSUME_NONNULL_BEGIN

@interface JPFUtil : NSObject

+ (NSBundle *)bundleWithName:(NSString *)name;

+ (UIImage *)imageNamed:(NSString *)name withBundle:(NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
