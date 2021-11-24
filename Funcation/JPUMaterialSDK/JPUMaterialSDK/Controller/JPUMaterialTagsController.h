//
//  JPUMaterialTagsController.h
//  EditVideoText
//
//  Created by foundao on 2021/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialTagsController : UIViewController
@property (nonatomic, copy)void(^selectTagsBlock)(NSMutableArray *selectTagsArr);
@property (nonatomic, strong) NSMutableArray *selectTagsArr;

@end

NS_ASSUME_NONNULL_END
