//
//  JPLService.h
//  JPLSDK
//
//  Created by 任敬 on 2021/11/1.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@class JPLResultBase;

#define API_HOST @"https://zs-api.foundao.com:10443/"


typedef NS_ENUM(NSInteger, JPLNetWorkStatusCode){
    JPNetWorkStatusSuccess = 0,
    JPNetWorkStatusError
};

typedef NS_ENUM(NSInteger, JPLHttpRequestType){
    JPLHttpRequestTypeGet = 0,
    JPLHttpRequestTypePost
};

NS_ASSUME_NONNULL_BEGIN

@interface JPLService : NSObject

+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(JPLHttpRequestType)type
                     success:(void (^)(JPLResultBase *response))success
                     failure:(void (^)(NSError *error))failure
                withErrorMsg:(NSString *)msg;
+ (void)monitorNetworking:(void (^)(AFNetworkReachabilityStatus status))block;

@end


@interface JPLResultBase : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) id rows;
@property (nonatomic, strong) id ret;
@property (nonatomic, strong) id activate_Advertisement_id;

@end


NS_ASSUME_NONNULL_END
