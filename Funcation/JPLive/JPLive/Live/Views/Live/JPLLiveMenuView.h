//
//  JPLLiveMenuView.h
//  jper
//
//  Created by RRRenJ on 2020/5/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,JPLLiveMenuType) {
    JPLLiveMenuTypeGoods,
    JPLLiveMenuTypeBeauty,
    JPLLiveMenuTypeFilter,
    JPLLiveMenuTypeSoundOff,
    JPLLiveMenuTypeCamera,
    JPLLiveMenuTypeLight,
    
};


@interface JPLLiveMenuView : UIView

@property (nonatomic, copy) BOOL(^menuClicedBlock)(JPLLiveMenuType type, BOOL isSelected);

- (void)select:(JPLLiveMenuType)type;

- (void)cancelSelect:(JPLLiveMenuType)type;

- (void)toggleMenuBt:(JPLLiveMenuType)type;

- (void)updateLayoutWithOrientation:(BOOL)isPortrait;


@end

NS_ASSUME_NONNULL_END
