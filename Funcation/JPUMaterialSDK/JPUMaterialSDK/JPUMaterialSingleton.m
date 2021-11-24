//
//  JPUMaterialSingleton.m
//  EditVideoText
//
//  Created by foundao on 2021/9/14.
//

#import "JPUMaterialSingleton.h"
#import "JPUMaterialPhotoAlbumController.h"
#import "JPUMaterialServiceModel.h"
#import "MJExtension.h"
#import "QCloudCOSXML/QCloudCOSXML.h"
#import "AssetsLibrary/AssetsLibrary.h" // 必须导入
#import "JPUMaterialProgressHUD.h"
#import "JPUMaterialSelectFootageView.h"
#import "JPUMaterialEditController.h"

//#define API_HOST             @"https://zs-api.foundao.com:10043/"
//#define API_HOST             @"http://115.182.9.167/vapi/comm/cosToken2.do"
#define API_HOST             @"http://115.182.9.167/vapi/"


//腾讯云APPID
#define COS_APPID             @"1305103504"


@implementation JPUMaterialTagsModel
@end
@implementation JPUMaterialVideoClass
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"labels":@"JPUMaterialVideoClassSub"};
}
@end
@implementation  JPUMaterialVideoClassSub

@end
@implementation JPUMaterialCredentials
@end
@implementation JPUMaterialTcCloudModel
@end

@interface JPUMaterialSingleton()<QCloudCredentailFenceQueueDelegate,QCloudSignatureProvider>

@property (nonatomic, strong) QCloudCredentailFenceQueue *credentialFenceQueue;
@property (nonatomic, strong) JPUMaterialTcCloudModel *uploadCloudModel;
@property (nonatomic, strong) NSString *timestamp;

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *verifycode;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *third_id;


@end
@implementation JPUMaterialSingleton

static JPUMaterialSingleton *singleton = nil;
+ (instancetype)singleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc]init];
    });
    return singleton;
}

- (void)jpu_material_selectFootageBacktransmsViewUid:(NSString *)uid verifycode:(NSString *)verifycode cityCode:(NSString *)cityCode source:(NSString *)source phone:(NSString *)phone third_id:(NSString *)third_id
{
    self.uid = uid;
    self.verifycode = verifycode;
    self.cityCode = cityCode;
    self.source = source;
    self.phone = phone;
    self.third_id = third_id;
    
    if (!uid.length ) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"请输入uid"];
        return;
    }
    if (!verifycode.length ) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"请输入verifycode"];
        return;
    }
    
    UIViewController *vc = (UIViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;//当前控制器
    JPUMaterialSelectFootageView *selectView = [JPUMaterialSelectFootageView viewFromXib];
    selectView.selectBlock = ^(JPUMaterialEditType type) {        
        [self jpu_material_GoEdit:type];
    };
    [selectView show:vc.view];
    
}

- (void)jpu_material_EditAllUid:(NSString *)uid verifycode:(NSString *)verifycode cityCode:(NSString *)cityCode source:(NSString *)source phone:(NSString *)phone third_id:(NSString *)third_id ;
{
    self.uid = uid;
    self.verifycode = verifycode;
    self.cityCode = cityCode;
    self.source = source;
    self.phone = phone;
    self.third_id = third_id;
    
    if (!uid.length ) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"请输入uid"];
        return;
    }
    if (!verifycode.length ) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"请输入verifycode"];
        return;
    }
    
    [self jpu_material_GoEdit:JPUMaterialEditAll];
}
- (void)jpu_material_EditVideoUid:(NSString *)uid verifycode:(NSString *)verifycode cityCode:(NSString *)cityCode source:(NSString *)source phone:(NSString *)phone third_id:(NSString *)third_id
{
    self.uid = uid;
    self.verifycode = verifycode;
    self.cityCode = cityCode;
    self.source = source;
    self.phone = phone;
    self.third_id = third_id;
    
    if (!uid.length ) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"请输入uid"];
        return;
    }
    if (!verifycode.length ) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"请输入verifycode"];
        return;
    }
    
    [self jpu_material_GoEdit:JPUMaterialEditVideo];
}

