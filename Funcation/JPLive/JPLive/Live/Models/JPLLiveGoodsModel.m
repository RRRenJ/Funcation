//
//  JPLLiveGoodsModel.m
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveGoodsModel.h"

@implementation JPLLiveGoodsModel

- (CGSize)cellSize{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
    CGSize size=[self.goods_name sizeWithAttributes:attrs];
    CGFloat width = size.width + 28 + 10;
    if (width > JPL_SCR_WIDTH - 30) {
        width = JPL_SCR_WIDTH - 30;
    }
    return CGSizeMake(width, 40);
}

@end
