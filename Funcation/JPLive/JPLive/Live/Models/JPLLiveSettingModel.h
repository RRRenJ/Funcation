//
//  JPLLiveSettingModel.h
//  jper
//
//  Created by RRRenj on 2021/6/24.
//  Copyright © 2021 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPLLiveWatermarkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveSettingModel : NSObject

@property (nonatomic, assign) BOOL  isBackCamera;

@property (nonatomic, assign) BOOL  isPortrait;

@property (nonatomic, assign) BOOL  allow;

@property (nonatomic, strong) JPLLiveWatermarkModel * watermarkModel;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
