//
//  JPUMaterialPlayCustomView.h
//  EditVideoText
//
//  Created by foundao on 2021/9/16.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayerMediaControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialPlayCustomView : UIView <ZFPlayerMediaControl>

/// 控制层自动隐藏的时间，默认2.5秒
@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;

/// 控制层显示、隐藏动画的时长，默认0.25秒
@property (nonatomic, assign) NSTimeInterval autoFadeTimeInterval;

@end

NS_ASSUME_NONNULL_END
