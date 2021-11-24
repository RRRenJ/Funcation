//
//  JPUMaterialServiceModel.m
//  EditVideoText
//
//  Created by foundao on 2021/9/26.
//

#import "JPUMaterialServiceModel.h"
#import "AFNetworking.h"

@implementation JPUMaterialServiceModel
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                  verifycode:(NSString *)verifycode
                        type:(JPUHttpRequestType)type
                     success:(void (^)(id sender))success
                     failure:(void (^)(NSString *errorStr))failure
{
    
    AFHTTPSessionManager *manager = [self HTTPSessionManager:URLString  verifycode:verifycode];
//    NSLog(@"地址-%@",URLString);
//    NSLog(@"参数-%@",parameters);
    switch (type) {
        case JPHttpRequestTypeGet:
        {
            [manager GET:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject[@"code"] intValue] == 200) {
                    !success?:success(responseObject);
                }else{
                    !failure?:failure(responseObject[@"msg"]);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !failure?:failure(@"请检查网络状态");
            }];
        } break;
            
        default:
        {
            [manager POST:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject[@"code"] intValue] == 200) {
                    !success?:success(responseObject);
                }else{
                    !failure?:failure(responseObject[@"msg"]);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !failure?:failure(@"请检查网络状态");
            }];
        } break;
    }

    
}


+ (AFHTTPSessionManager *)HTTPSessionManager:(NSString *)URLString  verifycode:(NSString *)verifycode
{
    static AFHTTPSessionManager *manager;
    manager = [AFHTTPSessionManager manager];
    if (![URLString containsString:@"cosToken2"]) {
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet  setWithObjects:@"text/html",@"application/json", nil];
    }else{
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    manager.requestSerializer.timeoutInterval = 30.f;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if (verifycode.length) {
        [manager.requestSerializer setHTTPShouldHandleCookies:YES];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"verifycode=%@",verifycode] forHTTPHeaderField:@"Cookie"];
    }
    return manager;
}



    


@end
