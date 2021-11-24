//
//  JPLBarrageModel.h
//  jper
//
//  Created by RRRenJ on 2020/5/28.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BarrageModelAble.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPLBarrageModel : NSObject<BarrageModelAble>

@property (nonatomic, assign) PriorityLevel level;

@property (nonatomic, copy) NSString *  name;

@property (nonatomic, copy) NSString *  message;

@end

NS_ASSUME_NONNULL_END
