//
//  JPLStarSheetView.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLStarSheetView : UIView

@property (nonatomic, copy) void (^viewHideBlock)(void);


- (void)show:(UIViewController *)viewController;

- (void)hide;

@end

@interface JPLStarSheetCell : UIView

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * subTitle;

@property (nonatomic, copy) NSString * iconName;

@property (nonatomic, assign) NSInteger bagdeNumber;

@property (nonatomic, copy) void(^tapBlock)(void);


@end

NS_ASSUME_NONNULL_END
