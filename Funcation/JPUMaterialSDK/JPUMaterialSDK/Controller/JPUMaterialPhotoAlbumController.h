//
//  JPUMaterialPhotoAlbumController.h
//  EditVideoText
//
//  Created by foundao on 2021/9/14.
//

#import <UIKit/UIKit.h>
#import "JPUMaterialEditAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialPhotoAlbumController : UIViewController

@property (nonatomic, assign) QMUIAlbumContentType contentType;
@property (nonatomic, copy)void(^selectPhotoBlock)(NSMutableArray *imgArr);
@property (nonatomic, copy)void(^selectVideoBlock)(JPUMaterialEditAssetModel *model);
@property (nonatomic, assign) NSInteger maxNumber;
@property (nonatomic, assign) BOOL isEditSelectVideo;//是否是编辑页面选择视频

@end

NS_ASSUME_NONNULL_END