- (void)jpu_material_EditPhotoUid:(NSString *)uid verifycode:(NSString *)verifycode cityCode:(NSString *)cityCode source:(NSString *)source phone:(NSString *)phone third_id:(NSString *)third_id
{
    self.uid = uid;
    self.verifycode = verifycode;
    self.cityCode = cityCode;
    self.source = source;
    self.phone = phone;
    self.third_id = third_id;
    if (!uid.length ) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"请输入uid"];
        return;
    }
    if (!verifycode.length ) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"请输入verifycode"];
        return;
    }
    
    [self jpu_material_GoEdit:JPUMaterialEditImage];
}

- (void)jpu_material_GoEdit:(JPUMaterialEditType)type
{
    
    UIViewController *vc = (UIViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    JPUMaterialEditController *Vc = [[JPUMaterialEditController alloc]initWithNibName:@"JPUMaterialEditController" bundle:[JPUMaterialSingleton singleton].bundle];
    Vc.type = type;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:Vc];
    nav.modalPresentationStyle = 0;
    [vc presentViewController:nav animated:YES completion:nil];
    
}


- (NSString *)jpu_material_getVideoTime:(NSTimeInterval)duration
{
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    return  [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, seconds];
}
- (NSString *)jpu_material_getVideoSeconds:(NSTimeInterval)duration
{
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    return  [NSString stringWithFormat:@"%zd",seconds];
}

- (void)jpu_material_getTakeVideoImageAndTimeForm:(NSURL *)url block:(void(^)(NSString *timeStr,UIImage *image,NSInteger fileSize,NSString *seconds))block
{
    
    AVURLAsset*asset = [[AVURLAsset alloc]initWithURL:url options:nil];

    
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 1;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    //视频图片
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    Float64 duration = CMTimeGetSeconds(asset.duration);
    NSString *timeStr=[self timeFromSeconds:duration];
            
    NSArray *arr = [asset tracksWithMediaType:AVMediaTypeVideo];// 项目中是明确媒体类型为视频，其他没试过
    NSInteger fileSize = 0;
    for (AVAssetTrack *track in arr) {
        fileSize = track.totalSampleDataLength;
    }
    
    
    !block?:block(timeStr,thumbnailImage,fileSize,[self jpu_material_getVideoSeconds:duration]);
    
}


- (void)jpu_material_downloadiCloudVideo:(PHAsset *)asset success:(void(^)(NSString *filePath))success
{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        !success ?: success([NSString stringWithFormat:@"%@",urlAsset.URL]);
    }];

}

- (NSMutableArray *)jpu_material_getAllAlbumsWithAlbum:(QMUIAlbumContentType)contentType;
{
    NSMutableArray *array = [NSMutableArray array];
    [[QMUIAssetsManager sharedInstance]enumerateAllAlbumsWithAlbumContentType:contentType showEmptyAlbum:NO showSmartAlbumIfSupported:NO usingBlock:^(QMUIAssetsGroup *resultAssetsGroup) {
        if (resultAssetsGroup) {
            if (resultAssetsGroup.numberOfAssets > 0 ) {
                [resultAssetsGroup enumerateAssetsWithOptions:QMUIAlbumSortTypeReverse usingBlock:^(QMUIAsset *resultAsset) {
                    if (resultAsset) {
                        JPUMaterialEditAssetModel *model = [[JPUMaterialEditAssetModel alloc]init];
                        model.asset = resultAsset;
                        model.contentType = contentType;
                        [array addObject:model];
                    }
                }];
            }
        }
    }];
    
    return array;
}

