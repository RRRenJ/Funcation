//
//  JPUMaterialPhotoCollectionCell.h
//  EditVideoText
//
//  Created by foundao on 2021/9/14.
//

#import <UIKit/UIKit.h>
#import "JPUMaterialEditAssetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialPhotoCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTags;
@property (weak, nonatomic) IBOutlet UIButton *btnDel;
@property (weak, nonatomic) IBOutlet UIView *viewSelectHint;
@property (weak, nonatomic) IBOutlet UILabel *labelNumber;
@property (nonatomic, strong) JPUMaterialEditAssetModel *model;;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPlay;

@property (nonatomic, copy)void(^delBlock)(void);


@end

NS_ASSUME_NONNULL_END
