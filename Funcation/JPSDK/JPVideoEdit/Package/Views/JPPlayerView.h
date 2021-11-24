//
//  JPPlayerView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/5/8.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPPlayerViewDelegate <NSObject>

- (void)willPlayVideo;

@end

typedef void(^JPPlayerGoBackBlock)(void);
// playerLayer的填充模式（默认：等比例填充，直到一个维度到达区域边界）
typedef NS_ENUM(NSInteger, JPPlayerLayerGravity) {
    JPPlayerLayerGravityResize,           // 非均匀模式。两个维度完全填充至整个视图区域
    JPPlayerLayerGravityResizeAspect,     // 等比例填充，直到一个维度到达区域边界
    JPPlayerLayerGravityResizeAspectFill  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
};

@interface JPPlayerView : UIView

@property (nonatomic, strong) NSURL                *videoURL;

@property (nonatomic, strong) NSArray              *videoURLArray;

@property (nonatomic, copy  ) JPPlayerGoBackBlock  goBackBlock;

@property (nonatomic, assign) JPPlayerLayerGravity playerLayerGravity;

@property (nonatomic, strong) NSDictionary         *resolutionDic;

@property (nonatomic, assign) NSInteger            seekTime;

@property (nonatomic, assign) BOOL isPlay;

@property (nonatomic, assign) BOOL                 isFullScreen;

@property (nonatomic, weak) id<JPPlayerViewDelegate>delegate;

- (void)autoPlayTheVideo;

- (void)cancelAutoFadeOutControlBar;

- (void)resetPlayer;

- (void)resetToPlayNewURL;

- (void)play;

- (void)pause;

- (void)pauseAction;

@end
