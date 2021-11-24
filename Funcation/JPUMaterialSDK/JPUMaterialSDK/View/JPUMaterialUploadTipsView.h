//
//  JPUMaterialUploadTipsView.h
//  EditVideoText
//
//  Created by foundao on 2021/10/20.
//

#import <UIKit/UIKit.h>
#import "JPUMaterialSingleton.h"
NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialUploadTipsView : UIView
+ (instancetype)viewFromXib;
@property (nonatomic, assign) JPUMaterialEditType type;

- (void)show:(BOOL)isSuccess;
@property (nonatomic, copy)void(^goHomeBlock)(void);
@property (nonatomic, copy)void(^uploadBlock)(BOOL isNewly);


@end

NS_ASSUME_NONNULL_END
