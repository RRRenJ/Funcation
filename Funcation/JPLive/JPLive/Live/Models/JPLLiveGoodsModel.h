//
//  JPLLiveGoodsModel.h
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveGoodsModel : NSObject

@property (nonatomic, copy) NSString *  goods_id;

@property (nonatomic, copy) NSString *  goods_name;

@property (nonatomic, copy) NSString *  goods_icon;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) CGSize cellSize;

@end

NS_ASSUME_NONNULL_END
