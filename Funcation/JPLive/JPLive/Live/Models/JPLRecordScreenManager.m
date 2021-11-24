//
//  JPLRecordScreenManager.m
//  JPLSDK
//
//  Created by 任敬 on 2021/11/10.
//

#import "JPLRecordScreenManager.h"
#import <ReplayKit/ReplayKit.h>
#import <Photos/Photos.h>


@interface JPLRecordScreenManager () <RPPreviewViewControllerDelegate>

@property (strong, nonatomic) RPScreenRecorder *screenRecorder;
@property (strong, nonatomic) AVAssetWriter *assetWriter;
@property (strong, nonatomic) AVAssetWriterInput *videoInput;
@property (strong, nonatomic) AVAssetWriterInput *audioInput;
@property (assign, nonatomic) BOOL forceRecord;
@end

@implementation JPLRecordScreenManager

+ (JPLRecordScreenManager *)manager{
    static JPLRecordScreenManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JPLRecordScreenManager alloc]init];
    });
    return manager;
}

- (void)startRecord{
    [self checkRecordAble];
}


- (void)checkPhotoLibrary{
    BOOL able = [JPLRecordScreenManager requestPhotoLibrary:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self checkRecordAble];
        });
    }];
    if (able) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self checkRecordAble];
        });
    }
}


- (void)checkRecordAble{
    //可用存储  mb
    if ([JPLUtil getAvailableDiskSize] <= 500) {
        [MBProgressHUD jpl_showMessage:@"当前设备可用存储低于500MB"];
        return;
    }
    
    if (![self.screenRecorder isAvailable]) {
        [MBProgressHUD jpl_showMessage:@"当前设备不支持边播边录"];
        return;
    }
    if (self.screenRecorder.isRecording) {
        return;
    }
    NSLog(@"开始录制");
    [self screenRecordStart];
}

- (void)screenRecordStart{
    self.screenRecorder.microphoneEnabled = NO;
    [self.screenRecorder startRecordingWithHandler:^(NSError * _Nullable error) {
        NSLog(@"录制开始...");
        if (error) {
            NSLog(@"错误信息 %@", error);
        } else {
        }
    }];
}

- (void)stopRecord {
    NSLog(@"结束录制");
    if (!self.screenRecorder.isRecording) {
        return;
    }
    [self.screenRecorder stopRecordingWithHandler:^(RPPreviewViewController *previewViewController, NSError *  error){
        if (error) {
            NSLog(@"录制出错");
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD jpl_showMessage:error.localizedDescription];
            });
        } else {
            NSLog(@"录制完成");
            [self handleEndScreenRecord:previewViewController];
        }
    }];

}

- (void)handleEndScreenRecord:(RPPreviewViewController *)previewViewController {

    NSURL *videoURL = [previewViewController valueForKey:@"movieURL"];
    if (videoURL) {
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([videoURL path]);
        if (compatible) {
            [self saveToAlbum:videoURL];
            NSLog(@"%@",videoURL);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD jpl_showMessage:@"视频地址错误"];
            });
            
            //清除replaykit录制数据
            [self.screenRecorder discardRecordingWithHandler:^{
                        
            }];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD jpl_showMessage:@"视频地址错误"];
        });
        //清除replaykit录制数据
        [self.screenRecorder discardRecordingWithHandler:^{
                    
        }];
    }
    
}


- (void)saveToAlbum:(NSURL *)videoURL{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest * collectionRequest;
        PHAssetCollection *assetCollection = [self getCurrentPhotoCollectionWithTitle:@"新建相册"];
        if (assetCollection) {
            collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        } else {
            collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"新建相册"];
        }
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoURL];
        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
        [collectionRequest addAssets:@[placeholder]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD jpl_showMessage:error.localizedDescription];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD jpl_showMessage:@"保存成功"];
            });
        }
        //清除replaykit录制数据
        [self.screenRecorder discardRecordingWithHandler:^{
                    
        }];
    }];
   
}



- (RPScreenRecorder *)screenRecorder {
    if (!_screenRecorder) {
        _screenRecorder = [RPScreenRecorder sharedRecorder];
    }
    return _screenRecorder;
}


+ (BOOL)requestPhotoLibrary:(void(^)(void))statusBlock{
    BOOL isAvalible = NO;
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized){
                if (statusBlock){
                    statusBlock();
                }
            }
        }];
    }else if(authStatus == PHAuthorizationStatusAuthorized){
        isAvalible = YES;
    }else{
        NSLog(@"没有相册权限");
    }
    return isAvalible;
}

- (PHAssetCollection *)getCurrentPhotoCollectionWithTitle:(NSString *)collectionName {
     PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
     for (PHAssetCollection *assetCollection in result) {
         if ([assetCollection.localizedTitle containsString:collectionName]) {
             return assetCollection;
         }
     }
     return nil;
 }



@end
