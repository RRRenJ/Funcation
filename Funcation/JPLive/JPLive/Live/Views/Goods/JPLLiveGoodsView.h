//
//  JPLLiveGoodsView.h
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLLiveGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveGoodsView : UIView

@property (nonatomic, copy) NSString *  live_id;

@property (nonatomic, assign, readonly) BOOL isShow;

@property (nonatomic, copy) void(^selectGoodsBlock)(JPLLiveGoodsModel * _Nonnull model);

@property (nonatomic, copy) void(^tapHideBlock)();


- (void)updateLayoutWithOrientation:(BOOL)isPortrait;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
