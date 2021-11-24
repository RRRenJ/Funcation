//
//  UIAlertController+JPL.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/26.
//

#import "UIAlertController+JPL.h"

@implementation UIAlertController (JPL)

+ (UIAlertController *)jpl_crateWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)style actions:(NSDictionary<NSString *,NSNumber *> *)actions handler:(void(^)(NSString * actionTitle))handler{
    UIAlertController * alter = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    for (int index = 0; index < actions.count; index++) {
        UIAlertActionStyle style = actions.allValues[index].integerValue;
        UIAlertAction * action = [UIAlertAction actionWithTitle:actions.allKeys[index] style:style handler:^(UIAlertAction * _Nonnull action) {
            handler(actions.allKeys[index]);
        }];
        [alter addAction:action];
    }
    return alter;
}

@end