- (void)jpu_material_uploadVideo:(JPUMaterialEditAssetModel *)model  progressBlock:(void(^)(CGFloat progress))progressBlock success:(void(^)(NSString *url))success failBlock:(void(^)(NSString *errorStr))failBlock
{

    
    NSDictionary *dic = @{@"tokenName":@"iOS",
                          @"uid":self.uid
    };
    self.timestamp = [self getNowTimeTimestamp];
    
    [JPUMaterialServiceModel requestWithURLString:[NSString stringWithFormat:@"%@comm/cosToken2.do",API_HOST] parameters:dic verifycode:self.verifycode type:JPHttpRequestTypeGet success:^(id  _Nonnull sender) {
        JPUMaterialTcCloudModel *cloudModel = [JPUMaterialTcCloudModel mj_objectWithKeyValues:sender[@"data"]];
        self.uploadCloudModel = cloudModel;
        
        if (!model.isTakeVideo) {//相册选择视频
            NSString *suffix = [model.filePath pathExtension];
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHVideoRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            [[PHImageManager defaultManager]requestAVAssetForVideo:model.asset.phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                NSData *data = [NSData dataWithContentsOfURL:urlAsset.URL];
                [self setupCOSXMLShareServiceWithModel:cloudModel];
                [self creatUploadTaskWithData:data isImg:NO andModel:cloudModel videoExtension:suffix uploadBlock:^(CGFloat progress) {
                    !progressBlock?:progressBlock(progress);
                }successBlock:^(NSString *url) {
                    !success?:success(url);
                }];
            }];
        }else{//拍摄
            NSString *suffix = [model.filePath pathExtension];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.filePath]];
            [self setupCOSXMLShareServiceWithModel:cloudModel];
            [self creatUploadTaskWithData:data isImg:NO andModel:cloudModel videoExtension:suffix uploadBlock:^(CGFloat progress) {
                !progressBlock?:progressBlock(progress);
            }successBlock:^(NSString *url) {
                !success?:success(url);
            }];
        }
       

    }failure:^(NSString * _Nonnull errorStr) {
        !failBlock?:failBlock(errorStr);
    }];

}



- (void)jpu_material_uploadPhoto:(UIImage *)image  success:(void(^)(NSString *url))success failBlock:(void(^)(NSString *errorStr))failBlock
{
    

//    NSDictionary *dic = @{@"service":@"App.Upload_Clouds.Sts",
//                          @"ext":@"png",
//                          @"type":@"works",
//                          @"file_type":@"image"
//    };
    
    
    NSDictionary *dic = @{@"tokenName":@"iOS",
                          @"uid":self.uid
    };
    
    self.timestamp = [ self getNowTimeTimestamp];
    [JPUMaterialServiceModel requestWithURLString:[NSString stringWithFormat:@"%@comm/cosToken2.do",API_HOST] parameters:dic verifycode:self.verifycode type:JPHttpRequestTypeGet success:^(id  _Nonnull sender) {
        JPUMaterialTcCloudModel *cloudModel = [JPUMaterialTcCloudModel mj_objectWithKeyValues:sender[@"data"]];
        self.uploadCloudModel = cloudModel;
        NSData *data = UIImageJPEGRepresentation(image,0.8);
        [self setupCOSXMLShareServiceWithModel:cloudModel];
        
        [self creatUploadTaskWithData:data isImg:YES andModel:cloudModel videoExtension:@"" uploadBlock:^(CGFloat progress) {
        }successBlock:^(NSString *url) {
            !success?:success(url);
        }];

    }failure:^(NSString * _Nonnull errorStr) {
        !failBlock?:failBlock(errorStr);
    }];
        
}


- (void)jpu_material_pushDynamicTitle:(NSString *)title  content:(NSString *)content  photoArr:(NSArray *)photoArr success:(void(^)(void))success failBlock:(void(^)(void))failBlock
{
    
    NSDictionary *dic = @{@"third_id":self.third_id?:@"",
                          @"dynamic_title":title,
                          @"dynamic_brief":content?:@"",
                          @"images":photoArr,
                          @"city_code":self.cityCode?:@"",
                          @"uid":self.uid?:@"",
                          @"source":self.source?:@"",
                          @"phone":self.phone?:@""
    };
    
    
    [JPUMaterialServiceModel requestWithURLString:[NSString stringWithFormat:@"%@ucreator/addDynamic.do",API_HOST] parameters:dic verifycode:self.verifycode type:JPHttpRequestTypePost success:^(id  _Nonnull sender) {
        [[JPUMaterialProgressHUD sharedHUD]hide];
        !success?:success();
    } failure:^(NSString * _Nonnull errorStr) {
        [[JPUMaterialProgressHUD sharedHUD]hide];
        !failBlock?:failBlock();
    }];
    
}

