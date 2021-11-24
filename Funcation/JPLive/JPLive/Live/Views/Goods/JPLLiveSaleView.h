//
//  JPLLiveSaleView.h
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLLiveGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveSaleView : UIView

@property (nonatomic, copy) NSString *  live_id;

@property (nonatomic, copy) void(^selectBlock)(JPLLiveGoodsModel * _Nullable model);

@property (nonatomic, copy) void(^saleGoodsBlock)(NSMutableArray<JPLLiveGoodsModel*> * saleArray);


- (void)updateLayoutWithOrientation:(BOOL)isPortrait;

- (void)refreshRequestData;



@end

NS_ASSUME_NONNULL_END
