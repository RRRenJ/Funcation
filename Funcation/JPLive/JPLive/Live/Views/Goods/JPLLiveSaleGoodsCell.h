//
//  JPLLiveSaleGoodsCell.h
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLLiveGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveSaleGoodsCell : UICollectionViewCell

@property (nonatomic, strong) JPLLiveGoodsModel * model;

@property (nonatomic, copy) void(^selectBlock)(BOOL isSelect);

@end

NS_ASSUME_NONNULL_END