- (void)jpu_material_pushMaterialTitle:(NSString *)title  content:(NSString *)content  photoArr:(NSArray *)photoArr videoArr:(NSArray *)videoArr success:(void(^)(void))success failBlock:(void(^)(void))failBlock
{
    
    NSDictionary *dic = @{@"third_id":self.third_id?:@"",
                          @"material_title":title,
                          @"material_brief":content?:@"",
                          @"videos":videoArr,
                          @"images":photoArr,
                          @"city_code":self.cityCode?:@"",
                          @"uid":self.uid?:@"",
                          @"source":self.source?:@"",
                          @"phone":self.phone?:@""
    };
    
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
//    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"strJson-%@",strJson);
    
    
    
    [JPUMaterialServiceModel requestWithURLString:[NSString stringWithFormat:@"%@ucreator/addMaterial.do",API_HOST] parameters:dic verifycode:self.verifycode type:JPHttpRequestTypePost success:^(id  _Nonnull sender) {
        [[JPUMaterialProgressHUD sharedHUD]hide];
        !success?:success();
    } failure:^(NSString * _Nonnull errorStr) {
        [[JPUMaterialProgressHUD sharedHUD]hide];
        !failBlock?:failBlock();
    }];
    
}

- (void)jpu_material_pushVideolTitle:(NSString *)title  content:(NSString *)content  video_cover:(NSString *)video_cover video_tagsArr:(NSArray *)video_tagsArr  video_url:(NSString *)video_url video_type:(NSString *)video_type video_category:(NSString *)video_category  video_label:(NSString *)video_label videoModel:(JPUMaterialEditAssetModel *)videoModel  success:(void(^)(void))success failBlock:(void(^)(void))failBlock
{
        
    NSMutableArray *tagsArr = [NSMutableArray array];
    for (JPUMaterialTagsModel *tagsModel in video_tagsArr) {
        [tagsArr addObject:tagsModel.name];
    }
    
    NSString *tagsStr = [tagsArr componentsJoinedByString:@","];
    NSString *suffix = [videoModel.filePath pathExtension];
    
    
    NSDictionary *dic = @{@"guid":self.third_id?:@"",
                          @"video_title":title,
                          @"video_img":video_cover,
                          @"video_url":video_url,
                          @"video_brief":content?:@"",
                          @"video_keyword":tagsStr,
                          @"category":video_category,
                          @"label":video_label,
                          @"video_type":video_type,
                          @"video_part_time":videoModel.seconds,
                          @"format":suffix,
                          @"file_size": [NSString stringWithFormat:@"%zd",videoModel.filesize],
                          @"city_code":self.cityCode?:@"",
                          @"uid":self.uid?:@"",
                          @"source":self.source?:@"",
                          @"phone":self.phone?:@"",
                          
    };
    [JPUMaterialServiceModel requestWithURLString:[NSString stringWithFormat:@"%@ucreator/addVideo.do",API_HOST] parameters:dic verifycode:self.verifycode type:JPHttpRequestTypePost success:^(id  _Nonnull sender) {
        [[JPUMaterialProgressHUD sharedHUD]hide];
        !success?:success();
    } failure:^(NSString * _Nonnull errorStr) {
        [[JPUMaterialProgressHUD sharedHUD]hide];
        !failBlock?:failBlock();
    }];
    
    
    
    
    
}

