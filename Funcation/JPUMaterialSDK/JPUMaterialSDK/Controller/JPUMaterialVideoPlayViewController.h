//
//  JPUMaterialVideoPlayViewController.h
//  EditVideoText
//
//  Created by foundao on 2021/9/16.
//

#import <UIKit/UIKit.h>
#import "JPUMaterialEditAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialVideoPlayViewController : UIViewController

@property (nonatomic, assign) BOOL isPlay;//是否只是播放
@property (nonatomic, copy) void(^selectVideoBlock)(void);
@property (nonatomic, strong) JPUMaterialEditAssetModel *model;


@end

NS_ASSUME_NONNULL_END
