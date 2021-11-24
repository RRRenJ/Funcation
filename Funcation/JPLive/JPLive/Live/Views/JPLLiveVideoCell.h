//
//  JPLLiveVideoCell.h
//  jper
//
//  Created by RRRenJ on 2020/6/4.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLLiveAMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveVideoCell : UITableViewCell

@property (nonatomic, strong) JPLLiveAMModel *  model;

@property (nonatomic, assign) BOOL isLast;

@property (nonatomic, copy) void(^functionBlock)();

@end

NS_ASSUME_NONNULL_END
