//
//  UIAlertController+JPL.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (JPL)

+ (UIAlertController *)jpl_crateWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)style actions:(NSDictionary<NSString*,NSNumber*>*)actions handler:(void(^)(NSString * actionTitle))handler;

@end

NS_ASSUME_NONNULL_END
