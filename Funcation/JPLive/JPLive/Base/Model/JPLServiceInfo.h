//
//  JPLServiceInfo.h
//  JPLSDK
//
//  Created by 任敬 on 2021/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLServiceInfo : NSObject

@property (nonatomic, copy) NSString * token;

@property (nonatomic, copy) NSString * bundleID;

@property (nonatomic, copy) NSString * app_version;

@property (nonatomic, copy) NSString * device_type;


+ (JPLServiceInfo *)share;


@end

NS_ASSUME_NONNULL_END
