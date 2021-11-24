//
//  JPDraftCell.h
//  JPSDK
//
//  Created by 任敬 on 2021/10/25.
//

#import <UIKit/UIKit.h>
#import "JPVideoRecordInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPDraftCell : UICollectionViewCell

@property (nonatomic, strong) JPVideoRecordInfo * videoInfo;

@property (nonatomic, copy) void(^editBlock)(JPVideoRecordInfo * videoInfo);

@property (nonatomic, copy) void(^deleteBlock)(JPVideoRecordInfo * videoInfo);

@end

NS_ASSUME_NONNULL_END
