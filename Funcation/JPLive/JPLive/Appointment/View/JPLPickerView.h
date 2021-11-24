//
//  JPLPickerView.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JPLPickerType) {
    JPLPickerTypeString,
    JPLPickerTypeDate,
};

@interface JPLPickerView : UIView

@property (nonatomic, strong) NSArray <NSString *> * dataSource;

@property (nonatomic, copy) NSString * content;

@property (nonatomic, copy) NSString * minTime;

@property (nonatomic, copy) NSString * maxTime;

@property (nonatomic, copy) void(^selectBlock)(NSString *  content);

- (void)show;

- (void)hide;

- (instancetype)initWithType:(JPLPickerType)type;

@end

NS_ASSUME_NONNULL_END
