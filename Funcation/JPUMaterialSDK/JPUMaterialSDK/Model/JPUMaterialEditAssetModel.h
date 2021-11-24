//
//  JPUMaterialEditAssetModel.h
//  EditVideoText
//
//  Created by foundao on 2021/9/22.
//

#import <Foundation/Foundation.h>
#import "QMUIKit.h"
#import "JPUMaterialProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialEditAssetModel : NSObject

@property (nonatomic, strong) QMUIAsset *asset;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UIImage *photoImg;
@property (nonatomic, assign) QMUIAlbumContentType contentType;
@property (nonatomic, assign) NSInteger selectindex;
@property (nonatomic, assign) BOOL isDownload;



//编辑页面所需要的参数
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) UIImage  *videoImage;
@property (nonatomic, strong) NSString *videoTime;
@property (nonatomic, assign) NSInteger filesize;
@property (nonatomic, assign) NSString * seconds;//秒数


//是否拍摄视频
@property (nonatomic, assign) BOOL  isTakeVideo;



@end

NS_ASSUME_NONNULL_END
