//
//  JPLBarrageModel.m
//  jper
//
//  Created by RRRenJ on 2020/5/28.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLBarrageModel.h"

@implementation JPLBarrageModel

- (CGFloat)cellWidth
{
    return [[NSString stringWithFormat:@"%@%@",self.name,self.message] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]}].width + 44;
}

@end