- (void)jpu_material_getVideoSourceInfoSuccess:(void(^)(NSArray *videoClassArr ,NSArray *videoScreenArr))success fail:(void(^)(void))fail;
{
    
    //获取横屏竖屏
    NSArray *videoScreenArray = [JPUMaterialVideoClass mj_objectArrayWithKeyValuesArray:@[@{@"cateId":@"1",@"cateName":@"竖屏"},@{@"cateId":@"0",@"cateName":@"横屏"}]];
    [JPUMaterialServiceModel requestWithURLString:[NSString stringWithFormat:@"%@ucreator/categorys.do",API_HOST] parameters:@{} verifycode:self.verifycode type:JPHttpRequestTypeGet success:^(id  _Nonnull sender) {
        [[JPUMaterialProgressHUD sharedHUD]hide];
        if ([[NSString stringWithFormat:@"%@",sender[@"code"]] isEqualToString:@"200"]) {
            NSArray *videoClassArray = [JPUMaterialVideoClass mj_objectArrayWithKeyValuesArray:sender[@"data"]];
    
            !success?:success(videoClassArray,videoScreenArray);
        }else{
            !fail?:fail();
        }
    } failure:^(NSString * _Nonnull errorStr) {
        [[JPUMaterialProgressHUD sharedHUD]hide];
        !fail?:fail();
    }];
    
    
}

- (void)jpu_material_getHotTagsSuccess:(void(^)(NSArray *tagsArr))success failBlock:(void(^)(NSString *errorStr))failBlock
{
    
    NSDictionary *dic = @{@"service":@"App.Cgi_Article.Get_label",
                          @"detail":@"1",
                          @"type":@"expand",
    };
    
    [JPUMaterialServiceModel requestWithURLString:API_HOST parameters:dic verifycode:self.verifycode type:JPHttpRequestTypePost success:^(id  _Nonnull sender) {
        [[JPUMaterialProgressHUD sharedHUD]hide];
//        NSLog(@"热门标签-%@",sender);
        if ([[NSString stringWithFormat:@"%@",sender[@"ret"]] isEqualToString:@"200"]) {
            NSArray *tagsArr = [JPUMaterialTagsModel mj_objectArrayWithKeyValuesArray:sender[@"data"]];
            !success?:success(tagsArr);
        }else{
            !failBlock?:failBlock(sender[@"msg"]?:@"接口异常");
        }
    } failure:^(NSString * _Nonnull errorStr) {
        [[JPUMaterialProgressHUD sharedHUD]hide];
        !failBlock?:failBlock(@"网络问题");
    }];
    
    
}

- (void)setupCOSXMLShareServiceWithModel:(JPUMaterialTcCloudModel *)model {
    self.credentialFenceQueue = [QCloudCredentailFenceQueue new];
    self.credentialFenceQueue.delegate = self;
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
//    configuration.appID = model.AppId;
    configuration.appID = COS_APPID;
    configuration.signatureProvider = self;
//    QCloudCOSXMLEndPoint * endpoint = [[QCloudCOSXMLEndPoint alloc]initWithLiteralURL:[NSURL URLWithString:self.uploadCloudModel.UploadDomain]];
        QCloudCOSXMLEndPoint * endpoint = [[QCloudCOSXMLEndPoint alloc]initWithLiteralURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://xcreator-%@.cos.ap-beijing.myqcloud.com",COS_APPID]]];

    configuration.endpoint = endpoint;
    
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
    
}

- (void)creatUploadTaskWithData:(NSData *)data isImg:(BOOL)isImg andModel:(JPUMaterialTcCloudModel *)model videoExtension:(NSString *)videoExtension uploadBlock:(void(^)(CGFloat progress))uploadBlock successBlock:(void(^)(NSString *url))successBlock {
//    __weak typeof(self) weakSelf = self;
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
//    put.object = model.key;
//    put.bucket = model.Bucket;
        
    NSString *objectStr;
    if (isImg) {
        objectStr = [NSString stringWithFormat:@"/media/img/%@/%@/%@.png",self.uid,[self getCurrentTimesYYMMDD],self.timestamp];
    }else{
        objectStr = [NSString stringWithFormat:@"/media/video/%@/%@/%@.%@",self.uid,[self getCurrentTimesYYMMDD],self.timestamp,videoExtension];
    }
        
    put.object = objectStr ;
    put.bucket = [NSString stringWithFormat:@"xcreator-%@",COS_APPID];
    put.body = data;
    __block QCloudCOSXMLUploadObjectRequest * uploadRequest = put;
    [uploadRequest setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSString *bytesStr = [NSString stringWithFormat:@"%lld",totalBytesSent];
        NSString *totalByStr = [NSString stringWithFormat:@"%lld",totalBytesExpectedToSend];
        NSLog(@"%.2f",[bytesStr floatValue]/[totalByStr floatValue]);
        !uploadBlock?:uploadBlock([bytesStr floatValue]/[totalByStr floatValue]);
        
    }];
    [uploadRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        uploadRequest = nil;
        if (result.location) {
            !successBlock?:successBlock(result.location);
        }
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:uploadRequest];
}

