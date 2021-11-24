//
//  JPLBarrageCell.h
//  jper
//
//  Created by RRRenJ on 2020/5/28.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "BarrageViewCell.h"
#import "BarrageView.h"
#import "JPLBarrageModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JPLBarrageCell : BarrageViewCell

@property (nonatomic, strong) JPLBarrageModel * model;

+ (instancetype)cellWithBarrageView:(BarrageView *)barrageView;

@end

NS_ASSUME_NONNULL_END
