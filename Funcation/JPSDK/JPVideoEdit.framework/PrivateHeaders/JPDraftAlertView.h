//
//  JPDraftAlertView.h
//  JPSDK
//
//  Created by 任敬 on 2021/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPDraftAlertView : UIView

@property (nonatomic, copy) void(^confirmBlock)(void);

- (void)show:(UIViewController *)vc;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
