//
//  LewPopupViewAnimationSlide.h
//  LewPopupViewController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+LewPopupViewController.h"

typedef NS_ENUM(NSUInteger, LewPopupViewAnimationSlideType) {
    LewPopupViewAnimationSlideTypeBottomTop,
    LewPopupViewAnimationSlideTypeBottomBottom,
    LewPopupViewAnimationSlideTypeTopTop,
    LewPopupViewAnimationSlideTypeTopBottom,
    LewPopupViewAnimationSlideTypeLeftLeft,
    LewPopupViewAnimationSlideTypeLeftRight,
    LewPopupViewAnimationSlideTypeRightLeft,
    LewPopupViewAnimationSlideTypeRightRight,
};

@protocol LewPopupViewAnimationSlideDelegate <NSObject>

- (void)lewPopupViewWillDissmiss;

@end


@interface LewPopupViewAnimationSlide : NSObject<LewPopupAnimation>

@property (nonatomic,assign)LewPopupViewAnimationSlideType type;

@property (nonatomic, assign) CGFloat popViewPoint_y;

@property (nonatomic, copy) NSString * popViewPoint_x;

@property (nonatomic, retain)id<LewPopupViewAnimationSlideDelegate>delegate;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
