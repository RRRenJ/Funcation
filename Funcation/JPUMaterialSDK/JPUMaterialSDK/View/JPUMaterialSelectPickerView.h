//
//  JPUMaterialSelectPickerView.h
//  EditVideoText
//
//  Created by foundao on 2021/10/29.
//

#import <UIKit/UIKit.h>
#import "JPUMaterialSingleton.h"
NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialSelectPickerView : UIView

+ (instancetype)viewFromXib;

- (void)show:(BOOL)isVideoClass;

@property (nonatomic, strong) NSArray *videoClassArr;
@property (nonatomic, strong) NSArray *videoScreenArr;


@property (nonatomic, copy) void(^selectClassBlock)(JPUMaterialVideoClass *model, JPUMaterialVideoClassSub *subModel);

@property (nonatomic, copy) void(^selectScreenBlock)(JPUMaterialVideoClass *model);

@end

NS_ASSUME_NONNULL_END
