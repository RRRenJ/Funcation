//
//  JPLUtil.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/26.
//

#import "JPLUtil.h"
#import <AVFoundation/AVFoundation.h>
//计算存储空间
#include <sys/param.h>
#include <sys/mount.h>

//计算内存大小
#import <mach/mach.h>
#import <mach/mach_host.h>

@implementation JPLUtil

+ (NSBundle *)bundleWithName:(NSString *)name{
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"bundle"]];
    });
    return bundle;
}

+ (UIImage *)imageNamed:(NSString *)name withBundle:(NSBundle *)bundle{
    if (name.length == 0) return nil;

    UIImage * image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    
    return image;
}

+ (UIViewController *)currentViewController {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *currentVC = window.rootViewController;
    while (currentVC.presentedViewController) {
        currentVC = currentVC.presentedViewController;
    }
    if ([currentVC isKindOfClass:[UITabBarController class]]) {
        currentVC = [(UITabBarController *)currentVC selectedViewController];
    }
    if ([currentVC isKindOfClass:[UINavigationController class]]) {
        currentVC = [(UINavigationController *)currentVC topViewController];
    }
    return currentVC;
}

+ (void)showVideoAuthorizationAlertWithCompletionHandler:(void (^)(BOOL granted))completionHandler {
    AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(auth == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (completionHandler) {
                if (granted) {
                    completionHandler(YES);
                } else {
                    completionHandler(NO);
                }
            }
         }];
    } else if(AVAuthorizationStatusAuthorized != auth){
        if (completionHandler) {
            completionHandler(NO);
        }
    } else {
        if (completionHandler) {
            completionHandler(YES);
        }
    }
}

+ (void)showAudioAuthorizationAlertWithCompletionHandler:(void (^)(BOOL granted))completionHandler {
    AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(auth == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (completionHandler) {
                if (granted) {
                    completionHandler(YES);
                } else {
                    completionHandler(NO);
                }
            }
        }];
    } else if(AVAuthorizationStatusAuthorized != auth){
        if (completionHandler) {
            completionHandler(NO);
        }
    } else {
        if (completionHandler) {
            completionHandler(YES);
        }
    }
}

+ (CGSize)getStringSizeWith:(UIFont *)font
           andContainerSize:(CGSize)size
                  andString:(NSString *)str {
    CGSize s = CGSizeZero;
    if (!str || !str.length) {
        return s;
    }
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attri = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    CGRect rect = [str boundingRectWithSize:size
                                                  options:opts
                                               attributes:attri
                                                  context:nil];
    s = rect.size;
    return s;
}

+ (NSString *)signStringWithDictionary:(NSDictionary *)dic{
    NSMutableString *bodyStr = [NSMutableString string];
    NSArray *keys = dic.allKeys;
    NSArray *sortKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *key1 = obj1;
        NSString *key2 = obj2;
        return [key1 compare:key2];
    }];
    for (NSString *key in sortKeys) {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",key, dic[key]];
        if (bodyStr.length == 0) {
            [bodyStr appendString:keyValue];
        }else{
            [bodyStr appendFormat:@"&%@", keyValue];
        }
    }
    NSString *uppercaseString = [bodyStr uppercaseString];
    NSString *tempStr = [NSString stringWithFormat:@"%@%@", uppercaseString, @"JPER_API"];
    NSString *firstMD5 = [tempStr jpl_md5];
    NSString *thirtyStr = [firstMD5 substringWithRange:NSMakeRange(0, 30)];
    NSString *sign = [thirtyStr jpl_md5];
    return sign;
}




#pragma 获取总内存大小
+ (NSString *)getTotalMemorySize {
    long long totalMemorySize = [NSProcessInfo processInfo].physicalMemory;
    return [self fileSizeToString:totalMemorySize];
}

#pragma 获取当前可用内存
+ (NSString *)getAvailableMemorySize {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return @"内存查找失败";
    }
    long long availableMemorySize = ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
    return [self fileSizeToString:availableMemorySize];
}

#pragma 获取总磁盘容量
+ (NSInteger)getTotalDiskSize{
    struct statfs buf;
    unsigned long long totalDiskSize = -1;
    if (statfs("/var", &buf) >= 0) {
        totalDiskSize = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return [self fileSizeToMB:totalDiskSize];
}

#pragma 获取可用磁盘容量  f_bavail 已经减去了系统所占用的大小. 比 f_bfree 更准确
+ (NSInteger)getAvailableDiskSize {
    struct statfs buf;
    unsigned long long availableDiskSize = -1;
    if (statfs("/var", &buf) >= 0) {
        availableDiskSize = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return [self fileSizeToMB:availableDiskSize];
}



+ (NSInteger)fileSizeToMB:(unsigned long long)fileSize{
    return (NSInteger)(fileSize / 1024 / 1024);
}

+ (NSString *)fileSizeToString:(unsigned long long)fileSize {
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;

    if (fileSize < 10)  {
        return @"0 B";
    }else if (fileSize < KB) {
        return @"< 1 KB";
    }else if (fileSize < MB) {
        return [NSString stringWithFormat:@"%.2f KB",((CGFloat)fileSize)/KB];
    }else if (fileSize < GB) {
        return [NSString stringWithFormat:@"%.2f MB",((CGFloat)fileSize)/MB];
    }else {
         return [NSString stringWithFormat:@"%.2f GB",((CGFloat)fileSize)/GB];
    }
}

@end
