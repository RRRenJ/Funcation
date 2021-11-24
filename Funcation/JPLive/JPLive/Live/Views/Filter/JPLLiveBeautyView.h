//
//  JPLLiveBeautyView.h
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveBeautyView : UIView

@property (nonatomic, assign) float beautyValue;

@property (nonatomic, assign) float whitenessValue;

@property (nonatomic, assign) float ruddyValue;

@property (nonatomic, copy) void(^beautyBlock)(float value);

@property (nonatomic, copy) void(^whitenessBlock)(float value);

@property (nonatomic, copy) void(^ruddyBlock)(float value);

@property (nonatomic, copy) void(^tapHideBlock)();



- (void)updateLayoutWithOrientation:(BOOL)isPortrait;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