#pragma mark - <QCloudSignatureProvider>
- (void)signatureWithFields:(QCloudSignatureFields*)fileds
                    request:(QCloudBizHTTPRequest*)request
                 urlRequest:(NSMutableURLRequest*)urlRequst
                  compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    [self.credentialFenceQueue performAction:^(QCloudAuthentationCreator *creator, NSError *error) {
        if (error) {
            continueBlock(nil, error);
        } else {
            QCloudSignature* signature =  [creator signatureForData:urlRequst];
            continueBlock(signature, nil);
        }
    }];
}

#pragma mark - <QCloudCredentailFenceQueueDelegate>
- (void)fenceQueue:(QCloudCredentailFenceQueue *)queue requestCreatorWithContinue:(QCloudCredentailFenceQueueContinue)continueBlock {

    QCloudCredential* crendential = [[QCloudCredential alloc] init];
    
    crendential.secretID = self.uploadCloudModel.credentials.tmpSecretId;
    crendential.secretKey =self.uploadCloudModel.credentials.tmpSecretKey;
    crendential.startDate = [NSDate dateWithTimeIntervalSince1970:self.uploadCloudModel.startTime];
    crendential.experationDate = [NSDate dateWithTimeIntervalSinceNow:self.uploadCloudModel.expiredTime];
    crendential.token = self.uploadCloudModel.credentials.sessionToken;
    
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:crendential];
    continueBlock(creator, nil);
}


- (UIColor *)jpu_material_colorWithHex:(long)hex alpha:(CGFloat)alpha;
{
    return [UIColor colorWithRed:(CGFloat)((hex & 0xFF0000) >> 16) / 255.0 green:(CGFloat)((hex & 0xFF00) >> 8) / 255.0 blue:(CGFloat)((hex & 0xFF)) / 255.0 alpha:alpha];
}



- (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"JPUEditVideoImageBundle" ofType:@"bundle"]];

    });
    return bundle;
    
//    return [NSBundle mainBundle];

}


- (UIImage *)jpu_material_imageName:(NSString *)name
{
    if (name.length == 0) return nil;
    int scale = (int)UIScreen.mainScreen.scale;
    if (scale < 2) scale = 2;
    else if (scale > 3) scale = 3;
    NSString *n = [NSString stringWithFormat:@"%@@%dx", name, scale];
    UIImage *image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:n ofType:@"png"]];
    if (!image) image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:name ofType:@"png"]];
    return image;
    
//    return [UIImage imageNamed:name];
}


- (void)makeLayer:(UIView *)view  byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame =view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}



- (NSString *)timeFromSeconds:(NSInteger)seconds
{
    int m =seconds/60;
    int s = seconds%60;
    NSString *mString ;
    NSString *sString ;
    if (m<10)
        mString =[NSString stringWithFormat:@"%d",m];
    else
        mString =[NSString stringWithFormat:@"%d",m];

    if (s<10)
        sString =[NSString stringWithFormat:@"0%d",s];
    else
        sString =[NSString stringWithFormat:@"%d",s];
    
    return  [NSString stringWithFormat:@"%@:%@",mString,sString];
    
}

- (NSString *)getNowTimeTimestamp{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这个对于时间的处理有时很重要

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    [formatter setTimeZone:timeZone];

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;

}


- (NSString*)getCurrentTimesYYMMDD{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;

}
@end
