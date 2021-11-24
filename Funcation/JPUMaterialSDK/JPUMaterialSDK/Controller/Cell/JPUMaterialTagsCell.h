//
//  JPUMaterialTagsCell.h
//  EditVideoText
//
//  Created by foundao on 2021/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialTagsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIButton *btnDel;
@property (nonatomic, copy) void(^delTagsBlock)(void);

@end

NS_ASSUME_NONNULL_END
