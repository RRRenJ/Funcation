//
//  JPLInitLiveView.h
//  jper
//
//  Created by RRRenJ on 2020/5/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLInitLiveView : UIView

@property (nonatomic, copy) NSString * liveTitle;

@property (nonatomic, copy) BOOL(^tfWillEditBlock)(void);

@property (nonatomic, copy) void(^tfEndEditBlock)(NSString * title);

@property (nonatomic, copy) void(^liveStartBlock)(NSString * title);

@property (nonatomic, copy) void(^liveBackBlock)(void);

@property (nonatomic, copy) void(^liveSettingBlock)(void);


- (void)updateLayoutWithOrientation:(BOOL)isPortrait;


@end

NS_ASSUME_NONNULL_END
