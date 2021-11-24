//
//  JPLLiveAMModel.m
//  jper
//
//  Created by RRRenJ on 2020/6/8.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveAMModel.h"


@implementation JPLLiveAMModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.live_direction = @"竖屏";
        self.live_ratio = @"720p";
        self.live_record = NO;
        self.live_category = @"生活";
    }
    return self;
}

- (BOOL)isPortrait{
    return [self.live_direction isEqualToString:@"竖屏"];
}


- (CGFloat)liveListCellTitleOfHeight{
    CGSize size = [JPLUtil getStringSizeWith:[UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium] andContainerSize:CGSizeMake(JPL_SCR_WIDTH - 113, CGFLOAT_MAX) andString:self.live_name];
    return ceil(size.height);
}

- (CGFloat)liveListCellFailOfHeight{
    if (self.live_reason.length == 0) {
        return  0;
    }
    CGSize size = [JPLUtil getStringSizeWith:[UIFont jpl_pingFangWithSize:12] andContainerSize:CGSizeMake(JPL_SCR_WIDTH - 130, CGFLOAT_MAX) andString:[NSString stringWithFormat:@"失败原因：%@",self.live_reason]];
    return ceil(size.height);
}

- (CGFloat)liveListCellOfHeight{
    return (self.liveListCellFailOfHeight + self.liveListCellTitleOfHeight + 88);
}

@end
