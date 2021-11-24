//
//  UIColor+JPL.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JPL)

+ (UIColor *)jpl_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)jpl_colorWithHexString:(NSString *)color;

+ (CAGradientLayer *)jpl_gradientWith:(CGRect)frame fromeColor:(UIColor *)fromeColor toColor:(UIColor *)toColor  fromePoint:(CGPoint)fromePoint toPoint:(CGPoint)toPoint;

@end

NS_ASSUME_NONNULL_END
