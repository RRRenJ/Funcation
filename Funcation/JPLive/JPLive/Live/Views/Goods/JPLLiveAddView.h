//
//  JPLLiveAddView.h
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLLiveGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveAddView : UIView

@property (nonatomic, copy) NSString *  live_id;

@property (nonatomic, strong) NSMutableArray <JPLLiveGoodsModel *>* selectArray;

@property (nonatomic, strong) JPLLiveGoodsModel * saleModel;

@property (nonatomic, copy) void(^beginEditBlock)();

@property (nonatomic, copy) void(^endEditBlock)();

- (void)updateLayoutWithOrientation:(BOOL)isPortrait;

- (void)refreshRequestData;

- (void)endSearchEdit;



@end

NS_ASSUME_NONNULL_END
