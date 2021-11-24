//
//  JPManager.h
//  JPSDK
//
//  Created by 任敬 on 2021/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPManager : NSObject


+ (void)loadConfige;

+ (void)showVideoEditAlert:(UIViewController*)vc hide:(void(^)(void))hideBlock;






@end

NS_ASSUME_NONNULL_END
