//
//  JPLService.m
//  JPLSDK
//
//  Created by 任敬 on 2021/11/1.
//

#import "JPLService.h"

@implementation JPLService

+ (void)requestWithURLString:(NSString *)URLString parameters:(id)parameters type:(JPLHttpRequestType)type success:(void (^)(JPLResultBase * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure withErrorMsg:(NSString *)msg{
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.f;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",nil];
    [manager.requestSerializer setValue:[JPLServiceInfo share].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[JPLServiceInfo share].app_version forHTTPHeaderField:@"app-version"];
    [manager.requestSerializer setValue:[JPLServiceInfo share].device_type forHTTPHeaderField:@"device-type"];
    [manager.requestSerializer setValue:@"grtrgtrgrgrgrgtrgrg" forHTTPHeaderField:@"device-token"];
#ifdef DEBUG
    [manager.requestSerializer setValue:@"TEST" forHTTPHeaderField:@"app-channel"];
#else
    [manager.requestSerializer setValue:@"App Store" forHTTPHeaderField:@"app-channel"];
#endif
    [manager.requestSerializer setValue:[JPLServiceInfo share].bundleID forHTTPHeaderField:@"app-packagename"];
    switch (type) {
        case JPLHttpRequestTypeGet:{
            [manager GET:URLString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                JPLResultBase *res = [[JPLResultBase alloc] init];
                if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                    res.code = [responseObject valueForKey:@"code"];
                    res.message = [responseObject valueForKey:@"msg"];
                    res.data = [responseObject valueForKey:@"data"];
                    res.rows = [responseObject valueForKey:@"rows"];
                }
                if (success) {
                    success(res);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
                if (msg && msg.length) {
                    [MBProgressHUD jpl_showMessage:msg];
                }
            }];
        }
            break;
        case JPLHttpRequestTypePost:{
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
            [dic setObject:[NSString stringWithFormat:@"%.0f", timeInterval] forKey:@"time"];
            NSString *signStr = [JPLUtil signStringWithDictionary:dic];
            [dic setObject:signStr forKey:@"sign"];

            
            [manager POST:URLString parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                JPLResultBase *res = [[JPLResultBase alloc] init];
                if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                    res.ret = [responseObject valueForKey:@"ret"];
                    res.msg = [responseObject valueForKey:@"msg"];
                    res.code = [responseObject valueForKey:@"code"];
                    res.message = [responseObject valueForKey:@"msg"];
                    res.data = [responseObject valueForKey:@"data"];
                    res.rows = [responseObject valueForKey:@"rows"];
                    res.activate_Advertisement_id = [responseObject valueForKey:@"activate_Advertisement_id"];
                }
                if (success) {
                    success(res);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
                if (msg && msg.length) {
                    [MBProgressHUD jpl_showMessage:msg];
                }
            }];
        }
            break;
    }
}

+ (void)monitorNetworking:(void (^)(AFNetworkReachabilityStatus status))block{
    
    block([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus);

}



+ (AFHTTPSessionManager *)HTTPSessionManager
{
    static AFHTTPSessionManager *manager;
    if (manager == nil) {
        manager = [AFHTTPSessionManager manager];
    }
    return manager;
}



@end


@implementation JPLResultBase


@end
