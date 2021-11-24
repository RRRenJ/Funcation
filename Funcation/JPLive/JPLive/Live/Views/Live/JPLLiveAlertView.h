//
//  JPLLiveAlertView.h
//  jper
//
//  Created by RRRenJ on 2020/5/28.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JPLLiveAlertType) {
    JPLLiveAlertTypeAsk,
    JPLLiveAlertTypeRemind,
    JPLLiveAlertTypeWarning,
};

@interface JPLLiveAlertView : UIView

@property (nonatomic, copy) NSString *  message;

@property (nonatomic, copy) NSString *  remind;

@property (nonatomic, copy) void(^comfirmBlock)(void);

@property (nonatomic, copy) void(^cancelBlock)(void);

- (instancetype)initWithType:(JPLLiveAlertType)type title:(NSString *)title;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
