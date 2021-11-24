//
//  UIView+JPUMaterialUIKit.m
//  EducationalViedel
//
//  Created by 陈飞宇 on 2019/1/31.
//  Copyright © 2019 陈飞宇. All rights reserved.
//

#import "UIView+JPUMaterialUIKit.h"
#import <objc/runtime.h>

@implementation UIView (CFYUIKit)

+ (instancetype)jpu_viewWithNib {
    UIView * view = [[UIView alloc] init];
    if ([NSStringFromClass([self class]) isEqualToString:@"UIView"]) {
        return view;
    }
    view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    return view;
}

- (void)setJpu_showShadow:(BOOL)jpu_showShadow {
    
    if (jpu_showShadow) {
        self.layer.shadowColor = self.jpu_shadowColor.CGColor;
        self.layer.shadowOpacity = 1.0f;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowRadius = 4;
    } else {
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowOpacity = 0.0f;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 0;
    }
    
    NSNumber * number = [NSNumber numberWithFloat:jpu_showShadow];
    objc_setAssociatedObject(self, @selector(jpu_showShadow), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJpu_shadowColor:(UIColor *)jpu_shadowColor {
    self.layer.shadowColor = jpu_shadowColor.CGColor;
    objc_setAssociatedObject(self, @selector(jpu_shadowColor), jpu_shadowColor, OBJC_ASSOCIATION_COPY);
}
- (UIColor *)jpu_shadowColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJpu_radius:(CGFloat)jpu_radius {
    self.layer.cornerRadius = jpu_radius;
    
    NSNumber * number = [NSNumber numberWithFloat:jpu_radius];
    objc_setAssociatedObject(self, @selector(jpu_radius), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)jpu_showShadow {
    NSNumber * number = objc_getAssociatedObject(self, _cmd);
    return [number boolValue];
}
- (CGFloat)jpu_radius {
    NSNumber * number = objc_getAssociatedObject(self, _cmd);
    return [number floatValue];
}

#pragma mark -- 设置边框线宽度和颜色
- (void)setJpu_borderWidth:(CGFloat)jpu_borderWidth {
    if (jpu_borderWidth > 0) {
        self.layer.borderWidth = jpu_borderWidth;
        self.layer.masksToBounds = YES;
    }
    NSNumber * number = [NSNumber numberWithFloat:jpu_borderWidth];
    objc_setAssociatedObject(self, @selector(jpu_borderWidth), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)jpu_borderWidth {
    NSNumber * number = objc_getAssociatedObject(self, _cmd);
    return [number floatValue];
}
- (void)setJpu_borderColor:(UIColor *)jpu_borderColor {
    self.layer.borderColor = jpu_borderColor.CGColor;
    objc_setAssociatedObject(self, @selector(jpu_borderColor), jpu_borderColor, OBJC_ASSOCIATION_COPY);
}
- (UIColor *)jpu_borderColor {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma 旋转角度
- (void)setJpu_rotationAngle:(CGFloat)jpu_rotationAngle
{
    self.transform = CGAffineTransformMakeRotation(M_PI * (jpu_rotationAngle/360) );
    NSNumber * number = [NSNumber numberWithFloat:jpu_rotationAngle];
    objc_setAssociatedObject(self, @selector(jpu_rotationAngle), number, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)jpu_rotationAngle {
    NSNumber * number = objc_getAssociatedObject(self, _cmd);
    return [number floatValue];
}


@end
