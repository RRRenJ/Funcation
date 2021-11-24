//
//  JPUMaterialSingleton.h
//  EditVideoText
//
//  Created by foundao on 2021/9/14.
//


#import <UIKit/UIKit.h>
#import "QMUIKit.h"
#import "JPUMaterialEditAssetModel.h"
#import "UIView+JPUMaterialUIKit.h"
typedef NS_ENUM(NSInteger ,  JPUMaterialEditType)
{
    JPUMaterialEditAll = 0,
    JPUMaterialEditVideo = 1,
    JPUMaterialEditImage = 2
};

NS_ASSUME_NONNULL_BEGIN

#define JPU_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define JPU_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define JPU_IPHONEX ([[UIApplication sharedApplication] statusBarFrame].size.height>20)
#define JPU_NavHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88:64)
#define JPU_SafeBottomMargin ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)
#define CFYWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define VIDEOCACHEPATH [NSTemporaryDirectory() stringByAppendingPathComponent:@"videoCache"]
#define JPUKeyWindow [[UIApplication sharedApplication]keyWindow]


@interface JPUMaterialSingleton : NSObject

+ (instancetype)singleton;


/// 弹出选择 3个选项的View
- (void)jpu_material_selectFootageBacktransmsViewUid:(NSString *)uid verifycode:(NSString *)verifycode cityCode:(NSString *)cityCode source:(NSString *)source phone:(NSString *)phone third_id:(NSString *)third_id ;

/// 回传素材
- (void)jpu_material_EditAllUid:(NSString *)uid verifycode:(NSString *)verifycode cityCode:(NSString *)cityCode source:(NSString *)source phone:(NSString *)phone third_id:(NSString *)third_id ;

/// 回传视频
- (void)jpu_material_EditVideoUid:(NSString *)uid verifycode:(NSString *)verifycode cityCode:(NSString *)cityCode source:(NSString *)source phone:(NSString *)phone third_id:(NSString *)third_id ;

/// 回传图片
- (void)jpu_material_EditPhotoUid:(NSString *)uid verifycode:(NSString *)verifycode cityCode:(NSString *)cityCode source:(NSString *)source phone:(NSString *)phone third_id:(NSString *)third_id ;

/// 得到视频时长
/// @param duration 时间搓
- (NSString *)jpu_material_getVideoTime:(NSTimeInterval)duration;

/// 得到视频秒数
- (NSString *)jpu_material_getVideoSeconds:(NSTimeInterval)duration;



/// 从iCould下载视频
/// @param asset PHAsset
/// @param success 回调
- (void)jpu_material_downloadiCloudVideo:(PHAsset *)asset success:(void(^)(NSString *filePath))success;


/// 从地址中获取视频的第一帧图片和时间
/// @param url 地址
/// @param block 回调
- (void)jpu_material_getTakeVideoImageAndTimeForm:(NSURL *)url block:(void(^)(NSString *timeStr,UIImage *image,NSInteger fileSize,NSString *seconds))block;



/// 得到相册所有资源
/// @param contentType 类型
- (NSMutableArray *)jpu_material_getAllAlbumsWithAlbum:(QMUIAlbumContentType)contentType;


/// 上传视频
/// @param model model
/// @param progressBlock 进度回调
- (void)jpu_material_uploadVideo:(JPUMaterialEditAssetModel *)model  progressBlock:(void(^)(CGFloat progress))progressBlock success:(void(^)(NSString *url))success failBlock:(void(^)(NSString *errorStr))failBlock;



/// 上传图片
/// @param image 图片
- (void)jpu_material_uploadPhoto:(UIImage *)image  success:(void(^)(NSString *url))success failBlock:(void(^)(NSString *errorStr))failBlock;



/// 发布动态接口
/// @param title 标题
/// @param content 简介
/// @param photoArr 图片数组
- (void)jpu_material_pushDynamicTitle:(NSString *)title  content:(NSString *)content  photoArr:(NSArray *)photoArr success:(void(^)(void))success failBlock:(void(^)(void))failBlock;



/// 发布素材
/// @param title 标题
/// @param content 简介
/// @param photoArr 图片数组
/// @param videoArr 视频数组

- (void)jpu_material_pushMaterialTitle:(NSString *)title  content:(NSString *)content  photoArr:(NSArray *)photoArr videoArr:(NSArray *)videoArr success:(void(^)(void))success failBlock:(void(^)(void))failBlock;



- (void)jpu_material_pushVideolTitle:(NSString *)title  content:(NSString *)content  video_cover:(NSString *)video_cover video_tagsArr:(NSArray *)video_tagsArr  video_url:(NSString *)video_url video_type:(NSString *)video_type video_category:(NSString *)video_category  video_label:(NSString *)video_label videoModel:(JPUMaterialEditAssetModel *)videoModel  success:(void(^)(void))success failBlock:(void(^)(void))failBlock;



/// 得到视频所属分类 画面数据
/// @param success 回调
/// @param fail 回调
- (void)jpu_material_getVideoSourceInfoSuccess:(void(^)(NSArray *videoClassArr ,NSArray *videoScreenArr))success fail:(void(^)(void))fail;


/// 得到热门标签
- (void)jpu_material_getHotTagsSuccess:(void(^)(NSArray *tagsArr))success failBlock:(void(^)(NSString *errorStr))failBlock;


/// 颜色 懒得写分类
- (UIColor *)jpu_material_colorWithHex:(long)hex alpha:(CGFloat)alpha;


- (NSBundle *)bundle;


- (UIImage *)jpu_material_imageName:(NSString *)name;



///切圆角
- (void)makeLayer:(UIView *)view  byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii ;


- (NSString *)getNowTimeTimestamp;


@end

@interface JPUMaterialCredentials :NSObject
@property (nonatomic , copy) NSString              * sessionToken;
@property (nonatomic , copy) NSString              * tmpSecretKey;
@property (nonatomic , copy) NSString              * tmpSecretId;

@end


@interface JPUMaterialTcCloudModel : NSObject


@property (nonatomic , assign) NSInteger              startTime;
@property (nonatomic , assign) NSInteger              expiredTime;
@property (nonatomic , copy) NSString              * requestId;
@property (nonatomic , copy) NSString              * expiration;
@property (nonatomic , strong) JPUMaterialCredentials              * credentials;

@end

@interface JPUMaterialVideoClassSub : NSObject
@property (nonatomic , copy) NSString              * labelId;
@property (nonatomic , copy) NSString              * labelName;
@end

//视频分类
@interface JPUMaterialVideoClass : NSObject
@property (nonatomic , copy) NSString              * cateId;
@property (nonatomic , copy) NSString              * cateName;
@property (nonatomic , strong) NSArray<JPUMaterialVideoClassSub *>           * labels;
@end



@interface JPUMaterialTagsModel: NSObject
@property (nonatomic , copy) NSString              * label_id;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic, assign) BOOL                   isSelect;

@end
NS_ASSUME_NONNULL_END
