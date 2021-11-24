//
//  JPLLivePushView.h
//  jper
//
//  Created by RRRenJ on 2020/5/28.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarrageModelAble.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPLLivePushView : UIView

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * liveID;

@property (nonatomic, copy) NSString *  person;

@property (nonatomic, copy) NSString *  city;

@property (nonatomic, assign, readonly) int seconds;

@property (nonatomic, copy, readonly) NSString *  time;

@property (nonatomic, copy) void(^endBlock)(void);

- (void)updateLayoutWithOrientation:(BOOL)isPortrait;

- (void)insertBarrages:(NSArray<id<BarrageModelAble>> *)barrages immediatelyShow:(BOOL)flag;

- (void)startTimer;

- (void)endTimer;



@end

NS_ASSUME_NONNULL_END
