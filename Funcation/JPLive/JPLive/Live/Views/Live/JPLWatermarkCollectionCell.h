//
//  JPLWatermarkCollectionCell.h
//  jper
//
//  Created by RRRenJ on 2020/6/8.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLWatermarkCollectionCell : UICollectionViewCell

@property (nonatomic, copy) NSString *  imageURL;

@property (nonatomic, copy) NSString *  content;

@property (nonatomic, assign) BOOL  isSelect;

@property (nonatomic, copy) void(^selectBlock)() ;

@end

NS_ASSUME_NONNULL_END
