//
//  JPUMaterialSelectFootageView.h
//  EditVideoText
//
//  Created by foundao on 2021/10/18.
//

#import <UIKit/UIKit.h>
#import "JPUMaterialSingleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialSelectFootageView : UIView

+ (instancetype)viewFromXib;
- (void)show:(UIView *)view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutContentHeight;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (nonatomic, copy) void(^selectBlock)(JPUMaterialEditType type);



@end

NS_ASSUME_NONNULL_END
