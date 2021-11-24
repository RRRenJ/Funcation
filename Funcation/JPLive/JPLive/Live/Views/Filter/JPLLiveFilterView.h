//
//  JPLLiveFilterView.h
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JPLLiveFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveFilterView : UIView

@property (nonatomic, copy) void(^filterBlock)(JPLLiveFilterModel * model);

@property (nonatomic, copy) void(^tapHideBlock)();

- (void)updateLayoutWithOrientation:(BOOL)isPortrait;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
