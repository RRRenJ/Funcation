//
//  JPLManager.m
//  JPLSDK
//
//  Created by 任敬 on 2021/11/3.
//

#import "JPLManager.h"
#import "JPLStarSheetView.h"
#import "TXLiteAVSDK_Smart/TXLiteAVSDK.h"
#import "JPLServiceInfo.h"

@implementation JPLManager


+ (void)setLicenceURL:(NSString *)lecence key:(NSString *)key{
    [TXLiveBase setLicenceURL:lecence key:key];
}


+ (void)setUserToken:(NSString *)token bundleID:(nonnull NSString *)bundleID{
    [JPLServiceInfo share].token = token;
    [JPLServiceInfo share].bundleID = bundleID;
    [JPLServiceInfo share].device_type = @"1";
    [JPLServiceInfo share].app_version = @"3.0.0";
}

+ (void)showAlert:(UIViewController *)vc hide:(nonnull void (^)(void))hideBlock{
    JPLStarSheetView * view = [[JPLStarSheetView alloc ]init];
    [view show:vc];
    view.viewHideBlock = ^{
        hideBlock();
    };
}

@end
