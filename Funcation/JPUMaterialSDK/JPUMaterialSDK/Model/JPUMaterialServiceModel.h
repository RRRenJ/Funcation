//
//  JPUMaterialServiceModel.h
//  EditVideoText
//
//  Created by foundao on 2021/9/26.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JPUHttpRequestType) {
    JPHttpRequestTypeGet = 0,
    JPHttpRequestTypePost
};

NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialServiceModel : NSObject

+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                  verifycode:(NSString *)verifycode
                        type:(JPUHttpRequestType)type
                     success:(void (^)(id sender))success
                     failure:(void (^)(NSString *errorStr))failure;

@end

NS_ASSUME_NONNULL_END
