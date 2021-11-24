//
//  UIButton+JPL.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JPLButtonEdgeInsetsStyle) {
    JPLButtonEdgeInsetsStyleTop, // image在上，label在下
    JPLButtonEdgeInsetsStyleLeft, // image在左，label在右
    JPLButtonEdgeInsetsStyleBottom, // image在下，label在上
    JPLButtonEdgeInsetsStyleRight // image在右，label在左
};


@interface UIButton (JPL)

- (void)jpl_layoutButtonWithEdgeInsetsStyle:(JPLButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
