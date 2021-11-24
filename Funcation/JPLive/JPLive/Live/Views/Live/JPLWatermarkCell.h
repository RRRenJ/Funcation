//
//  JPLWatermarkCell.h
//  jper
//
//  Created by RRRenJ on 2020/5/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLLiveWatermarkModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JPLWatermarkCell : UITableViewCell

@property (nonatomic, strong) JPLLiveWatermarkModel * selectModel;

@property (nonatomic, strong) NSArray <JPLLiveWatermarkModel *>* dataArray;

@property (nonatomic, copy) void(^selectBlock)(JPLLiveWatermarkModel * model) ;

@end

NS_ASSUME_NONNULL_END
