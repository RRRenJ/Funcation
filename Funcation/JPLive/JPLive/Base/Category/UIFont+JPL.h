//
//  UIFont+JPL.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (JPL)


+ (UIFont *)jpl_pingFangWithSize:(CGFloat)size;

+ (UIFont *)jpl_pingFangWithSize:(CGFloat)size weight:(UIFontWeight)weight;

@end

NS_ASSUME_NONNULL_END
