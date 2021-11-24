//
//  JPLLiveListCell.h
//  JPLSDK
//
//  Created by 任敬 on 2021/11/1.
//

#import <UIKit/UIKit.h>
#import "JPLLiveAMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveListCell : UITableViewCell

@property (nonatomic, strong) JPLLiveAMModel * model;

@property (nonatomic, copy) void(^enterLiveBlock)(void);
//修改或者重新预约
@property (nonatomic, copy) void(^modifyLiveBlock)(void);



@end

NS_ASSUME_NONNULL_END
