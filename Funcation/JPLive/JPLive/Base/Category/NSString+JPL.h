//
//  NSString+JPL.h
//  JPLSDK
//
//  Created by 任敬 on 2021/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JPL)

- (NSString *)jpl_md5;

- (NSString*)jpl_aci_encryptWithAES;

@end

NS_ASSUME_NONNULL_END
