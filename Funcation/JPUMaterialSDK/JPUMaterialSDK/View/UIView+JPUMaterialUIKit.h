//
//  UIView+JPUMaterialUIKit.h
//  EducationalViedel
//
//  Created by 陈飞宇 on 2019/1/31.
//  Copyright © 2019 陈飞宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CFYUIKit)
/**
 加载XIB文件
 */
+ (instancetype)jpu_viewWithNib;
/**
 显示阴影，默认为NO
 */
@property (nonatomic, assign) IBInspectable BOOL jpu_showShadow;

/**
 阴影颜色
 */
@property (nonatomic, copy) IBInspectable UIColor * jpu_shadowColor;

/**
 添加圆角
 */
@property (nonatomic, assign) IBInspectable CGFloat jpu_radius;

/**
 设置边框线宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat jpu_borderWidth;

/**
 设置边框线颜色
 */
@property (nonatomic, copy) IBInspectable UIColor * jpu_borderColor;

/**
 旋转角度
 */
@property (nonatomic, assign) IBInspectable CGFloat jpu_rotationAngle;




@end

NS_ASSUME_NONNULL_END
